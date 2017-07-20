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
<title>信托项目查询</title>
</head>
<body>
	<div class="container-fluid">
		<div class="row base-margin" id="query">
        <form class="form-inline"  method="post" id="queryForm">
            <div class="form-group">
                <label for="projectName">项目名称:</label> 
                <input type="text"  class="form-control" name="projectName"  id="input_projectName">
                <button type="button" id="queryBtn" onclick="doQuery();" class="btn btn-primary">查询</button>
            </div>
        </form>
    </div>
    <div class="container" >
        <table id="project-table">
        </table>
    </div>
	</div>

	<script>
	var table;
	$(function () {
		
		/**
		 * 查询
		 */
		$("#queryBtn").click(function(){
			$('#project-table').bootstrapTable( 'refresh');
		});
		
	    initTable();
	});

	function doQuery(params){
	    $('#project-table').bootstrapTable('refresh');    //刷新表格
	}
	/*获取表格高度，根据浏览器自适应*/
	function getHeight() {
        return $(window).height() - 75;
    }
	/**
	 * 初始化table
	 */
	function initTable(){
	    var url = "${webRoot}/publicquery/projectSearch";
	        table = $('#project-table').bootstrapTable({
	        height : getHeight(),
	        clickToSelect: true,                //是否启用点击选中行
	        url:url,
	        queryParams: function queryParams(params) { //设置查询参数  
	              var param = {    
	            		  pageSize : params.pageSize,
	            		  pageNumber : params.pageNumber, 
	            		  projectName : $("#input_projectName").val()
	              };    
	              return param;                   
	        },                     //每页的记录行数（*）
	        pageList: pageList,        //可供选择的每页的行数（*）
	        uniqueId: "id",                     //每一行的唯一标识，一般为主键列
	        columns: [{
	        	checkbox: true  
			}, {
	            field : 'projId',
	            visible :false
	        }, {
	            field : 'projName',
	            title : '项目名称',
	            align : 'left',
	            valign : 'middle',
	            sortable : true
	        }]
	    });
	}
	
	function callbackdata(){
		var arrvalue = new Array();
		var row=table.bootstrapTable('getSelections')[0];
		if (row == null || row == undefined || row == '') { 
    		layer.alert("未选择对象");
    		return ;
    	}else{
			arrvalue[0]=row.projId;
			arrvalue[1]=row.projName;
    	}
		return arrvalue;
		
	}

</script>
</body>
</html>