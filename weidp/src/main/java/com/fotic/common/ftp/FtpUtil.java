package com.fotic.common.ftp;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;
import org.apache.commons.pool.impl.GenericObjectPool;
import org.apache.commons.pool.impl.GenericObjectPool.Config;
import org.springframework.web.multipart.MultipartFile;

import com.fotic.common.exception.FTPClientException;
import com.fotic.common.ftp.pool.FTPPool;
import com.fotic.common.util.PropertiesUtil;
import com.fotic.common.util.RandomStringUtil;
import com.fotic.common.util.StringUtils;

/**
 * ftp服务器操作工具类
 * 
 * @author zhaoqh
 *
 */
public class FtpUtil {
	// private static Logger logger = LoggerFactory.getLogger(FtpUtil.class);

	private static FTPPool pool = null;

	/**
	 * 最大池容量
	 */
	private static final int FTP_DEFUALT_MAXACTIVE = 10;

	/**
	 * whenExhaustedAction 如果是WHEN_EXHAUSTED_BLOCK，指定等待的毫秒数
	 */
	private static final int FTP_DEFUALT_MAXWAIT = 60000;

	/**
	 * 链接保持时间 , 默认15分钟
	 */
	private static final int FTP_DEFUALT_CONTROL_KEEP_ALIVE_TIMEOUT = 900000;

	/**
	 * 默认端口
	 */
	private static final int FTP_DEFUALT_PORT = 21;

	/**
	 * 如果是WHEN_EXHAUSTED_FAIL，当池中对象达到上限以后，继续borrowObject会抛出NoSuchElementException异常。
	 * 如果是WHEN_EXHAUSTED_GROW，当池中对象达到上限以后，会创建一个新对象，并返回它。
	 * 如果是WHEN_EXHAUSTED_BLOCK，当池中对象达到上限以后，会一直等待，直到有一个对象可用。这个行为还与maxWait有关，如果maxWait是正数，那么会等待maxWait的毫秒的时间，超时会抛出NoSuchElementException异常；如果maxWait为负值，会永久等待。
	 * whenExhaustedAction 的默认值是WHEN_EXHAUSTED_BLOCK，maxWait的默认值是-1。
	 */
	private static final byte FTP_DEFUALT_WHEN_EXHAUSTED_ACTION = GenericObjectPool.WHEN_EXHAUSTED_GROW;

	/**
	 * 支持数据流的被动式联机模式(YES (NO)) 一定要设定为 YES！
	 */
	private static final String FTP_DEFUALT_PASSIVE_MODE = "true";

	/**
	 * 如果testOnBorrow被设置，pool会在borrowObject返回对象之前使用PoolableObjectFactory的validateObject来验证这个对象是否有效，要是对象没通过验证，这个对象会被丢弃，然后重新选择一个新的对象。
	 */
	private static final boolean FTP_DEFUALT_TEST_ON_BORROW = true;

	/**
	 * 如果testOnReturn被设置，pool会在returnObject的时候通过PoolableObjectFactory的validateObject方法验证对象，如果对象没通过验证，对象会被丢弃，不会被放到池中。
	 */
	private static final boolean FTP_DEFUALT_TEST_ON_RETURN = true;

	static {
		initFTPPool();
	}

