<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<%@include file="/common/jsp/bootstrap.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
<meta >
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>信托产品</title>
</head>
<body>
	<div class="container-fluid">
		<div class="row base-margin" id="query">
        <form class="form-inline"   method="post" id="queryForm">
            <div class="form-group">
                <label>产品名称:</label> 
                <input type="text"  class="form-control" name="input_proName" id="input_proName"  >
            </div>
            <div class="form-group">
                <button type="button" id="queryBtn" onclick="doQuery();" class="btn btn-primary">查询</button>
            </div>
        </form>
    </div>
     
    <div class="container" style="width: 100%">
        <table id="produre-table"> </table>
    </div>
	</div>
	
<script>
	var table;
	$(function () {
	    initTable();
	});

	function doQuery(params){
	    $('#produre-table').bootstrapTable('refresh');    //刷新表格
	}

	function initTable(){
	    var url = "${webRoot}/publicquery/productSearch";
	        table = $('#produre-table').bootstrapTable({
	        method:'GET',
	        dataType:'json',
	        contentType: "application/json;charset=utf-8",
	        pagination: true,                   //是否显示分页（*）
	        cache: false,
	        showRefresh: true,   
	        striped: true,                      //是否显示行间隔色
	        sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
	        clickToSelect: true,                //是否启用点击选中行
	        showToggle: true,                    //是否显示详细视图和列表视图的切换按钮
	        url:url,
	        showColumns:true,
	        singleSelect    : true,                     // 单选checkbox  
	        pagination:true,
	        queryParamsType : "undefined",
	        queryParams: function queryParams(params) { //设置查询参数  
	              var param = {    
	            		  pageSize: params.pageSize,
	            		  pageNumber: params.pageNumber, 
	            		  proName : $("#input_proName").val()
	              };    
	              return param;                   
	        }, 
	        minimumCountColumns:2,
	        pageNumber:pageNumber,                       //初始化加载第一页，默认第一页
	        pageSize: pageSecondSize,                       //每页的记录行数（*）
	        pageList: pageList,        //可供选择的每页的行数（*）
	        uniqueId: "id",                     //每一行的唯一标识，一般为主键列
	        columns: [{
	        	checkbox: true  
			},{
	            field : 'prodCode',
	            title : '产品号',
	            align : 'center',
	            valign : 'middle',
	            sortable : true
	        },{
	            field : 'prodName',
	            title : '产品名称',
	            align : 'center',
	            valign : 'middle',
	            sortable : true
	        }]
	    });
	}
	
	function callbackdata(){
		var arr = new Array();
		var row=table.bootstrapTable('getSelections')[0];
		if (row == null || row == undefined || row == '') { 
    		layer.alert("未选择对象");
    		return ;
    	}else{
    		arr[0]=row.prodCode;
    		arr[1]=row.prodName;
    		return arr;
    	}
	
	}
	
	</script>
</body>
</html>