<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>信贷信息管理-csv导入</title>
<!-- 导入jquery bootstrap js css lib -->
<%@include file="/common/jsp/bootstrap.jsp"%>
<!-- 导入bootstrap-fileinput js css -->
<%@include file="/common/jsp/fileupload.jsp"%>
 
</head>
<body>
	<div class="container-fluid">
		<div class="row base-margin">
	 
			<div class="form-group">
				<label for="file" >CSV文件:</label> 
				<input id="file"  name="file"type="file" >
			</div>
		</div>
	</div>

	<script type="text/javascript"
		src="${webRoot}/common/js/bootstrapFileInput.js"></script>
	<script type="text/javascript"
		src="${webRoot}/js/reportinfo/importCSV.js"></script>

		
</body>
</html>