	/**
	 * 初始化配置信息
	 * 
	 * @return
	 */
	private static GenericObjectPool.Config initConfig() {
		GenericObjectPool.Config config = new Config();

		int maxActive = StringUtils.objToInt(PropertiesUtil.get("maxActive"), FTP_DEFUALT_MAXACTIVE);
		int maxWait = StringUtils.objToInt(PropertiesUtil.get("maxWait"), FTP_DEFUALT_MAXWAIT);
		boolean testOnBorrow = StringUtils.objToBoolean(PropertiesUtil.get("testOnBorrow"), FTP_DEFUALT_TEST_ON_BORROW);
		boolean testOnReturn = StringUtils.objToBoolean(PropertiesUtil.get("testOnReturn"), FTP_DEFUALT_TEST_ON_RETURN);
		byte whenExhaustedAction = StringUtils.objToByte(PropertiesUtil.get("whenExhaustedAction"),
				FTP_DEFUALT_WHEN_EXHAUSTED_ACTION);
		/*
		 * 最大池容量
		 */
		config.maxActive = maxActive;
		/*
		 * 如果是WHEN_EXHAUSTED_FAIL，当池中对象达到上限以后，
		 * 继续borrowObject会抛出NoSuchElementException异常。
		 * 如果是WHEN_EXHAUSTED_GROW，当池中对象达到上限以后，会创建一个新对象，并返回它。
		 * 如果是WHEN_EXHAUSTED_BLOCK，当池中对象达到上限以后，会一直等待，直到有一个对象可用。这个行为还与maxWait有关，
		 * 如果maxWait是正数，那么会等待maxWait的毫秒的时间，超时会抛出NoSuchElementException异常；
		 * 如果maxWait为负值，会永久等待。 whenExhaustedAction
		 * 的默认值是WHEN_EXHAUSTED_BLOCK，maxWait的默认值是-1。
		 */
		config.whenExhaustedAction = whenExhaustedAction;
		/*
		 * whenExhaustedAction 如果是WHEN_EXHAUSTED_BLOCK，指定等待的毫秒数
		 */
		config.maxWait = maxWait;
		/*
		 * 如果testOnBorrow被设置，
		 * pool会在borrowObject返回对象之前使用PoolableObjectFactory的validateObject来验证这个对象是否有效
		 * ，要是对象没通过验证，这个对象会被丢弃，然后重新选择一个新的对象。
		 */
		config.testOnBorrow = testOnBorrow;
		/*
		 * 如果testOnReturn被设置，
		 * pool会在returnObject的时候通过PoolableObjectFactory的validateObject方法验证对象，
		 * 如果对象没通过验证，对象会被丢弃，不会被放到池中。
		 */
		config.testOnReturn = testOnReturn;

		return config;
	}

	/**
	 * 初始化池信息
	 */
	private static void initFTPPool() {
		GenericObjectPool.Config config = initConfig();
		String host = PropertiesUtil.get("host");
		int port = StringUtils.objToInt(PropertiesUtil.get("port"), FTP_DEFUALT_PORT);
		int controlKeepAliveTimeout = StringUtils.objToInt(PropertiesUtil.get("controlKeepAliveTimeout"),
				FTP_DEFUALT_CONTROL_KEEP_ALIVE_TIMEOUT);
		String userName = PropertiesUtil.get("userName");
		String password = PropertiesUtil.get("password");
		pool = new FTPPool(config, host, port, userName, password, FTP_DEFUALT_PASSIVE_MODE, controlKeepAliveTimeout);
	}

	/**
	 * 获取唯一的文件名称
	 * 
	 * @param prefix
	 *            文件前缀
	 * @return
	 */
	public static String getFileName(String prefix) {
		return new StringBuffer().append(prefix).append(RandomStringUtil.getString(6)).toString();
	}

	public static void main(String[] args) {
		System.out.println(getFileName("/home/dsadm/RHZX_DSLOG/Q_I_MFS_PROJ"));
	}

	/**
	 * 获取FTPClient对象
	 * 
	 * @return
	 */
	public static FTPClient getFTPClient() {
		return pool.getResource();
	}

	/**
	 * 创建FTP服务器文件目录
	 * 
	 * @param client
	 * @param basePath
	 * @param filePath
	 */
	private static void makeDir(FTPClient client, String basePath, String filePath) {
		String[] dirs = filePath.split("/");
		for (String dir : dirs) {
			if (StringUtils.isBlank(dir))
				continue;
			basePath += File.separator + dir;
			try {
				if (!client.changeWorkingDirectory(basePath)) {
					if (!client.makeDirectory(basePath)) {
					} else {
						client.changeWorkingDirectory(basePath);
					}
				}
			} catch (IOException e) {
				new FTPClientException("创建FTP服务器文件目录出错:" + basePath, e);
			}
		}
	}

