<%
	Function LEFT_MENU_HIGHLIGHT(LEFT_MENU_NUM,LEFT_MENU_LEN,LEFT_MENU_TXT)

		If UCase(LEFT_MENU_NUM) = Left(UCase(INFO_MODE),LEFT_MENU_LEN) Then
			LEFT_MENU_HIGHLIGHT = "<span class=""red"">"&LEFT_MENU_TXT&"</span>"
		Else
			LEFT_MENU_HIGHLIGHT = LEFT_MENU_TXT
		End If

	End Function
	Function LEFT_MENU_HIGHLIGHT2(LEFT_MENU_NUM,LEFT_MENU_TXT)

		If UCase(LEFT_MENU_NUM) = UCase(INFO_MODE) Then
			LEFT_MENU_HIGHLIGHT2 = "<span class=""red"">"&LEFT_MENU_TXT&"</span>"
		Else
			LEFT_MENU_HIGHLIGHT2 = LEFT_MENU_TXT
		End If

	End Function
%>
<div id="left_site_link" class="tcenter width100"> <a href="/index.asp" target="_blank">사이트 바로가기</a></div>
<div id="left_top">
	<div class="width100">
		<p class="left_icon tcenter"></p>
		<p class="left_site tcenter"><%=Split(houUrl,":")(0)%></p>
	</div>
	<ul class="width100">
		<li class="fleft"><a href="/admin/index.asp"><span class="btns color1">첫화면으로</span></a></li>
		<li class="fright"><a href="/common/member_logout.asp"><span class="btns color2">로그아웃</span></a></li>
		<li class="cleft" style="margin-top:7px; width:100%;">
			<select name="ADMIN_LANG" id="ADMIN_LANG" class="width100">
				<%=viewLeftLangOPTION%>
			</select>
			<script>
				$(document).ready(function() {
					$("#ADMIN_LANG").change(function(event) {
						event.preventDefault();
						//alert($(this).val());
						thisVal = $(this).val();
						adminLangChange(thisVal);
					});
				});
				function adminLangChange(thisVal) {
					$.ajax({
						type: "POST"
						,url: "/admin/_inc/adminLang.asp"
						,data: {
							//"ADMIN_LANG"	: $(this).val()
							"ADMIN_LANG"	: thisVal
						}
						,success: function(data) {
							if (data == "OK") {
								location.reload();
							} else {
								alert(data);
							}
						}
						,error:function(data) {
							alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
						}
					});
				}
			</script>
		</li>
	</ul>
	<!-- <div class="width100 timerWrap tcenter">
		로그인 시간 : <span id="timer"></span><a href="javascript:refreshTimer();" class="miniBtn color1">[시간 연장]</a>
	</div> -->
</div>


