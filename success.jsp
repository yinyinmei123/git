<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>登录成功，跳转到主页</title>
</head>
<body>
<%--登录成功，进入我的主页 --%>
<h1><%=request.getParameter("user")%>  恭喜你登录成功！！！</h1><br>
<h1><a href="pig.html">点击进入我的主页</a></h1>
</body>
</html>

