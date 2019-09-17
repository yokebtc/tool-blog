/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50717
 Source Host           : localhost:3306
 Source Schema         : blog

 Target Server Type    : MySQL
 Target Server Version : 50717
 File Encoding         : 65001
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_attach
-- ----------------------------
DROP TABLE IF EXISTS `t_attach`;
CREATE TABLE `t_attach`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `fname` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `ftype` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '',
  `fkey` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `author_id` int(10) NULL DEFAULT NULL,
  `created` int(10) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_comments
-- ----------------------------
DROP TABLE IF EXISTS `t_comments`;
CREATE TABLE `t_comments`  (
  `coid` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'comment表主键',
  `cid` int(10) UNSIGNED NULL DEFAULT 0 COMMENT 'post表主键,关联字段',
  `created` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '评论生成时的GMT unix时间戳',
  `author` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论作者',
  `author_id` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '评论所属用户id',
  `owner_id` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '评论所属内容作者id',
  `mail` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论者邮件',
  `url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论者网址',
  `ip` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论者ip地址',
  `agent` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '评论者客户端',
  `content` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '评论内容',
  `type` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'comment' COMMENT '评论类型',
  `status` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'approved' COMMENT '评论状态',
  `parent` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '父级评论',
  PRIMARY KEY (`coid`) USING BTREE,
  INDEX `cid`(`cid`) USING BTREE,
  INDEX `created`(`created`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '评论' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_contents
-- ----------------------------
DROP TABLE IF EXISTS `t_contents`;
CREATE TABLE `t_contents`  (
  `cid` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'post表主键',
  `title` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '内容标题',
  `slug` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '内容缩略名',
  `slug_title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '首页显示标题',
  `slug_order` int(11) NULL DEFAULT 1 COMMENT '排序',
  `thumb_img` varchar(512) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `created` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '内容生成时的GMT unix时间戳',
  `modified` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '内容更改时的GMT unix时间戳',
  `content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '内容文字',
  `author_id` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '内容所属用户id',
  `type` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'post' COMMENT '内容类别',
  `status` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'publish' COMMENT '内容状态',
  `fmt_type` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'markdown',
  `tags` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '标签列表',
  `categories` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '分类列表',
  `hits` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '点击次数',
  `comments_num` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '内容所属评论数',
  `allow_comment` tinyint(1) NULL DEFAULT 1 COMMENT '是否允许评论',
  `allow_ping` tinyint(1) NULL DEFAULT 1 COMMENT '是否允许ping',
  `allow_feed` tinyint(1) NULL DEFAULT 1 COMMENT '允许出现在聚合中',
  PRIMARY KEY (`cid`) USING BTREE,
  UNIQUE INDEX `slug`(`slug`) USING BTREE,
  INDEX `created`(`created`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 73 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '内容表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_logs
-- ----------------------------
DROP TABLE IF EXISTS `t_logs`;
CREATE TABLE `t_logs`  (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `action` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '产生的动作',
  `data` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '产生的数据',
  `author_id` int(10) NULL DEFAULT NULL COMMENT '发生人id',
  `ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '日志产生的ip',
  `created` int(10) NULL DEFAULT NULL COMMENT '日志创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = MyISAM AUTO_INCREMENT = 2095 CHARACTER SET = swe7 COLLATE = swe7_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_metas
-- ----------------------------
DROP TABLE IF EXISTS `t_metas`;
CREATE TABLE `t_metas`  (
  `mid` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '项目主键',
  `name` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '名称',
  `slug` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '项目缩略名',
  `type` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '项目类型',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '选项描述',
  `sort` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '项目排序',
  `parent` int(10) UNSIGNED NULL DEFAULT 0,
  PRIMARY KEY (`mid`) USING BTREE,
  INDEX `slug`(`slug`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '项目' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_options
-- ----------------------------
DROP TABLE IF EXISTS `t_options`;
CREATE TABLE `t_options`  (
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '' COMMENT '配置名称',
  `value` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '配置值',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_relationships
-- ----------------------------
DROP TABLE IF EXISTS `t_relationships`;
CREATE TABLE `t_relationships`  (
  `cid` int(10) UNSIGNED NOT NULL COMMENT '内容主键',
  `mid` int(10) UNSIGNED NOT NULL COMMENT '项目主键',
  PRIMARY KEY (`cid`, `mid`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_users
-- ----------------------------
DROP TABLE IF EXISTS `t_users`;
CREATE TABLE `t_users`  (
  `uid` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'user表主键',
  `username` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名称',
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户密码',
  `email` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户的邮箱',
  `home_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户的主页',
  `screen_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户显示的名称',
  `created` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '用户注册时的GMT unix时间戳',
  `activated` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '最后活动时间',
  `logged` int(10) UNSIGNED NULL DEFAULT 0 COMMENT '上次登录最后活跃时间',
  `group_name` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'visitor' COMMENT '用户组',
  PRIMARY KEY (`uid`) USING BTREE,
  UNIQUE INDEX `name`(`username`) USING BTREE,
  UNIQUE INDEX `mail`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for t_wallpapers
-- ----------------------------
DROP TABLE IF EXISTS `t_wallpapers`;
CREATE TABLE `t_wallpapers`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `uid` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int(11) NOT NULL,
  `digest` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 997 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '文章图片' ROW_FORMAT = Dynamic;

SET FOREIGN_KEY_CHECKS = 1;
