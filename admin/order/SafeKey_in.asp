<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "ORDERS"
	INFO_MODE = "ORDERS4-2"


		Function makeOrderNo()
			Dim nowTime : nowTime = Now
			Dim firstDay, startTime
			Dim no1_head, no2_year, no3_dayNum, no4_secondNum, no5_rndNo

			firstDay = Year(nowTime) &"-01-01"
			startTime = FormatDateTime(nowTime, 2) &" 00:00:00"

			Randomize
			rndNo = Int(Rnd * 99+Second(nowTime))

			no1_head = "MT"
			no2_year = Right(Year(nowTime), 2)
			no3_dayNum = Right("00"& (DateDiff("d", firstDay, nowTime)+1), 3)
			no4_secondNum = Right("0000"& DateDiff("s", startTime, nowTime), 5)
			no5_rndNo = Right("0"& rndNo, 2)

			makeOrderNo = no1_head & no2_year & no3_dayNum & no4_secondNum & no5_rndNo
		End Function

	orderNum = makeOrderNo()


%>
<script language="javascript" src="http://plugin.inicis.com/pay40_safekeyin_unissl.js"></script>
<link rel="stylesheet" href="SafeKey.css" />
<script type="text/javascript" src="SafeKey.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript" language="javascript">
	StartSmartUpdate();

	var openwin;

	function pay(frm){
		// MakePayMessage()를 호출함으로써 플러그인이 화면에 나타나며, Hidden Field
		// 에 값들이 채워지게 됩니다. 일반적인 경우, 플러그인은 결제처리를 직접하는 것이
		// 아니라, 중요한 정보를 암호화 하여 Hidden Field의 값들을 채우고 종료하며,
		// 다음 페이지인 INIsecurepay.asp로 데이터가 포스트 되어 결제 처리됨을 유의하시기 바랍니다.

		if(document.ini.clickcontrol.value == "enable"){
			if(document.ini.goodname.value == "")  // 필수항목 체크 (상품명, 상품가격, 구매자명, 구매자 이메일주소, 구매자 전화번호)
			{
				alert("상품명이 빠졌습니다. 필수항목입니다.");
				document.ini.goodname.focus();
				return false;
			}
			else if(document.ini.price.value == ""){
				alert("상품가격이 빠졌습니다. 필수항목입니다.");
				document.ini.price.focus();
				return false;
			}
			else if(document.ini.buyername.value == ""){
				alert("구매자명이 빠졌습니다. 필수항목입니다.");
				document.ini.buyername.focus();
				return false;
			}
			else if(document.ini.buyeremail.value == ""){
				alert("구매자 이메일주소가 빠졌습니다. 필수항목입니다.");
				document.ini.buyeremail.focus();
				return false;
			}
			else if(document.ini.buyertel.value == ""){
				alert("구매자 전화번호가 빠졌습니다. 필수항목입니다.");
				document.ini.buyertel.focus();
				return false;
			}
			else if(document.INIpay == null || document.INIpay.object == null)  // 플러그인 설치유무 체크
			{
				alert("\n이니페이 플러그인 128이 설치되지 않았습니다. \n\n안전한 결제를 위하여 이니페이 플러그인 128의 설치가 필요합니다. \n\n다시 설치하시려면 Ctrl + F5키를 누르시거나 메뉴의 [보기/새로고침]을 선택하여 주십시오.");
				return false;
			}
			else{

				if(MakePayMessage(frm)){
					disable_click();
					openwin = window.open("childwin.html","childwin","width=299,height=149");
					return true;
				}else{
					alert("결제를 취소하셨습니다.");
					return false;
				}
			}
		}
		else{
			return false;
		}
	}

	function enable_click(){
		document.ini.clickcontrol.value = "enable"
	}

	function disable_click(){
		document.ini.clickcontrol.value = "disable"
	}

	function focus_control(){
		if(document.ini.clickcontrol.value == "disable")
		openwin.focus();
	}
			</script>
			<script language="JavaScript" type="text/JavaScript">
<!--
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}
	MM_reloadPage(true);

	function MM_jumpMenu(targ,selObj,restore){ //v3.0
	  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
	  if (restore) selObj.selectedIndex=0;
	}
//-->
</script>