<%Select Case ADMIN_LEFT_MODE%>
<%	Case "CONFIG"%>
	<div id="lmenu">
		<div>
			<!-- <ul>
				<li class="sub">기본정보 설정</li>
				<li class="ssub"><a href="bank.asp"><%=LEFT_MENU_HIGHLIGHT("CONFIG3-3",9,"회사계좌")%></a></li>
			</ul> -->
			<ul>
				<li class="sub">정책관리 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="policy.asp?type=policy01"><%=LEFT_MENU_HIGHLIGHT2("CONFIG2-1","온라인 이용약관")%></a></li>
				<li class="ssub"><a href="policy.asp?type=policy02"><%=LEFT_MENU_HIGHLIGHT2("CONFIG2-2","개인정보 수집 및 이용")%></a></li>
				<li class="ssub"><a href="policy.asp?type=policy03"><%=LEFT_MENU_HIGHLIGHT2("CONFIG2-3","사업자회원 가입약관")%></a></li>
				<li class="ssub"><a href="policy.asp?type=policy04"><%=LEFT_MENU_HIGHLIGHT2("CONFIG2-4","임의적인 가공 및 재판매 금지서약")%></a></li>
				<li class="ssub"><a href="policy.asp?type=delivery"><%=LEFT_MENU_HIGHLIGHT2("CONFIG2-7","배송정책")%></a></li>
				<!-- <li class="ssub"><a href="policy.asp?type=policy04"><%=LEFT_MENU_HIGHLIGHT2("CONFIG2-4","영업지침")%></a></li>
				<li class="ssub"><a href="policy.asp?type=policy06"><%=LEFT_MENU_HIGHLIGHT2("CONFIG2-6","납세관리인 설정신고")%></a></li>
				<li class="ssub"><a href="policy.asp?type=policy05"><%=LEFT_MENU_HIGHLIGHT2("CONFIG2-5","회원가입 전 확인사항")%></a></li> -->
			</ul>

			<%If DK_MEMBER_LEVEL > 10 And webproIP="T" And UCase(viewAdminLangCode) = "KR" Then %>
			<hr>
			<ul>
				<li class="sub" style="background:#444;">[Wpro] 개인정보 추가수집</li>
				<li class="ssub"><a href="policy.asp?type=policy99"><%=LEFT_MENU_HIGHLIGHT2("CONFIG9-9","개인정보 추가수집")%></a></li>
			</ul>
			<ul>
				<li class="sub" style="background:#444;">[Wpro] PGAYTAG 약관</li>
				<li class="ssub"><a href="policy.asp?type=PAYTAG01"><%=LEFT_MENU_HIGHLIGHT2("CONFIGPTG-1","전자금융거래이용약관")%></a></li>
				<li class="ssub"><a href="policy.asp?type=PAYTAG02"><%=LEFT_MENU_HIGHLIGHT2("CONFIGPTG-2","개인정보취급방침")%></a></li>
				<li class="ssub"><a href="policy.asp?type=PAYTAG03"><%=LEFT_MENU_HIGHLIGHT2("CONFIGPTG-3","서비스이용약관")%></a></li>
			</ul>
			<ul>
				<li class="sub" style="background:#444;">[Wpro] KSNET 약관</li>
				<li class="ssub"><a href="policy.asp?type=KSNET01"><%=LEFT_MENU_HIGHLIGHT2("CONFIGKSNET-1","전자금융거래이용약관")%></a></li>
			</ul>
			<hr>
			<%End If %>

			<!-- <%If DK_MEMBER_ID="webpro"Then%>
			<hr>
			<ul>
				<li class="sub red">제한관리(w-only)</li>
				<li class="ssub"><a href="blockID.asp"><%=LEFT_MENU_HIGHLIGHT("CONFIG3-1",9,"아이디제한 관리")%></a></li>
				<li class="ssub"><a href="blockIP.asp"><%=LEFT_MENU_HIGHLIGHT("CONFIG3-2",9,"아이피제한 관리")%></a></li>
			</ul>
			<%End If%> -->
 			<ul>
				<li class="sub"><!-- 국가별 --> 배송비관리</li>
				<li class="ssub"><a href="DeliveryFee.asp"><%=LEFT_MENU_HIGHLIGHT("CONFIG7-2",9,"<!-- 국가별 --> 배송비관리")%></a></li>
			</ul>
		</div>
	</div>
