<%If PAGE_SETTING <> "MYOFFICE" Then%>
<%If PAGE_SETTING <> "INDEX" Then%>
<script type="text/javascript">
	$(function(){
		$('.footer .site-top').click(function(){
			$( 'html, body').animate( { scrollTop : 0 }, 400 );
			return false;
		});
	});
</script>
	</div>
	</div>
		<%If PAGE_SETTING = "SHOP" Then 'shop에만 배경색%>
		<%Else%>
		<%End If%>
<%Else%>
<%End If%>
<%End If%>
<%
	'footer-menu
	FOO_MENU_LINE 		= "<li class=""foo-menu-line""></li>" & VbCrLf
	FOO_MENU_COMPANY 	= "<li><a href=""/page/company.asp?view=1&sview=1"">"&LNG_BOTTOM_COMPANY&"</a></li>" & VbCrLf
	FOO_MENU_POLICY1 	= "<li><a href=""/page/policy.asp?view=1"">"&LNG_BOTTOM_POLICY1&"</a></li>" & VbCrLf
	FOO_MENU_POLICY2 	= "<li class=""policy2""><a href=""/page/policy.asp?view=2"">"&LNG_BOTTOM_POLICY2&"</a></li>" & VbCrLf
	FOO_MENU_SALESMAN 	= "<li><a href=""/salesman/salesman.asp"">"&LNG_SALESMAN_SEARCH&"</a></li>" & VbCrLf
	FOO_MENU_LOCATION 	= "<li><a href=""/page/location.asp"">"&LNG_BOTTOM_LOCATION&"</a></li>" & VbCrLf
	FOO_MENU_CUSTOMER 	= "<li><a href=""/cboard/board_list.asp?bname=notice"">"&LNG_CUSTOMER&"</a></li>" & VbCrLf
	FOO_MENU_GOODS 		= "<li><a href= ""javascript: popWindow('/common/pop_admission.asp','admission','500','600');"">"&LNG_BOTTOM_GOODS&"</a></li>" & VbCrLf
	'FOO_MENU_GOODS 		= "<li><a href=""javascript: alert('준비중입니다.');"">"&LNG_BOTTOM_GOODS&"</a></li>" & VbCrLf
	FOO_MENU_DEDUCTION 	= "<li><a href=""https://kossa.or.kr/user/m3/bbs/union/ddcNotie/selectBbsInc.do?bbsSeq=4"" target=""_blank"">"&LNG_BOTTOM_DEDUCTION&"</a></li>" & VbCrLf

	If PG_EXAM_MODE = "T" Then FOO_MENU_SALESMAN = ""

	FOO_MENU_SET = FOO_MENU_POLICY1 & FOO_MENU_POLICY2 & FOO_MENU_SALESMAN & FOO_MENU_DEDUCTION & FOO_MENU_GOODS


	'footer-info
	FOO_INFO_COMPANY 		= "<span>"&LNG_COPYRIGHT_TITLE_COMPANY			&" : "&LNG_COPYRIGHT_COMPANY&"</span>" & VbCrLf
	FOO_INFO_CEO 			= "<span>"&LNG_COPYRIGHT_TITLE_CEO				&" : "&LNG_COPYRIGHT_CEO&"</span>" & VbCrLf
	FOO_INFO_ADDRESS 		= "<span>"&LNG_COPYRIGHT_TITLE_ADDRESS			&" : "&LNG_COPYRIGHT_ADDRESS&"</span>" & VbCrLf
	FOO_INFO_BUSINESS_NUM 	= "<span>"&LNG_COPYRIGHT_TITLE_BUSINESS_NUM		&" : "&LNG_COPYRIGHT_BUSINESS_NUM&"</span>" & VbCrLf
	FOO_INFO_TEL 			= "<span>"&LNG_COPYRIGHT_TITLE_TEL				&" : "&LNG_COPYRIGHT_TEL&"</span>" & VbCrLf
	FOO_INFO_CSTEL 			= "<span>"&LNG_COPYRIGHT_TITLE_CSTEL			&" : "&LNG_COPYRIGHT_CSTEL&"</span>" & VbCrLf
	FOO_INFO_FAX 			= "<span>"&LNG_COPYRIGHT_TITLE_FAX				&" : "&LNG_COPYRIGHT_FAX&"</span>" & VbCrLf
	FOO_INFO_EMAIL 			= "<span>"&LNG_COPYRIGHT_TITLE_EMAIL			&" : "&LNG_COPYRIGHT_EMAIL&"</span>" & VbCrLf
	FOO_INFO_MAILORDER_NUM 	= "<span>"&LNG_COPYRIGHT_TITLE_MAILORDER_NUM	&" : "&LNG_COPYRIGHT_MAILORDER_NUM&"</span>" & VbCrLf
	FOO_INFO_INFO_RMANAGER 	= "<span>"&LNG_COPYRIGHT_TITLE_INFO_RMANAGER	&" : "&LNG_COPYRIGHT_INFO_RMANAGER&"</span>" & VbCrLf


	FOO_INFO_SET1 = 	"<p>" & "<span>"& LNG_COPYRIGHT_COMPANY &"</span>" & FOO_INFO_CEO & FOO_INFO_BUSINESS_NUM & "</p>"
	FOO_INFO_SET2 =		"<p>" & FOO_INFO_TEL & FOO_INFO_FAX & FOO_INFO_EMAIL & "</p>"
	FOO_INFO_SET3 =		"<p>" & FOO_INFO_ADDRESS & "</p>"
