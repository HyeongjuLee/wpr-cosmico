<%
	Function AdminMap(ByVal deli)

		PRINTABLE = ""
		PRINTABLE = PRINTABLE & "<div id=""admin_info"" class=""clear"">"
		PRINTABLE = PRINTABLE & "	<div class=""top""></div>"
		PRINTABLE = PRINTABLE & "	<ul>"
		If IsArray(deli) Then
			For m = 0 To UBound(deli)
				PRINTABLE = PRINTABLE & "		<li>"&Trim(deli(m)(1)) &"</li>"
			Next
		End If
		PRINTABLE = PRINTABLE & "	</ul>"
		PRINTABLE = PRINTABLE & "	<div class=""bottom""></div>"
		PRINTABLE = PRINTABLE & "</div>"
		Response.Write PRINTABLE

	End Function


'설정확인
	If PAGE_SETTING <> "" Then
		Select Case INFO_MODE

		Case "DASHBOARD"
			MAP_DEPTH2 = LNG_MYOFFICE_DASHBOARD
			MAP_DEPTH3 = LNG_MYOFFICE_DASHBOARD_01
			arrayLi = Array(_
				Array(True, "회원정보를 수정할 수 있습니다."), _
				Array(True, "수정이 불가능한 항목의 경우에는 본사로 연락주셔야 합니다.")_
			)

'======================================================================================================================
		Case "MENU8-1-10"
			MAP_DEPTH2 = "회원정보수정"
			MAP_DEPTH3 = "회원정보수정"
			arrayLi = Array(_
				Array(True, "회원정보를 수정할 수 있습니다."), _
				Array(True, "수정이 불가능한 항목의 경우에는 본사로 연락주셔야 합니다.")_
			)
'======================================================================================================================
'======================================================================================================================
		Case "MEMBER1-1"
			MAP_DEPTH2 = LNG_MYOFFICE_MEMBER
			MAP_DEPTH3 = LNG_MYOFFICE_MEMBER_01
			arrayLi = Array(_
				Array(True, "본인이 후원한 사람을 볼 수 있습니다."), _
				Array(True, "개인정보보호를 위해 간단한 정보만 열람이 가능합니다.")_
			)
		Case "MEMBER1-2"
			MAP_DEPTH2 = LNG_MYOFFICE_MEMBER
			MAP_DEPTH3 = LNG_MYOFFICE_MEMBER_02
			arrayLi = Array(_
				Array(True, "본인이 추천한 사람을 볼 수 있습니다."), _
				Array(True, "개인정보보호를 위해 간단한 정보만 열람이 가능합니다.")_
			)
		Case "MEMBER1-3"
			MAP_DEPTH2 = LNG_MYOFFICE_MEMBER
			MAP_DEPTH3 = LNG_MYOFFICE_MEMBER_03
			arrayLi = Array(_
				Array(True, "본인이 추천한 직하선 소비자 정보입니다."), _
				Array(True, "개인정보보호를 위해 간단한 정보만 열람이 가능합니다.")_
			)

		Case "MEMBER1-6"
			MAP_DEPTH2 = LNG_MYOFFICE_MEMBER
			MAP_DEPTH3 = LNG_MYOFFICE_MEMBER_06

		Case "MEMBER1-7"
			MAP_DEPTH2 = LNG_MYOFFICE_MEMBER
			MAP_DEPTH3 = LNG_MYOFFICE_MEMBER_07

		Case "MEMBER2-1"
			MAP_DEPTH2 = LNG_MYOFFICE_MEMBER
			'MAP_DEPTH3 = LNG_MYOFFICE_MEMBER_04
			MAP_DEPTH3 = LNG_TEXT_JOIN					'더화이트 : (하선)회원가입
			arrayLi = Array(_
				Array(True, "본인을 추천인으로 하선에 소비자회원을 등록할 수 있습니다.") _
			)
		Case "MEMBER2-2"
			MAP_DEPTH2 = LNG_MYOFFICE_MEMBER
			MAP_DEPTH3 = LNG_MYOFFICE_MEMBER_05
			arrayLi = Array(_
				Array(True, "본인을 추천인으로 다구좌회원을 등록할 수 있습니다.") _
			)
		'하선 구매현황
		Case "MEMBER2-3"
			MAP_DEPTH2 = LNG_MYOFFICE_MEMBER
			MAP_DEPTH3 = LNG_TEXT_CENTER_UNDER_PURCHASE
			arrayLi = Array(_
				Array(True, "센터장 하선의 판매현황을 볼 수 있습니다.") _
			)
		'비번변경
		Case "MEMBER2-4"
			MAP_DEPTH2 = LNG_MYPAGE
			MAP_DEPTH3 = LNG_MYPAGE_01
			arrayLi = Array(_
				Array(True, "회원정보수정") _
			)
		Case "MEMBER2-5"			'"보안비밀번호 변경"
			MAP_DEPTH2 = LNG_MYPAGE
			MAP_DEPTH3 = LNG_MONEY_OUTPUT_PIN_CHANGE
			arrayLi = Array(_
				Array(True, "보안비밀번호 변경") _
			)
		Case "MEMBER2-6"			'"보안비밀번호 초기화"
			MAP_DEPTH2 = LNG_MYPAGE
			MAP_DEPTH3 = LNG_MONEY_OUTPUT_PIN_RESET
			arrayLi = Array(_
				Array(True, "보안비밀번호 초기화") _
			)

		Case "MEMBER2-7"
			MAP_DEPTH2 = "금융정보"
			MAP_DEPTH3 = "계좌관리"
