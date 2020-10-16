<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form action="./testingMap.jsp" method="post" name="wfrm">
		<div>
			<div>
				<table>
				<tr>
					<th>주소1</th>
					<td><input type="text" id="address1" name="address1" value="서울특별시 서초구 청계산로9길 1-12 (신원동, 서초포레스타6단지)"/></td>
				</tr>
				<tr>
					<th>주소2</th>
					<td><input type="text" id="address2" name="address2" value="서울특별시 강서구 양천로 489 (가양동, 가양우성아파트)"/></td>
				</tr>
				<tr>
					<th>주소3</th>
					<td><input type="text" id="address3" name="address3" value=""/></td>
				</tr>
				</table>
			</div>
			<div>
				<div>		
					<input type="submit" value="등록" id="wbtn" />					
				</div>	
			</div>
		</div>
	</form>
</body>
</html>