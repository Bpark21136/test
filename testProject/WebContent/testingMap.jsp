<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding( "utf-8" );

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
	
	function goPopup(){
		// 주소 팝업창 경로
	    var pop = window.open("./jusoPopup2.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes");
	}
	function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn
							, detBdNmList, bdNm, bdKdcd, siNm, sggNm, emdNm, liNm, rn, udrtYn, buldMnnm, buldSlno, mtYn, lnbrMnnm, lnbrSlno, emdNo){
		addressSearch(roadFullAddr);
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
		        
		     	// 마커에 클릭이벤트를 등록합니다
		        kakao.maps.event.addListener(marker, 'click', function() {
		              // 마커 위에 인포윈도우를 표시합니다
					  infowindow.close();
		        });
		        kakao.maps.event.addListener(marker, 'rightclick', function() {
		              // 마커 위에 인포윈도우를 표시합니다
		              infowindow.open(map, marker);
		        });
		        
		     	map.setCenter(coords);
		    } 
		});
	}

	
	// 도형 스타일을 변수로 설정합니다
	var strokeColor = '#39f',
		fillColor = '#cce6ff',
		fillOpacity = 0.5,
		hintStrokeStyle = 'dash';

	var options = { // Drawing Manager를 생성할 때 사용할 옵션입니다
	    map: map, // Drawing Manager로 그리기 요소를 그릴 map 객체입니다
	    drawingMode: [
	        kakao.maps.Drawing.OverlayType.MARKER,
	        kakao.maps.Drawing.OverlayType.ARROW,
	        kakao.maps.Drawing.OverlayType.POLYLINE,
	        kakao.maps.Drawing.OverlayType.RECTANGLE,
	        kakao.maps.Drawing.OverlayType.CIRCLE,
	        kakao.maps.Drawing.OverlayType.ELLIPSE,
	        kakao.maps.Drawing.OverlayType.POLYGON
	    ],
	    // 사용자에게 제공할 그리기 가이드 툴팁입니다
	    // 사용자에게 도형을 그릴때, 드래그할때, 수정할때 가이드 툴팁을 표시하도록 설정합니다
	    guideTooltip: ['draw', 'drag', 'edit'], 
	    markerOptions: {
	        draggable: true,
	        removable: true
	    },
	    arrowOptions: {
	        draggable: true,
	        removable: true,
	        strokeColor: strokeColor,
	        hintStrokeStyle: hintStrokeStyle
	    },
	    polylineOptions: {
	        draggable: true,
	        removable: true,
	        strokeColor: strokeColor,
	        hintStrokeStyle: hintStrokeStyle
	    },
	    rectangleOptions: {
	        draggable: true,
	        removable: true,
	        strokeColor: strokeColor,
	        fillColor: fillColor,
	        fillOpacity: fillOpacity
	    },
	    circleOptions: {
	        draggable: true,
	        removable: true,
	        strokeColor: strokeColor,
	        fillColor: fillColor,
	        fillOpacity: fillOpacity
	    },
	    ellipseOptions: {
	        draggable: true,
	        removable: true,
	        strokeColor: strokeColor,
	        fillColor: fillColor,
	        fillOpacity: fillOpacity
	    },
	    polygonOptions: {
	        draggable: true,
	        removable: true,
	        strokeColor: strokeColor,
	        fillColor: fillColor,
	        fillOpacity: fillOpacity
	    }
	};

	// 위에 작성한 옵션으로 Drawing Manager를 생성합니다
	var manager = new kakao.maps.Drawing.DrawingManager(options);

	// Toolbox를 생성합니다. 
	// Toolbox 생성 시 위에서 생성한 DrawingManager 객체를 설정합니다.
	// DrawingManager 객체를 꼭 설정해야만 그리기 모드와 매니저의 상태를 툴박스에 설정할 수 있습니다.
	var toolbox = new kakao.maps.Drawing.Toolbox({drawingManager: manager});

	// 지도 위에 Toolbox를 표시합니다
	// kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOP은 위 가운데를 의미합니다.
	map.addControl(toolbox.getElement(), kakao.maps.ControlPosition.TOP);

	// 지도 타입 변경 컨트롤을 생성한다
	var mapTypeControl = new kakao.maps.MapTypeControl();

	// 지도의 상단 우측에 지도 타입 변경 컨트롤을 추가한다
	map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
	
	// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
	var zoomControl = new kakao.maps.ZoomControl();
	map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
</script>
</body>
</html>