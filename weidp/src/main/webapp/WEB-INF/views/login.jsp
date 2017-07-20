<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>  
<%  
    String url = request.getRequestURL().toString();  
    url = url.substring(0, url.indexOf('/', url.indexOf("//") + 2));  
    String context = request.getContextPath();  
    url += context;  
    application.setAttribute("ctx", url);  
%>  
<!DOCTYPE html>
<html lang="zh-CN">
<head>  
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge,Chrome=1" />
<title>登录</title>
    <link href="plug-in/hplus/css/bootstrap.min.css" rel="stylesheet">
    <link href="plug-in/hplus/css/font-awesome.min93e3.css?v=4.4.0" rel="stylesheet">
    <link href="plug-in/hplus/css/animate.min.css" rel="stylesheet">
    <link href="plug-in/hplus/css/style.min.css" rel="stylesheet">
    <link href="plug-in/hplus/css/login.min.css" rel="stylesheet">
    <!--[if lte IE 9]>
    <script src="plug-in/jquery/1.10.2/jquery.js"></script>
    <script src="plug-in/html5shiv/3.7/html5shiv.min.js"></script>
    <script src="plug-in/respond/1.4.2/respond.js"></script>
    <![endif]-->
    <script>
        if(window.top!==window.self){window.top.location=window.location};
    </script>  
</head>  
<body class="signin">
    <div class="signinpanel">
        <div class="row">
            <div class="col-sm-7">
                <div class="signin-info">
                    <div class="logopanel m-b">
                       
                    </div>
                    <div class="m-b"></div>
                   
                </div>
            </div>
            <div class="col-sm-5">
                <form action="${ctx}/checkLogin" method="post">  
                    <h4 class="no-margins">商城后台管理系统用户名1 密码 1</h4>
                    <p class="m-t-md"></p>
                    <input type="text" class="form-control uname" placeholder="用户名" name="username"/>
                    <input type="password" class="form-control pword m-b" placeholder="密码" name="password"/>
                    <button class="btn btn-success btn-block">登录</button>
                </form>
                <p class="text-error">${requestScope.message}</p>
            </div>
        </div>
        <div class="signup-footer">
            <div class="pull-left">
                &copy; 2017 All Rights Reserved. 
            </div>
        </div>
    </div>
</body>
</html> 