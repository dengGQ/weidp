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
<title>新增报送数据配置</title>
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
                <button type="button" id="saveBtn" onclick="doSave();" class="btn btn-primary">保存配置</button>
            </div>
            
             <div class="form-group group2">
              <button type="button" id="resetBtn" onclick="formReset();" class="btn btn-primary">重置</button>
            </div>
        </form>
    </div>		
	</div>


   
	<script>
	function doSave(){
	    $.ajax({
	    	  type: 'post',
	    	  url: '${webRoot}/datareportcfg/save',
	    	  data:{ 
	    		   org : $('#org').val(), orgname : $('#orgname').val(), 
	    		   prod : $('#prod').val(), prodname : $('#prodname').val(), 
	    		   conno : $('#conno').val(), connoname : $('#connoname').val(), 
	    		   project : $('#project').val(),projectname : $('#projectname').val()
	    	  },
	    	  dataType: 'json',
	    	  success: function(data){
	    		  if (data.success == "true") {
	    			  layer.alert('保存配置成功');
                     // $('#notsubmitdata-table').bootstrapTable('refresh');    //刷新表格
                  }else{
                	  layer.alert(data.msg);
                  }
	    		  
	    	  },
	    	  error: function () {
	    		  layer.alert('保存配置失败')
              },
	    	  
	    	});
	}
	
	
	function selectProject(){
		var projectNum;
		var index = layer.open({
			  type: 2,
			  title: '选择信托项目',
			  maxmin: true,
			  content: '${webRoot}/publicquery/project',
			  area: ['900px', '500px'],
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
			  area: ['900px', '500px'],
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
			  area: ['900px', '500px'],
			  btn: ['确定','关闭'],
              yes: function(index){
                  //当点击‘确定’按钮的时候，获取弹出层返回的值
                  projectNum = window["layui-layer-iframe" + index].callbackdata();
                  $("#prod").val(projectNum[0]);
                  $("#prodname").val(projectNum[1]);
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
			  area: ['900px', '500px'],
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
	  $('#queryForm')[0].reset();  
	}
	
	

	</script>
</body>
</html>