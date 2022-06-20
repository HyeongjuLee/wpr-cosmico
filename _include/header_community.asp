<%
	If webproIP <> "T" Then
		Call ALERTS("준비중입니다.\n\nSorry! Under Construction!","go","/index.asp")
	End If
%>
<%
	TOP_BTN_LINE			= "<li class=""top_btn_line tcenter""></li>" & VbCrLf
	TOP_BTN_HOME			= "<li><a href=""/index.asp"">"&LNG_HEADER_HOME&"</a></li>" & VbCrLf
	TOP_BTN_LOGIN			= "<li><a href=""/common/member_login.asp"">"&LNG_HEADER_LOGIN&"</a></li>" & VbCrLf
	TOP_BTN_LOGOUT			= "<li><a href=""/common/member_logout.asp"">"&LNG_TEXT_LOGOUT&"</a></li>" & VbCrLf
	TOP_BTN_JOIN			= TOP_BTN_LINE & "<li><a href=""/common/joinStep01.asp"">"&LNG_HEADER_JOIN&"</a></li>" & VbCrLf
	TOP_BTN_SEARCH_IDPW		= TOP_BTN_LINE & "<li><a href=""/common/member_idpw.asp"">"&LNG_HEADER_SEARCH_IDPW&"</a></li>" & VbCrLf
	TOP_BTN_DELIVERY		= TOP_BTN_LINE & "<li><a href=""/mypage/order_List.asp"">"&LNG_HEADER_DELIVERY&"</a></li>" & VbCrLf
	LNG_HEADER_CSORDER		= TOP_BTN_LINE & "<li><a href=""/myoffice/buy/order_list.asp"">"&LNG_HEADER_CSORDER&"</a></li>" & VbCrLf
	TOP_BTN_MYPAGE			= TOP_BTN_LINE & "<li><a href=""/mypage/member_info.asp"">"&LNG_HEADER_MYPAGE&"</a></li>" & VbCrLf
	TOP_BTN_ADMIN			= TOP_BTN_LINE & "<li><a href=""/admin"" class=""admin"">"&LNG_HEADER_ADMIN&"</a></li>" & VbCrLf
	TOP_BTN_ADMIN2			= TOP_BTN_LINE & "<li><a href=""/seller_admin"" style=""color:#b79878"">"&LNG_HEADER_ADMIN2&"</a></li>" & VbCrLf
	TOP_BTN_CSCENTER		= TOP_BTN_LINE & "<li><a href=""/cboard/board_list.asp?bname=notice"">"&LNG_HEADER_CSCENTER2&"</a></li>" & VbCrLf
	TOP_BTN_NOTICE			= TOP_BTN_LINE & "<li><a href=""/cboard/board_list.asp?bname=notice"">"&LNG_HEADER_NOTICE&"</a></li>" & VbCrLf
	TOP_BTN_CART			= TOP_BTN_LINE & "<li><a href=""/shop/cart.asp"">"&LNG_HEADER_CART&"</a></li>" & VbCrLf
	TOP_BTN_MYOFFICE		= TOP_BTN_LINE & "<li><a href=""/myoffice/buy/order_list.asp"">"&LNG_HEADER_MYOFFICE&"</a></li>" & VbCrLf
	TOP_BTN_MYOFFICE_ADMIN	= TOP_BTN_LINE & "<li><a href=""/cboard/board_list.asp?bname=myoffice"">"&LNG_HEADER_MYOFFICE&"</a></li>" & VbCrLf
	TOP_BTN_SHOP			= TOP_BTN_LINE & "<li><a href=""/shop"">"&LNG_SHOP_HEADER_TXT_01&"</a></li>" & VbCrLf

	Select Case DK_MEMBER_TYPE
		Case "MEMBER"
			TOP_BTN_SET = TOP_BTN_LOGOUT & TOP_BTN_MYOFFICE & TOP_BTN_DELIVERY & TOP_BTN_MYPAGE & TOP_BTN_CSCENTER
		Case "ADMIN","OPERATOR"
			TOP_BTN_SET = TOP_BTN_LOGOUT & TOP_BTN_ADMIN & TOP_BTN_MYOFFICE_ADMIN & TOP_BTN_DELIVERY & TOP_BTN_MYPAGE & TOP_BTN_CSCENTER
		Case "SELLER"
			TOP_BTN_SET = TOP_BTN_LOGOUT & TOP_BTN_ADMIN2 & TOP_BTN_MYOFFICE & TOP_BTN_DELIVERY & TOP_BTN_MYPAGE & TOP_BTN_CSCENTER
		Case "COMPANY"
			If DK_MEMBER_STYPE = "0" Then
			TOP_BTN_SET = TOP_BTN_LOGOUT & TOP_BTN_MYOFFICE & TOP_BTN_DELIVERY & TOP_BTN_MYPAGE & TOP_BTN_CSCENTER
			Else
			TOP_BTN_SET = TOP_BTN_LOGOUT & TOP_BTN_MYOFFICE & TOP_BTN_DELIVERY & TOP_BTN_MYPAGE & TOP_BTN_CSCENTER
			End If
		Case "GUEST"
			TOP_BTN_SET = TOP_BTN_MYOFFICE & TOP_BTN_DELIVERY & TOP_BTN_MYPAGE & TOP_BTN_CSCENTER & TOP_BTN_JOIN
	End Select
