<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>项目列表</title>
<%@include file="/common/jsp/mytag.jsp"%>
<%@include file="/common/jsp/bootstrap.jsp" %>
</head>
<body>
	
	<div class="container-fluid">
		<div class="row base-margin" id="query">
			<form class="form-inline" role="form" method="post" id="query-form">　
				<div class="form-group">
					<label>项目名称</label>
					<input class="form-control" id="projectname" name="projectname"/>
				</div>
				
				<div class="form-group group1">   
              		<button type="button" id="searchBtn" class="btn btn-primary">查询</button>
	            </div>
	            
	            <div class="form-group group2">
	            	<button type="button" id="resetBtn" onclick="formReset();" class="btn btn-primary">重置</button>
	            </div>
			</form>
		</div>
		
		 <div class="container" style="width: 100%">
	        <div id="toolbar" class="btn-group group3">
					<div class="btn-group">
				       <button class="btn btn-primary" id="addBtn" >新增</button>
				    </div>
				    <div class="btn-group">
				       <button class="btn btn-primary" id="editBtn">修改</button>
				    </div>
				    <div class="btn-group">
				       <button class="btn btn-primary" id="editBtn">删除</button>
				    </div>
			</div>
	        <table id="project-table">
	        </table>
	    </div>
	</div>
	<script type="text/javascript">
		$(function(){
			var tableObj = $("#project-table");
			tableObj.bootstrapTable({
				url: "${webRoot}/projectmanage/list",
				dataType: 'json',
				method: 'GET',
				pagination: true,
				pageList: [10, 25, 35, 50, 100],
				pageSize: pageIndexSize,
				pageNum: pageNumber,
				cache: false,
				clickToSelect: true,
				showRefresh: true,
				queryParams:function(params){
					return {
						pageSize: params.pageSize,
						pageNumber: params.pageNumber,
						projectname: $("#projectname").val()
					}
				},
				uniqueId: 'id',
				columns:[{
					filed:'id',
					checkbox: true
				},{
					filed: 'projectcode',
					title: '项目CODE',
					align: 'center',
					formatter:function(value, row, index){
						return row["projectcode"]
					}	
				},{
					filed: 'projectname',
					title: '项目名称',
					align: 'center',
					formatter:function(value, row, index){
						return row['projectname']
					}
				},{
					filed: 'ledgerid',
					title: '财产类型',
					align: 'center',
					formatter: function(value, row ,index){
						if(row['ledgerid'] == 1){
							return "私募基金";
						}else if(row['ledgerid'] == 2){
							return "信托基金";
						}else{
							return "个人财产";
						}
						return value
					}
				},{
					filed: 'sellstartdate',
					title: '预计发行开始时间',
					align: 'center',
					formatter: function(value, row, index){
						return dateFormatUtil(row['sellstartdate'])
					}
				},{
					filed: 'sellenddate',
					title: '预计发行结束时间',
					align: 'center',
					formatter: function(value, row, index){
						return dateFormatUtil(row['sellenddate'])
					}
				},{
					filed: 'effectdate',
					title: '生效时间',
					align: 'center',
					formatter: function(value, row, index){
						return dateFormatUtil(row['effectdate'])
					}
				},{
					filed: 'establishdate',
					title: '信托成立时间',
					align: 'center',
					formatter: function(value, row, index){
						return dateFormatUtil(row['establishdate'])
					}
				}]
				
			})
			
			
			$("#searchBtn").click(function(){
				tableObj.bootstrapTable('refresh')
			})
		
			$("#addBtn").click(function(){
			  	var index = tableObj.bootstrapTable('getData').length;
			  	tableObj.bootstrapTable("insertRow", {
					index: index,
					row: {
						id: '',
						projectname:''
					}
				});
			})
			
			$("#editBtn").click(function(){
				
			})
		})
		
		function formReset(){
			$("#projectname").val('');
			$("#searchBtn").click();
		}
	</script>
</body>
</html>