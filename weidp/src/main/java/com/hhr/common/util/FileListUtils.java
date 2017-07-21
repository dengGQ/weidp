package com.hhr.common.util;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class FileListUtils {

	private String path = "";

	public FileListUtils(String path) {
		this.path = path;
	}

	/**
	 * 获取所有文件列表
	 * 
	 * @return
	 */
	public List<File> getfList() {
		List<File> fileList = new ArrayList<File>();
		File file = new File(path);
		File[] tempList = file.listFiles();
		for (int i = 0; i < tempList.length; i++) {
				fileList.add(tempList[i]);
		}
		return fileList;
	}

	/**
	 * 获取文件夹列表
	 * 
	 * @return
	 */
	public List<File> getdList() {
		List<File> fileList = new ArrayList<File>();
		File file = new File(path);
		File[] tempList = file.listFiles();
		for (int i = 0; i < tempList.length; i++) {
			if (tempList[i].isDirectory()) {
				fileList.add(tempList[i]);
			}
		}
		return fileList;
	}

}