<%	Case "GOODS"%>
	<div id="lmenu">
		<div>
			<ul>
				<li class="sub">쇼핑카테고리 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="category.asp"><%=LEFT_MENU_HIGHLIGHT2("GOODS1-1","카테고리")%></a></li>
			</ul>
			<ul>
				<li class="sub">상품 등록 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="goods_Regist_CS.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS3-1-"&arrList_L1_intSort,10,"상품등록")%></a></li>
				<!-- <%If isCSGOODUSE = "T" Then '▣CS상품연동여부%>
					<li class="ssub"><a href="goods_Regist_CS.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS3-2",10,"상품 등록(CS연동)")%></a></li>
				<%Else%>
					<li class="ssub"><a href="goods_Regist.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS3-2",10,"상품 등록")%></a></li>
				<%End If%> -->
			</ul>
			<ul>
				<li class="sub">상품 목록 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="goods_list.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS2-1-"&arrList_L1_intSort,10,"상품목록")%></a></li>
			</ul>
			<!-- <ul>
				<li class="sub">카테고리 관리</li>
				<li class="ssub"><a href="category.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS1-1",10,"카테고리 관리")%></a></li>
			</ul> -->
			<!-- <ul>
				<li class="sub">서브이미지</li>
				<li class="ssub"><a href="2_menu_top_img.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS4-1",10,"기본 카테고리 이미지")%></a></li>
			</ul> -->
			<!-- <ul>
				<li class="sub">자체 상품관리</li>
				<li class="ssub"><a href="goods_list.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS3-1",10,"상품 목록")%></a></li>
				<%If isCSGOODUSE = "T" Then '▣CS상품연동여부%>
					<li class="ssub"><a href="goods_Regist_CS.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS3-2",10,"상품 등록(CS연동)")%></a></li>
				<%Else%>
					<li class="ssub"><a href="goods_Regist.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS3-2",10,"상품 등록")%></a></li>
				<%End If%>
				<li class="ssub"><a href="deliveryFee_Manage.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS3-5",10,"택배비 관리")%></a></li>
			</ul> -->
			<!-- <ul>
				<li class="sub">벤더 상품관리</li>
				<li class="ssub"><a href="Vendor_Goods_List_F.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS5-2",10,"승인대기 상품목록")%></a></li>
				<li class="ssub"><a href="Vendor_Goods_List_T.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS5-1",10,"승인된 상품목록")%></a></li>
				<li class="ssub"><a href="Vendor_Goods_List_P.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS5-3",10,"재승인대기 상품목록")%></a></li>
				<li class="ssub"><a href="Vendor_Goods_List_R.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS5-4",10,"승인반려 상품목록")%></a></li>
				<li class="ssub"><a href="Vendor_Goods_List_A.asp"><%=LEFT_MENU_HIGHLIGHT("GOODS5-5",10,"승인반려 재승인대기<br /> 상품목록")%></a></li>
			</ul> -->
		</div>
	</div>
<%	Case "MEMBER"%>
	<div id="lmenu">
		<div>
			<ul>
				<li class="sub">회원관리 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="member_list.asp"><%=LEFT_MENU_HIGHLIGHT("MEMBER1-1",9,"회원리스트")%></a></li>
				<!-- <li class="ssub"><a href="member_list443.asp"><%=LEFT_MENU_HIGHLIGHT("MEMBER1-2",9,"탈퇴요청회원")%></a></li>
				<li class="ssub"><a href="member_list444.asp"><%=LEFT_MENU_HIGHLIGHT("MEMBER1-3",9,"탈퇴승인회원")%></a></li> -->
				<!-- <li class="ssub"><a href="member_list445.asp"><%=LEFT_MENU_HIGHLIGHT("MEMBER1-4",9,"강제탈퇴회원")%></a></li> -->
			</ul>
			<%If webproIP="T" and 1=2 Then%>
			<ul>
				<li class="sub" style="background: #000;">메세지 관리(w-pro only)</li>
				<li class="ssub"><a href="sms_list.asp?cate=join"><%=LEFT_MENU_HIGHLIGHT("MEMBER1-5",9,"회원가입 메세지(알림톡)")%></a></li>
				<li class="ssub"><a href="sms_list.asp?cate=order"><%=LEFT_MENU_HIGHLIGHT("MEMBER1-7",9,"상품주문 메세지(알림톡)")%></a></li>
				<hr>
				<li class="ssub"><a href="sms_list.asp?cate=join2"><%=LEFT_MENU_HIGHLIGHT("MEMBER1-8",9,"회원가입 메세지(이메일)")%></a></li>
				<%If 1=2 Then%>
				<li class="ssub"><a href="/admin/member/sms_list.asp?cate=spwd"><%=LEFT_MENU_HIGHLIGHT("MEMBER1-9",9,"보안비번 초기화 메세지")%></a></li>
				<%End If%>
			</ul>
			<%End If%>
			<!-- <ul>
				<li class="sub">CS회원관리 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="base_voter.asp"><%=LEFT_MENU_HIGHLIGHT("MEMBER3-2",9,"기본추천인등록")%></a></li>
			</ul> -->
		</div>
	</div>
