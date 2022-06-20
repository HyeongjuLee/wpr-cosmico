<%@ CodePage="65001" Language="VBScript"%>
<%
	Session.CodePage = 65001
	Response.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Expires","0"
	'쿠키 미 사용시
	Response.AddHeader "Pragma","no-cache"
	'쿠키 사용시
		'Response.AddHeader "Pragma", "private"
		'Response.AddHeader "Cache-Control", "private, must-revalidate"


' *****************************************************************************
'	Function name	: eRegiReplace
'	Description		: 문자열 정규식 Replace
' *****************************************************************************
	Function eRegiReplace(ByVal value, ByVal pattern, ByVal replacement)
		Dim objRegExp
		Set objRegExp = New RegExp

		objRegExp.Pattern = pattern
		objRegExp.IgnoreCase = True	 		' 대/소문자를 구분하지 않도록 함
		objRegExp.Global = True					' 문자열 전체에서 검색

		eRegiReplace = objRegExp.Replace(value, replacement)
		Set objRegExp = Nothing
	End Function
%>
<%

	TX_KSNET_TID_KEYIN	= Request.Form("TX_KSNET_TID")
	OrderNum			= Request.Form("orderNum")
	strName				= Request.Form("strName")
	strEmail			= Request.Form("strEmail")
	GoodsName			= Request.Form("GoodsName")
	strMobile			= Request.Form("strMobile")
	CardNo				= Request.Form("CardNo")
	cardYYMM			= Request.Form("cardYYMM")
	Quotabase			= Request.Form("Quotabase")
	CardPrice			= Request.Form("CardPrice")
	CardPass			= Request.Form("CardPass")
	CARDAUTH_Input		= Request.Form("CARDAUTH_Input")

