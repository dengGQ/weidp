package com.fotic.common.util;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fotic.common.ftp.FtpUtil;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;

/**
 * DsJob工具类
 * @author zhaoqh
 */
public class DsJobUtil {
	private static Logger logger = LoggerFactory.getLogger(DsJobUtil.class.getName());
	private static String ipAddr = PropertiesUtil.get("ds.ipAddr");
	private static String charset = Charset.defaultCharset().toString();
	private static String userName = PropertiesUtil.get("ds.userName");;
	private static String password = PropertiesUtil.get("ds.password");;

	private static Connection getConnection() {
		Connection conn = new Connection(ipAddr);
		try {
			conn.connect(); // 连接
			boolean flag = conn.authenticateWithPassword(userName, password); // 认证
			if (!flag) {
				conn = null;
			}
		} catch (IOException e) {
			conn.close();
			conn = null;
			e.printStackTrace();
		}

		return conn;

	}
	
	/**
	 * 执行命令
	 * @param cmds 可以传多个命令, 只有最后一个命令产生返回值(不包含删除命令)
	 * @return
	 */
	public static String exec(String[] cmds) {
		Connection conn = getConnection();
		InputStream in = null;
		Session session = null;
		String result = "";
		if (conn != null) {
			//删除日志命令
			String delLogCommand = null;
			//调用job命令
			StringBuffer cmd = new StringBuffer();
			int cmdsLength = cmds.length;
			for (int i = 0; i < cmdsLength; i++) {
				String command = cmds[i];
				//判断最后一条是否为null, 用于是否执行删除日志命令(约定最后一个命令为删除命令)
				if(cmdsLength == i+1){
					delLogCommand = command;
				}else{
				    if(StringUtils.isBlank(command)){
				        continue;
				    }
					//拼接其他命令行
					cmd.append(command).append(";");
				}
				
			}
			logger.info("dsjob命令："+cmd.toString());
			try { 
				// 打开一个会话
				session = conn.openSession();
				session.execCommand(cmd.toString());
				in = new StreamGobbler(session.getStderr());
				result = processStdout(in, charset);
			} catch (IOException e) {
				if(conn.isAuthenticationPartialSuccess()||session==null){
					logger.error("获取ds服务器连接失败",e);
				}else{
					logger.error("执行脚本命令报错",e);
				}
			} finally {
				//关闭会话连接
				session.close();
				//如果需要执行删除命令, 在删除命令执行完毕后关闭连接
				if(delLogCommand==null){
					conn.close();
				}
			}
			
			//执行删除命令, 不需要返回值
			if(delLogCommand!=null){
				try {
					session = conn.openSession();
					session.execCommand(delLogCommand);
				} catch (IOException e) {
					if(conn.isAuthenticationPartialSuccess()||session==null){
						logger.error("获取ds服务器连接失败",e);
					}else{
						logger.error("执行脚本命令报错",e);
					}
				}finally {
					session.close();
					conn.close();
				}
				
			}
			
			logger.info("job返回正确信息："+result);
		}

		return result;
	}

	/**
	 * 解析流获取字符串信息
	 * @param in  输入流对象
	 * @param charset 字符集
	 * @return
	 */
	private static String processStdout(InputStream in, String charset) {
		byte[] buf = new byte[1024];
		StringBuffer sb = new StringBuffer();
		try {
			while (in.read(buf) != -1) {
				sb.append(new String(buf, charset));
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return sb.toString();
	}

	public static void main(String[] args) {
//		String[] cmds = new String[]{"source  /opt/IBM/InformationServer/Server/DSEngine/dsenv", 
//				"/opt/IBM/InformationServer/Server/DSEngine/bin/dsjob -run -mode NORMAL -param \\$ETL_DATE='20170617' -jobstatus ZQTEST Q_S_MFS_REBUY1 > /home/dsadm/RHZX_DSLOG/Q_I_MFS_PROJ.log",
//				"cat /home/dsadm/RHZX_DSLOG/Q_I_MFS_PROJ.log | grep -A1 'Job Status' "};
////		String[] cmds = new String[]{"ls","cat /home/dsadm/RHZX_DSLOG/Q_I_MFS_PROJ.log | grep -A1 'Job Status'"};
//		
//		String retStr = exec(cmds);
//		System.out.println(retStr);\
	}
	
	/**
	 * 生成dsjob调用脚本
	 * @param jobName	job名称
	 * @param paramKey	job参数
	 * @param paramValue	job参数值
	 * @param delLogFlag	是否要删除日志文件
	 * @return
	 */
	public static String[] processCMDS(String jobName, String paramKey, String paramValue, boolean delLogFlag){
		//第一步 -- 执行source命令
		String sourceCommand = new StringBuffer("source ").append(PropertiesUtil.get("ds.source")).toString();
		//第二步 -- 进入ds工具bin目录
		String inBinCommand = new StringBuffer("cd ").append(PropertiesUtil.get("ds.dsbin")).toString();
		
		//第三部 -- 调用dsjob
		StringBuffer jobInvokeCommand = new StringBuffer("./dsjob -run -mode NORMAL -param '").append(paramKey).append("='").append(paramValue).append("''")
                .append(" -jobstatus ").append(PropertiesUtil.get("ds.user")).append(" ").append(jobName);
		
		//第四步 -- 读取重定向日志
        String findStatusCommand = null;
		//第五步 -- 删除日志文件
        String deleteLogCommand = null;
		if(delLogFlag) {
		   //日志文件名称和位置
	        String logFullPath = FtpUtil.getFileName(PropertiesUtil.get("ds.log"))+".log";
            jobInvokeCommand.append(" > ").append(logFullPath);
            findStatusCommand = new StringBuffer("cat ").append(logFullPath).append(" | grep -A1 'Job Status' ").toString();
            deleteLogCommand = new StringBuffer("rm -fr ").append(logFullPath).toString();
        }
		
		return new String[]{sourceCommand, inBinCommand, jobInvokeCommand.toString(), findStatusCommand, deleteLogCommand};
	}
	
	 
	
	
	/**
	 * 生成dsjob调用脚本
	 * @param jobName	job名称
	 * @param paramKey	job参数
	 * @param paramValue	job参数值
	 * @return
	 */
	public static String[] processCMDS(String jobName, String paramKey, String paramValue){
		 return processCMDS(jobName, paramKey, paramValue, false);
	}
}
