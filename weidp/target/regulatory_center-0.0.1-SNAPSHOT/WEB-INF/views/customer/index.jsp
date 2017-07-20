<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="/common/jsp/mytag.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
<title>客户个人信息</title>
<!-- 导入jquery bootstrap js css lib -->
<%@include file="/common/jsp/bootstrap.jsp"%>

</head>
<body>
	<div class="container-fluid">
		<div class="row base-margin" id="query">
			<form class="form-inline" role="form" method="post" id="queryForm">
				
				<div class="form-group">
					<label>合同编号:</label> 
					<input type="text" class="form-control" id="name" name="name"> 
				</div>
				<div class="form-group">
					<label >证件号码:</label> 
					<input type="text" class="form-control" name="certNo" id="certNo" />
				</div>
				<br/>
				<div class="form-group group1 ">
					<button type="button" id="queryBtn" class="btn btn-primary">查询</button>
				</div>
				<div class="form-group group2">
					<button type="button" id="resetBtn" class="btn btn-primary">重置</button>
				</div>
			</form>
		</div>
		<div class="container">
			   
			<ul id="myTab" class="nav nav-tabs">
			    <li class="active"><a href="#tradehis" data-toggle="tab">交易查询</a></li>
			    <li><a href="#spetradfHis" data-toggle="tab">特殊交易查询</a></li>
			    <li><a href="#perpersonHis" data-toggle="tab"> 客户基本信息查询  </a> </li>
			    <li><a href="#addrHis" data-toggle="tab">客户住址信息查询</a></li>
			    <li><a href="#emphis" data-toggle="tab">客户职业查询</a></li>
			</ul>
			<div id="myTabContent" class="tab-content">
			    <div class="tab-pane fade in active" id="tradehis">
			    	<jsp:include page="../trade/submittradehis.jsp" flush="true" />
			    </div>
			    <div class="tab-pane fade" id="spetradfHis">
			    	<jsp:include page="./submtSpetradfHis.jsp" flush="true" />
			    </div>
			    <div class="tab-pane fade" id="perpersonHis">
			    	<jsp:include page="./submtPersonHis.jsp" flush="true" />
			    </div>
			    <div class="tab-pane fade" id="addrHis">
			    	<jsp:include page="./submitAddrHis.jsp" flush="true" />
			    </div>
			    <div class="tab-pane fade" id="emphis">
			    	<jsp:include page="./submitemphis.jsp" flush="true" />
			    </div>
			</div>
		</div>
	</div>
		
	<script>
		 

	</script>
</body>
</html>