%>
<script type="text/javascript">


	//Top 레이어팝업
	$(document).ready(function(){
		if( $('#topPopup').is(":hidden")) {
			var cookie_topPopup = getcookietopPopup('topPopup');
			//alert(cookie_topPopup);
			if(cookie_topPopup =='no'){

			}else {
				$("#topPopupArea").slideToggle(0);
			}
		}
	});
	function closeTopPopup(fs){
		if(	$("#topPopup").prop("checked") == true) {
			setCookie(fs, 'no' , 1);
		}else {
		}
		$("#topPopupArea").slideToggle(300);
		//$('#topPopupArea').css({"display":"none"});
	}
	function getcookietopPopup(c_name) {
		var i,x,y,ARRcookies=document.cookie.split(";");
		for (i=0;i<ARRcookies.length;i++) {
			x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
			y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
			x=x.replace(/^\s+|\s+$/g,"");
			if (x==c_name)		{
				return unescape(y);
			}
		}
	}
	//쿠키지우기
    function delPopupCookie(fs){
		deleteCookie(fs);
    }

</script>
<div id="all">
	<%
		'Top 레이어팝업
		SQL = "SELECT TOP(1) * FROM [DK_POPUP] WITH(NOLOCK) WHERE [popKind] = 'T' AND [useTF] = 'T' AND [isViewCom] = 'T' AND [strNation] = '"&Lang&"' ORDER BY [intIDX] DESC "
		Set DKRS = Db.execRs(SQL,DB_TEXT,Nothing,Nothing)
		If Not DKRS.BOF And Not DKRS.EOF Then
			popTitle	 = DKRS("popTitle")
			linkType	 = DKRS("linkType")
			linkUrl		 = DKRS("linkUrl")
			strScontent	 = DKRS("strScontent")
		Else
			popTitle	 = ""
		End If
		Call CloseRS(DKRS)

		Select Case linkType
			Case "S" : targets = " target=""_self"""
			Case "B" : targets = " target=""_blank"""
		End Select
	%>
	<%
		'Top Menu Targeting
		Function Fnc_TopMenu_ON(valThisPage, valThisPage2)
			If valThisPage = valThisPage2 Then
				Fnc_TopMenu_ON = "class=""on"""
			Else
				Fnc_TopMenu_ON = ""
			End If
		End Function
	%>
	<script type="text/javascript">
		<%If TOP_WRAP_FIX <> "F" Then%>
		//top_wrap 고정
		$( document ).ready( function() {
			var jbOffset = $( '#top_wrap' ).offset();
			var tmenu = $( '#top_menu' ).offset().top;
			var	scrolled = false;

			$( window ).scroll( function() {
				if ($( document ).scrollTop() > 5 && !scrolled) {
					$( '#top_wrap #wrap' ).addClass( 'jbFixed' );
					scrolled = true;
				}
				if ($( document ).scrollTop() < 46 && scrolled) {
					$( '#top_wrap #wrap' ).removeClass( 'jbFixed' );
					scrolled = false;
				}
			});
		});
		<%End If%>
	</script>

	<div id="top_wrap" class="layout_wrap" >
		<i class="wrap_line"></i>
		<div id="wrap">
			<div id="top" class="layout_inner">
				<div id="top_logo"><a href="/index.asp"><img src="/images/share/top_logo.png" alt="" /></a></div>
				<div class="top_search">
					<form name="tsearch" id="tsearch" action="/shop/category.asp" method="post" onsubmit="return searchfrmChk(this)">
						<input type="hidden" name="tSEARCHTERM" value="GoodsName" class="">
						<div class="searchBar">
							<input type="text" name="tSEARCHSTR" value="" class="input_search" title="검색어 입력" placeholder="<%=LNG_SHOP_HEADER_TXT_04%>">
							<button type="submit" title="" class="btn_search"></button>
						</div>
					</form>
				</div>
				<div id="top_btn">
					<div class="img"></div>
					<div class="txt">
						<%Select Case DK_MEMBER_TYPE%>
						<%Case "GUEST" %>
						<div class="guest">
							<a href="/common/member_login.asp">
								<p>안녕하세요.</p>
								<p><span>로그인<i></i></span>이 필요합니다.</p>
							</a>
						</div>
						<%Case Else%>
						<div class="member">
							<p><%=DK_MEMBER_NAME%>님,</p>
							<p>환영합니다.</p>
						</div>
						<%End Select%>
					</div>
					<i class="off"></i>
					<i class="on"></i>
					<div class="top_btn_list">
						<ul>
							<%=TOP_BTN_SET%>
						</ul>
					</div>
				</div>
				<table id="top_menu">
					<tr>
						<td><a href="#;"><%=LNG_COMMUNITY_01%></a></td>
						<td><a href="#;"><%=LNG_COMMUNITY_02%></a></td>
						<td><a href="#;"><%=LNG_COMMUNITY_03%></a></td>
						<td><a href="#;"><%=LNG_COMMUNITY_04%></a></td>
						<td><a href="/cboard/board_list.asp?bname=humor"><%=LNG_COMMUNITY_05%></a></td>
						<td><a href="#;"><%=LNG_COMMUNITY_06%></a></td>
						<td><a href="#;"><%=LNG_COMMUNITY_07%></a></td>
						<td><a href="#;"><%=LNG_COMMUNITY_08%></a></td>
						<td><a href="#;"><%=LNG_COMMUNITY_09%></a></td>
						<td><a href="#;"><%=LNG_COMMUNITY_10%></a></td>
						<td><a href="#;"><%=LNG_COMMUNITY_11%></a></td>
					</tr>
				</table>
				<div class="sub_bg"><i></i></div>
			</div>

			<script type="text/javascript">

				$(document).ready(function() {

					// .sub_menu 중 가장 높은 높이값과 전체 높이값 동일하게 조절
					var maxHeight = -1;
					var	wrap	= $('#top_wrap');
					var	tmenu	= $('#top_menu');
					var	smenu	= $('#top_wrap .sub_menu');
					var	bg		= $('#top_wrap .sub_bg');
					var	bgi		= $('#top_wrap .sub_bg i');

					smenu.each(function() {
						maxHeight = maxHeight > $(this).height() ? maxHeight : $(this).height();
					});

					//hover시 smenu보임

					// tmenu.hover(function(){
					// 	if(smenu.is(':visible')){
					// 		smenu.slideUp(100);
					// 		bg.slideUp(100);
					// 		bgi.slideUp(100);
					// 	}else{
					// 		smenu.css('height',maxHeight+'px');
					// 		bg.css('height',maxHeight+55+'px');
					// 		smenu.slideDown(100);
					// 		bg.slideDown(100);
					// 		bgi.slideDown(100);
					// 	}
					// });

					// var spanTxt = $('.sub_menu li a span');

					// $('.sub_menu li').each(function(){
					// 	var index = $('.sub_menu li').index(this); // .sub_menu li 순서
					// 	var spanH = $('.sub_menu li:eq('+index+')').find('span').text(); //각 li 아래 span의 텍스트값
					// 	var indexOf = spanH.lastIndexOf(' '); //span의 텍스트값에서 가장 마지막에 위치한 공백

					// 	if (spanH.length > 20) { //span의 텍스트가 20글자를 초과하면
					// 		$('.sub_menu li:eq('+index+')').find('a').html('<span>' + spanH.substr(0,indexOf) + '<i></i></span><span>' + spanH.substr(indexOf)+'<i></i></span>');
					// 	}
					// 	//.sub_menu li 바로 아래 a의 html 값을 변경
					// 	//가장 마지막 공백 기준으로 두 줄 만들기
					// 	//<span> + 텍스트의 처음~마지막 공백 + <i></i></span><span> + 마지막 공백 이후 모든 텍스트 + <i></i></span>

					// });
				});
			</script>
		</div>
	</div>

	<script type="text/javascript">
		$(function() {
			$("#image_list_2").jQBanner({	//롤링을 할 영역의 ID 값
				nWidth:2000,				//영역의 width
				nHeight:250,				//영역의 height
				nCount:3,					//돌아갈 이미지 개수
				isActType:"left",			//움직일 방향 (left, right, up, down)
				nOrderNo:1,					//초기 이미지
				nDelay:5000					//롤링 시간 타임 (1000 = 1초)
				/*isBtnType:"li"*/			//라벨(버튼 타입) - 여기는 안쓰임
				}
			);
		});
	</script>
	<script type="text/javascript">
		/*
		//현재 화면에서 다른 페이지로 이동할 때 부드럽게 스크롤
		// to top right away
		if ( window.location.hash ) scroll(0,0);
		// void some browsers issue
		setTimeout( function() { scroll(0,0); }, 1);

		$(function() {

			// your current click function
			$('a[href*=#]').on('click', function(event){
				////event.preventDefault();
				$('html,body').animate({scrollTop:$(this.hash).offset().top-150}, 500);
			});

			// *only* if we have anchor on the url
			if(window.location.hash) {

				// smooth scroll to the anchor id
				$('html, body').animate({
					scrollTop: $(window.location.hash).offset().top-150
				}, 1000, 'swing');
			}

		});
		*/
	</script>
	<div id="contain_wrap" class="layout_wrap <%=cw_class%>">
	<% If PAGE_SETTING2 <> "INDEX" Then%>
	<div id="subVisualWrap">
		<div id="subVisualWrapD1">
			<div id="subVisuals"  class="layout_inner">
				<div class="images">
					<%Select Case PAGE_SETTING%>
					<%Case "COMPANY"%>
						<img src="/images/community/sub_visual01.jpg" alt="" />
					<%Case "BUSINESS"%>
						<img src="/images/community/sub_visual01.jpg" alt="" />
					<%Case "PRODUCT"%>
						<img src="/images/community/sub_visual01.jpg" alt="" />
					<%Case "CUSTOMER"%>
						<img src="/images/community/sub_visual01.jpg" alt="" />
					<%Case "MYOFFICE"%>
						<img src="/images/community/sub_visual01.jpg" alt="" />
					<%Case Else%>
						<img src="/images/community/sub_visual01.jpg" alt="" />
					<%End Select%>
				</div>
			</div>
		</div>
	</div>

	<%End If%>
		<%	If ISLEFT = "T" Then%>
			<!--#include virtual = "/_include/sub_title.asp"-->
		<div id="contain" class="layout_inner">
			<!-- <div id="left"> -->
				<!--include virtual = "/_include/left.asp"-->
				<!-- <i class="line"></i></div> -->
			<%If PAGE_SETTING = "MYOFFICE" Then%>
				<div id="content_M">
			<%Else%>
				<div id="content">
			<%End If%>
		<%	Else %>
			<div id="contentFull" <%=cw_style%>>
		<%	End If%>

