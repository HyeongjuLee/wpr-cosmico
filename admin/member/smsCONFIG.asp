<%

	'템플릿 설정

	'▣ 카톡기능 사용여부 설정	("sms","lms","mms","at","ai","ft","rcs")
	strType_at = "F"	'알림톡 사용여부
	strType_at = "F"	'알림톡 사용여부
	strType_ai = "F"	'알림톡 이미지 사용여부
	strType_ft = "F"	'친구톡 사용여부

	Select Case LCase(strCate)
		Case "join"
			INFO_MODE = "MEMBER1-5"
			THIS_SUBJECT = "[회원가입 안내]"
			strType_at = "T"

		Case "order"
			INFO_MODE = "MEMBER1-7"
			THIS_SUBJECT = "[상품주문]"
			strType_at = "T"

		Case "join2"		'메타추가
			INFO_MODE = "MEMBER1-8"
			THIS_SUBJECT = "[회원가입 안내]"

		'Case "spwd"
		'	INFO_MODE = "MEMBER1-9"
		'	THIS_SUBJECT = "[이체비번 초기화]"

		Case Else
			If isJsonPage = "T" Then
				PRINT "{""result"" : ""error"", ""resultMsg"" : ""권한이 없습니다. 다시 로그인 후 이용 바랍니다.""}" :	Response.End
			Else
				Call ALERTS("잘못된 설정입니다.","BACK","")
			End If

	End Select


%>