'======================================================================================================================
'======================================================================================================================
		Case "BUY1-1"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = LNG_MYOFFICE_BUY_01
			arrayLi = Array(_
				Array(True, "본인이 구매한 구매내역을 볼 수 있습니다.") _
			)
		Case "BUY1-2"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = LNG_MYOFFICE_BUY_02
			arrayLi = Array(_
				Array(True, "본인이 후원한 회원의 구매정보를 볼 수 있습니다.") _
			)
		Case "BUY1-3"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = LNG_MYOFFICE_BUY_03
			arrayLi = Array(_
				Array(True, "본인이 추천한 회원의 구매정보를 볼 수 있습니다.") _
			)
		Case "BUY1-4"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = LNG_MYOFFICE_BUY_02&"(대수별)"
			arrayLi = Array(_
				Array(True, "본인이 후원한 회원의 대수별 구매정보를 볼 수 있습니다.") _
			)
		Case "BUY1-5"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = LNG_MYOFFICE_BUY_03&"(대수별)"
			arrayLi = Array(_
				Array(True, "본인이 추천한 회원의 대수별 구매정보를 볼 수 있습니다.") _
			)
		Case "BUY1-6"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = LNG_MYOFFICE_BUY_01
			arrayLi = Array(_
				Array(True, "소비자회원 본인이 구매한 구매내역을 볼 수 있습니다.") _
			)
		Case "BUY1-8"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = "가상계좌 발급 입금계좌 리스트"
			arrayLi = Array(_
				Array(True, "가상계좌 신청내역 및 입금계좌를 볼 수 있습니다.") _
			)
		Case "BUY2-1"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = LNG_MYOFFICE_BUY_01&"(Chart)"
			arrayLi = Array(_
				Array(True, "본인이 구매한 구매내역을 볼 수 있습니다.") _
			)
		Case "BUY2-2"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = LNG_MYOFFICE_BUY_01&"(월별-주문)"
			arrayLi = Array(_
				Array(True, "본인의 월별 구매금액을 볼 수 있습니다.") _
			)
		Case "BUY2-3"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = LNG_MYOFFICE_BUY_01&"(월별-결제)"
			arrayLi = Array(_
				Array(True, "본인의 결제방법에 따른 월별 구매금액을 볼 수 있습니다.") _
			)
		Case "BUY3-1"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = "하선 팀매출 내역조회"
			arrayLi = Array(_
				Array(True, "본인의 후원한 회원의 팀매출 내역을 조회할 수 있습니다.") _
			)

		Case "BUY3-2"
			MAP_DEPTH2 = LNG_MYOFFICE_BUY
			MAP_DEPTH3 = "하선 그룹매출 내역조회"
