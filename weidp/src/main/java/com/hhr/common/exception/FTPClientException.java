package com.hhr.common.exception;

public class FTPClientException extends Exception {

	private static final long serialVersionUID = 1L;

	public FTPClientException(String msg, Exception e) {
		super(msg, e);
	}
	
	public FTPClientException(String msg) {
		super(msg);
	}

}
