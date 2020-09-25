<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model1.BoardTO" %>
<%
	String cpage = (String)request.getAttribute("cpage");
	String cSeq = (String)request.getAttribute("cSeq");
	BoardTO to = (BoardTO)request.getAttribute("to");
	
	String seq = to.getSeq();
	String subject = to.getSubject();
	String writer = to.getWriter();
%>	
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="./css/board_write.css">
<script type="text/javascript">
	window.onload = function() {
		document.getElementById('dbtn').onclick = function() {
			if(document.dfrm.cpassword.value.trim() == '') {
				alert('비밀번호를 입력하셔야 합니다');
				return false;
			}
			document.dfrm.submit();
		};
	};
</script>
</head>

<body>
	<form action="./commentDelete_ok.do" method="post" name="dfrm">		
		<input type="hidden" name="seq" value="<%=seq%>" />
		<input type="hidden" name="cpage" value="<%=cpage%>" />
		<input type="hidden" name="cSeq" value="<%=cSeq%>" />
			<table>
				<tr>
					<th class="top">비밀번호를 입력</th>
					<td class="top" colspan="3"><input type="text" name="cpassword" value="" class="board_write_input_100" maxlength="5" /></td>
				</tr>
			</table>
			<div>			
				<input type="button" id="dbtn" value="입력" class="btn_write btn_txt01" style="cursor: pointer;" />
			</div>	
	</form>
</body>
</html>
