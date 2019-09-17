package com.tale.bootstrap;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.tale.utils.ScriptRunner;
import com.zaxxer.hikari.HikariDataSource;

import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * SQLite 数据库操作
 * <p>
 * Created by biezhi on 2017/3/4.
 */
@Slf4j
@NoArgsConstructor
public final class MySQLJdbc {

	/**
	 * 测试连接并导入数据库
	 */
	public static void importSql(HikariDataSource hikariDataSource) {
		
		try {
			Connection con = hikariDataSource.getConnection();
			
			Statement  statement = con.createStatement();
            ResultSet  rs        = statement.executeQuery("SELECT count(*) FROM information_schema.TABLES WHERE table_name='t_users'");
            rs.next();
            int        count     = rs.getInt(1);
            
            log.info("=======> is database  {}", count > 0);
            
            if (count == 0) {
            	
            	ScriptRunner runner = new ScriptRunner(con, false, true);
            	String cp = MySQLJdbc.class.getClassLoader().getResource("").getPath();
            	
            	InputStreamReader isr = new InputStreamReader(new FileInputStream(cp + "schema_mysql.sql"), "UTF-8");
            	BufferedReader read = new BufferedReader(isr);
            	runner.runScript(read);
            }
            
            rs.close();
            statement.close();
            con.close();
		} catch (Exception e) {
			 log.error("initialize database fail", e);
		}
	}

}