'======================================================================================================================
		Case "ORDER1-1"
			MAP_DEPTH2 = LNG_MYOFFICE_ORDER
			MAP_DEPTH3 = LNG_MYOFFICE_ORDER_03
			arrayLi = Array(_
				Array(True, "상품 결제 페이지 입니다.."), _
				Array(True, "배송자 정보와 구매종류 선택후 결제를 해주세요.") _
			)
		Case "ORDER1-2"
			MAP_DEPTH2 = LNG_MYOFFICE_ORDER
			MAP_DEPTH3 = LNG_MYOFFICE_ORDER_01
			arrayLi = Array(_
				Array(True, "주문이 가능한 상품 목록입니다."), _
				Array(True, "주문하실 상품에 구입버튼을 눌러 수량등을 정하신 후 장바구니에서 구매해주세요.") _
			)
		Case "ORDER1-3"
			MAP_DEPTH2 = LNG_MYOFFICE_ORDER
			MAP_DEPTH3 = LNG_MYOFFICE_ORDER_02
			arrayLi = Array(_
				Array(True, "회원님이 장바구니에 담으신 상품 목록입니다. 구입하실 상품을 체크하신 후 신청하시면 됩니다. ") _
			)
		Case "ORDER1-4"
			MAP_DEPTH2 = LNG_MYOFFICE_ORDER
			MAP_DEPTH3 = LNG_MYOFFICE_ORDER_04
			arrayLi = Array(_
				Array(True, "본인 또는 직하선 소비자의 구매내역을 볼 수 있습니다.") _
			)
	'	Case "ORDER1-4"
	'		MAP_DEPTH2 = LNG_MYOFFICE_ORDER
	'		MAP_DEPTH3 = LNG_MYOFFICE_ORDER_05
	'		arrayLi = Array(_
	'			Array(True, "본인이 구매한 가상계좌 결제 내역을 볼 수 있습니다.") ,_
	'			Array(True, "입금일내에 하단의 은행계좌로 입금하시면 정상 결제처리됩니다.") _
	'		)
		Case "ORDER1-5"
			MAP_DEPTH2 = LNG_MYOFFICE_ORDER
			MAP_DEPTH3 = LNG_MYOFFICE_ORDER_06
			arrayLi = Array(_
				Array(True, "카드 분할결제 내역을 볼 수 있습니다.") _
			)

		Case "ORDER1-6"
			MAP_DEPTH2 = LNG_MYOFFICE_ORDER
			MAP_DEPTH3 = LNG_MYOFFICE_ORDER_01 & "("&LNG_TEXT_UNDER_PURCHASE&")"
			arrayLi = Array(_
				Array(True, "주문이 가능한 상품 목록입니다."), _
				Array(True, "주문하실 상품에 구입버튼을 눌러 수량등을 정하신 후 장바구니에서 구매해주세요.") _
			)
		Case "ORDER1-7"
			MAP_DEPTH2 = LNG_MYOFFICE_ORDER
			MAP_DEPTH3 = LNG_MYOFFICE_ORDER_02
			arrayLi = Array(_
				Array(True, "회원님이 장바구니에 담으신 상품 목록입니다. 구입하실 상품을 체크하신 후 신청하시면 됩니다. ") _
			)

		Case "ORDER2-1"
			MAP_DEPTH2 = LNG_MYOFFICE_ORDER
			MAP_DEPTH3 = LNG_MYOFFICE_ORDER_03&"(직하선 소비자)"
			arrayLi = Array(_
				Array(True, "상품 결제 페이지 입니다.."), _
				Array(True, "배송자 정보와 구매종류 선택후 결제를 해주세요.") _
			)
		Case "ORDER2-2"
			MAP_DEPTH2 = LNG_MYOFFICE_ORDER
			MAP_DEPTH3 = LNG_MYOFFICE_ORDER_01&"(직하선 소비자)"
			arrayLi = Array(_
				Array(True, "주문이 가능한 상품 목록입니다."), _
				Array(True, "주문하실 상품에 구입버튼을 눌러 수량등을 정하신 후 장바구니에서 구매해주세요.") _
			)
		Case "ORDER2-3"
			MAP_DEPTH2 = LNG_MYOFFICE_ORDER
			MAP_DEPTH3 = LNG_MYOFFICE_ORDER_02&"(직하선 소비자)"
			arrayLi = Array(_
				Array(True, "회원님이 직하선구매-장바구니에 담으신 상품 목록입니다. 구입하실 상품을 체크하신 후 신청하시면 됩니다. ") _
			)
