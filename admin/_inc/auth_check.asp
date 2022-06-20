<%
	If DK_MEMBER_TYPE <> "ADMIN" Then Call ALERTS("관리자가 아닙니다. 회원로그아웃 후 다시 확인해주세요","go","/common/member_logout.asp")
	If DK_MEMBER_LEVEL < DKCONF_SITE_ADMIN Then Call ALERTS("관리자 아이디이지만 관리자모드에 접속할 수 없는 레벨입니다. 최종관리자에게 문의해주세요.","go","/common/member_logout.asp")
%>
