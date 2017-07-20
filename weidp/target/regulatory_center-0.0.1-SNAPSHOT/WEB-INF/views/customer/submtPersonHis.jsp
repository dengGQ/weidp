<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<%@include file="/common/jsp/bootstrap.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>客户个人信息_历史</title>
</head>
<body>
	<div class="container-fluid">
		<br/>
		<div class="container">
			<table id="perpersonhis-table">
			</table>
		</div>
	</div>
	<script>
	var perpersonhisUrl = "${webRoot}/customer/submtPersonHis";
		$(function() {
			
			$("#resetBtn").click(function() {
				$('.form-control').val('');
			});
			
			$("#queryBtn").click(function() {
				$('#perpersonhis-table').bootstrapTable('refresh');
			});
			initPerpersonhisTable();
		});


		function initPerpersonhisTable() {
			$('#perpersonhis-table')
					.bootstrapTable(
							{
								method : 'GET',
								url : perpersonhisUrl,
								queryParams : function queryParams(params) { //设置查询参数  
									var param = {
										pageSize : params.pageSize,
										pageNumber : params.pageNumber,
										certNo : $("#certno").val(),
										name : $("#name").val()
									};
									return param;
								},
								columns : [ {
									checkbox : true
								}, {
									field : 'name',
									title : '客户姓名',
									align : 'center',
									valign : 'middle',
									sortable : true,
								}, {
									field : 'certtype',
									title : '证件类型',
									align : 'center',
									valign : 'middle',
									formatter: function (value) {return value==0?'身份证':'军官证'}
								}, {
									field : 'certno',
									title : '证件号码',
									align : 'center',
									valign : 'middle'
								}, {
									field : 'gender',
									title : '性别',
									align : 'center',
									valign : 'middle',
									formatter: function (value) {return value==1?'男':'女'}
								}, {
									field : 'birthday',
									title : '出生日期',
									align : 'center',
									valign : 'middle',
									formatter: function (value) {return dateFormatUtil(value);}
								}, {
									field : 'marriage',
									title : '婚姻状况',
									align : 'center',
									valign : 'middle',
									formatter: function (value) {
										if(value == 20){
											value = '已婚';
										}else if(value == 90){
											value = '丧偶';
										}else if(value == 10){
											value = '未婚';
										}
										return value;
									}
								}, {
									field : 'spouse_name',
									title : '配偶姓名',
									align : 'center',
									valign : 'middle'
								},{
									field : 'mobiletel',
									title : '手机号码',
									align : 'center',
									valign : 'middle'
								},{
									field : 'address',
									title : '通讯地址',
									align : 'center',
									valign : 'middle'
								},{
									field : 'zip',
									title : '通讯邮政编码',
									align : 'center',
									valign : 'middle'
								},{
									field : 'residence',
									title : '户籍地址',
									align : 'center',
									valign : 'middle'
								},{
									field : 'data_src',
									title : '数据来源',
									align : 'center',
									valign : 'middle',
									formatter: function (value) {return getDataSrc(value)}
								},{
									field : 'job_batch',
									title : '批次号',
									align : 'center',
									valign : 'middle'
								}]
							});
		}

		function formReset() {
			document.getElementById("queryForm").reset()
		}
		
	</script>
</body>
</html>