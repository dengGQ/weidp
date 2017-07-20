<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>合同</title>
    <!-- 导入jquery bootstrap js css lib -->
    <%@include file="/common/jsp/bootstrap.jsp"%>
</head>
<body>
	<div class="container-fluid">

	 <div class="row base-margin" id="query">
        <ol class="breadcrumb">
            <li><strong><span style="color: #27a0d7"></span></strong></li>
        </ol>
        <form class="form-inline" role="form" style="float: left; width: 100%" method="post" id="queryForm">
            <div class="form-group">
                <label>合同号:</label> 
                <input type="text"  class="form-control" name="conNo" id="conNo"  >
            </div>
            <div class="form-group">
                <button type="button" id="queryBtn" onclick="doQuery();" class="btn btn-primary">查询</button>
            </div>
        </form> 
    </div>
  
    <div class="container" style="width: 100%">
        <table id="contract-table">
        </table>
    </div>
		
	</div>


   
	<script>
	var table;
	$(function () {
	    initTable();
	});

	function doQuery(params){
	    $('#contract-table').bootstrapTable('refresh');    //刷新表格
	}
	
	/*获取表格高度，根据浏览器自适应*/
	function getHeight() {
        return $(window).height() - 95;
    }

	function initTable(){
	    var url = "${webRoot}/publicquery/contractSearch";
	        table = $('#contract-table').bootstrapTable({
	        method:'GET',
	        dataType:'json',
	        contentType: "application/json;charset=utf-8",
	        pagination: true,                   //是否显示分页（*）
	        cache: false,
	        height : getHeight(),
	        striped: true,                      //是否显示行间隔色
	        sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
	        clickToSelect: true,                //是否启用点击选中行
	        url:url,
	        singleSelect    : true,                     // 单选checkbox  
	        pagination:true,
	        //设置为undefined可以获取pageNumber，pageSize，searchText，sortName，sortOrder  
            //设置为limit可以获取limit, offset, search, sort, order  
	        queryParamsType : "undefined",
	        queryParams: function queryParams(params) { //设置查询参数  
	              var param = {    
	            		  pageSize: params.pageSize,
	            		  pageNumber: params.pageNumber, 
	            		  conNo:$('#conNo').val()
	              };    
	              return param;                   
	        }, 
	        minimumCountColumns:2,
	        pageNumber:pageNumber,                       //初始化加载第一页，默认第一页
	        pageSize: pageSecondSize,                       //每页的记录行数（*）
	        pageList: pageList,        //可供选择的每页的行数（*）
	        uniqueId: "id",                     //每一行的唯一标识，一般为主键列
	      
	        columns: [
	        {
	        	checkbox: true  
	        	    
			},
			{
	            field : 'conNo',
	            title : '合同号',
	            align : 'center',
	            valign : 'middle',
	            sortable : true
	        },
	        {
	            field : 'coOrgName',
	            title : '机构名称',
	            align : 'center',
	            valign : 'middle',
	            sortable : true
	        },{
	            field : 'prodName',
	            title : '产品名称',
	            align : 'center',
	            valign : 'middle',
	            sortable : true
	        },{
	            field : 'projName',
	            title : '项目名称',
	            align : 'center',
	            valign : 'middle',
	            sortable : true
	        }]
	    });
	}
	
	function callbackdata(){
		var row=table.bootstrapTable('getSelections')[0];
		var arrvalue = new Array();
		if (row == null || row == undefined || row == '') { 
    		layer.alert("未选择对象");
    		return ;
    	}else{
    		arrvalue[0]=row.conNo;
    		arrvalue[1]=row.conNo;
    		return arrvalue;
    	}
		
	}

	// 用于server 分页，表格数据量太大的话 不想一次查询所有数据，可以使用server分页查询，数据量小的话可以直接把sidePagination: "server"  改为 sidePagination: "client" ，同时去掉responseHandler: responseHandler就可以了，
	function responseHandler(res) { 
	    if (res) {
	        return {
	            "rows" :  res.rows,
	            "total" : res.total
	        };
	    } else {
	        return {
	            "rows" : [],
	            "total" : 0
	        };
	    }
	}
	
	</script>
</body>
</html>