<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<%@include file="/common/jsp/bootstrap.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>错误信息查询</title>
</head>
<body>
	<div class="container-fluid">
		<div class="row base-margin" id="query">
			<form class="form-inline"  method="post" id="queryForm">
				<div class="form-group">
					<label >合作机构:</label> 
					<input type="text"  class="hidden" name="orgNo"  id="orgNo"> 
					<input type="text" class="form-control"  readonly="readonly"  name="orgName" id="orgName"  onclick="selectOrg()" placeholder="请选择"/>
				</div>
				<div class="form-group">
					<label >业务号:</label> 
					<input type="text" class="form-control" name="contractNo" id="contractNo" />
				</div>
				<div class="form-group">
                	<label>证件类型：</label>
                        <select id="credType" name="credType" class="selectpicker">
                            <option value="0">身份证</option>
                            <option value="1">户口簿</option>
                            <option value="2">护照</option>
                            <option value="3">军官证</option>
                            <option value="4">士兵证</option>
                            <option value="5">港澳居民来往内地通行证</option>
                            <option value="6">台湾同胞来往内地通行证</option>
                            <option value="7">临时身份证</option>
                            <option value="8">外国人居留证</option>
                            <option value="9">警官证</option>
                            <option value="X">其他证件</option>
                        </select>
                 </div>
				<div class="form-group">
					<label >证件号码:</label> 
					<input type="text" class="form-control" name="credNo" id="credNo" />
				</div>
				<div class="form-group btn2">
					<button type="button" id="queryBtn" class="btn btn-primary">查询</button>
					<button type="button" id="resetBtn" class="btn btn-primary">重置</button>
				</div>
			</form>
		</div>
		<div class="container">
			<table id="error-table"> </table>
		</div>
	</div>
		
<script>
	var queryUrl = "${webRoot}/error/errorMsgPage";
	
	/**
	 * 机构下拉框
	 */
	function selectOrg(){
		var projectNum;
		var index = layer.open({
			  type: 2,
			  title: '选择机构',
			  maxmin: true,
			  content: '${webRoot}/publicquery/org',
			  area: ['850px', '500px'],
			  btn: ['确定','关闭'],
              yes: function(index){
                  projectNum = window["layui-layer-iframe" + index].callbackdata();
                  $("#orgNo").val(projectNum[0]);
                  $("#orgName").val(projectNum[1]);
                  //最后关闭弹出层
                  layer.close(index);
              },
              cancel: function(){
              }
		});
	}
	$(function() {
		initTable();
		/**
		* 主页查询按钮
		*/
		$("#queryBtn").click(function() {
			$('#error-table').bootstrapTable( 'refresh');
		});
		
		/**
		 * 重置按钮
		 */
		$("#resetBtn").click(function() {
			document.getElementById('queryForm').reset();
		});
	});

		function doQuery(params) {
			$('#error-table').bootstrapTable('refresh'); //刷新表格
		}
		
		/**
		 * 初始化table
		 */
		function initTable() {
			$('#error-table').bootstrapTable({
				url : queryUrl,
				method : 'GET',
				queryParams : function queryParams(params) { 
					var param = {
						pageSize : params.pageSize,
						pageNumber : params.pageNumber,
						orgNo : $("#orgNo").val(),
						contractNo : $("#contractNo").val(),
						credNo : $("#credNo").val(),
						credType : $("#credType").val()
					};
					return param;
				},
				columns : [ 
						{
							checkbox : true
						}, 
						{
							field: '',
							title: '序号', 
							valign : 'left',
							formatter: function (value, row, index) { 
								return index+1; }
						},
						{
							field : 'ruleNo',
							title : '校验编号',
							align : 'left',
							valign : 'middle'
						}, 
						{
							field : 'checkDate',
							title : '检查日期',
							align : 'left',
							valign : 'middle',
							formatter: function (value) {
								return dateFormatUtil(value);
							}
						}, 
						{
							field : 'checkType',
							title : '检查目标类型',
							align : 'left',
							valign : 'middle',
							formatter: function (value) {
								return getCheckType(value);
							}
						}, 
						{
							field : 'dataSrc',
							title : '数据来源',
							align : 'left',
							valign : 'middle',
							formatter:function(value){
								return getDataSrc(value);
							}
						}, 
						{
							field : 'orgNo',
							title : '机构代码',
							align : 'left',
							valign : 'middle'
						}, 
						{
							field : 'contractNo',
							title : '合同号',
							align : 'left',
							valign : 'middle'
						}, 
						{
							field : 'credType',
							title : '证件类型',
							align : 'left',
							valign : 'middle',
							formatter:function(value){
								return getCredType(value);
							}
						}, 
						{
							field : 'credNo',
							title : '证件号码',
							align : 'left',
							valign : 'middle'
						},
						{
							field : 'termNo',
							title : '期次号',
							align : 'left',
							valign : 'middle'
						}, 
						{
							field : 'tableName',
							title : '检查表名',
							align : 'left',
							valign : 'middle'
						}, 
						{
							field : 'checkColumn',
							title : '检查字段',
							align : 'left',
							valign : 'middle'
						}, 
						{
							field : 'checkValue',
							title : '检查字段值',
							align : 'left',
							valign : 'middle'
						}, 
						{
							field : 'ruleDesc',
							title : '交易规则描述',
							align : 'left',
							valign : 'middle'
						} 
					]
			});
		}
	</script>
</body>
</html>