</head>
<body onload="javascript:enable_click()" onFocus="javascript:focus_control()">
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="safekey" class="in">
	<p class="titles">결제 요청</p>
	<p class="caution">상단의 페이지 설명의 주의사항을 반드시 읽고 결제를 진행하세요</p>
	<form name="ini" method="post" action="SafeKey_in_Result.asp" onSubmit="return pay(this)">
	<input type="hidden" name="INIregno" size="40" class="input_text" style="width:150px;" value="" readonly="readonly"/>
	<table <%=tableatt%> class="width100">
		<col width="190" />
		<col width="310" />
		<col width="*" />
		<tr>
			<th>결 제 방 법</th>
			<td>
				<select name="gopaymethod">
					<option value="">[ 결제방법을 선택하세요. ]</option>
					<option value="Card" selected="selected">신용카드 결제</option>
				</select>
			</td>
			<td></td>
		</tr><tr>
			<th>상 품 명</th>
			<td><input type="text" name="goodname" size="20" class="input_text" style="width:220px;" value="" /></td>
			<td><span class="red">(필수값)</span> 20자 이내로 작성</td>
		</tr><tr>
			<th>가 격</th>
			<td><input type="text" name="price" size="20" class="input_text" style="width:150px;" value="" <%=onlyKeys%>/></td>
			<td><span class="red">(필수값)</span> 콤마(,) 표시를 제외한 숫자만 입력</td>
		</tr><tr>
			<th>성 명</th>
			<td><input type="text" name="buyername" size="20" class="input_text" style="width:150px;" value="" /></td>
			<td><span class="red">(필수값)</span> 20자 이내로 작성</td>
		</tr><!-- <tr>
			<th>주 민 번 호</th>
			<td><input type="text" name="INIregno" size="40" class="input_text" style="width:150px;" value="" /></td>
			<td>선택입력 (필요시에만 입력)</td>
		</tr> --><tr>
			<th>전 자 우 편</th>
			<td><input type="text" name="buyeremail" size="20" class="input_text imes" style="width:220px;" value="" /></td>
			<td><span class="red">(필수값)</span> 20자 이내로 작성 </td>
		</tr><tr>
			<th>이 동 전 화</th>
			<td><input type="text" name="buyertel" size="20" class="input_text" style="width:150px;" value="" /></td>
			<td><span class="red">(필수값)</span> 20자 이내로 작성</td>
		</tr><tr>
			<td colspan="3" class="btnArea"><input type="image" src="<%=IMG_BTN%>/btn_cart_pay.gif" /></td>
		</tr>
	</table>



		<!-- 상점아이디. 테스트를 마친 후, 발급받은 아이디로 바꾸어 주십시오. -->
		<input type="hidden" name="mid" value="INIpayTest">
		<!-- <input type="hidden" name="mid" value="dermal0000"> -->
		<!--화폐단위 WON 또는 CENT 주의 : 미화승인은 별도 계약이 필요합니다.-->
		<input type="hidden" name="currency" value="WON">
		<!--
			무이자 할부
			무이자로 할부를 제공 : yes
			무이자할부는 별도 계약이 필요합니다.
			카드사별,할부개월수별 무이자할부 적용은 아래의 카드할부기간을 참조 하십시오.
			무이자할부 옵션 적용은 반드시 매뉴얼을 참조하여 주십시오.
		-->
		<input type="hidden" name="nointerest" value="no">
		<!--
			카드할부기간
			각 카드사별로 지원하는 개월수가 다르므로 유의하시기 바랍니다.

			value의 마지막 부분에 카드사코드와 할부기간을 입력하면 해당 카드사의 해당
			할부개월만 무이자할부로 처리됩니다 (매뉴얼 참조).
		-->
		<input type="hidden" name="quotabase" value="선택:일시불:3개월:4개월:5개월:6개월:7개월:8개월:9개월:10개월:11개월:12개월">
		<!-- 기타설정 -->
		<!--
			SKIN : 플러그인 스킨 칼라 변경 기능 - 6가지 칼라(ORIGINAL, GREEN, ORANGE, BLUE, KAKKI, GRAY)
			HPP : 컨텐츠 또는 실물 결제 여부에 따라 HPP(1)과 HPP(2)중 선택 적용(HPP(1):컨텐츠, HPP(2):실물)
			Card(0): 신용카드 지불시에 이니시스 대표 가맹점인 경우에 필수적으로 세팅 필요 ( 자체 가맹점인 경우에는 카드사의 계약에 따라 설정) - 자세한 내용은 메뉴얼  참조
			OCB : OK CASH BAG 가맹점으로 신용카드 결제시에 OK CASH BAG 적립을 적용하시기 원하시면 "OCB" 세팅 필요 그 외에 경우에는 삭제해야 정상적인 결제 이루어짐

			VBANK() : 무통장입금 서비스 입급예정일자 및 시간 설정. [ 20061018 ]
				 가) 무통장입금 결제수단에서 입금예정일을 고객이 아닌 상점에서 설정할 수 있게 하는 옵션입니다.
					  2005년 4월 10일까지로 제한한 예시입니다.
					  <input type=hidden name=acceptmethod value="...:Vbank(20050410)">

				 나) 무통장입금 결제수단에서 입금예정일자 및 시간까지를 상점에서 설정할수 있게 하는 옵션입니다.
					  2005년 4월 10일 13시 30분 까지로 제한한 시입니다.(분단위까지 설정가능)
					  <input type=hidden name=acceptmethod value="...:Vbank(200504101330)">

				  이에 대한 설정을 하시면 은행에서 수취인 성명조회하는 경우에 해당 기간을 초과한 시점에 입금되는 것을 차단할 수 있습니다.
				  (단, 수취인 성명조회를 통한 입금 처리가능 은행인 경우 이 기능이 유효하며, 또한 은행에서는 수취인 성명조회 단계를 거친 이후
				   입금 처리를 함으로 인해 실제 입금 시간이 입금 예정 기간을 초과하여 입금이 가능할 수 있습니다.)
		-->
		<input type="hidden" name="acceptmethod" value="SKIN(ORIGINAL):HPP(1)">
		<!--
			상점 주문번호 : 무통장입금 예약(가상계좌 이체),전화결재(1588 Bill) 관련 필수필드로 반드시 상점의 주문번호를 페이지에 추가해야 합니다.
			결제수단 중에 실시간 계좌이체 이용 시에는 주문 번호가 결제결과를 조회하는 기준 필드가 됩니다.
			상점 주문번호는 최대 40 BYTE 길이입니다.
		-->
		<input type="hidden" name="oid" size="40" value="<%=orderNum%>">
		<input type="hidden" name="orderNum" size="40" value="<%=orderNum%>">
		<!--
			플러그인 좌측 상단 상점 로고 이미지 사용
			플러그인 좌측 상단에 상점 로고 이미지를 사용하실 수 있으며,
			주석을 풀고 이미지가 있는 URL을 입력하시면 플러그인 상단 부분에 상점 이미지를 삽입할수 있습니다.
		-->
		<!--input type=hidden name=ini_logoimage_url  value="http://[사용할 이미지주소]"-->
		<!--
			좌측 결제메뉴 위치에 이미지 추가
			좌측 결제메뉴 위치에 미미지를 추가하시 위해서는 담당 영업대표에게 사용여부 계약을 하신 후
			주석을 풀고 이미지가 있는 URL을 입력하시면 플러그인 좌측 결제메뉴 부분에 이미지를 삽입할수 있습니다.
		-->
		<!--input type=hidden name=ini_menuarea_url value="http://[사용할 이미지주소]"-->
		<!--
			플러그인에 의해서 값이 채워지거나, 플러그인이 참조하는 필드들
			삭제/수정 불가
		-->
			<input type="hidden" name="quotainterest" value="" />
			<input type="hidden" name="paymethod" value="" />
			<input type="hidden" name="cardcode" value="" />
			<input type="hidden" name="cardquota" value="" />
			<input type="hidden" name="rbankcode" value="" />
			<input type="hidden" name="reqsign" value="DONE" />
			<input type="hidden" name="encrypted" value="" />
			<input type="hidden" name="sessionkey" value="" />
			<input type="hidden" name="uid" value="" />
			<input type="hidden" name="sid" value="" />
			<input type="hidden" name="version" value="4000" />
			<input type="hidden" name="clickcontrol" value="" />
	</form>
</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
