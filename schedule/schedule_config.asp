 <%
	'엘라이프2017 마이오피스 일정관리(2017-02-27)

	If DK_MEMBER_TYPE <> "ADMIN" Then Call ALERTS("관리자가 아닙니다. 회원로그아웃 후 다시 확인해주세요","go","/common/member_logout.asp")
	If DK_MEMBER_LEVEL < DKCONF_SITE_ADMIN Then Call ALERTS("관리자 아이디이지만 관리자모드에 접속할 수 없는 레벨입니다. 최종관리자에게 문의해주세요.","go","/common/member_logout.asp")


	Select Case schType
		Case "oneday"
			view = 4
			SCHEDULE_TYPE_TXT = LNG_SCHEDULE_01
		Case "success"
			view = 5
			SCHEDULE_TYPE_TXT = LNG_SCHEDULE_02
		Case Else
		Call ALERTS(LNG_BOARD_LIST_TEXT02,"BACK","")
	End Select

%>