'======================================================================================================================
		Case "BONUS1-1"		'NEW
			MAP_DEPTH2 = LNG_MYOFFICE_BONUS
			MAP_DEPTH3 = LNG_MYOFFICE_BONUS_01
			arrayLi = Array(_
				Array(True, "규정에 따른 판매등의 수당을 보실 수 있습니다."), _
				Array(True, "해당 메뉴에서는 일일마감수당에 대한 수당내역을 보실 수 있습니다.") _
			)
		Case "BONUS1-1-1"	'OLD
			MAP_DEPTH2 = LNG_MYOFFICE_BONUS
			MAP_DEPTH3 = LNG_MYOFFICE_BONUS_01
			arrayLi = Array(_
				Array(True, "규정에 따른 판매등의 수당을 보실 수 있습니다."), _
				Array(True, "해당 메뉴에서는 기간마감수당에 대한 수당내역을 보실 수 있습니다.") _
			)
		Case "BONUS1-2"
			MAP_DEPTH2 = LNG_MYOFFICE_BONUS
			MAP_DEPTH3 = LNG_MYOFFICE_BONUS_02
			arrayLi = Array(_
				Array(True, "규정에 따른 판매등의 수당을 보실 수 있습니다."), _
				Array(True, "해당 메뉴에서는 월마감수당 대한 수당내역을 보실 수 있습니다.") _
			)
		Case "BONUS1-3"
			MAP_DEPTH2 = LNG_MYOFFICE_BONUS
			MAP_DEPTH3 = LNG_MYOFFICE_BONUS_03

		Case "BONUS1-4"
			MAP_DEPTH2 = LNG_MYOFFICE_BONUS
			MAP_DEPTH3 = LNG_MYOFFICE_BONUS_04

		Case "BONUS1-5"
			MAP_DEPTH2 = LNG_MYOFFICE_BONUS
			MAP_DEPTH3 = LNG_MYOFFICE_BONUS_05

		Case "BONUS1-10"
			MAP_DEPTH2 = LNG_MYOFFICE_BONUS
			MAP_DEPTH3 = LNG_MYOFFICE_BONUS_07
			arrayLi = Array(_
				Array(True, "규정에 따른 판매등의 수당을 보실 수 있습니다."), _
				Array(True, "해당 메뉴에서는 센터마감에 대한 수당내역을 보실 수 있습니다.") _
			)
		Case "BONUS1-11"
			MAP_DEPTH2 = LNG_MYOFFICE_BONUS
			MAP_DEPTH3 = LNG_MYOFFICE_BONUS_07&"(일반)"
			arrayLi = Array(_
				Array(True, "규정에 따른 판매등의 수당을 보실 수 있습니다."), _
				Array(True, "해당 메뉴에서는 센터마감에 대한 수당내역을 보실 수 있습니다.") _
			)
'======================================================================================================================
'====== 마이오피스 고객센터(공지사항) =================================================================================
		Case "NOTICE1-1"
			MAP_DEPTH2 = LNG_CUSTOMER
			MAP_DEPTH3 = LNG_MYOFFICE_NOTICE
		Case "NOTICE1-2"
			MAP_DEPTH2 = LNG_CUSTOMER
			MAP_DEPTH3 = LNG_CUSTOMER_02
		Case "NOTICE1-3"
			MAP_DEPTH2 = LNG_CUSTOMER
			MAP_DEPTH3 = LNG_CUSTOMER_05
'======================================================================================================================
'======================================================================================================================
		Case "POINT1-0"
			MAP_DEPTH2 = SHOP_POINT	'마일리지(포인트)
			MAP_DEPTH3 = SHOP_POINT&" "&LNG_MYOFFICE_POINT_00
			arrayLi = Array(_
				Array(True, "본인의 "&SHOP_POINT&" 비밀번호 입력/변경을 할 수 있습니다.") _
			)
		Case "POINT1-1"
			MAP_DEPTH2 = SHOP_POINT	'마일리지(포인트)
			MAP_DEPTH3 = SHOP_POINT&" "&LNG_HEADERDATA_CS_POINT_TEXT01_1
			arrayLi = Array(_
				Array(True, "본인의 "&SHOP_POINT&"내역을 확인할 수 있습니다.") _
			)
		Case "POINT1-2"
			MAP_DEPTH2 = SHOP_POINT2	'마일리지(포인트)
			MAP_DEPTH3 = SHOP_POINT2&" "&LNG_HEADERDATA_CS_POINT_TEXT01_1
			arrayLi = Array(_
				Array(True, "본인의 "&SHOP_POINT2&"내역을 확인할 수 있습니다.") _
			)
		Case "POINT1-5"
			MAP_DEPTH2 = SHOP_POINT	'마일리지(포인트)
			MAP_DEPTH3 = SHOP_POINT&" "&LNG_HEADERDATA_CS_POINT_TEXT01_1 & " - A("&LNG_TEXT_POINT_A&")"
			arrayLi = Array(_
				Array(True, "본인의 "&SHOP_POINT&"내역을 확인할 수 있습니다.") _
			)

		Case "POINT1-2"
			MAP_DEPTH2 = SHOP_POINT
			MAP_DEPTH3 = SHOP_POINT&" "&LNG_MYOFFICE_POINT_01
			arrayLi = Array(_
				Array(True, "본인의 "&SHOP_POINT&" 이체내역을 확인할 수 있습니다.") _
			)
		Case "POINT1-3"
			MAP_DEPTH2 = SHOP_POINT
			MAP_DEPTH3 = SHOP_POINT&" "&LNG_MYOFFICE_POINT_02
			arrayLi = Array(_
				Array(True, "본인의 "&SHOP_POINT&"를 타회원에게 이체할 수 있습니다.") _
			)
		Case "POINT1-4"
			MAP_DEPTH2 = SHOP_POINT
			MAP_DEPTH3 = SHOP_POINT&" "&LNG_MYOFFICE_POINT_03
			arrayLi = Array(_
				Array(True, "본인의 "&SHOP_POINT&"를 전환신청할 수 있습니다.") _
			)
		Case "POINT1-6"
			MAP_DEPTH2 = SHOP_POINT
			MAP_DEPTH3 = SHOP_POINT&" "&LNG_MYOFFICE_POINT_04
			arrayLi = Array(_
				Array(True, "본인의 "&SHOP_POINT&"를 pontA로 전환신청할 수 있습니다.") _
			)

