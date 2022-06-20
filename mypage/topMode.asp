<%

	DEPTH1 = "<a href=""/index"">HOME</a>"
	DEPTH2 = "<a href=""/mypage/member_info.asp"">마이페이지</a>"

	Select Case UCase(PageMode)
		Case "MEMBERINFO"
			ThisTit = "tit_memberinfo.gif"
			DEPTH3 = "<a href=""/mypage/member_info.asp"">회원정보수정</a>"
		Case "MEMBERLEAVE"
			ThisTit = "tit_memberleave.gif"
			DEPTH3 = "<a href=""/mypage/member_info.asp"">회원탈퇴신청</a>"
	End Select




	PRINT TABS(1)& "	<div class=""titleLine"">"
	PRINT TABS(1)& "		<div class=""fleft"">"&viewImg(IMG_MYPAGE&"/"&ThisTit,250,35,"")&"</div>"
	PRINT TABS(1)& "		<div class=""fright navi"">"&DEPTH1&" > "&DEPTH2&" > "&DEPTH3&"</div>"
	PRINT TABS(1)& "	</div>"


%>
