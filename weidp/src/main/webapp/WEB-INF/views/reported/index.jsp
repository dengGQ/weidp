<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>报送数据配置</title>
    <!-- 导入jquery bootstrap js css lib -->
    <%@include file="/common/jsp/bootstrap.jsp"%>
</head>
<body>
	

	<div class="container-fluid">
		
		<div class="row base-margin" id="query">
	        <ol class="breadcrumb">
	            <li><strong><span style="color: #27a0d7"></span></strong></li>
	        </ol>
	        <form class="form-inline" role="form"  method="post" id="queryForm">
	            <div class="form-group">
	                <button type="button" id="submitBtn"  class="btn btn-primary">推送数据</button>
	            </div>
	          
	        </form>
	    </div>
    <div class="container" style="width: 100%">
        <table id="reported-table" > </table>
    </div>
		
	</div>


   
	<script>
	var url = "${webRoot}/reported/findPage?dataSrc="+${dataSrc};
	$(function () {
		
		//推送按钮点击事件
		$("#submitBtn").click(function(){
			var selected = $('#reported-table').bootstrapTable('getSelections');
			if(!selected || selected.length==0){
				layer.msg("请选择需推送的数据记录",{icon: 2})
				return false;
			}
			
			//存储校验结果 -- 暂时没显示
			var validateMsg = new Array();
			var sourceType = new Array();
			var param = new Array();
			$.each(selected, function(index, row){
				param[index] = dateFormatUtil(row.insertDttm, 'yyyyMMdd')+ ':' + row.dataSrc;
				//因为校验参数是数据来源,最多校验2次
				if($.inArray(row.dataSrc, sourceType)==-1){
					//校验调用
					$.post("${webRoot}/check/preCheck", {'datatype':row.dataSrc}, function(data){
						validateMsg[index] = data;
					}); 
					sourceType[index] = row.dataSrc;
				}
			});
			//推送数据调用
			$.post("${webRoot}/reported/reporting", {'insertDates':param.join(',')}, function(data){
		        if(data.status==0){
		        	layer.msg('推送数据失败, 原因 \: ['+data.msg+']', {icon: 2});
		        }else{
		        	layer.msg('推送数据成功', {icon: 1});
		        }
			});
			
		});
		
		initTable();
	});
	function initTable() {
		$('#reported-table').bootstrapTable(
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
			url : url,
			showColumns : true,
			queryParamsType : "undefined",
			minimumCountColumns : 2,
			pageNumber : pageNumber, //初始化加载第一页，默认第一页
			pageSize : pageIndexSize, //每页的记录行数（*）
			pageList : pageList, //可供选择的每页的行数（*）
			uniqueId : "id" ,//每一行的唯一标识，一般为主键列
			columns :  [
		        { field : 'checked', radio : true},
		        { field : 'insertDttm', title : '日期', align : 'center', valign : 'middle', sortable : true, formatter: function (value) {return	dateFormatUtil(value);} }, 
		        { field : 'dataSrc', title : '数据来源', align : 'center', valign : 'middle',formatter: function (value) {return value==1?'信贷':'CSV'}}, 
		        { field : 'allNum', title : '提交校验', align : 'center', valign : 'middle' }, 
		        { field : 'successNum', title : '校验通过', align : 'center', valign : 'middle'  }, 
		        { field : 'failNum', title : '校验未通过', align : 'center', valign : 'middle' }
		        ]
		});
	}

	</script>
</body>
</html>