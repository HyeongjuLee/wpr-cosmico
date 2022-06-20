<%

	NICE_LIVE_PAY_TF = "F"

	If NICE_LIVE_PAY_TF ="T" Then
		'REAL
		'◈일반
			NICE_merchantKey = ""	'상점키
			NICE_merchantID	 = ""																				    '상점아이디(OOO podo0000000)
			NICE_CancelPwd	 = ""					 '거래취소 패스워드(실거래시, 가맹점 관리자의 가맹점정보>기본정보>별도설정한 비밀번호 기입!
		'◈키인
		'	NICE_merchantKey_KEYIN	= ""	'상점키
		'	NICE_merchantID_KEYIN 	= ""																				'상점아이디
		'	NICE_CancelPwd_KEYIN	= ""		 '거래취소 패스워드(실거래시, 가맹점 관리자의 가맹점정보>기본정보>별도설정한 비밀번호 기입!

			TXT_vBankRecvName = "OOO 주식회사"
	Else
		'TEST
		'◈일반 nicepay00m
			NICE_merchantKey = "EYzu8jGGMfqaDEp76gSckuvnaHHu+bC4opsSN6lHv3b2lurNYkVXrZ7Z1AoqQnXI3eLuaUFyoRNC6FkrzVjceg=="	'상점키
			NICE_merchantID  = "nicepay00m"																				'상점아이디
			NICE_CancelPwd	  = "123456"		 '거래취소 패스워드(실거래시, 가맹점 관리자의 가맹점정보>기본정보>별도설정한 비밀번호 기입!

		'◈키인 nictest04m
			NICE_merchantKey_KEYIN	= "b+zhZ4yOZ7FsH8pm5lhDfHZEb79tIwnjsdA0FBXh86yLc6BJeFVrZFXhAoJ3gEWgrWwN+lJMV0W4hvDdbe4Sjw=="	'상점키
			NICE_merchantID_KEYIN 	= "nictest04m"																				'상점아이디
			NICE_CancelPwd_KEYIN	= "123456"		 '거래취소 패스워드(실거래시, 가맹점 관리자의 가맹점정보>기본정보>별도설정한 비밀번호 기입!

			TXT_vBankRecvName = "OOO 주식회사"
	End if

' *****************************************************************************
'	Function name	: PG_NICEPAY_CANCEL
'	Description		: NICEPAY 결제취소
'
'	Call PG_NICEPAY_CANCEL(merchantKey, PGID, CancelPwd, amt, tid, isDirect, GoodIDX, chgPage,"identity미발생오류:")
' *****************************************************************************

	Function PG_NICEPAY_CANCEL(ByVal F_merchantKey, ByVal F_PGID, ByVal F_CancelPwd, ByVal F_CancelAmt, ByVal F_TID, ByVal F_isDirect, ByVal F_GoodIDX, ByVal F_chgPage, ByRef F_CancelMsg)

		'isDirect or Cart 체크 (GO_BACK_ADDR)
		If F_isDirect = "T" Then
			F_GO_BACK_ADDR = F_chgPage&"/shop/detailView.asp?gidx="&F_GoodIDX
		Else
			F_GO_BACK_ADDR = F_chgPage&"/shop/cart.asp"
		End If

		merchantKey			= F_merchantKey
		PGID				= F_PGID
		CancelPwd			= F_CancelPwd
		CancelAmt			= F_CancelAmt
		TID					= F_TID
		CancelMsg			= F_CancelMsg
		PartialCancelCode	= 0		'전체취소 : 0, 부분취소 : 1

		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' <취소 결과 설정>
		' 사용전 결과 옵션을 사용자 환경에 맞도록 변경하세요.
		' 상점키, MID는 꼭 변경하세요.
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		Set NICEpay = Server.CreateObject("NICE.NICETX2.1")
		PInst = NICEpay.Initialize("")
		NICEpay.SetActionType CLng(PInst),"CANCEL"
		NICEpay.SetField CLng(PInst),"logpath","D:\PG\NICEPAY\log"			'Log Path 설정						'Webpro Log Path
		NICEpay.SetField CLng(PInst),"LicenseKey",merchantKey               'MID
		NICEpay.SetField CLng(PInst),"mid",PGID								'상점 ID							'PGID
		NICEpay.SetField CLng(PInst),"CancelPwd",CancelPwd									'취소 패스워드
		NICEpay.SetField CLng(PInst),"CancelAmt",CancelAmt									'취소금액
		NICEpay.SetField CLng(PInst),"tid",TID												'거래번호
		NICEpay.SetField CLng(PInst),"CancelMSG",CancelMsg									'취소 사유
		NICEpay.SetField CLng(PInst),"partialcancelcode",PartialCancelCode					'부분취소 여부
		NICEpay.SetField CLng(PInst),"CancelIP",getuserIP()									'취소요청자IP
		NICEpay.SetField CLng(PInst),"debug","true"                                         '로그모드(true=상세한 로그)
		NICEpay.StartAction(CLng(PInst))

		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' <취소 결과 필드>
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		m_tid            = NICEpay.GetResult(CLng(PInst),"tid")                             '거래번호
		m_resultCode     = NICEpay.GetResult(CLng(PInst),"resultcode")                      '결과코드 (취소성공: 2001, 취소성공(LGU 계좌이체):2211)
		m_resultMsg      = NICEpay.GetResult(CLng(PInst),"resultmsg")                       '결과메시지
		m_cancelauthcode = NICEpay.GetResult((PInst),"CancelNum")                           '취소승인번호
		m_cancelDate     = NICEpay.GetResult((PInst),"CancelDate")                          '취소일시
		m_cancelTime     = NICEpay.GetResult((PInst),"CancelTime")                          '취소시간
		m_cancelamt      = NICEpay.GetResult((PInst),"cancelamt")                           '취소금액
		m_cancelIP       = NICEpay.GetResult((PInst),"CancelIP")							'취소요청자IP

		'로그기록생성 S ============================================================================================
		On Error Resume Next
		Dim  Fso22 : Set  Fso22=CreateObject("Scripting.FileSystemObject")
		Dim LogPath22 : LogPath22 = Server.MapPath ("Cancel/Cresult__") & Replace(Date(),"-","") & ".log"
		Dim Sfile22 : Set  Sfile22 = Fso22.OpenTextFile(LogPath22,8,true)

		Sfile22.WriteLine chr(13)
		Sfile22.WriteLine "Date : " & now()
		Sfile22.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
		Sfile22.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
		Sfile22.WriteLine "THIS_PAGE_URL  : " & Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")
		Sfile22.WriteLine "===== <취소 결과 > ====="
		'Sfile22.WriteLine "merchantKey : " & merchantKey
		Sfile22.WriteLine "PGID : " & PGID
		Sfile22.WriteLine "CancelPwd: " & CancelPwd
		Sfile22.WriteLine "CancelMsg: " & CancelMsg
		Sfile22.WriteLine "m_tid : " & m_tid
		Sfile22.WriteLine "m_resultCode : " & m_resultCode
		Sfile22.WriteLine "m_resultMsg : " & m_resultMsg
		Sfile22.WriteLine "m_cancelauthcode : " & m_cancelauthcode
		Sfile22.WriteLine "m_cancelDate		 : " & m_cancelDate
		Sfile22.WriteLine "m_cancelTime	 : " & m_cancelTime
		Sfile22.WriteLine "m_cancelamt : " & m_cancelamt
		Sfile22.WriteLine "m_cancelIP	 : " & m_cancelIP
		Sfile22.WriteLine chr(13)
		Sfile22.WriteLine chr(13)
		Sfile22.Close
		Set Fso22= Nothing
		Set objError= Nothing
		On Error GoTo 0
		'로그기록생성 E ============================================================================================

		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' <취소 성공 여부 확인>
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		If m_resultCode = "2001" Then
			Call ALERTS("데이터 처리중 오류가 발생하여 결제를 취소하였습니다\n\n오류사유 : "&F_CancelMsg,"GO",F_GO_BACK_ADDR)
		Else
			Call ALERTS("결제취소중 오류가 발생하였습니다. 결제취소가 정상적으로 이루어 지지 않은 경우 업체에 문의해주세요","GO",F_GO_BACK_ADDR)
		End If

		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		' <인스턴스 해제>
		''''''''''''''''''''''''''''''''''''''''''''''''''''''''
		NICEpay.Destroy CLng(PInst)
		Response.End

	End Function





' *****************************************************************************
'	Function name	: NICEPAY_CARDCODE
'	Description		: NICEPAY 카드사코드 변경
' *****************************************************************************
	Function NICEPAY_CARDCODE(ByVal codeData)
		Select Case codeData
			Case "01"	: NICEPAY_CARDCODE = "11"	'비씨
			Case "02"	: NICEPAY_CARDCODE = "06"	'국민
			Case "03"	: NICEPAY_CARDCODE = "01"	'외환
			Case "04"	: NICEPAY_CARDCODE = "12"	'삼성
			Case "06"	: NICEPAY_CARDCODE = "14"	'신한
			Case "07"	: NICEPAY_CARDCODE = "04"	'현대
			Case "08"	: NICEPAY_CARDCODE = "03"	'롯데
			Case "09"	: NICEPAY_CARDCODE = "15"	'한미
			Case "10"	: NICEPAY_CARDCODE = "99"	'신세계한미
			Case "11"	: NICEPAY_CARDCODE = "30"	'시티
			Case "12"	: NICEPAY_CARDCODE = "16"	'농협
			Case "13"	: NICEPAY_CARDCODE = "32"	'수협
			Case "14"	: NICEPAY_CARDCODE = "99"	'평화
			Case "15"	: NICEPAY_CARDCODE = "19"	'우리
			Case "16"	: NICEPAY_CARDCODE = "17"	'하나
			Case "17"	: NICEPAY_CARDCODE = "99"	'동남(주택)
			Case "18"	: NICEPAY_CARDCODE = "99"	'주택
			Case "19"	: NICEPAY_CARDCODE = "99"	'조흥(강원)
			Case "20"	: NICEPAY_CARDCODE = "99"	'축협(농협)
			Case "21"	: NICEPAY_CARDCODE = "28"	'광주
			Case "22"	: NICEPAY_CARDCODE = "18"	'전북
			Case "23"	: NICEPAY_CARDCODE = "99"	'제주
			Case "24"	: NICEPAY_CARDCODE = "99"	'산은
			Case "25"	: NICEPAY_CARDCODE = "21"	'해외비자
			Case "26"	: NICEPAY_CARDCODE = "22"	'해외마스터
			Case "27"	: NICEPAY_CARDCODE = "25"	'해외다이너스
			Case "28"	: NICEPAY_CARDCODE = "24"	'해외AMX
			Case "29"	: NICEPAY_CARDCODE = "23"	'해외JCB
			Case Else : NICEPAY_CARDCODE = "99"					'기타
		End Select
	End Function

%>