package com.hhr.common.ftp.pool;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.pool.impl.GenericObjectPool.Config;

public class FTPPool extends Pool<FTPClient>{  
    
	/**
	 * 初始化链接池信息
	 * @param poolConfig	连接池配置
	 * @param host		ftp服务器ip
	 * @param port		ftp端口
	 * @param user		用户名
	 * @param password	密码
	 * @param passiveModeConf	支持数据流的被动式联机模式(YES (NO)) 一定要设定为 YES！
	 * @param controlKeepAliveTimeout	链接保持时间
	 */
    public FTPPool(Config poolConfig,String host,int port,String user,String password,String passiveModeConf, int  controlKeepAliveTimeout){  
        super(poolConfig, new FTPPoolableObjectFactory(host, port, user, password, passiveModeConf, controlKeepAliveTimeout));  
    }  
      
} 