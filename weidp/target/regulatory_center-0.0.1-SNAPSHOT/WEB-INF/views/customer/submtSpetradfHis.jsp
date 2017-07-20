<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<%@include file="/common/jsp/bootstrap.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>特殊交易信息_历史</title>
</head>
<body>
	<div class="container-fluid">
		<br/>
		<div class="container">
			   
			<table id="spetHis-table">
			</table>
		</div>
	</div>
		
	<script>
		var spetHisUrl = "${webRoot}/customer/spetradHisPage";
		$(function() {
			
			$("#resetBtn").click(function(){
				  $('.form-control').val('');
			});
			
			$("#queryBtn").click(function(){
				$('#spetHis-table').bootstrapTable('refresh');
			});
			
			initSpetHisTable();
		});
		
		function initSpetHisTable() {
			$('#spetHis-table').bootstrapTable(
			{
				method : 'GET',
				url : spetHisUrl,
				queryParams : function queryParams(params) { //设置查询参数  
					var param = {
						pageSize : params.pageSize,
						pageNumber : params.pageNumber,
						certNo : $("#certno").val(),
						name : $("#name").val()
					};
					return param;
				},
				columns : [
					{field: '', title: '序号', formatter: function (value, row, index) { return index+1; }},
					{field : 'account', title : '业务号', align : 'center', valign : 'middle', sortable : true},
		   			{field : 'tradeid', title : '交易ID', align : 'center', valign : 'middle' }, 
		   			{field : 'deptcode', title : '数据发生机构代码', align : 'center', valign : 'middle'}, 
		   			{field : 'spectype', title : '特殊交易类型', align : 'center', valign : 'middle'}, 
		   			{field : 'specdate', title : '发生日期', align : 'center', valign : 'middle', formatter: function (value) {return dateFormatUtil(value);}}, 
		   			{field : 'specmonth', title : '变更期数', align : 'center', valign : 'middle'}, 
		   			{field : 'specmoney', title : '发生金额', align : 'center', valign : 'middle'}, 
		   			{field : 'specdetail', title : '明细记录', align : 'center', valign : 'middle'}, 
		   			{field : 'bussDate', title : '数据业务日期', align : 'center', valign : 'middle', formatter: function (value) {return dateFormatUtil(value);}}, 
		   			{field : 'dataStatus', title : '数据检验状态', align : 'center', valign : 'middle', formatter: function (value) {return getValidateStatus(value)}}, 
		   			{field : 'insertDttm',title : '数据生成时间',align : 'center',valign : 'middle', formatter: function (value) {return dateFormatUtil(value);}},
		   			{field : 'dataSrc',title : '数据来源',align : 'center',valign : 'middle', formatter: function (value) {return getDataSrc(value)}},
		   			{field : 'jobBatch',title : '批次号',align : 'center',valign : 'middle'}
				  ]
			});
		}

	</script>
</body>
</html>