%>
<!-- #include file=KSPayApprovalCancel_ansi.inc -->
<%

	'카드결제 (실결제) =================================================================================================
	'★★★★ KSNET API ★★★★
	'payment	카드승인요청

	'Header부 Data --------------------------------------------------
		EncType			= "2" 					'0: 암화안함, 1:ssl, 2: seed
		Version			= "0603"				' 전문버전
		VType			= "00"					' 구분
		Resend			= "0"					' 전송구분 : 0 : 처음,  2: 재전송

		RequestDate		=	SetData(Year(Now),    4, "9") & _
							SetData(Month(Now),   2, "9") & _
							SetData(Day(Now),     2, "9") & _
							SetData(Hour(Now),    2, "9") & _
							SetData(Minute(Now),  2, "9") & _
							SetData(Second(Now),  2, "9")

		KeyInType		= "K" 					'KeyInType 여부 : S : Swap, K: KeyInType
		LineType		= "1"					'lineType 0 : offline, 1:internet, 2:Mobile
		ApprovalCount	= "1"					'복합승인갯수
		GoodType		= "0" 					'제품구분 0 : 실물, 1 : 디지털
		HeadFiller		= ""					'예비

		StoreId			= TX_KSNET_TID_KEYIN												'*상점아이디(키인)

		OrderNumber		= OrderNum															'*주문번호	/ wpro 다카드주문번호
		UserName		= Trim(Left(eRegiReplace(strName,"[^-가-힣a-zA-Z0-9]",""),15))		'*주문자명
		IdNum			= request.form("idnum") 											'주민번호 or 사업자번호
		Email			= Trim(strEmail) 													'*email
		GoodName		= Trim(Left(eRegiReplace(GoodsName,"[^-가-힣a-zA-Z0-9]",""),15)) 	'*제품명			'전문 : 2번째 카드부터 상품명 뒤로 5바이트씩 밀리는 현상? ㅡ.,ㅡ
		PhoneNo			= Left(Replace(strMobile,"-",""),12)								'*휴대폰번호
	'Header end -------------------------------------------------------------------

	'Data Default-------------------------------------------------
		ApprovalType		= "1300" 												'승인구분 1300 (구인증 카유비생, 1000 카유)
		InterestType		= "1"						 							'일반/무이자구분 1:일반 2:무이자 <input type=hidden name="interesttype"			value="1"> 무시
		TrackII				= CardNo&"="&CardYYMM							      	'카드번호=유효기간  or 거래번호
		Installment			= Quotabase 											'할부  00일시불
		Amount				= CardPrice												'금액
		Passwd				= CardPass			 									'비밀번호 앞2자리
		LastIdNum			= CARDAUTH_Input										'주민번호  뒤7자리, 사업자번호10
		CurrencyType		= "WON"						 							'통화구분 0:원화 1: 미화 <input type=hidden name="currencytype"			value="WON"> 무시

		BatchUseType		= "0" 				'거래번호배치사용구분  0:미사용 1:사용
		'CardSendType		= "0" 				'카드정보전송유무
		CardSendType		= "2" 				'카드정보전송유무
		'0:미전송 1:카드번호,유효기간,할부,금액,가맹점번호 2:카드번호앞14자리 + "XXXX",유효기간,할부,금액,가맹점번호
		VisaAuthYn			= "7" 				'비자인증유무 0:사용안함,7:SSL,9:비자인증
		Domain				= "" 				'도메인 자체가맹점(PG업체용)
		IpAddr				= Request.ServerVariables("REMOTE_ADDR")			'IP ADDRESS 자체가맹점(PG업체용)
		BusinessNumber		= "" 												'사업자 번호 자체가맹점(PG업체용)
		Filler				= "" 												'예비
		AuthType			= "" 												'ISP : ISP거래, MP1, MP2 : MPI거래, SPACE : 일반거래
		MPIPositionType		= "" 												'K : KSNET, R : Remote, C : 제3기관, SPACE : 일반거래
		MPIReUseType		= "" 	      										'Y : 재사용, N : 재사용아님
		EncData				= "" 												'MPI, ISP 데이터

	'Data Default end -------------------------------------------------------------

	'Server로 부터 응답이 없을시 자체응답
		rApprovalType		= "1001"
		rTransactionNo		= "" 							'거래번호
		rStatus				= "X" 							'상태 O : 승인, X : 거절
		rTradeDate			= "" 							'거래일자
		rTradeTime			= "" 							'거래시간
		rIssCode			= "00" 							'발급사코드
		rAquCode			= "00" 							'매입사코드
		rAuthNo				= "9999" 						'승인번호 or 거절시 오류코드
		rMessage1			= "승인거절" 					'메시지1
		rMessage2			= "C잠시후재시도" 				'메시지2
		rCardNo				= "" 							'카드번호
		rExpDate			= "" 							'유효기간
		rInstallment		= "" 							'할부
		rAmount				= "" 							'금액
		rMerchantNo			= "" 							'가맹점번호
		rAuthSendType		= "N" 							'전송구분
		rApprovalSendType	= "N" 							'전송구분(0 : 거절, 1 : 승인, 2: 원카드)
		rPoint1				= "000000000000" 				'Point1
		rPoint2				= "000000000000"				'Point2
		rPoint3				= "000000000000"				'Point3
		rPoint4				= "000000000000" 				'Point4
		rVanTransactionNo	= ""
		rFiller				= "" 							'예비
		rAuthType	 		= "" 							'ISP : ISP거래, MP1, MP2 : MPI거래, SPACE : 일반거래
		rMPIPositionType	= "" 							'K : KSNET, R : Remote, C : 제3기관, SPACE : 일반거래
		rMPIReUseType		= "" 							'Y : 재사용, N : 재사용아님
		rEncData			= "" 							'MPI, ISP 데이터
	'--------------------------------------------------------------------------------

		if CurrencyType = "WON" or CurrencyType = "410" or CurrencyType = "" then CurrencyType = "0" end if
		if CurrencyType = "USD" or CurrencyType = "840" then CurrencyType = "1" else CurrencyType = "0" end if

		'dll 초기화
		KSPayApprovalCancel "210.181.28.137", 21001


		'Header부 전문조립
		HeadMessage EncType, Version, VType, Resend, RequestDate, StoreId, OrderNumber, UserName, IdNum, Email, GoodType, GoodName, KeyInType, LineType, PhoneNo, ApprovalCount, HeadFiller

		'Data부 전문조립
		CreditDataMessage ApprovalType, InterestType, TrackII, Installment, Amount, Passwd, LastIdNum, CurrencyType, BatchUseType, CardSendType, VisaAuthYn, Domain, IpAddr, BusinessNumber, Filler, AuthType, MPIPositionType, MPIReUseType, EncData


		rSendSoket			= "F"
		'KSPAY로 요청전문송신후 수신데이터 파싱
		If SendSocket("1") = True Then
			rSendSoket			= "T"
			rApprovalType		= ApprovalType			'승인구분코드(서비스종류를 구분할수 있습니다. 첨부된전문내역서상의 승인코드부 참조)
			rTransactionNo		= TransactionNo	  		' 거래번호
			rStatus				= Status		  		' 상태 O : 승인, X : 거절
			rTradeDate			= TradeDate		  		' 거래일자
			rTradeTime			= TradeTime		  		' 거래시간
			rIssCode			= IssCode		  		' 발급사코드
			rAquCode			= AquCode		  		' 매입사코드
			rAuthNo				= AuthNo		  		' 승인번호 or 거절시 오류코드
			rMessage1			= Message1		  		' 메시지1
			rMessage2			= Message2		  		' 메시지2
			rCardNo				= CardNo		  		' 카드번호
			rExpDate			= ExpDate		  		' 유효기간
			rInstallment		= Installment	  		' 할부
			rAmount				= Amount		  		' 금액
			rMerchantNo			= MerchantNo	  		' 가맹점번호
			rAuthSendType		= AuthSendType	  		' 전송구분= new String(this.read(2))
			rApprovalSendType	= ApprovalSendType		' 전송구분(0 : 거절, 1 : 승인, 2: 원카드)
		End If
