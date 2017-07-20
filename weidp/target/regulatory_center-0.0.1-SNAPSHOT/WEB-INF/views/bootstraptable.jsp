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
<title>征信平台</title>
    <!-- 导入jquery bootstrap js css lib -->
    <%@include file="/common/jsp/bootstrap.jsp"%>
</head>
<body>
	

	<div class="container-fluid">
		<div class="row">
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<h2 class="sub-header">BootStrap Table DEMO</h2>
			</div>
		</div>
		
		<div class="row base-margin" id="query">
        <ol class="breadcrumb">
            <li><strong><span style="color: #27a0d7"></span></strong></li>
        </ol>
        <form class="form-inline" role="form" style="float: left; width: 100%" method="post" id="queryForm">
            <div class="form-group">
                <label for="orgCode">信托项目:</label> 
                <select class="form-control" id="orgCode" name="orgCode">   
                    <option value="">默认选择</option>
                    <c:forEach var="data" items="${orgList}">
                        <option value="${data.orgCode }">${data.orgName }</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="userName1">合作机构:</label> 
                <input type="text" class="form-control" name="searchuserName" id="searchuserName"  placeholder="请输入名称">
            </div>
            <div class="form-group">
                <label >日期:</label>
                <input placeholder="开始日期" class="form-control layer-date" id="startDate" name="startDate">
                <input placeholder="结束日期" class="form-control layer-date" id="endDate" name="endDate">
            </div>
            <div class="form-group">
                <button type="button" id="queryBtn" onclick="doQuery();" class="btn btn-primary">查询</button>
            </div>
            <div class="form-group btn-right">
                <button type="button" class="btn btn-primary" id="addBtn" >layer弹出框演示</button>
            </div> 
        </form>
    </div>
    <div class="container" style="width: 100%">
        <table id="demo-table">
        </table>
    </div>
		
	</div>


   
	<script>
	$(function () {
	    initTable();
	    initDate();
	});

	function doQuery(params){
	    $('#demo-table').bootstrapTable('refresh');    //刷新表格
	}

	function initTable(){
	    var url = "test/searchListByPage";
	    $('#demo-table').bootstrapTable({
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
	        showExport: true,                     //是否显示导出
	        exportDataType: "basic",              //basic', 'all', 'selected'.
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
	                  searchuserName : $("#searchuserName").val()  
	              };    
	              return param;                   
	            }, 
	        onEditableSave: function (field, row, oldValue, $el) {
	                $.ajax({
	                    type: "post",
	                    url: "test/tableEdit",
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
	        minimumCountColumns:2,
	        pageNumber:1,                       //初始化加载第一页，默认第一页
	        pageSize: 20,                       //每页的记录行数（*）
	        pageList: [10, 25, 50, 100],        //可供选择的每页的行数（*）
	        uniqueId: "id",                     //每一行的唯一标识，一般为主键列
	        showExport: true,                    
	        exportDataType: 'all',
	        columns: [
	        {
	        	    title: '不报',
					checkbox : true
			},
	        {
	            field: '',
	                    title: '序号',
	                    formatter: function (value, row, index) {
	                          return index+1;
	                     }
	        },
	        {
	            field : 'id',
	            title : 'User ID',
	            align : 'center',
	            valign : 'middle',
	            sortable : true
	        }, {
	            field : 'name',
	            title : '姓名',
	            align : 'center',
	            valign : 'middle',
	            sortable : true,
		        editable: {
	                type: 'text',
	                mode: 'inline',       
	                title: '姓名'
	            }
	        }, {
	            field : 'age',
	            title : '部门',
	            align : 'center',
	            valign : 'middle',
	            editable: {
                    type: 'select',
                    title: '部门',
                    source:[{value:"1",text:"研发部"},{value:"2",text:"销售部"},{value:"3",text:"行政部"}]
                }
	        }, {
	            field : 'crateDate',
	            title : '创建日期',
	            align : 'center',
	            valign : 'left',
	            formatter: function (value) {
	                 return	 dateFormatUtil(value);
	            },
	            editable: {
                    type: 'date',
                    title: '创建日期'
                }
	        }]
	    });
	}
	
	

	function initDate(){
	    var start = {
	            elem: '#startDate',
	            format: 'YYYY-MM-DD hh:mm:ss',
	            min: laydate.now(-7),       
	            max: laydate.now(),
	            istime: true,
	            istoday: false,
	            choose: function (datas) {
	                end.min = datas; //开始日选好后，重置结束日的最小日期
	                end.start = datas //将结束日的初始值设定为开始日
	            }
	        };
	        var end = {
	            elem: '#endDate',
	            format: 'YYYY-MM-DD hh:mm:ss',
	            min: laydate.now(-7),       
	            max: laydate.now(),
	            istime: true, //是否开启时间选择
	            isclear: true, //是否显示清空
	            istoday: true, //是否显示今天
	            issure: true, //是否显示确认
	            choose: function (datas) {
	                start.max = datas; //结束日选好后，重置开始日的最大日期
	            }
	        };
	        laydate(start);
	        laydate(end);
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
	

			$('#username').editable({
				type : "text", //编辑框的类型。支持text|textarea|select|date|checklist等
				title : "用户名", //编辑框的标题
				disabled : false, //是否禁用编辑
				emptytext : "空文本", //空值的默认文本
				mode : "inline", //编辑框的模式：支持popup和inline两种模式，默认是popup
				validate : function(value) { //字段验证
					if (!$.trim(value)) {
						return '不能为空';
					}
				}
			});

		
		//弹出一个页面层
		$('#addBtn').on('click', function(){
		  layer.open({
		  type: 1,
		  area: ['600px', '360px'],
		  shadeClose: true, //点击遮罩关闭
		  content: '\<\div style="padding:20px;">自定义内容\<\/div>'
		  });
		});
	</script>
</body>
</html>