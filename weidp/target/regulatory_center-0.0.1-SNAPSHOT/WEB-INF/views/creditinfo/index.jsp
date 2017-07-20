<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<%@include file="/common/jsp/bootstrap.jsp"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript" src="${webRoot}/js/creditinfo/edit.js"></script>
<title>信贷信息管理</title>
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
					<input placeholder="应上报开始日期" class="form-control layer-date" id="startDate" name="startDate"> 
				</div>
				<div class="form-group">
					<label >结束日期:</label> 
					<input placeholder="应上报结束日期" class="form-control layer-date" id="endDate" name="endDate" >
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
			       <button class="btn btn-primary" id="noSubmitBtn" >不报</button>
			    </div>
			    <div class="btn-group">
			       <button class="btn btn-primary" id="editBtn">修改</button>
			    </div>
				<div class="btn-group">
					<button type="button" class="btn btn-primary"  id="preCheckBtn">预校验  </button>
				</div>
				<div class="btn-group">
					<button type="button" class="btn btn-primary "  id="reportDataBtn">上报  </button>
				</div>
			  	</div>
			<table id="reprotdata-table"> </table>
		</div>
	</div>
		
<script>
	//数据来源：信贷系统
	var dataSrc_formSys = 1;
	var queryUrl = "${webRoot}/creditinfo/findPage?dataSrc="+dataSrc_formSys;
	
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
	$(function() {
		initDate();
		initTable();
		/**
		* 主页查询按钮
		*/
		$("#queryBtn").click(function() {
			$('#reprotdata-table').bootstrapTable( 'refresh');
		});
		
		/**
		 * 重置按钮
		 */
		$("#resetBtn").click(function() {
			document.getElementById('queryForm').reset();
		});
		 
		/**
		 * 不报按钮
		 */
		$("#noSubmitBtn").click(function(){
			var selected = $('#reprotdata-table').bootstrapTable('getSelections');
			if(!selected || selected.length==0){
				layer.msg("请选择需不报的数据",{icon: 2})
				return false;
			}
			var conno = getConNoSelections(selected);
		    $.ajax({
	            type: "post",
	            url: "${webRoot}/datareportcfg/save",
	            data: {'conno':conno},
	            success: function(data){
		    		  if (data.success == "true") {
		    			  layer.alert("设置成功！");
	                  }else{
	                	  layer.alert(data.msg);
	                  }
		    	  },
		    	  error: function () {
		    		  layer.alert(data.msg);
	              },
	        });
		});
		

		/**
		*  上报
		*/
		$("#reportDataBtn").click(function(){
			layer.open({
				title : [ '推送数据', 'font-size:18px;' ],
				maxmin : true,
				type : 2,
				offset: '80px',
				area : [ '850px', '500px' ],
				content : '${webRoot}/reported/index?dataSrc=' + dataSrc_formSys ,
				cancel : function() {
				}
			});
		});
			
		/**
		 * 预校验，AJAX调用存储过程
		 */
		$("#preCheckBtn").click(function (){
			$.ajax({
				type: "post",
				url: "${webRoot}/check/preCheck",
				data: {'dataType': dataSrc_formSys},
				success: function(data){
					var str='提交校验:'+data.total+'条' + '<br>校验通过:'+data.pass+'条' + '<br>校验未通过:'+data.notpass +'条';
					layer.alert(str);
				}
			});
		});
		
	});

		/**
		 * 初始化日期
		 */
		function initDate() {
			//开始日期
			var start = {
				elem : '#startDate',
				format : 'YYYY-MM-DD',
				max : laydate.now(),
				istoday : true, //是否显示今天
				isclear : true, //是否显示清空
				issure : true, //是否显示确认
				choose : function(datas) {
					end.min = datas; //开始日选好后，重置结束日的最小日期
					end.start = datas //将结束日的初始值设定为开始日
				}
			};
			//结束日期
			var end = {
				elem : '#endDate',
				format : 'YYYY-MM-DD',
				max : laydate.now(),
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
		
		function getConNoSelections(rows) {
			var conNo = "";
			for (var i = 0; i < rows.length; i++) {
				if ("" == conNo) {
					conNo = rows[i].conNo;
				} else {
					conNo = conNo + "," + rows[i].conNo;
				}
			}
			return conNo;
		};

		/**
		 * 初始化table
		 */
		function initTable() {
			$('#reprotdata-table').bootstrapTable({
				url : queryUrl,
				method : 'GET',
				queryParams : function queryParams(params) { 
					var param = {
						pageSize : params.pageSize,
						pageNumber : params.pageNumber,
						projectId : $("#projectId").val(),
						coOrgCode : $("#coOrgCode").val(),
						IOUNo : $("#IOUNo").val(),
						credNo : $("#credNo").val(),
						checkResult : $("#checkResult").val(),
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
	</script>
</body>
</html>