<%	Case "ORDERS"%>
	<div id="lmenu">
		<div>
		<%If isMACCO = "T" Then%>
			<ul>
				<li class="sub">주문관리(직판) : <%=viewAdminLang%></li>
				<li class="ssub"><a href="order_list_MACCO.asp"><%=LEFT_MENU_HIGHLIGHT("ORDERSALL",9,"전체주문리스트")%></a></li>
				<li class="ssub"><a href="order_list_MACCO.asp?menu=100"><%=LEFT_MENU_HIGHLIGHT("ORDERS1-0",9,"신규주문(입금확인전)")%></a></li>
				<li class="ssub"><a href="order_list_MACCO.asp?menu=101"><%=LEFT_MENU_HIGHLIGHT("ORDERS1-1",9,"입금확인(배송준비중)")%></a></li>
				<li class="ssub"><a href="order_list_MACCO.asp?menu=102"><%=LEFT_MENU_HIGHLIGHT("ORDERS1-2",9,"배송완료(배송 중)")%></a></li>
				<li class="ssub"><a href="order_list_MACCO.asp?menu=103"><%=LEFT_MENU_HIGHLIGHT("ORDERS1-3",9,"구매확정(수취확인)")%></a></li>
			</ul>
			<ul>
				<li class="sub">취소주문(직판) : <%=viewAdminLang%></li>
				<li class="ssub"><a href="order_list_MACCO.asp?menu=201"><%=LEFT_MENU_HIGHLIGHT("ORDERS2-1",9,"관리자주문취소")%></a></li>
				<li class="ssub"><a href="order_list_MACCO.asp?menu=301"><%=LEFT_MENU_HIGHLIGHT("ORDERS3-1",9,"주문취소요청")%></a></li>
				<li class="ssub"><a href="order_list_MACCO.asp?menu=302"><%=LEFT_MENU_HIGHLIGHT("ORDERS3-2",9,"주문취소완료")%></a></li>
			</ul>
		<%Else%>
			<ul>
				<li class="sub">주문관리 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="order_list.asp"><%=LEFT_MENU_HIGHLIGHT("ORDERSALL",11,"전체주문리스트")%></a></li>
				<li class="ssub"><a href="order_list.asp?menu=100"><%=LEFT_MENU_HIGHLIGHT("ORDERS1-0",11,"신규주문(입금확인전)")%></a></li>
				<li class="ssub"><a href="order_list.asp?menu=101"><%=LEFT_MENU_HIGHLIGHT("ORDERS1-1",11,"입금확인(배송준비중)")%></a></li>
				<li class="ssub"><a href="order_list.asp?menu=102"><%=LEFT_MENU_HIGHLIGHT("ORDERS1-2",11,"배송완료(배송 중)")%></a></li>
				<li class="ssub"><a href="order_list.asp?menu=103"><%=LEFT_MENU_HIGHLIGHT("ORDERS1-3",11,"구매확정(수취확인)")%></a></li>
			</ul>
			<ul>
				<li class="sub">취소주문 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="order_list.asp?menu=201"><%=LEFT_MENU_HIGHLIGHT("ORDERS2-1",11,"관리자주문취소")%></a></li>
				<li class="ssub"><a href="order_list.asp?menu=301"><%=LEFT_MENU_HIGHLIGHT("ORDERS3-1",11,"주문취소요청")%></a></li>
				<li class="ssub"><a href="order_list.asp?menu=302"><%=LEFT_MENU_HIGHLIGHT("ORDERS3-2",11,"주문취소완료")%></a></li>
			</ul>
			<!-- <ul>
				<li class="sub">결제관리</li>
				<li class="ssub"><a href="SafeKey_list.asp"><%=LEFT_MENU_HIGHLIGHT("ORDERS4-1",9,"수동결제목록")%></a></li>
				<li class="ssub"><a href="SafeKey_in.asp"><%=LEFT_MENU_HIGHLIGHT("ORDERS4-2",9,"수동결제")%></a></li>
			</ul> -->
		<%End If%>
		</div>
	</div>