%>
	<%If PAGE_SETTING <> "MYOFFICE" Then%>
	<footer>
		<div id="footer" class="footer">
			<div class="footer-menu">
				<div class="layout_inner">
					<ul>
						<%=FOO_MENU_SET%>
					</ul>
					<i></i>
					<ul class="cscenter">
						<li class="tit">CUSTOMER CENTER</li>
						<li class="tel"><%=LNG_COPYRIGHT_CSTEL%></li>
						<li>Mon-Fri. 09:00 ~ 18:00 / Close. Sat-Sun, Holiday</li>
					</ul>
				</div>
			</div>
			<div class="layout_inner">
				<div class="footer-logo">
					<img src="/images/share/logo(1).svg" alt="">
				</div>
				<article class="footer-right">
					<div class="footer-icon">
						<ul>
							<li class="naver"><a href="https://blog.naver.com/metac21g" target="_blank" title="<%=LNG_NAVER%>"><i class="icon-naver"></i></a></li>
							<li class="youtube"><a href="https://www.youtube.com/channel/UCkgCXAv0-Y4HGHxJVbEIWcg" target="_blank" title="<%=LNG_YOUTUBE%>"><i class="icon-youtube"></i></a></li>
							<li class="facebook"><a href="https://www.facebook.com/Meta-C21-Global-101342629170938" target="_blank" title="<%=LNG_FACEBOOK%>"><i class="icon-facebook-1"></i></a></li>
							<li class="insta"><a href="https://www.instagram.com/metac21global/" target="_blank" title="<%=LNG_INSTAGRAM%>"><i class="icon-instagram"></i></a></li>
							<li class="kakao"><a href="https://story.kakao.com/metac21g" target="_blank" title="<%=LNG_KAKAOSTORY%>"><i class="icon-kakao-story"></i></a></li>
						</ul>
					</div>
					<div class="footer-info">
						<%=FOO_INFO_SET1%>
						<%=FOO_INFO_SET3%>
						<%=FOO_INFO_SET2%>
					</div>
					<%If webproIP = "T" Then%>
					<%If PG_EXAM_MODE <> "T" Then%>
					<div class="banners">
						<a class="kossa" href="http://www.mlmunion.or.kr/index.do" target="_blank"><img src="/images/share/footer-kossa.gif" alt="특판공제조합"></a>
						<a class="ftc" href="https://ftc.go.kr/" target="_blank"><img src="/images/share/footer-ftc.gif" alt="공정거래위원회"></a>
					</div>
					<%End If%>
					<%End If%>
					<div class="copyright">Copyright (c) <%=LNG_COPYRIGHT_COMPANY_INC%> co., ltd All rights reserv<a href="/common/admin_login.asp">ed.</a></div>
					<!-- <button class="site-top"></button> -->
					<a href="#1st" class="site-top"></a>
				</article>
			</div>
		</div>
	</footer>
	<%Else%>
	<footer>
		<div class="layout_inner">
			<div class="copyright">COPYRIGHT (C) <%=LNG_COPYRIGHT_COMPANY_INC%> CO., LTD ALL RIGHTS RESERV<a href="/common/admin_login.asp">ED</a></div>
		</div>
	</footer>
	<%End If%>


<%'퀵메뉴 고정형(2018-07-04~%>
<div id="fixQuick" style="position:fixed; top:150px; left:50%; margin-left: 640px; z-index: 9999;"><!--include virtual = "/_include/fixQuick.asp"--></div>

<%

	isUSE_FLOATING = "F"

	If isUSE_FLOATING = "T" Then
%>
	<div id="floating2" style="position: absolute; z-index:99999;"><!--#include virtual="/_include/floating2.asp"--></div>
	<script type="text/javascript">
		if (document.getElementById("floating2")) {
			// 반드시 플로팅 기준객체(basisBody) 외부에서 설정
			var objFloating = new floating();
			objFloating.objBasis = document.getElementById("contain");
			objFloating.objFloating = document.getElementById("floating2");
			objFloating.time = 15;
			objFloating.marginLeft = 1593;
			objFloating.marginTop = (document.body.clientHeight)-3871;
			objFloating.init();
			objFloating.run();
		}

	</script>
<%End If%>
<script type="text/javascript">
	window.popWindow = function (url, winname, width, height) {
		attributes = "left=" + (window.screen.width - width) / 2 + ",top=0,width=" + width + ",height=" + height + ",scrollbars=yes, menubar=0, status=0, toolbar=0, location=0";
		popW = window.open(url, winname, attributes);
		popW.focus();
	}
</script>

</body>
</html>
