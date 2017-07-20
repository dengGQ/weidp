<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>报送数据配置</title>
    <!-- 导入jquery bootstrap js css lib -->
    <%@include file="/common/jsp/bootstrap.jsp"%>
    <!-- 导入bootstrap-fileinput js css -->
    <%@include file="/common/jsp/fileupload.jsp"%>
</head>
<body>
	

	<div class="container-fluid">
		
		
		<div class="row base-margin" id="query">
        <ol class="breadcrumb">
            <li><strong><span style="color: #27a0d7"></span></strong></li>
        </ol>
        <form class="form-inline" role="form" style="float: left; width: 100%" method="post" id="queryForm">
            <div class="form-group">
                <label for="project">信托项目:</label> 
                <input type="text" class="form-control" name="project" id="project"  placeholder="选择信托项目" onclick="selectProject()"/>
            </div>
            <div class="form-group">
                <label for="userName1">合作机构:</label> 
                <input type="text" class="form-control" name="org" id="org"  placeholder="请输入名称">
            </div>
            
            <div class="form-group">
                <label for="userName1">信托产品:</label> 
                <input type="text" class="form-control" name="prod" id="prod"  placeholder="请输入名称">
            </div>
            
            <div class="form-group">
                <label for="userName1">合同:</label> 
                <input type="text" class="form-control" name="conno" id="conno"  placeholder="请输入名称">
            </div>
            
            <div class="form-group">
                <button type="button" id="queryBtn" onclick="doSave();" class="btn btn-primary">保存配置</button>
            </div>
            
            
        </form>
    </div>
    <div class="container" style="width: 100%">
        <table id="notsubmitdata-table">
        </table>
    </div>
		
	</div>
 
 
 
  
  
	<script>
	$(function () {
		
	   // initTable();
	});

	function doQuery(params){
	    $('#notsubmitdata-table').bootstrapTable('refresh');    //刷新表格
	}
	function doSave(){
		
	    $.ajax({
	    	  type: 'post',
	    	  url: 'datareportcfgsave',
	    	  data:{ 
	    		   org : $('#org').val(), 
	    		   prod : $('#prod').val(), 
	    		   conno : $('#conno').val(), 
	    		   proj : $('#proj').val()
	    	  },
	    	  dataType: 'json',
	    	  success: function(data){
	    		  if (data.success == "true") {
	    			  layer.alert('保存配置成功')
                      $('#notsubmitdata-table').bootstrapTable('refresh');    //刷新表格
                  }else{
                	  layer.alert('保存配置失败');
                  }
	    		  
	    	  },
	    	  error: function () {
	    		  layer.alert('保存配置失败')
              },
	    	  
	    	});
	}

	function initTable(){
	    var url = "datareportcfg/searchListByPage";
	    $('#notsubmitdata-table').bootstrapTable({
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
	        //showExport: true,                     //是否显示导出
	       // exportDataType: "basic",              //basic', 'all', 'selected'.
	        pagination:true,
	        //设置为undefined可以获取pageNumber，pageSize，searchText，sortName，sortOrder  
            //设置为limit可以获取limit, offset, search, sort, order  
	        queryParamsType : "limit",
	        queryParams: function queryParams(params) {   //设置查询参数  
	              var param = {    
	            	  limit: params.limit,    
	            	  offset: params.offset, 
	            	  sort:params.sort, 
	            	  order:params.order, 
	                 // searchuserName : $("#searchuserName").val()  
	              };    
	              return param;                   
	            },
	        minimumCountColumns:2,
	        pageNumber:1,                       //初始化加载第一页，默认第一页
	        pageSize: 20,                       //每页的记录行数（*）
	        pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
	        uniqueId: "id",                     //每一行的唯一标识，一般为主键列
	        onEditableSave: function (field, row, oldValue, $el) {
                $.ajax({
                    type: "post",
                    url: "datareportcfg/tableEdit",
                    data: { strJson: JSON.stringify(row) },
                    success: function (data, status) {
                        if (status == "success") {
                            alert("编辑成功");
                        }
                    },
                    error: function () {
                        alert("编辑失败");
                    },
                    complete: function () {

                    }

                });
        },
	        columns: [
	        {
	                    field: '',
	                    title: '序号',
	                    formatter: function (value, row, index) {
	                    return index+1;
	                    }
	        },
	        {
	            field : 'ruleType',
	            title : '规则类型',
	            align : 'center',
	            valign : 'middle',
	            sortable : true,
	            formatter : function (value, row, index) {
	                if (row['ruleType'] == 1) {
	                    return '信托项目';
	                }
	                if (row['ruleType'] == 2) {
	                    return '信托产品';
	                }
	                if (row['ruleType'] == 3) {
	                    return '合作机构';
	                }
	                if (row['ruleType'] == 4) {
	                    return '合同';
	                }
	                return value;
	            }
	        }, {
	            field : 'value',
	            title : '值',
	            align : 'center',
	            valign : 'middle',
	        },{
	            field : 'ifValid',
	            title : '是否有效',
	            align : 'center',
	            valign : 'middle',
	            editable: {
                    type: 'select',
                    title: '状态',
                    source:[{value:"1",text:"有效"},{value:"2",text:"失效"}]
                }
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
			  content: 'publicqueryproject',
			  area: ['1000px', '500px'],
			  btn: ['确定','关闭'],
              yes: function(index){
                  //当点击‘确定’按钮的时候，获取弹出层返回的值
                  projectNum = window["layui-layer-iframe" + index].callbackdata();
                  //打印返回的值，看是否有我们想返回的值。
                  $("#project").val(projectNum);
                  //最后关闭弹出层
                  layer.close(index);
              },
              cancel: function(){
                  //右上角关闭回调
              }
			  
			});
		
	}
	

	</script>
</body>
</html>