<%	Case "DESIGN"%>
	<div id="lmenu">
		<ul>
			<li class="sub">PC 홈페이지 : <%=viewAdminLang%></li>
			<li class="ssub"><a href="shop_design_banner.asp?area=n01_a01"><%=LEFT_MENU_HIGHLIGHT("DESIGN_N01_A01",16,"인덱스 메인 배너")%></a></li>
			<li class="ssub"><a href="shop_design_banner.asp?area=n02_a01"><%=LEFT_MENU_HIGHLIGHT("DESIGN_N02_A01",16,"인덱스 new product 배너")%></a></li>
			<!-- <li class="ssub"><a href="shop_design_banner.asp?area=n03_a01"><%=LEFT_MENU_HIGHLIGHT("DESIGN_N03_A01",16,"인덱스 서브 배너")%></a></li> -->
		</ul>
		<ul>
			<li class="sub">모바일 : <%=viewAdminLang%></li>
			<li class="ssub"><a href="shop_design_banner.asp?area=m01_a01"><%=LEFT_MENU_HIGHLIGHT("DESIGN_M01_A01",16,"[모바일] 인덱스 롤링 배너")%></a></li>
			<!-- <li class="ssub"><a href="shop_design_banner.asp?area=m02_a01"><%=LEFT_MENU_HIGHLIGHT("DESIGN_M02_A01",16,"[모바일] 배너 #1")%></a></li> -->
			<!-- <li class="ssub"><a href="shop_design_banner.asp?area=m02_a02"><%=LEFT_MENU_HIGHLIGHT("DESIGN_M02_A02",16,"[모바일] 배너 #2")%></a></li>
			<li class="ssub"><a href="shop_design_banner.asp?area=m02_a03"><%=LEFT_MENU_HIGHLIGHT("DESIGN_M02_A03",16,"[모바일] 배너 #3")%></a></li> -->
		</ul>
		<%If 1=2 Then%>
		<ul>
			<li class="sub">PC 쇼핑몰 :  <%=viewAdminLang%></li>
			<li class="ssub"><a href="shop_design_banner.asp?area=s01_a01"><%=LEFT_MENU_HIGHLIGHT("DESIGN_S01_A01",16,"인덱스 롤링 배너")%></a></li>
			<li class="ssub"><a href="shop_design_banner.asp?area=s02_a01"><%=LEFT_MENU_HIGHLIGHT("DESIGN_S02_A01",16,"인덱스 배너 #1")%></a></li>
			<li class="ssub"><a href="shop_design_banner.asp?area=s02_a02"><%=LEFT_MENU_HIGHLIGHT("DESIGN_S02_A02",16,"인덱스 배너 #2")%></a></li>
			<li class="ssub"><a href="shop_design_banner.asp?area=s02_a03"><%=LEFT_MENU_HIGHLIGHT("DESIGN_S02_A03",16,"인덱스 배너 #3")%></a></li>
			<li class="ssub"><a href="shop_design_banner.asp?area=s02_a04"><%=LEFT_MENU_HIGHLIGHT("DESIGN_S02_A04",16,"인덱스 배너 #4")%></a></li>
		</ul>
		<%End If%>
		<!-- <ul>
			<li class="sub">배너관리</li>
			<li class="ssub"><a href="rolling_banner.asp"><%=LEFT_MENU_HIGHLIGHT("DESIGN1-9",9,"롤링배너 영역")%></a></li>
		</ul>	-->
	</div>

<%	Case "VENDOR"%>
	<div id="lmenu">
		<div>
			<ul>
				<li class="sub">판매처 관리</li>
				<li class="ssub"><a href="vendor_list.asp"><%=LEFT_MENU_HIGHLIGHT("VENDOR1-1",9,"판매처 목록")%></a></li>
				<li class="ssub"><a href="vendor_regist.asp"><%=LEFT_MENU_HIGHLIGHT("VENDOR1-2",9,"판매처 등록")%></a></li>
			</ul>
			<ul>
				<li class="sub">정산 관리</li>
				<li class="ssub"><a href="calc_list.asp"><%=LEFT_MENU_HIGHLIGHT("VENDOR2-1",9,"판매 전체목록")%></a></li>
			</ul>
		</div>
	</div>
