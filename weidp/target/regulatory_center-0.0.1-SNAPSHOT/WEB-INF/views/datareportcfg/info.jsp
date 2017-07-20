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
<title>不报数据查询</title>
    <!-- 导入jquery bootstrap js css lib -->
    <%@include file="/common/jsp/bootstrap.jsp"%>
</head>
<body>
	<div class="container-fluid">
	
		<div class="row base-margin" id="query">
       <form class="form-inline"  method="post" id="queryForm">
            <div class="form-group">
                <label>信托项目:</label>
                <input type="text" class="hidden" name="project" id="project" /> 
                <input type="text" readonly="readonly" class="form-control" name="projectname" id="projectname"   onclick="selectProject()"  placeholder="请选择"/>
            </div>
            <div class="form-group">
                <label>合作机构:</label> 
                <input type="text"  class="hidden"   name="org" id="org" >
                <input type="text" readonly="readonly" class="form-control" name="orgname" id="orgname"    onclick="selectOrg()"  placeholder="请选择"/>
            </div>
            
            <div class="form-group">
                <label>信托产品:</label> 
                <input  type="text" class="hidden"   name="prod" id="prod" >
                <input type="text" readonly="readonly" class="form-control" name="prodname" id="prodname"   onclick="selectProdure()"  placeholder="请选择"/>
            </div>
            
            <div class="form-group">
                <label>合同:</label> 
                <input type="text" class="hidden" name="conno" id="conno" /> 
                <input type="text" readonly="readonly" class="form-control" name="connoname" id="connoname"   onclick="selectConno()"  placeholder="请选择"/>
            </div>
            
            <div class="form-group group1">   
                <button type="button" id="saveBtn" onclick="doQuery();" class="btn btn-primary">查询</button>
            </div>
            
             <div class="form-group group2">
              <button type="button" id="resetBtn" onclick="formReset();" class="btn btn-primary">重置</button>
            </div>
        </form>
    </div>
    <div class="container">
        <table id="notsubmitdatainfo-table">
        </table>
    </div>
		
	</div>
	
<script>

	$(function () {
	    initTable();
	});

	function doQuery(params){
	    $('#notsubmitdatainfo-table').bootstrapTable('refresh');    //刷新表格
	}
	
	function initTable(){
	    var url = "${webRoot}/datareportcfg/searchListByPage4Info";
	    $('#notsubmitdatainfo-table').bootstrapTable({
	        method:'GET',
	        dataType:'json',
	        contentType: "application/json;charset=utf-8",
	        pagination: true,                   //是否显示分页（*）
	        cache: false,
	        striped: true,                      //是否显示行间隔色
	        sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
	        clickToSelect: true,                //是否启用点击选中行
	        url:url,
	        showColumns:true,
	        pagination:true,
	        queryParamsType : "undefined",
	        queryParams: function queryParams(params) {   //设置查询参数  
	             var param = {    
	            		  pageSize: params.pageSize,
	            		  pageNumber: params.pageNumber,  
	            		  org : $('#org').val(), orgname : $('#orgname').val(), 
	    		   		  prod : $('#prod').val(), prodname : $('#prodname').val(), 
	    		          conno : $('#conno').val(), connoname : $('#connoname').val(), 
	    		          project : $('#project').val(),projectname : $('#projectname').val()
	              };    
	              return param;                   
	        }, 
	        pageNumber:pageNumber,                       //初始化加载第一页，默认第一页
	        pageSize: pageIndexSize,                       //每页的记录行数（*）
	        pageList: pageList,        //可供选择的每页的行数（*）
	        columns: [
	        {
	                    field: '',
	                    title: '序号',
	                    formatter: function (value, row, index) {
	                    return index+1;
	                    }
	        },
	        {
	            field : 'projName',
	            title : '信托项目',
	            align : 'center',
	            valign : 'middle',
	            sortable : true
	        }, {
	            field : 'orgName',
	            title : '合作机构',
	            align : 'center',
	            valign : 'middle'
	        },{
	            field : 'prodName',
	            title : '产品名称',
	            align : 'center',
	            valign : 'middle'
	        },{
	            field : 'conNo',
	            title : '合同号',
	            align : 'center',
	            valign : 'middle'
	        },{
	            field : 'validDate',
	            title : '生效日期',
	            align : 'center',
	            valign : 'middle'
	        }]
	    });
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
	
	function selectProject(){
		var projectNum;
		var index = layer.open({
			  type: 2,
			  title: '选择信托项目',
			  maxmin: true,
			  content: '${webRoot}/publicquery/project',
			  area: ['1000px', '500px'],
			  btn: ['确定','关闭'],
              yes: function(index){
                  //当点击‘确定’按钮的时候，获取弹出层返回的值
                  projectNum = window["layui-layer-iframe" + index].callbackdata();
                  //打印返回的值，看是否有我们想返回的值。
                  $("#project").val(projectNum[0]);
                  $("#projectname").val(projectNum[1]);
                  //最后关闭弹出层
                  layer.close(index);
              },
              cancel: function(){
                  //右上角关闭回调
              }
			  
			});
		
	}
	
	function selectOrg(){
		var projectNum;
		var index = layer.open({
			  type: 2,
			  title: '选择机构',
			  maxmin: true,
			  content: '${webRoot}/publicquery/org',
			  area: ['1000px', '500px'],
			  btn: ['确定','关闭'],
              yes: function(index){
                  //当点击‘确定’按钮的时候，获取弹出层返回的值
                  projectNum = window["layui-layer-iframe" + index].callbackdata();
                  //打印返回的值，看是否有我们想返回的值。
                 // $("#org").val(projectNum);
                  $("#org").val(projectNum[0]);
                  $("#orgname").val(projectNum[1]);
                  //最后关闭弹出层
                  layer.close(index);
              },
              cancel: function(){
                  //右上角关闭回调
              }
			  
			});
		
	}
	
	function selectProdure(){
		var projectNum;
		var index = layer.open({
			  type: 2,
			  title: '选择产品',
			  maxmin: true,
			  content: '${webRoot}/publicquery/product',
			  area: ['1000px', '500px'],
			  btn: ['确定','关闭'],
              yes: function(index){
                  //当点击‘确定’按钮的时候，获取弹出层返回的值
                  projectNum = window["layui-layer-iframe" + index].callbackdata();
                  //打印返回的值，看是否有我们想返回的值。
                  $("#prod").val(projectNum[0]);
                  $("#prod").val(projectNum[1]);
                  //最后关闭弹出层
                  layer.close(index);
              },
              cancel: function(){
                  //右上角关闭回调
              }
			  
			});
		
	}
	
	function selectConno(){
		var projectNum;
		var index = layer.open({
			  type: 2,
			  title: '选择合同',
			  maxmin: true,
			  content: '${webRoot}/publicquery/contract',
			  area: ['1000px', '500px'],
			  btn: ['确定','关闭'],
              yes: function(index){
                  //当点击‘确定’按钮的时候，获取弹出层返回的值
                  projectNum = window["layui-layer-iframe" + index].callbackdata();
                  //打印返回的值，看是否有我们想返回的值。
                  $("#conno").val(projectNum[0]);
                  $("#connoname").val(projectNum[1]);
                  //最后关闭弹出层
                  layer.close(index);
              },
              cancel: function(){
                  //右上角关闭回调
              }
			  
			});
		
	}
	
	function formReset()
	{
	  document.getElementById("queryForm").reset()
	}
	
	

	</script>
</body>
</html>