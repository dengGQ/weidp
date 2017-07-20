<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>客户家庭住址信息_历史</title>
<!-- 导入jquery bootstrap js css lib -->
<%@include file="/common/jsp/bootstrap.jsp"%>

</head>
<body>
	<div class="container-fluid">
		<br/>
		<div class="container">
			<table id="addrHis-table">
			</table>
		</div>
	</div>
		
	<script>
		var addrHisTableUrl = "${webRoot}/customer/addrHisPage";
		$(function() {
			$("#resetBtn").click(function(){
				  $('.form-control').val('');
			});
			
			$("#queryBtn").click(function(){
				var param = {
						url : addrHisTableUrl,
						query : {
							pageNumber : 1, //初始化加载第一页，默认第一页
							pageSize : 25,
							certNo : $("#certNo").val(),
							name : $("#name").val()
						}
					}
					$('#addrHis-table').bootstrapTable('refresh', param);
			});
			
			initAddrHisTable();
		});
		
		function initAddrHisTable() {
			$('#addrHis-table').bootstrapTable(
			{
				method : 'GET',
				dataType : 'json',
				contentType : "application/json;charset=utf-8",
				pagination : true, //是否显示分页（*）
				cache : false,
				showRefresh : true,
				striped : true, //是否显示行间隔色
				sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
				clickToSelect : true, //是否启用点击选中行
				showToggle : false, //是否显示详细视图和列表视图的切换按钮
				url : addrHisTableUrl,
				showColumns : true,
				queryParamsType : "undefined",
				queryParams : function queryParams(params) { //设置查询参数  
					var param = {
						pageSize : params.pageSize,
						pageNumber : params.pageNumber,
						certNo : $("#certno").val(),
						name : $("#name").val()
					};
					return param;
				},
				minimumCountColumns : 2,
				pageNumber : pageNumber, //初始化加载第一页，默认第一页
				pageSize : pageIndexSize, //每页的记录行数（*）
				pageList : pageList, //可供选择的每页的行数（*）
				uniqueId : "id", //每一行的唯一标识，一般为主键列
				columns : [
					{field: '', title: '序号', formatter: function (value, row, index) { return index+1; }},
       				{field : 'name', title : '姓名', align : 'center', valign : 'middle', sortable : true},
	       			{field : 'certType', title : '证件类型', align : 'center', valign : 'middle' }, 
	       			{field : 'certNo', title : '证件号码', align : 'center', valign : 'middle'}, 
	       			{field : 'deptCode', title : '数据发生机构代码', align : 'center', valign : 'middle'}, 
	       			{field : 'residence', title : '居住地址', align : 'center', valign : 'middle'}, 
	       			{field : 'resZip', title : '居住地址邮编', align : 'center', valign : 'middle'}, 
	       			{field : 'resCondition', title : '居住状况', align : 'center', valign : 'middle'}, 
	       			{field : 'bussDate', title : '数据业务日期', align : 'center', valign : 'middle', formatter: function (value) {return dateFormatUtil(value);}}, 
	       			{field : 'dataStatus', title : '数据检验状态', align : 'center', valign : 'middle', formatter: function (value) {return getValidateStatus(value)}}, 
	       			{field : 'insertDttm', title : '数据生成时间', align : 'center', valign : 'middle', formatter: function (value) {return dateFormatUtil(value);}}, 
	       			{field : 'dataSrc',title : '数据来源',align : 'center',valign : 'middle', formatter: function (value) {return getDataSrc(value)}}
        		  ]
			});
		}

	</script>
</body>
</html>