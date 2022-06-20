		</div>
	</div>
	<div id="bottom_wrap">
		<div id="bottom">
			<div class="btn_area"></div>
			<div class="bottom_logo"><%=viewImg(IMG_SHARE&"/bottom_logo.gif",149,87,"")%></div>
			<div class="bottom_copy">
			<p style="margin-top:30px; line-height:130%;">
				상호 : 미디어원 | 주소 : 경북 구미시 원평동 구미 CGV 3층 | 대표자: 김동만<br />
				사업자등록번호 : 510-02-46486 | 통신판매업 신고번호 : 제 2011-경북구미-0011 호<br />
				TEL: 15-99-4251 | FAX : 0505-606-1544 | E-MAIL : ceo@media1.co.kr<br />
				<br />
				Copyright ⓒ 2011 ilovekt.co.kr All Rights Reserved.<br />
			</p>
			</div>
		</div>
	</div>
</div>



<div id="floating1" style="position:absolute; z-index:1000;"><!--#include virtual="/_include/floating1.asp"--></div>
<div id="floating2" style="position:absolute; z-index:1000;"><!--#include virtual="/_include/floating2.asp"--></div>
<script type="text/javascript">
<!--

if (document.getElementById("floating1")) {
	// 반드시 플로팅 기준객체(basisBody) 외부에서 설정
	var objFloating = new floating();
	objFloating.objBasis = document.getElementById("contain");
	objFloating.objFloating = document.getElementById("floating1");
	objFloating.time = 15;
	objFloating.marginLeft = -1220;
	objFloating.marginTop = 80;
	objFloating.init();
	objFloating.run();
}

if (document.getElementById("floating2")) {
	// 반드시 플로팅 기준객체(basisBody) 외부에서 설정
	var objFloating = new floating();
	objFloating.objBasis = document.getElementById("contain");
	objFloating.objFloating = document.getElementById("floating2");
	objFloating.time = 15;
	objFloating.marginLeft = 100;
	objFloating.marginTop = 100;
	objFloating.init();
	objFloating.run();
}




//-->
</script>
</body>
</html>
