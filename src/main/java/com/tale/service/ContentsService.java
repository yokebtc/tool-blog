package com.tale.service;

import static com.tale.bootstrap.TaleConst.SQL_QUERY_ARTICLES;
import static io.github.biezhi.anima.Anima.deleteById;
import static io.github.biezhi.anima.Anima.select;

import java.util.List;
import java.util.Map;
import java.util.Objects;

import com.blade.exception.ValidatorException;
import com.blade.ioc.annotation.Bean;
import com.blade.ioc.annotation.Inject;
import com.blade.kit.DateKit;
import com.blade.kit.StringKit;
import com.tale.model.dto.Types;
import com.tale.model.entity.Comments;
import com.tale.model.entity.Contents;
import com.tale.model.entity.Relationships;
import com.tale.model.params.ArticleParam;
import com.vdurmont.emoji.EmojiParser;

import io.github.biezhi.anima.Anima;
import io.github.biezhi.anima.core.AnimaQuery;
import io.github.biezhi.anima.core.ResultList;
import io.github.biezhi.anima.page.Page;
import io.netty.util.internal.StringUtil;

/**
 * 文章Service
 *
 * @author biezhi
 * @since 1.3.1
 */
@Bean
public class ContentsService {

    @Inject
    private MetasService metasService;

    /**
     * 根据id或slug获取文章
     *
     * @param id 唯一标识
     */
    public Contents getContents(String id) {
        Contents contents = null;
        if (StringKit.isNotBlank(id)) {
            if (StringKit.isNumber(id)) {
                contents = select().from(Contents.class).byId(id);
            } else {
                contents = select().from(Contents.class).where(Contents::getSlug, id).one();
            }
            if (null != contents) {
                return this.mapContent(contents);
            }
        }
        return contents;
    }
    
    /**
     * 更新文章点击数
     *
     * @param id 唯一标识
     */
    public int updateHists(String id) {
        if (StringKit.isNotBlank(id)) {
            if (StringKit.isNumber(id)) {
            	return Anima.execute("UPDATE t_contents set hits = hits + 1 WHERE cid = ?", id);
            }
        }
        return 0;
    }
    
    public Contents getId(String id) {
        Contents contents = null;
        if (StringKit.isNotBlank(id)) {
            if (StringKit.isNumber(id)) {
            	contents = select().from(Contents.class).byId(id);
            }
        }
        return contents;
    }
    
    /**
     * 发布文章
     *
     * @param contents 文章对象
     */
    public Integer publish(Contents contents) {
        if (null == contents.getAuthorId()) {
        	
            throw new ValidatorException("请登录后发布文章");
        }
        long count = new Contents().where(Contents::getSlug, contents.getSlug()).count();
        if (count > 0) {
        	
        	throw new ValidatorException("slug 已经存在");
		}
        
        contents.setContent(EmojiParser.parseToAliases(contents.getContent()));

        int time = DateKit.nowUnix();
        contents.setCreated(time);
        contents.setModified(time);
        contents.setHits(0);

        String tags       = contents.getTags();
        String categories = contents.getCategories();
        
        List<Map<String, Object>> maps = Anima.select().from(Contents.class).select("MAX(slug_order) as orderCount").maps();
        Map<String, Object> one = maps.get(0);
        Integer slugOrder = Integer.valueOf(Objects.toString(one.get("orderCount"), "1"));
        contents.setSlugOrder(slugOrder + 1);

        Integer cid = contents.save().asInt();

        metasService.saveMetas(cid, tags, Types.TAG);
        metasService.saveMetas(cid, categories, Types.CATEGORY);

        return cid;
    }

    /**
     * 编辑文章
     *
     * @param contents 文章对象
     */
    public void updateArticle(Contents contents) {
        contents.setCreated(contents.getCreated());
        contents.setModified(DateKit.nowUnix());
        contents.setContent(EmojiParser.parseToAliases(contents.getContent()));
        contents.setTags(contents.getTags() != null ? contents.getTags() : "");
        contents.setCategories(contents.getCategories() != null ? contents.getCategories() : "");
        if (StringUtil.isNullOrEmpty(contents.getSlugTitle())) {
        	contents.setSlugTitle("NULL");
		}
        Integer cid = contents.getCid();
        contents.updateById(cid);
        if (StringUtil.isNullOrEmpty(contents.getSlug())) {
        	Anima.execute("update t_contents set slug = null where cid = ?", cid);
		}

        String tags       = contents.getTags();
        String categories = contents.getCategories();

        if (null != contents.getType() && !contents.getType().equals(Types.PAGE)) {
            Anima.delete().from(Relationships.class).where(Relationships::getCid, cid).execute();
        }

        metasService.saveMetas(cid, tags, Types.TAG);
        metasService.saveMetas(cid, categories, Types.CATEGORY);
    }

    /**
     * 根据文章id删除
     *
     * @param cid 文章id
     */
    public void delete(int cid) {
        Contents contents = this.getContents(cid + "");
        if (null != contents) {
            deleteById(Contents.class, cid);
            Anima.delete().from(Relationships.class).where(Relationships::getCid, cid).execute();
            Anima.delete().from(Comments.class).where(Comments::getCid, cid).execute();
        }
    }

    /**
     * 查询分类/标签下的文章归档
     *
     * @param mid   分类、标签id
     * @param page  页码
     * @param limit 每页条数
     * @return
     */
    public Page<Contents> getArticles(Integer mid, int page, int limit) {
        return select().bySQL(Contents.class, SQL_QUERY_ARTICLES, mid).page(page, limit);
    }

    public Page<Contents> findArticles(ArticleParam articleParam) {
        AnimaQuery<Contents> query = select().from(Contents.class).exclude(Contents::getContent);

        if (StringKit.isNotEmpty(articleParam.getStatus())) {
            query.and(Contents::getStatus, articleParam.getStatus());
        }

        if (StringKit.isNotEmpty(articleParam.getTitle())) {
            query.and(Contents::getTitle).like("%" + articleParam.getTitle() + "%");
        }

        if (StringKit.isNotEmpty(articleParam.getCategories())) {
            query.and(Contents::getCategories).like("%" + articleParam.getCategories() + "%");
        }

        query.and(Contents::getType, articleParam.getType());
        query.order(articleParam.getOrderBy());
        Page<Contents> articles = query.page(articleParam.getPage(), articleParam.getLimit());
        return articles.map(this::mapContent);
    }

    private Contents mapContent(Contents contents) {
        if (StringKit.isNotEmpty(contents.getSlug())) {
            String url = "/" + contents.getSlug();
            contents.setUrl(url.replaceAll("[/]+", "/"));
        } else {
            contents.setUrl("/article/" + contents.getCid());
        }
        String content = contents.getContent();
        if (StringKit.isNotEmpty(content)) {
            content = content.replaceAll("\\\\\"", "\\\"");
            contents.setContent(content);
        }
        return contents;
    }
}
