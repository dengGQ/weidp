<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<!-- 导入jquery bootstrap js css lib -->
<%@include file="/common/jsp/bootstrap.jsp"%>
<!-- 导入bootstrap-fileinput js css -->
<%@include file="/common/jsp/fileupload.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>文件树形展示</title>
<link rel="stylesheet" href="${webRoot}/plug-in/zTree/v3/css/demo.css" type="text/css">
<link rel="stylesheet" href="${webRoot}/plug-in/zTree/v3/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${webRoot}/plug-in/jquery/1.10.2/jquery.js"></script>
<!--[if lte IE 9]>
 <script src="${webRoot}/plug-in/html5shiv/3.7/html5shiv.min.js"></script>
 <script src="${webRoot}/plug-in/respond/1.4.2/respond.js"></script>
<![endif]-->
<script type="text/javascript" src="${webRoot}/plug-in/zTree/v3/js/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${webRoot}/plug-in/zTree/v3/js/jquery.ztree.excheck.js"></script>
<script type="text/javascript">
var setting = {
		async: {
			enable: true,
			url:"${webRoot}/fileOperate/treedata",
		    autoParam:["id", "name", "level","pid","open","isParent","click","path"]
		},
		check: {
			enable: true
		},
		view : {  
            dblClickExpand : false,  
            showLine : false,
            selectedMulti: false
        },  
        data : {  
            simpleData : {  
                enable : true  
            }  
        },  
    	callback: {
			beforeAsync: beforeAsync,
			onAsyncError: onAsyncError,
			onAsyncSuccess: onAsyncSuccess,
			onCheck: onCheck
		},
        dataFilter: filter
	};

	function filter(treeId, parentNode, childNodes) {
		if (!childNodes) return null;
		for (var i=0, l=childNodes.length; i<l; i++) {
			childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
		}
		return childNodes;
	}
	
	//关键代码，通过treeNode遍历父亲节点，根节点再次调用getParentNode得到null终止循环
	function getPathText(node){
        var s=node.name;
        while(node=node.getParentNode())s=node.name+'/'+s;
        return s;
    }
	
	function showLog(str) {
		console.log("showlog:"+str);
	}
	
	function onCheck(e, treeId, treeNode) {
		showLog("[ "+getTime()+" onCheck ];" + getPathText(treeNode) );
		$("#filePath").val(getPathText(treeNode));
	}		
	

	var log, className = "dark";
	function beforeAsync(treeId, treeNode) {
		className = (className === "dark" ? "":"dark");
		//showLog("[ "+getTime()+" beforeAsync ]&nbsp;&nbsp;&nbsp;&nbsp;" + ((!!treeNode && !!treeNode.name) ? treeNode.name : "root") );
		return true;
	}
	function onAsyncError(event, treeId, treeNode, XMLHttpRequest, textStatus, errorThrown) {
		//showLog("[ "+getTime()+" onAsyncError ]&nbsp;&nbsp;&nbsp;&nbsp;" + ((!!treeNode && !!treeNode.name) ? treeNode.name : "root") );
	}
	function onAsyncSuccess(event, treeId, treeNode, msg) {
		//showLog("[ "+getTime()+" onAsyncSuccess ]&nbsp;&nbsp;&nbsp;&nbsp;" + ((!!treeNode && !!treeNode.name) ? treeNode.name : "root") );
	}
	function getTime() {
		var now= new Date(),
		h=now.getHours(),
		m=now.getMinutes(),
		s=now.getSeconds(),
		ms=now.getMilliseconds();
		return (h+":"+m+":"+s+ " " +ms);
	}

	function refreshNode(e) {
		var zTree = $.fn.zTree.getZTreeObj("tree"),
		type = e.data.type,
		silent = e.data.silent,
		nodes = zTree.getSelectedNodes();
		if (nodes.length == 0) {
			alert("请先选择一个父节点");
		}
		for (var i=0, l=nodes.length; i<l; i++) {
			zTree.reAsyncChildNodes(nodes[i], type, silent);
			if (!silent) zTree.selectNode(nodes[i]);
		}
	}

	$(document).ready(function(){
	   $.fn.zTree.init($("#tree"), setting);
	});

	
	/**
	 *上传
	 *jobName  job名称
	 *filePath 文件路径
	 */
	function upload() {
		var jobName = $("#jobName").val();
		var filePath = $("#filePath").val();
		var json = {"filePath" : filePath,"jobName" : jobName};
		$.ajax({
			type : 'post',
			url : '${webRoot}/fileOperate/newUploadfile',
			data : json,
			success : function(data) {
				layer.alert(data.msg);
			},
		});
	};
</script>
</head>

<body>
<div class="content_wrap">
	<div class="zTreeDemoBackground left">
		<ul id="tree" class="ztree"></ul>
	</div>
	<div class="right">
		<div id="selectDiv" class="form-group">
				<label for="jobName">CSV文件类型:</label>
				<select id="jobName" name="jobName">
					<option  class="form-control" value="0" selected="selected"  >请选择</option>
					<option  value="REG_LOAD_RHZX_TRADE_OK">交易信息</option>
					<option  value="REG_LOAD_RHZX_PERSON">客户信息</option>
					<option  value="REG_LOAD_RHZX_EMP">客户就业信息</option>
					<option  value="REG_LOAD_RHZX_ADDRESS">居住信息</option>
					<option  value="REG_LOAD_RHZX_SPETRADE">特殊交易信息</option>
				</select>
		</div>
		<div class="form-group">
			<input id="filePath" name="filePath" type="text" size="30px">
			<button class="btn btn-primary dropdown-toggle" onclick = "upload();">上传</button>
		</div>
	</div>
</div>
</body>
</html>