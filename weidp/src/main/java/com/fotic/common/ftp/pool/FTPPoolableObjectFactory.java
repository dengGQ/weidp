package com.fotic.common.ftp.pool;

import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.pool.BasePoolableObjectFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FTPPoolableObjectFactory extends BasePoolableObjectFactory<Object> {
	Logger logger = LoggerFactory.getLogger(FTPPoolableObjectFactory.class);

	private String host;
	private int port;
	private String user;
	private String password;
	
	private String passiveModeConf;
	/**
	 * 过期时间
	 */
	private int controlKeepAliveTimeout;
	
	private int controlKeepAliveReplyTimeout;

	public FTPPoolableObjectFactory(String host, int port, String user, String password, String passiveModeConf, int controlKeepAliveTimeout) {
		this.host = host;
		logger.info("ftp host :" + host);
		this.port = port;
		logger.info("ftp port :" + port);
		this.user = user;
		logger.info("ftp user :" + user);
		this.password = password;
		logger.info("ftp password :" + password);
		this.passiveModeConf = passiveModeConf;
		logger.info("ftp passiveModeConf :" + passiveModeConf);
		this.controlKeepAliveTimeout = controlKeepAliveTimeout;
		logger.info("ftp controlKeepAliveTimeout :" + controlKeepAliveTimeout);
		this.controlKeepAliveReplyTimeout = controlKeepAliveTimeout;
		logger.info("ftp controlKeepAliveReplyTimeout :" + controlKeepAliveTimeout);
		
	}

	@Override
	public Object makeObject() throws Exception {
		FTPClient ftpClient = new FTPClient();
		ftpClient.connect(host, port);
		ftpClient.setControlKeepAliveTimeout(controlKeepAliveTimeout);
		ftpClient.setControlKeepAliveReplyTimeout(controlKeepAliveReplyTimeout);
		ftpClient.login(user, password);
		boolean passiveMode = false;
		if (passiveModeConf == null || Boolean.parseBoolean(passiveModeConf) == true) {
			passiveMode = true;
		}
		if (passiveMode) {
			ftpClient.enterLocalPassiveMode();
		}
		ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
		return ftpClient;
	}

	@Override
	public void destroyObject(Object obj) throws Exception {
		if (obj instanceof FTPClient) {
			FTPClient ftpClient = (FTPClient) obj;
			if (!ftpClient.isConnected())
				return;
			try {
				ftpClient.disconnect();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	public boolean validateObject(Object obj) {
		if (obj instanceof FTPClient) {
			FTPClient ftpClient = (FTPClient) obj;
			try {
				return ftpClient.isConnected();
			} catch (Exception e) {
				return false;
			}
		}
		return false;
	}
}