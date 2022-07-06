<%
	'▣ 설정 구역 S

		PAGE_SETTING = "CUSTOMER"

		If MYOFFICE_MODE_TF = "T" Then
			PAGE_SETTING = "MYOFFICE"
			INFO_MODE	 = "NOTICE1-3"
		End If

		If DK_MEMBER_TYPE = "ADMIN" Then
			If MOB_PATH = "/m" Then
				Call ALERTS(LNG_STRCHECK_TEXT02,"BACK","")
			Else
				Response.Redirect "/admin/manage/1on1_list.asp"
			End If
		End If

		ISLEFT = "T"
		ISSUBTOP = "T"
		ISSUBVISUAL = "T"
		IS_LANGUAGESELECT = "F"

		mNum = 5
		sNum = 3
		sVar = sView
		view = sNum

		'Call WRONG_ACCESS()
		Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)		'고객지원 - 1:1상담 : 회원공개
		Call FN_NationCurrency(DK_MEMBER_NATIONCODE,Chg_CurrencyName,Chg_CurrencyISO)
		Chg_CurrencyISO = "USD"

		'ONLY_MEMBER_WRITE = "T" 'F 일시 비회원 작성 가능 (비회원은 답글 보기 기능 없음)
		USE_REPLY_MAIL = "F"
		USE_REPLY_MMS = "F"


		USE_WYSIWIG = "F"

		USE_DATA1 = "T"
		USE_DATA2 = "F"
		USE_DATA3 = "F"

		MEMBER_INFO_LINK_URL = "/mypage/member_info.asp"
		M_MEMBER_INFO_LINK_URL = "/m/mypage/member_info.asp"

	'▣ 설정 구역 E


	'If DK_MEMBER_TYPE = "ADMIN" Then Response.Redirect "/admin/manage/1on1_list.asp"

%>