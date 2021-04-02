<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%
	// 3개의 값(URL, HTML태그 셀렉트 박스, 크롤링한 HTML코드를 나눌 임의의 수)을 입력 받는다.
	// 1. 받은 URL주소의 페이지를 크롤링한다.
	// 2. 크롤링한 스트링을 영어와 숫자만 남긴다.(셀렉트 박스를 체크한 경우 HTML태그도 남긴다)
	// 3. Aa1Bb2Cc3...와 같이 정렬한다
	// 4. 입력받은 임의의수로 나눈 뒤 나머지를 구한다.
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form>
		<input type="text"  id="url" name="url" placeholder="url">
		<div></div>
		<label for="html">HTML태그 포함 여부</label>
		<input type="checkbox" id="html" name="html" value="html">
		<div></div>
		<input type="text"  id="number" name="number" placeholder="숫자">
		<div></div>
		<button type="submit">완료</button>
	</form>
</body>
</html>