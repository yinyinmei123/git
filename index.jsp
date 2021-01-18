<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>欢迎来到我们的世界！</title>
</head>
<body>
<%--登录页面 --%>
<h1 style="text-align:center;">即将踏入！</h1>
<form action="loginProcess.jsp">
<table align="center" border="10">
<tr>
<td>用户名：</td>
<td><input type="text" name="user"></td>
</tr>
<tr>
<td>密    码：</td>
<td><input type="password" name="password"></td>
</tr>
<tr>
<td><input type="submit" name="提交"></td>
<td><input type="reset" name="重置"></td>
</tr>
</table>
</form>
 
</body>
</html>