%>
<!-- #include file=encoding_utf8.asp -->
<%
	CardLogss = "mCardShopAPI"

	'▣ 로그 기록 S
		On Error Resume Next
			Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
			Dim LogPath2 : LogPath2 = Server.MapPath (CardLogss&"/mCardPay_") & Replace(Date(),"-","") & ".log"
			Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

			Sfile2.WriteLine chr(13)
			'Sfile2.WriteLine "Date : " & now()
			Sfile2.WriteLine "--- Card PAY #"&Right(OrderNum,1)&"---------------------------"
			Sfile2.WriteLine "OrderNum			: "	& OrderNum	'&"_"&m
			Sfile2.WriteLine "CardPrice			: "	& CardPrice
			Sfile2.WriteLine "rSendSoket		: " & rSendSoket
			Sfile2.WriteLine "StoreId			: "	& StoreId
			Sfile2.WriteLine "rApprovalType		: "	& rApprovalType
			Sfile2.WriteLine "rTransactionNo		: "	& rTransactionNo
			Sfile2.WriteLine "rStatus			: "	& rStatus
			Sfile2.WriteLine "rTradeDate		: "	& rTradeDate
			Sfile2.WriteLine "rTradeTime		: "	& rTradeTime
			Sfile2.WriteLine "rIssCode			: "	& rIssCode
			Sfile2.WriteLine "rAquCode			: "	& rAquCode
			Sfile2.WriteLine "rAuthNo			: "	& rAuthNo
			Sfile2.WriteLine "rMessage1			: "	& rMessage1
			Sfile2.WriteLine "rMessage2			: "	& rMessage2
			'Sfile2.WriteLine "rCardNo			: "	& rCardNo
			'Sfile2.WriteLine "rExpDate			: "	& rExpDate
			Sfile2.WriteLine "rInstallment		: "	& rInstallment
			Sfile2.WriteLine "rAmount			: "	& rAmount
			Sfile2.WriteLine "rMerchantNo		: "	& rMerchantNo
			Sfile2.WriteLine "rAuthSendType		: "	& rAuthSendType
			Sfile2.WriteLine "rApprovalSendType	: "	& rApprovalSendType
			'Sfile2.WriteLine "---------------------------------------------"
			Sfile2.Close
			Set Fso2= Nothing
			Set objError= Nothing
		On Error Goto 0
	'▣ 로그 기록 E


	Response.Write "{""rStatus"":"""&Trim(rStatus)&""",""rAuthNo"":"""&Trim(rAuthNo)&""",""rMessage1"":"""&rMessage1&""",""rMessage2"":"""&rMessage2&""",""rTransactionNo"":"""&rTransactionNo&""",""rInstallment"":"""&rInstallment&""",""rIssCode"":"""&rIssCode&""",""rTradeDate"":"""&rTradeDate&""",""StoreId"":"""&StoreId&"""}"


%>
