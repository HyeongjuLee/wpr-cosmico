	</div> <!--contain_wrap E-->
	<%Select Case PAGE_SETTING%>
	<%Case "MEMBERSHIP"%>
	</div>
	</div>
	<%Case Else%>
	<%End Select%>

	<%Select Case PAGE_SETTING2%>
	<%Case "MYOFFICEPAGE"%>
	</div>
	</div>
	<%Case Else%>
	<%End Select%>

	<script type="text/javascript">
		$(window).scroll(function(){
			if ( $(this).scrollTop()>200 ){
				$('.site-top').fadeIn();
			} else {
				$('.site-top').fadeOut();
			}
		});
		$(document).ready(function(){
			$('footer .site-top').click(function(){
				$( 'html, body').animate( { scrollTop : 0 }, 400 );
				return false;
			});
		});
	</script>

<%
	'footer-menu
	FOO_MENU_LINE 		= "<li class=""foo-menu-line""></li>" & VbCrLf
	FOO_MENU_LOGIN 		= "<li><a href=""/m/common/member_login.asp"">"&LNG_TEXT_LOGIN&"</a></li>" & VbCrLf
	FOO_MENU_LOGOUT 	= "<li><a href=""/m/common/member_logout.asp"">"&LNG_TEXT_LOGOUT&"</a></li>" & VbCrLf
	FOO_MENU_COMPANY 	= FOO_MENU_LINE & "<li><a href=""/m/page/company.asp?view=1&sview=1"">"&LNG_BOTTOM_COMPANY&"</a></li>" & VbCrLf
	FOO_MENU_POLICY1 	= FOO_MENU_LINE & "<li><a href=""/m/page/policy.asp?view=1"">"&LNG_BOTTOM_POLICY1&"</a></li>" & VbCrLf
	FOO_MENU_POLICY2 	= FOO_MENU_LINE & "<li class=""policy2""><a href=""/m/page/policy.asp?view=2"">"&LNG_BOTTOM_POLICY2&"</a></li>" & VbCrLf
	FOO_MENU_SALESMAN 	= FOO_MENU_LINE & "<li><a href=""/m/salesman/salesman.asp"">"&LNG_BUSINESS_05&"</a></li>" & VbCrLf
	FOO_MENU_LOCATION 	= FOO_MENU_LINE & "<li><a href=""/m/page/location.asp"">"&LNG_BOTTOM_LOCATION&"</a></li>" & VbCrLf
	FOO_MENU_CUSTOMER 	= FOO_MENU_LINE & "<li><a href=""/m/cboard/board_list.asp?bname=notice"">"&LNG_CUSTOMER&"</a></li>" & VbCrLf
	FOO_MENU_PC 		= FOO_MENU_LINE & "<li><a href=""/mbre.asp"" target=""_blank"">"&LNG_BOTTOM_PC&"</a></li>" & VbCrLf

	If PG_EXAM_MODE = "T" Then FOO_MENU_SALESMAN = ""

	If DK_MEMBER_LEVEL > 0 Then
	FOO_MENU_SET = FOO_MENU_LOGOUT & FOO_MENU_POLICY1 & FOO_MENU_POLICY2 & FOO_MENU_PC
	Else
	FOO_MENU_SET = FOO_MENU_LOGIN & FOO_MENU_POLICY1 & FOO_MENU_POLICY2 & FOO_MENU_PC
	End If


	'footer-info
	SSS 					= "<span>" & VbCrLf
	EEE 					= "</span>" & VbCrLf
	FOO_INFO_LINE 			= "<span class=""foo-info-line""></span>" & VbCrLf
	FOO_INFO_COMPANY 		= LNG_COPYRIGHT_TITLE_COMPANY			&" : "&LNG_COPYRIGHT_COMPANY & VbCrLf
	FOO_INFO_CEO 			= LNG_COPYRIGHT_TITLE_CEO				&" : "&LNG_COPYRIGHT_CEO & VbCrLf
	FOO_INFO_ADDRESS 		= LNG_COPYRIGHT_TITLE_ADDRESS			&" : "&LNG_COPYRIGHT_ADDRESS & VbCrLf
	FOO_INFO_BUSINESS_NUM 	= LNG_COPYRIGHT_TITLE_BUSINESS_NUM		&" : "&LNG_COPYRIGHT_BUSINESS_NUM & VbCrLf
	FOO_INFO_TEL 			= LNG_COPYRIGHT_TITLE_TEL				&" : "&LNG_COPYRIGHT_TEL & VbCrLf
	FOO_INFO_CSTEL 			= "<a href=""tel:"&LNG_COPYRIGHT_CSTEL&""" class=""tel"">"&LNG_COPYRIGHT_TITLE_CSTEL&" : "&LNG_COPYRIGHT_CSTEL&"</a>"& VbCrLf
	'FOO_INFO_CSTEL 			= LNG_COPYRIGHT_TITLE_CSTEL				&" : "&LNG_COPYRIGHT_CSTEL & VbCrLf
	FOO_INFO_FAX 			= LNG_COPYRIGHT_TITLE_FAX				&" : "&LNG_COPYRIGHT_FAX & VbCrLf
	FOO_INFO_EMAIL 			= LNG_COPYRIGHT_TITLE_EMAIL				&" : "&LNG_COPYRIGHT_EMAIL & VbCrLf
	FOO_INFO_MAILORDER_NUM 	= LNG_COPYRIGHT_TITLE_MAILORDER_NUM		&" : "&LNG_COPYRIGHT_MAILORDER_NUM & VbCrLf
	FOO_INFO_INFO_RMANAGER 	= LNG_COPYRIGHT_TITLE_INFO_RMANAGER		&" : "&LNG_COPYRIGHT_INFO_RMANAGER & VbCrLf


	FOO_INFO_SET1 = 	"<p>" & SSS & LNG_COPYRIGHT_COMPANY & EEE & "</p>"
	FOO_INFO_SET2 = 	"<p>" & SSS & FOO_INFO_BUSINESS_NUM & EEE & FOO_INFO_LINE & SSS & FOO_INFO_CEO & EEE & "</p>"
	FOO_INFO_SET3 = 	"<p>" & SSS & LNG_COPYRIGHT_ADDRESS & EEE & "</p>"
	FOO_INFO_SET4 =		"<p>" & FOO_INFO_CSTEL & "</p>"
	FOO_INFO_SET5 =		"<p>" & SSS & FOO_INFO_FAX & EEE & FOO_INFO_LINE & SSS & LNG_COPYRIGHT_EMAIL & EEE & "</p>"


%>
<%If PAGE_SETTING <> "MYOFFICE" Then%>
<footer>
	<div id="footer" class="footer">
		<div class="layout_inner">
			<ul class="footer-menu">
				<%=FOO_MENU_SET%>
			</ul>
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
				<%=FOO_INFO_SET2%>
				<%=FOO_INFO_SET3%>
				<%=FOO_INFO_SET4%>
				<%=FOO_INFO_SET5%>
			</div>
			<div class="copyright">Copyright (C) <%=LNG_COPYRIGHT_COMPANY_INC%> co., ltd All rights reserv<a href="/common/admin_login.asp">ed</a></div>
			<button class="site-top"></button>
		</div>
	</div>
</footer>
<%Else%>
	<footer>
		<div class="layout_inner">
			<div class="copyright">Copyright (C) <%=LNG_COPYRIGHT_COMPANY_INC%> co., ltd All rights reserv<a href="/common/admin_login.asp">ed</a></div>
		</div>
	</footer>
<%End If%>
</div>
</body>
</html>
