<%@page import="model1.CommentTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="model1.BoardTO" %>

<%
	String cpage = (String)request.getAttribute("cpage");

	BoardTO to = (BoardTO)request.getAttribute("to");
	CommentTO cto = (CommentTO)request.getAttribute("cto");
	int flag = (Integer)request.getAttribute("flag");

	out.println("<script type='text/javascript'>");
	if( flag == 0) {
		out.println("alert('댓글삭제에 성공 했습니다.')");
		out.println("window.close();");		
		// out.println("location.href='./board_view1.jsp?seq=" + to.getSeq() + "&cpage=" + cpage + "';");
	} else if( flag == 1 ) {
		out.println("alert('비밀번호가 잘못되었습니다.')");
		out.println("history.back();");
	} else {
		out.println("alert('댓글삭제에 실패했습니다.')");
		out.println("history.back();");
	}	
	out.println("</script>");
%>