'======================================================================================================================
'======================================================================================================================
'====== 마이오피스 조직도   ===========================================================================================
		Case "CHART1-1"
			MAP_DEPTH2 = LNG_MYOFFICE_CHART
			MAP_DEPTH3 = LNG_MYOFFICE_CHART_01
			arrayLi = Array(_
				Array(True, "회원 조직도를 볼 수 있습니다.") _
			)
		Case "CHART1-2"
			MAP_DEPTH2 = LNG_MYOFFICE_CHART
			MAP_DEPTH3 = LNG_MYOFFICE_CHART_09
			arrayLi = Array(_
				Array(True, "블록 조직도를 볼 수 있습니다.") _
			)
'======================================================================================================================
'======================================================================================================================

		Case "BCENTER1-1"
			MAP_DEPTH2 = LNG_MYOFFICE_BCENTER
			MAP_DEPTH3 = LNG_MYOFFICE_BCENTER_01
			arrayLi = Array(_
				Array(True, "센터에 등록된 회원을 보실 수 있습니다.") _
			)

		Case "BCENTER1-2"
			MAP_DEPTH2 = LNG_MYOFFICE_BCENTER
			MAP_DEPTH3 = LNG_MYOFFICE_BCENTER_02
			arrayLi = Array(_
				Array(True, "센터코드로 발생된 매출내역을 보실 수 있습니다.") _
			)
'======================================================================================================================
'======================================================================================================================
'======================================================================================================================

		Case "AUTOSHIP1-1"
			MAP_DEPTH2 = LNG_MYOFFICE_AUTOSHIP
			MAP_DEPTH3 = LNG_MYOFFICE_AUTOSHIP_01
		Case "AUTOSHIP1-2"
			MAP_DEPTH2 = LNG_MYOFFICE_AUTOSHIP
			MAP_DEPTH3 = LNG_MYOFFICE_AUTOSHIP_02
'======================================================================================================================
'======================================================================================================================
'======================================================================================================================




		End Select
	End If
%>
<div id="subTitleM" class="layout_wrap" style="display: none;">
	<%If UCase(Lang) = "KR" Then%>
		<!-- <div class="fright maps_navi" style="padding-top:45px;">
			<span class="first_navi"><%=LNG_HEADER_MYOFFICE%></span><span class="arrow"> ></span>
			<span class="center_navi"><%=MAP_DEPTH2%></span><span class="arrow"> ></span>
			<span class="last_navi" style="color: #e83430;"><%=MAP_DEPTH3%></span>
		</div> -->
	<%End If%>
		<div class="maps_title2"><%=MAP_DEPTH2%></div>

</div>

<%Select Case PAGE_SETTING2 %>
<%Case "MYPAGE", "MY_MEMBER"%>
<%Case Else%>
<script type="text/javascript">
	$(document).ready(function(){
		var subTit = $('#subTitleM .maps_title2').text();
		$('.sub-header-txt .maps_title').text(subTit);
	});
</script>
<%End Select%>




<%
	If PAGE_SETTING <> "" Then
		'If UCase(Lang) = "KR" Then
		'	Call AdminMap(arrayLi)
		'End If
	End If
%>