<%	Case "MANAGE"%>
	<div id="lmenu">
		<div>
			<ul>
				<li class="sub">1:1문의 관리 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="/admin/manage/1on1_category.asp"><%=LEFT_MENU_HIGHLIGHT2("MANAGE8-1","1:1문의 카테고리")%></a></li>
				<li class="ssub"><a href="/admin/manage/1on1_list.asp"><%=LEFT_MENU_HIGHLIGHT2("MANAGE8-2","1:1문의 관리")%></a></li>
			</ul>
			<ul>
				<li class="sub">FAQ관리 : <%=viewAdminLang%></li>
				<%If DK_MEMBER_LEVEL > 10 Then%>
					<li class="ssub"><a href="/admin/manage/faq_config.asp"><%=LEFT_MENU_HIGHLIGHT2("MANAGE1-4","[W] FAQ 설정")%></a></li>
				<%End If%>
				<li class="ssub"><a href="/admin/manage/faq_category.asp"><%=LEFT_MENU_HIGHLIGHT2("MANAGE1-1","FAQ 카테고리")%></a></li>
				<li class="ssub"><a href="/admin/manage/faq_list.asp"><%=LEFT_MENU_HIGHLIGHT2("MANAGE1-2","FAQ 리스트")%></a></li>
				<li class="ssub"><a href="/admin/manage/faq_regist.asp"><%=LEFT_MENU_HIGHLIGHT2("MANAGE1-3","FAQ 작성")%></a></li>
			</ul>
			<!-- <ul>
				<li class="sub">자료실 FAQ 관리</li>
				<li class="ssub"><a href="/admin/manage/faq2_category.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE2-1",9,"FAQ 카테고리관리")%></a></li>
				<li class="ssub"><a href="/admin/manage/faq2_list.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE2-2",9,"FAQ 리스트")%></a></li>
				<li class="ssub"><a href="/admin/manage/faq2_regist.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE2-3",9,"FAQ 작성")%></a></li>
			</ul> -->
			<!-- <ul>
				<li class="sub">1:1 상담관리</li>
				<li class="ssub"><a href="/admin/manage/counsel_list.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE3-1",9,"1:1 상담관리")%></a></li>
			</ul> -->
			<!-- <ul>
				<li class="sub">지사 관리</li>
				<li class="ssub"><a href="/admin/manage/branch_list.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE4-1",9,"지사 목록")%></a></li>
				<li class="ssub"><a href="/admin/manage/branch_Regist.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE4-5",9,"지사 입력")%></a></li>
				<li class="ssub"><a href="/admin/manage/branch2_list.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE5-1",9,"로드샵 목록")%></a></li>
				<li class="ssub"><a href="/admin/manage/branch2_Regist.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE5-5",9,"로드샵 입력")%></a></li>
			</ul> -->
			<!-- <ul>
				<li class="sub">배너관리</li>
				<li class="ssub"><a href="banner_list.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE7-1",9,"파트너 배너관리")%></a></li>
			</ul> -->
			<!-- <ul>
				<li class="sub">클라우드 태그 관리</li>
				<li class="ssub"><a href="cloudTag.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE7-1",9,"클라우드 태그 관리")%></a></li>
			</ul> -->

			<%'Popup Global%>
			<ul>
				<li class="sub">POPUP 관리 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="popup.asp?mb=F"><%=LEFT_MENU_HIGHLIGHT("MANAGE6-1",11,"팝업관리")%></a></li>
			</ul>
			<ul>
				<li class="sub">모바일 POPUP 관리 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="popup.asp?mb=T"><%=LEFT_MENU_HIGHLIGHT("MANAGE6-2",11,"모바일팝업관리")%></a></li>
			</ul>
				<%If 1=2 Then%>
				<ul>
					<li class="sub">메세지 관리</li>
					<li class="ssub"><a href="/admin/manage/mmsStat.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE9-1",9,"메세지 기본정보")%></a></li>
					<li class="ssub"><a href="/admin/manage/mmsResult_sms.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE9-2",9,"전체 SMS 전송내역")%></a></li>
					<li class="ssub"><a href="/admin/manage/mmsResult_lms.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE9-3",9,"전체 LMS 전송내역")%></a></li>
					<li class="ssub"><a href="/admin/manage/mmsResult_mms.asp"><%=LEFT_MENU_HIGHLIGHT("MANAGE9-4",9,"전체 MMS 전송내역")%></a></li>
				</ul>
				<%End If%>
			</div>
		</div>