	/**
	 * 下载文件
	 * 
	 * @param response
	 * @param fileName
	 *            文件名称
	 * @param path
	 *            文件路径
	 * @return
	 */
	public static boolean downloadFile(HttpServletResponse response, String fileName, String path) {
		response.setCharacterEncoding("UTF-8");
		response.setContentType("multipart/form-data;charset=UTF-8");
		try {
			FTPClient client = pool.getResource();
			client.changeWorkingDirectory(path);
			FTPFile[] fs = client.listFiles();
			for (FTPFile ff : fs) {
				if (ff.getName().equals(fileName)) {
					response.setHeader("Content-Disposition",
							"attachment;fileName=" + new String(ff.getName().getBytes("gb2312"), "ISO8859-1"));
					OutputStream os = response.getOutputStream();
					client.retrieveFile(ff.getName(), os);
					os.flush();
					os.close();
					break;
				}
			}
			pool.returnResource(client);
		} catch (Exception e) {
			new FTPClientException("FTP下载文件失败,method : downloadFile", e);
		}
		return true;
	}

	/**
	 * 上传文件到FTP服务器
	 * 
	 * @param uploadFile
	 * @param basePath
	 * @param filePath
	 * @return
	 */
	public static boolean uploadFile(MultipartFile[] uploadFile, String basePath, String filePath,
			String... fileNames) {
		try {
			FTPClient client = pool.getResource();

			// 切换到上传目录 ,basepath需已存在
			if (!client.changeWorkingDirectory(basePath + filePath)) {
				makeDir(client, basePath, filePath);
			}

			if (uploadFile != null && uploadFile.length > 0) {
				for (int i = 0; i < uploadFile.length; i++) {
					MultipartFile file = uploadFile[i];
					String fileName = fileNames != null ? fileNames[i] : null;
					saveFile(file, client, fileName);
				}
			}
			pool.returnResource(client);
			;
		} catch (Exception e) {
			e.printStackTrace();
			new FTPClientException("FTP上传文件失败,method : uploadFile", e);
		}
		return true;
	}

	/**
	 * 保持文件到FTP服务器
	 * 
	 * @param file
	 * @param client
	 * @return
	 */
	private static boolean saveFile(MultipartFile file, FTPClient client, String fileName) {
		boolean success = false;
		InputStream inStream = null;
		try {
			fileName = StringUtils.isNotBlank(fileName) ? fileName : file.getOriginalFilename();
			inStream = file.getInputStream();
			success = client.storeFile(fileName, inStream);
			if (success) {
				return success;
			}
		} catch (Exception e) {
			new FTPClientException("FTP上传文件失败,method : saveFile", e);
		} finally {
			if (inStream != null) {
				try {
					inStream.close();
				} catch (IOException e) {
					new FTPClientException("FTP上传文件,输入流关闭失败", e);
				}
			}
		}
		return success;
	}

	/**
	 * 新增ftp上传文件
	 * @param basePath
	 *            FTP服务器中文件保存的根目录
	 * @param filePath
	 *            FTP服务器文件保存的子目录
	 * @param filename
	 *            上传到FTP服务器上的文件名
	 * @param input
	 *            输入流
	 * @param client
	 * @return
	 */
	public static boolean uploadFile(String basePath,String filePath, String filename, InputStream input) {
		boolean success = false;
		FTPClient client = pool.getResource();
		try {
			// 切换到上传目录 ,basepath需已存在
			if (!client.changeWorkingDirectory(basePath + filePath)) {
				makeDir(client, basePath, filePath);
			}
			client.storeFile(filename, input);
			input.close();
			client.logout();
			pool.returnResource(client);
			success = true;
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (client.isConnected()) {
				try {
					client.disconnect();
				} catch (IOException ioe) {
				}
			}
		}
		return success;
	}
}