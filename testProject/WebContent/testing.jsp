<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
 
 
	// SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	
	String input = "2020/05/23 16:05:25";
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	String formattedDate = formatter.format(input);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%= input%>
<br />
<br />
<%= formattedDate%>
</body>
</html>