<%	Case "MYOFFICE"%>
	<div id="lmenu">
		<div>
			<!-- <ul>
				<li class="sub">일정관리</li>
				<li class="ssub"><a href="/admin/myoffice/schedule.asp"><%=LEFT_MENU_HIGHLIGHT("MYOFFICE1-1",11,"일정관리")%></a></li>
		</ul> -->
			<!-- <ul>
				<li class="sub">게시판(out)</li>
				<li class="ssub"><a href="/admin/myoffice/board_list.asp?bname=pds"><%=LEFT_MENU_HIGHLIGHT("MYOFFICE3-1",11,"자료실 목록")%></a></li>
				<li class="ssub"><a href="/admin/myoffice/board_write.asp?bname=pds"><%=LEFT_MENU_HIGHLIGHT("MYOFFICE3-2",11,"자료실 작성")%></a></li>
				<li class="ssub"><a href="/admin/myoffice/board_list.asp?bname=notice"><%=LEFT_MENU_HIGHLIGHT("MYOFFICE2-1",11,"공지사항 목록")%></a></li>
				<li class="ssub"><a href="/admin/myoffice/board_write.asp?bname=notice"><%=LEFT_MENU_HIGHLIGHT("MYOFFICE2-2",11,"공지사항 작성")%></a></li>
				<li class="ssub"><a href="/admin/cboard/board_list.asp?bname=vipqna"><%=LEFT_MENU_HIGHLIGHT("MYOFFICE4-1",11,"VIP Q&A 관리")%></a></li>
			</ul> -->
			<!-- <ul>
				<li class="sub">팝업 관리</li>
				<li class="ssub"><a href="popup.asp">팝업관리</a></li>
			</ul> -->
		</div>
	</div>

<%	Case "CBOARD"%>
	<div id="lmenu">
		<div>
			<ul>
				<%If 1=2 Then%>
				<%End If%>
				<li class="sub">게시판 : <%=viewAdminLang%></li>
				<li class="ssub"><a href="/cboard/board_list.asp?bname=notice"><%=LEFT_MENU_HIGHLIGHT("CBOARD1-1",11,LNG_CUSTOMER_01)%></a></a></li>
				<li class="ssub"><a href="/cboard/board_list.asp?bname=pds"><%=LEFT_MENU_HIGHLIGHT("CBOARD1-2",11,LNG_CUSTOMER_05)%></a></a></li>
				<hr>
				<li class="ssub"><a href="/cboard/board_list.asp?bname=myoffice"><%=LEFT_MENU_HIGHLIGHT("CBOARD2-1",11,"마이오피스 "&LNG_CUSTOMER_01)%></a></a></li>
			</ul>
		</div>
	</div>

<%	Case "WEBPRO"%>
	<div id="lmenu">
		<div>
			<!-- <ul>
				<li class="sub">메인 사이트 메뉴관리</li>
				<li class="ssub"><a href="menuColor.asp">메뉴색상관리</a></li>
				<li class="ssub"><a href="menuSettingTop.asp">탑메뉴기본설정</a></li>
				<li class="ssub"><a href="menuSettingLeft.asp">좌측메뉴기본설정</a></li>
				<li class="ssub"><a href="menulist.asp">메뉴관리</a></li>
			</ul> -->
			<!-- <ul>
				<li class="sub">메뉴관리</li>
				<li class="ssub"><a href="menuColor.asp">메뉴색상관리</a></li>
				<li class="ssub"><a href="menulist.asp">메뉴관리</a></li>
			</ul>
			<ul>
				<li class="sub">상품관리</li>
				<li class="ssub"><a href="goodsList2.asp">상품목록</a></li>
				<li class="ssub"><a href="goodsRegist2.asp">상품등록</a></li>
			</ul> -->
			<ul>
				<li class="sub">게시판 관리</li>
				<li class="ssub"><a href="forumList.asp">게시판리스트</a></li>
				<li class="ssub"><a href="forum_Regist.asp">게시판생성</a></li>
			</ul>

			<%If 1=2 Then%>
			<ul>
				<li class="sub">방문판매법관련 관리</li>
				<li class="ssub"><a href="pyramid_regist.asp">등록</a></li>
				<li class="ssub"><a href="pyramid.asp?cate=5">sid규정 및 활동법규</a></li>
				<li class="ssub"><a href="pyramid.asp?cate=1">법률</a></li>
				<li class="ssub"><a href="pyramid.asp?cate=2">법률 시행령</a></li>
				<li class="ssub"><a href="pyramid.asp?cate=3">법률 시행규칙</a></li>
				<li class="ssub"><a href="pyramid.asp?cate=4">고시</a></li>
			</ul>
			<%End If%>
		</div>
	</div>
<%End Select%>
