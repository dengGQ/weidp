<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>客户职业信息_历史</title>
<!-- 导入jquery bootstrap js css lib -->
<%@include file="/common/jsp/bootstrap.jsp"%>

</head>
<body>
	<div class="container-fluid">
		<br/>
		<div class="container">
			<table id="submitemp-table">
			</table>
		</div>
	</div>
		
	<script>
		var submitempUrl = "${webRoot}/customer/empHisSearchListByPage";
		$(function() {
			initSubmitempTable();
			
			$("#resetBtn").click(function() {
				$('.form-control').val('');
			});
			
			$("#queryBtn").click(function() {
				var param = {
					url : submitempUrl,
					query : {
						pageNumber : 1, //初始化加载第一页，默认第一页
						pageSize : 25,
						name : $("#name").val(),
						certno : $("#certno").val()
				
					}
				}
				$('#submitemp-table').bootstrapTable(
						'refresh', param);
			});
		});
		
		function doQuery(params) {
			$('#submitemp-table').bootstrapTable('refresh'); //刷新表格
		};

		function formReset() {
			document.getElementById("queryForm").reset()
		}

		function initSubmitempTable() {
			$('#submitemp-table').bootstrapTable(
			{
				method : 'GET',
				dataType : 'json',
				contentType : "application/json;charset=utf-8",
				pagination : true, //是否显示分页（*）
				toolbar : '#toolbar',
				cache : false,
				showRefresh : true,
				striped : true, //是否显示行间隔色
				sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
				clickToSelect : true, //是否启用点击选中行
				showToggle : false, //是否显示详细视图和列表视图的切换按钮
				singleSelect : false,//复选框单选
				url : submitempUrl,
				showColumns : true,
				queryParamsType : "undefined",
				queryParams : function queryParams(params) { //设置查询参数  
					var param = {
						pageSize : params.pageSize,
						pageNumber : params.pageNumber,
						name : $("#name").val(),
						certno : $("#certno").val()
					};
					return param;
				},
				minimumCountColumns : 2,
				pageNumber : pageNumber, //初始化加载第一页，默认第一页
				pageSize : pageIndexSize, //每页的记录行数（*）
				pageList : pageList, //可供选择的每页的行数（*）
				uniqueId : "id", //每一行的唯一标识，一般为主键列
				columns : [{field: '', title: '序号', formatter: function (value, row, index) { return index+1; }},{
					field : 'name',
					title : '姓名',
					align : 'center',
					valign : 'middle',
				}, {
					field : 'occupation',
					title : '职业信息',
					align : 'center',
					valign : 'middle'
				}, {
					field : 'company',
					title : '单位名称',
					align : 'center',
					valign : 'middle'
				}, {
					field : 'industry',
					title : '单位所属行业',
					align : 'center',
					valign : 'middle'
				}, {
					field : 'occaddress',
					title : '单位地址',
					align : 'center',
					valign : 'middle'
				}, {
					field : 'startyear',
					title : '本单位工作起始年份',
					align : 'center',
					valign : 'middle'
				}, {
					field : 'duty',
					title : '本人职务',
					align : 'center',
					valign : 'middle'
				}, {
					field : 'annualincome',
					title : '年收入',
					align : 'center',
					valign : 'middle'
				}, {
					field : 'bussDate',
					title : '数据业务日期',
					align : 'center',
					valign : 'middle'
				} ]
			});
		};

	</script>
</body>
</html>