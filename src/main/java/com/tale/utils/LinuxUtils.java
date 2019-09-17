package com.tale.utils;

import static com.blade.mvc.Const.ENV_KEY_NGINX_TRY_FILES;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Optional;

import com.blade.mvc.WebContext;

import io.netty.util.internal.StringUtil;

public class LinuxUtils {

	private static MapCache cache = MapCache.single();
	
    public static void rm_static_html() {
    	//RouteMethodHandler.IS_STATIC_HTML = true;
    	cache.del("get_nav_list");
    	String msgString = "";
    	Optional<String> optional = WebContext.blade().environment().get(ENV_KEY_NGINX_TRY_FILES);
    	if (optional.isPresent()) {
    		String nginxFile = optional.get();
    		String osName = System.getProperty("os.name","");
    		if (osName.startsWith("Windows")) {
    			nginxFile = "d:" + nginxFile;
    		}
    		if (!StringUtil.isNullOrEmpty(nginxFile) && nginxFile.length() > 5) {
    			String commString = "rm -rf ";
           		if (nginxFile.endsWith("/")) {
           			commString = commString + nginxFile + "*";
        		} else {
        			commString = commString + nginxFile + "/*";
        		}
    			String[] cmds = {"/bin/sh","-c", commString};  
    			try {
    				Process pro = Runtime.getRuntime().exec(cmds);  
    				pro.waitFor();  
    				InputStream in = pro.getInputStream();  
    				BufferedReader read = new BufferedReader(new InputStreamReader(in));  
    				StringBuffer sBuffer = new StringBuffer();
    				while((msgString = read.readLine())!=null){  
    					sBuffer.append(msgString);
    				}
    				msgString = sBuffer.toString();
    			} catch (Exception e) {
    				msgString = e.getMessage();
    			}
			}
    	}
    }
	
}
