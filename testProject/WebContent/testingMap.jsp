<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String address1 = request.getParameter("address1");
	String address2 = request.getParameter("address2");
	String address3 = request.getParameter("address3");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- services와 clusterer, drawing 라이브러리 불러오기 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=ea1cd4df3dc8369022db16f972c085c3&libraries=services,clusterer,drawing"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<div id="map" style="width:1000px;height:800px;"></div>
<!-- 지도api스크립트는 항상 구현하려는 지도 아래에 있어야됨 -->
<form name="form" id="form" method="post">
	<table >
			<colgroup>
				<col style="width:20%"><col>
			</colgroup>
			<tbody>
				<tr>
					<td>
					    <input type="hidden" id="confmKey" name="confmKey" value=""  >
						<input type="button"  value="주소검색" onclick="goPopup();">
					</td>
				</tr>
			</tbody>
		</table>
</form>
<script>
	var container = document.getElementById('map');
	// 시작 위치
	var options = {
		center: new kakao.maps.LatLng(37.582544875368, 126.973059283309),
		level: 5
	};

	var map = new kakao.maps.Map(container, options);
	
	// 주소-좌표 변환 객체를 생성합니다
	var geocoder = new kakao.maps.services.Geocoder();
	
	var address = ["<%=address1%>", "<%=address2%>", "<%=address3%>"];
	
	for (var i = 0; i < 3; i++) {
		var newAddress = address[i];
		if( newAddress != null) {
			addressSearch(newAddress);
		}
	}
	
	// 주소로 좌표를 검색합니다
	function addressSearch(address) {
		geocoder.addressSearch(address, function(result, status) {

		    // 정상적으로 검색이 완료됐으면 
		     if (status === kakao.maps.services.Status.OK) {

		        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

		        // 결과값으로 받은 위치를 마커로 표시합니다
		        var marker = new kakao.maps.Marker({
		            map: map,
		            position: coords
		        });
		        var iwContent = '<div style="width:150px;text-align:center;padding:6px 0;">'+ address +'</div>';
		        
		        // 인포윈도우로 장소에 대한 설명을 표시합니다
		        var infowindow = new kakao.maps.InfoWindow({
		            content: iwContent
		        });
		        infowindow.open(map, marker);
		        
		     	map.setCenter(coords);
		    } 
		});
	}

	function goPopup(){
		// 주소 팝업창 경로
	    var pop = window.open("./jusoPopup2.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes");
	}
	function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn
							, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo){
		
		// 주소로 좌표를 검색합니다
		geocoder.addressSearch(roadFullAddr, function(result, status) {

		    // 정상적으로 검색이 완료됐으면 
		     if (status === kakao.maps.services.Status.OK) {

		        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

		        // 결과값으로 받은 위치를 마커로 표시합니다
		        var marker = new kakao.maps.Marker({
		            map: map,
		            position: coords
		        });

		        // 인포윈도우로 장소에 대한 설명을 표시합니다
		        var infowindow = new kakao.maps.InfoWindow({
		            content: '<div style="width:150px;text-align:center;padding:6px 0;">'+roadFullAddr+'</div>'
		        });
		        infowindow.open(map, marker);

		        // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
		        map.setCenter(coords);
		    } 
		});
	}

	// 지도 타입 변경 컨트롤을 생성한다
	var mapTypeControl = new kakao.maps.MapTypeControl();

	// 지도의 상단 우측에 지도 타입 변경 컨트롤을 추가한다
	map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
</script>
</body>
</html>