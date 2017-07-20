<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<%@include file="/common/jsp/bootstrap.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>CSV导入文件管理</title>
</head>
<body>
	<div class="container-fluid">
		<div class="row base-margin" id="query">
			<form class="form-inline"  method="post" id="queryForm">
				<div class="form-group">
					<label >信托项目:</label> 
					<input type="text"  class="hidden"  name="projectId" id="projectId" /> 
					<input type="text"  class="form-control" readonly="readonly"  name="projectName" id="projectName"  onclick="selectProject()"  placeholder="请选择"/>
				</div>
				<div class="form-group">
					<label >合作机构:</label> 
					<input type="text"  class="hidden" name="coOrgCode"  id="coOrgCode"> 
					<input type="text" class="form-control"  readonly="readonly"  name="coOrgName" id="coOrgName"  onclick="selectOrg()" placeholder="请选择"/>
				</div>
				<div class="form-group">
					<label >业务编号:</label> 
					<input type="text" class="form-control" name="IOUNo" id="IOUNo" />
				</div>
				<div class="form-group">
					<label >证件号码:</label> 
					<input type="text" class="form-control" name="credNo" id="credNo" size="20" />
				</div>
				<div class="form-group">
					<label>开始日期:</label> 
					<input placeholder="合同开始日期" class="form-control layer-date" id="startDate" name="startDate"> 
				</div>
				<div class="form-group">
					<label >结束日期:</label> 
					<input placeholder="合同结束日期" class="form-control layer-date" id="endDate" name="endDate" >
				</div>
				
				<div class="form-group">
					<label>校验结果:</label> 
					<select name="checkResult" id="checkResult" class="form-control">
						<option class="form-control"  value="0"  selected="selected">请选择</option>
						<option  value="1">未校验</option>
						<option  value="2">校验通过</option>
						<option  value="3">校验失败</option>
					</select>
				</div>
				<div class="form-group btn2">
					<button type="button" id="queryBtn" class="btn btn-primary">查询</button>
					<button type="button" id="resetBtn" class="btn btn-primary">重置</button>
				</div>
			</form>
		</div>
		<div class="container">
			    <div id="toolbar" class="btn-group group3">
			    <div class="btn-group">
			      <button type="button" id="filestree" class="btn btn-primary">选择CSV文件(功能禁用)</button>
			    </div>
			    <div class="btn-group">
			       <button class="btn btn-primary" id="importCSVBtn">导入CSV文件</button>
			    </div>
				<div class="btn-group">
					<button type="button" class="btn btn-primary" id="preCheckBtn">预校验 </button>
				</div>
				<div class="btn-group">
					<button type="button" class="btn btn-primary" id="reportDataBtn">上报 </button>
				</div>
			  	</div>
			<table id="reprotdata-table"></table>
		</div>
	</div>
		
	<script>
	//数据来源：csv导入
	var dataSrc_formSys = 2;
	var url = "${webRoot}/creditinfo/findPage?dataSrc="+dataSrc_formSys;
		$(function() {
			
			/**
			 * CSV导入按钮调用
			 */
			$("#importCSVBtn").click(function(){
				layer.open({
				  type: 2,
				  title: 'CSV-导入',
				  //maxmin: true,
				  skin: 'layui-layer-rim', //加上边框
				  content:'${webRoot}/fileOperate/rediretCvsUploadPage', 
				  area: ['780px', '320px'], //宽高
		          cancel: function(){  }
				});
			});

			
			$("#resetBtn").click(function() {
				$('.form-control').val('');
			});
			
			
		   /**
			*  上报跳转
			**/
			$("#reportDataBtn").click(function(){
				layer.open({
					title : [ '推送数据', 'font-size:18px;' ],
					maxmin : true,
					type : 2,
					offset: '80px',
					area : [ '1000px', '500px' ],
					content : '${webRoot}/reported/index?dataSrc='+dataSrc_formSys,
					cancel : function() {
					}
				});
			});

			/**
			 * 预校验，AJAX调用存储过程
			 **/
			$("#preCheckBtn").click(function (){
				//数据来源 1代表信贷系统 2代表CSV导入
				$.ajax({
					type: "post",
					url: "${webRoot}/check/preCheck",
					data: {'datatype': dataSrc_formSys},
					success: function(data){
						var str='提交校验:'+data.total+'条' + '<br>校验通过:'+data.pass+'条' + '<br>校验未通过:'+data.notpass +'条';
						layer.alert(str);
					}
				});
			});
			/**
			* 主页查询按钮
			*/
			$("#queryBtn").click( function() {
				$('#reprotdata-table').bootstrapTable('refresh');
			});
			
			initTable();
			initDate();
		});

		/**
		 * 初始化日期插件
		 */
		function initDate() {
			var start = {
				elem : '#startDate',
				format : 'YYYY-MM-DD',
				max : laydate.now(),
				istime : true,
				istoday : false,
				choose : function(datas) {
					end.min = datas; //开始日选好后，重置结束日的最小日期
					end.start = datas //将结束日的初始值设定为开始日
				}
			};
			var end = {
				elem : '#endDate',
				format : 'YYYY-MM-DD',
				max : laydate.now(),
				istime : true, //是否开启时间选择
				isclear : true, //是否显示清空
				istoday : true, //是否显示今天
				issure : true, //是否显示确认
				choose : function(datas) {
					start.max = datas; //结束日选好后，重置开始日的最大日期
				}
			};
			laydate(start);
			laydate(end);
		}

		function doQuery(params) {
			$('#reprotdata-table').bootstrapTable('refresh'); //刷新表格
		}

		function initTable() {
			$('#reprotdata-table').bootstrapTable({
				method : 'GET',
				url : url,
				queryParams : function queryParams(params) { //设置查询参数  
					var param = {
						pageSize : params.pageSize,
						pageNumber : params.pageNumber,
						projName : $("#projname").val(),
						coOrgNo : $("#coorgno").val(),
						bussNo : $("#bussno").val(),
						credNo : $("#credno").val(),
						checkRest : $("#checkRest").val(),
						startDate : $("#startDate").val(),
						endDate : $("#endDate").val()
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
						field : 'iouno',
						title : '业务编号',
						align : 'left',
						valign : 'middle'
					}, 
					{
						field : 'credNo',
						title : '证件号码',
						align : 'left',
						valign : 'middle'
					}, 
					{
						field : 'conNo',
						title : '合同编号',
						align : 'left',
						valign : 'middle'
					}, 
					{
						field : 'projName',
						title : '项目名称',
						align : 'left',
						valign : 'middle'
					}, 
					{
						field : 'projId',
						title : '项目编号',
						align : 'left',
						valign : 'middle'
					}, 
					{
						field : 'coOrgName',
						title : '所属机构',
						align : 'left',
						valign : 'middle'
					}, 
					{
						field : 'dataSrc',
						title : '数据来源',
						align : 'left',
						valign : 'middle',
						formatter: function (value) {
							return value==1?'信贷':'CSV'}
					}, 
					{
						field : 'checkResult',
						title : '检查结果',
						align : 'left',
						valign : 'middle',
						formatter: function (value) {
							if(value == 3){
								return "校验失败";
							}
							if(value == 2){
								return "校验通过";
							}
							if(value == 1){
								return "未校验";
							}
					}}, 
					{
						field : 'repayData',
						title : '期次日期',
						align : 'left',
						valign : 'middle'
					} 
				]
			});
		}

		/**
		 * 信托项目下拉框
		 */
		function selectProject(){
			var projectNum;
			var index = layer.open({
				  type: 2,
				  title: '选择信托项目',
				  maxmin: true,
				  content: '${webRoot}/publicquery/project',
				  area: ['850px', '500px'],
				  btn: ['确定','关闭'],
	              yes: function(index){
	                  projectNum = window["layui-layer-iframe" + index].callbackdata();
	                  $("#projectId").val(projectNum[0]);
	                  $("#projectName").val(projectNum[1]);
	                  layer.close(index);
	              },
	              cancel: function(){
	              }
				});
		}
		
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
	                  $("#coOrgCode").val(projectNum[0]);
	                  $("#coOrgName").val(projectNum[1]);
	                  //最后关闭弹出层
	                  layer.close(index);
	              },
	              cancel: function(){
	              }
			});
		}
		
		function formReset() {
			document.getElementById("queryForm").reset()
		}
		
		$("#filestree").click(function(){
			var array;
			var index = layer.open({
				  type: 2,
				  title: '选择csv文件',
				  maxmin: true,
				  content: '${webRoot}/fileOperate/filestree',
				  area: ['850px', '500px'],
				  btn: ['确定','关闭'],
	              yes: function(index){
	                array = window["layui-layer-iframe" + index].callbackdata();
	                layer.close(index);
	              },
	              cancel: function(){
	              }
			});	
		}	
	);
		
	</script>
</body>
</html>