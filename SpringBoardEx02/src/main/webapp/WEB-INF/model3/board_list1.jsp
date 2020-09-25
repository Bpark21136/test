<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ page import="model1.BoardTO" %>
<%@ page import="model1.BoardListTO" %>

<%@ page import="java.util.ArrayList" %>

<%
	int cpage = (Integer)request.getAttribute("cpage");
	BoardListTO listTO = (BoardListTO)request.getAttribute("listTO");
	int totalRecord = (Integer)request.getAttribute("totalRecord");
	int totalPage = (Integer)request.getAttribute("totalPage");
	
	int blockPerPage = (Integer)request.getAttribute("blockPerPage");
	int startBlock = (Integer)request.getAttribute("startBlock");
	int endBlock = (Integer)request.getAttribute("endBlock");
	ArrayList<BoardTO> boardLists = (ArrayList<BoardTO>)request.getAttribute("boardLists");

	StringBuffer strHtml = new StringBuffer();
	int count = 1;
	for(BoardTO to : boardLists) {
		String seq = to.getSeq();
		String subject = to.getSubject();
		String writer = to.getWriter();
		String wdate = to.getWdate();
		String hit = to.getHit();
		String filename = to.getFilename();
		String cc = to.getCommentCount();
		int wgap = to.getWgap();
		if(count % 5 == 1) {
			strHtml.append("<tr>");
		}
		strHtml.append("<td width='20%' class='last2'>");
		strHtml.append("<div class='board'>");
		strHtml.append("<table class='boardT'>");
		strHtml.append("<tr>");
		strHtml.append("<td class='boardThumbWrap'>");
		strHtml.append("<div class='boardThumb'>");
		strHtml.append("<a href='view.do?cpage=" + cpage + "&seq=" + seq + "'>");
		strHtml.append("<img src='./upload/" + filename + "' onerror=\"src='./images/broken-1.png';\"border='0' width='100%' /></a>");
		strHtml.append("</div></td></tr><tr><td><div class='boardItem'>");
		strHtml.append("<strong>" + subject + "</strong>");
		strHtml.append("<span class='coment_number'><img src='./images/icon_comment.png' alt='commnet'>");
		strHtml.append(cc);
		strHtml.append("</span>");
		strHtml.append("<img src='./images/icon_hot.gif' alt='HOT'>");
		strHtml.append("</div></td></tr><tr>");
		strHtml.append("<td><div class='boardItem'><span class='bold_blue'>" + writer + "</span></div></td>");
		strHtml.append("</tr><tr>");
		strHtml.append("<td><div class='boardItem'>" + wdate + "<font>|</font> Hit " + hit + "</div></td>");
		strHtml.append("</tr></table></div></td>");
		if(count % 5 == 0) {
			strHtml.append("</tr>");
		}
		count++;
	}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="./css/board_list.css">
<style type="text/css">
<!--
	.board_pagetab { text-align: center; }
	.board_pagetab a { text-decoration: none; font: 12px verdana; color: #000; padding: 0 3px 0 3px; }
	.board_pagetab a:hover { text-decoration: underline; background-color:#f2f2f2; }
	.on a { font-weight: bold; }
-->
</style>
</head>

<body>
<!-- 상단 디자인 -->
<div class="contents1"> 
	<div class="con_title"> 
		<p style="margin: 0px; text-align: right">
			<img style="vertical-align: middle" alt="" src="./images/home_icon.gif" /> &gt; 커뮤니티 &gt; <strong>여행지리뷰</strong>
		</p>
	</div> 
	<div class="contents_sub">	
		<div class="board_top">
			<div class="bold">
				<p>총 <span class="txt_orange"><%=totalRecord%></span>건</p>
			</div>
		</div>	
		
		<!--게시판-->
		<table class="board_list">
			<tr>
				<%=strHtml %>
			</tr>
		</table>
		<!--//게시판-->	
		
		<div class="align_right">		
			<input type="button" value="쓰기" class="btn_write btn_txt01" style="cursor: pointer;" onclick="location.href='write.do?cpage=<%=cpage %>'" />
		</div>
		<!--페이지넘버-->
		<div class="paginate_regular">
			<div class="board_pagetab">
				<%
					if(startBlock == 1) {
						out.println("<span><a>&lt;&lt;</a></span>");
					} else {
						out.println("<span><a href='list.do?cpage=" + (startBlock - blockPerPage) + "'>&lt;&lt;</a></span>");
					}
					out.println("&nbsp;");
					
					if(cpage == 1) {
						out.println("<span><a>&lt;</a></span>");
					} else {
						out.println("<span><a href='list.do?cpage=" + (cpage - 1) + "'>&lt;</a></span>");
					}
					out.println("&nbsp;&nbsp;");
					
					for(int i = startBlock; i <= endBlock; i++) {
						if(cpage == i) {
							out.println("<span><a>[" + i + "]</a></span>");
						} else {
							out.println("<span><a href='list.do?cpage=" + i + "'>" + i + "</a></span>");
						}						
					}
					
					out.println("&nbsp;&nbsp;");
					if(cpage == totalPage) {
						out.println("<span><a>&gt;</a></span>");
					} else {
						out.println("<span><a href='list.do?cpage=" + (cpage + 1) + "'>&gt;</a></span>");
					}

					out.println("&nbsp;");					
					if(endBlock == totalPage) {
						out.println("<span><a>&gt;&gt;</a></span>");
					} else {
						out.println("<span><a href='list.do?cpage=" + (startBlock + blockPerPage) + "'>&gt;&gt;</a></span>");
					}
				%>
			</div>
		</div>
		<!--//페이지넘버-->	
  	</div>
</div>
<!--//하단 디자인 -->

</body>
</html>
