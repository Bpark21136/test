<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model1.BoardTO" %>
<%@ page import="model1.BoardListTO" %>
<%@ page import="model1.CommentTO" %>
<%@page import="java.util.ArrayList"%>

<%
	String cpage = (String)request.getAttribute("cpage");
	BoardTO to = (BoardTO)request.getAttribute("to");
	
	String seq = to.getSeq();
	String subject = to.getSubject();
	String writer = to.getWriter();
	String mail = to.getMail();
	String wdate = to.getWdate();
	String hit = to.getHit();
	String content = to.getContent();
	String filename = to.getFilename();
	String wip = to.getWip();
	CommentTO cto = (CommentTO)request.getAttribute("cto");
	ArrayList<CommentTO> commentLists = (ArrayList<CommentTO>)request.getAttribute("commentLists");
	
	StringBuffer strHtml = new StringBuffer();
	StringBuffer strJavaScript = new StringBuffer();
	for(CommentTO c : commentLists) {
		String cWriter = c.getWriter();
		String cWdate = c.getWdate();
		String cContent = c.getContent();
		String cSeq = c.getSeq();
		
		strHtml.append("<tr>");
		strHtml.append("<td class='coment_re' width='20%'>");
		strHtml.append("<strong>" + cWriter + "</strong> (" + cWdate + ")");
		strHtml.append("<div class='coment_re_txt'>");
		strHtml.append(cContent);
		strHtml.append("<br /><br />");
		strHtml.append("<form action='./commentDelete.do' method='post' name='dfrm" + cSeq + "' target='popUp" + cSeq + "'>");	
		strHtml.append("<input type='hidden' name='seq' value='" + seq + "' />");
		strHtml.append("<input type='hidden' name='cpage' value='" + cpage + "' />");
		strHtml.append("<input type='hidden' name='cSeq' value='" + cSeq + "' />");
		strHtml.append("<input type='button' id='" + cSeq + "' style='width: 60px; height: 20px; color: black;' value='댓글삭제' class='btn_re btn_txt01' onclick='popUp" + cSeq + "()' />");
		strHtml.append("</form>");
		strHtml.append("</div></td></tr>");
		
		strJavaScript.append("function popUp" + cSeq + "() {");
		strJavaScript.append("if(document.getElementById('" + cSeq + "') != null) {");
		strJavaScript.append("document.getElementById( '" + cSeq + "' ).onclick = function() {");
		strJavaScript.append("open('', 'popUp" + cSeq + "', 'height=600, width=500');");
		strJavaScript.append("document.dfrm" + cSeq + ".submit();");
		strJavaScript.append("}}}");
	}
%>	
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="./css/board_view.css">
<script type="text/javascript">
	window.onload = function() {
		document.getElementById( 'cbtn' ).onclick = function() {
			if(document.cfrm.cwriter.value.trim() == '' ) {
				alert('이름을 입력하셔야 합니다.');
				return false;
			}
			if(document.cfrm.cpassword.value.trim() == '' ) {
				alert('비밀번호를 입력하셔야 합니다.');
				return false;
			}
			if(document.cfrm.ccontent.value.trim() == '' ) {
				alert('내용을 입력하셔야 합니다.');
				return false;
			}
			document.cfrm.submit();
		};
	};
	<%=strJavaScript%>
</script>
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
	<!--게시판-->
		<div class="board_view">
			<table>
			<tr>
				<th width="10%">제목</th>
				<td width="60%"><%=subject %></td>
				<th width="10%">등록일</th>
				<td width="20%"><%=wdate %></td>
			</tr>
			<tr>
				<th>글쓴이</th>
				<td><%=writer %>(<%=mail %>)(<%=wip %>)</td>
				<th>조회</th>
				<td><%=hit %></td>
			</tr>
			<tr>
				<td colspan="4" height="200" valign="top" style="padding:20px; line-height:160%">
					<div id="bbs_file_wrap">
						<div>
							<img src="./upload/<%=filename %>" width="50%" alt=""/><br />
							
						</div>
					</div>
					<%=content%>
				</td>
			</tr>			
			</table>
			
			<table>
			<%=strHtml %>
			</table>

			<form action="./commentWrite_ok.do" method="post" name="cfrm">	
				<input type="hidden" name="seq" value="<%=seq%>" />
				<input type="hidden" name="cpage" value="<%=cpage%>" />
			<table>
			<tr>
				<td width="94%" class="coment_re">
					글쓴이 <input type="text" name="cwriter" maxlength="5" class="coment_input" />&nbsp;&nbsp;
					비밀번호 <input type="password" name="cpassword" class="coment_input pR10" />&nbsp;&nbsp;
				</td>
				<td width="6%" class="bg01"></td>
			</tr>
			<tr>
				<td class="bg01">
					<textarea name="ccontent" cols="" rows="" class="coment_input_text"></textarea>
				</td>
				<td align="right" class="bg01">
					<input type="button" id="cbtn" style="width: 100px; height: 50px; color: black;" value="댓글등록" class="btn_re btn_txt01" />
				</td>
			</tr>
			</table>
			</form>
		</div>
		<div class="btn_area">
			<div class="align_left">			
				<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='list.do?cpage=<%=cpage%>'" />
			</div>
			<div class="align_right">
				<input type="button" value="수정" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='modify.do?cpage=<%=cpage%>&seq=<%=seq%>'" />
				<input type="button" value="삭제" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='delete.do?cpage=<%=cpage%>&seq=<%=seq%>'" />
				<input type="button" value="쓰기" class="btn_write btn_txt01" style="cursor: pointer;" onclick="location.href='write.do?cpage=<%=cpage%>'" />
			</div>	
		</div>
		<!--//게시판-->
	</div>
<!-- 하단 디자인 -->
</div>

</body>
</html>
