<!--METADATA TYPE="typelib" NAME="ADODB Type Library" FILE="C:\Program Files\Common Files\System\ado\msado15.dll"-->
<!--#include file = "DAOU_FUNCTION.ASP"-->
<%

	'엠엔스 PC마이오피스,모바일마이오피스 인증결제(MYOFFICE, MYOFFICE_MOB,	2015-11-16)

	DAOU_PAYMETHOD				= Request("PAYMETHOD")					'10	결제수단(CARD)	상수
	DAOU_CPID					= Request("CPID")						'20	상점ID 	다우페이에서 부여
	DAOU_DAOUTRX				= Request("DAOUTRX")					'20	다우거래번호
	DAOU_ORDERNO				= Request("ORDERNO")					'50	주문번호
	DAOU_AMOUNT					= Request("AMOUNT")						'10	결제금액
	DAOU_SETTDATE				= Request("SETTDATE")					'14	결제일자(YYYYMMDDhh24miss)
	DAOU_EMAIL					= Request("EMAIL")						'100	고객 E-MAIL(고객이 입력한 경우)
	DAOU_CARDCODE				= Request("CARDCODE")					'4	카드사코드
	DAOU_CARDNAME				= Request("CARDNAME")					'20	카드사명
	DAOU_USERID					= Request("USERID")						'30	고객 ID
	DAOU_USERNAME				= Request("USERNAME")					'50	구매자명
	DAOU_PRODUCTCODE			= Request("PRODUCTCODE")				'10	상품코드
	DAOU_PRODUCTNAME			= Request("PRODUCTNAME")				'50	상품명
	DAOU_RESERVEDINDEX1			= Request("RESERVEDINDEX1")				'20	예약항목1(내부에서 INDEX로 관리)
	DAOU_RESERVEDINDEX2			= Request("RESERVEDINDEX2")				'20	예약항목2(내부에서 INDEX로 관리)
	DAOU_RESERVEDSTRING			= Request("RESERVEDSTRING")				'1024	예약항목
	DAOU_AUTHNO					= Request("AUTHNO")


'http://mnsint.w-pro.kr/PG/DAOU/cardResult.asp?PAYMETHOD=CARD&CPID=CMN12889&DAOUTRX=CTS14101418493499255&ORDERNO=DK142876774022&AMOUNT=2722&SETTDATE=20141014185002&EMAIL=123%40webpro%2Ekr&USERID=webpro&USERNAME=%C0%A5%C7%C1%B7%CE&PRODUCTCODE=59&PRODUCTNAME=Face%2DLifting%20Care%20Pack&CARDCODE=CCBC&CARDNAME=BC%C4%AB%B5%E5&RESERVEDINDEX1=DK142876774022&RESERVEDINDEX2=webpro&RESERVEDSTRING=%25EC%259B%25B9%25ED%2594%2584%25EB%25A1%259C%2526%2526%25EC%259B%25B9%25ED%2594%2584%25EB%25A1%259C%2526%25261600%2D123%2D333%2526%2526010%2D123%2D1234%2526%25261600%2D123%2D333%2526%2526010%2D123%2D1234%2526%2526123%2540webpro%2Ekr%2526%2526151%2D730%2526%2526%25EC%2584%259C%25EC%259A%25B8%2520%25EA%25B4%2580%25EC%2595%2585%25EA%25B5%25AC%2520%25EC%2584%259C%25EC%259B%2590%25EB%258F%2599%2520%25EC%2582%25BC%25EB%25AA%25A8%25EC%258A%25A4%25ED%258F%25AC%25EB%25A0%2589%25EC%258A%25A4%25EB%25B9%258C%25EB%2594%25A9%2526%2526777%2526%2526151%2D730%2526%2526%25EC%2584%259C%25EC%259A%25B8%2520%25EA%25B4%2580%25EC%2595%2585%25EA%25B5%25AC%2520%25EC%2584%259C%25EC%259B%2590%25EB%258F%2599%2520%25EC%2582%25BC%25EB%25AA%25A8%25EC%258A%25A4%25ED%258F%25AC%25EB%25A0%2589%25EC%258A%25A4%25EB%25B9%258C%25EB%2594%25A9%2526%2526777%2526%25262722%2526%25262500%2526%25260%2526%25260%2526%2526%2526%25261%2526%2526direct%2526%2526%2526%25260%2526%252659%2526%2526Card

'http://mnsint.w-pro.kr/PG/DAOU/cardResult.asp?PAYMETHOD=CARD&CPID=CMN12889&DAOUTRX=CTS14101418493499255&ORDERNO=MT143016037863&AMOUNT=3500&SETTDATE=20141014185002&EMAIL=yuwooji@paran.com&USERID=TE-1&USERNAME=%ED%85%8C%EC%8A%A4%ED%8A%B81&PRODUCTCODE=10&PRODUCTNAME=%ED%85%8C%EC%8A%A4%ED%8A%B8%EC%83%81%ED%92%88(%EA%B5%AC%EB%A7%A4%EB%B6%88%EA%B0%80)&CARDCODE=CCBC&CARDNAME=BC%EC%B9%B4%EB%93%9C&RESERVEDINDEX1=MT143016037863&RESERVEDINDEX2=162&RESERVEDSTRING=PAYMETHOD=CARD&CPID=CMN12889&DAOUTRX=CTS14101418493499255&ORDERNO=MT143016037863&AMOUNT=3500&SETTDATE=20141014185002&EMAIL=yuwooji@paran.com&USERID=TE-1&USERNAME=%ED%85%8C%EC%8A%A4%ED%8A%B81&PRODUCTCODE=10&PRODUCTNAME=%ED%85%8C%EC%8A%A4%ED%8A%B8%EC%83%81%ED%92%88(%EA%B5%AC%EB%A7%A4%EB%B6%88%EA%B0%80)&CARDCODE=CCBC&CARDNAME=BC%EC%B9%B4%EB%93%9C&RESERVEDINDEX1=MT143016037863&RESERVEDINDEX2=162&RESERVEDSTRING=%ED%85%8C%EC%8A%A4%ED%8A%B81%E2%98%9ETE%E2%98%9E1%E2%98%9E02-1599-8807%E2%98%9E010-2413-2486%E2%98%9Eyuwooji@paran.com%E2%98%9E151-730%E2%98%9E%EC%84%9C%EC%9A%B8%ED%8A%B9%EB%B3%84%EC%8B%9C%20%EA%B4%80%EC%95%85%EA%B5%AC%20%EC%84%9C%EC%9B%90%EB%8F%99%20%EC%82%BC%EB%AA%A8%EC%8A%A4%ED%8F%AC%EB%A0%89%EC%8A%A4%EB%B9%8C%EB%94%A9%E2%98%9E702%ED%98%B8%E2%98%9E3500%E2%98%9E2500%E2%98%9E%E2%98%9E%E2%98%9E%E2%98%9E%E2%98%9E10%E2%98%9ECard%E2%98%9E01


'http://mnsint.w-pro.kr/PG/DAOU/cardResult.asp?PAYMETHOD=CARD&CPID=CMN12889&DAOUTRX=CTS14101418493499255&ORDERNO=MT143016037863&AMOUNT=3500&SETTDATE=20141014185002&EMAIL=yuwooji@paran.com&USERID=TE-1&USERNAME=테스트1&PRODUCTCODE=10&PRODUCTNAME=테스트상품(구매불가)&CARDCODE=CCBC&CARDNAME=BC카드&RESERVEDINDEX1=MT143016037863&RESERVEDINDEX2=162&RESERVEDSTRING=테스트1☞TE☞1☞02-1599-8807☞010-2413-2486☞yuwooji@paran.com☞151-730☞서울특별시 관악구 서원동 삼모스포렉스빌딩☞702호☞3500☞2500☞☞☞☞☞10☞Card☞01



'로그기록생성
	Dim  Fso : Set  Fso=CreateObject("Scripting.FileSystemObject")
	'Dim LogPath : LogPath = Server.MapPath ("/PG/DAOU/mLoc/log_") & Replace(Date(),"-","") & ".log"
	Dim LogPath : LogPath = Server.MapPath ("mLoc_confirm/log_") & Replace(Date(),"-","") & ".log"
	Dim Sfile : Set  Sfile = Fso.OpenTextFile(LogPath,8,true)

	Sfile.WriteLine "Date : " & now()
	Sfile.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
	Sfile.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")

	Sfile.WriteLine "DAOU_PAYMETHOD : " & DAOU_PAYMETHOD
	Sfile.WriteLine "DAOU_CPID: " & DAOU_CPID
	Sfile.WriteLine "DAOU_DAOUTRX : " & DAOU_DAOUTRX
	Sfile.WriteLine "DAOU_ORDERNO : " & DAOU_ORDERNO
	Sfile.WriteLine "DAOU_AMOUNT : " & DAOU_AMOUNT
	Sfile.WriteLine "DAOU_SETTDATE : " & DAOU_SETTDATE
	Sfile.WriteLine "DAOU_EMAIL : " & DAOU_EMAIL
	Sfile.WriteLine "DAOU_CARDCODE		 : " & DAOU_CARDCODE
	'Sfile.WriteLine "DAOU_CARDNAME		 : " & DAOU_CARDNAME
	Sfile.WriteLine "DAOU_USERID		 : " & DAOU_USERID
	Sfile.WriteLine "DAOU_USERNAME		 : " & DAOU_USERNAME
	Sfile.WriteLine "DAOU_PRODUCTCODE	 : " & DAOU_PRODUCTCODE
	Sfile.WriteLine "DAOU_PRODUCTNAME	 : " & DAOU_PRODUCTNAME
	Sfile.WriteLine "DAOU_RESERVEDINDEX1 : " & DAOU_RESERVEDINDEX1
	Sfile.WriteLine "DAOU_RESERVEDINDEX2 : " & DAOU_RESERVEDINDEX2
	Sfile.WriteLine "DAOU_RESERVEDSTRING : " & DAOU_RESERVEDSTRING
	Sfile.WriteLine "DAOU_AUTHNO	: " & DAOU_AUTHNO

	Sfile.WriteLine chr(13)
	Sfile.Close
	Set Fso= Nothing
	Set objError= Nothing







'	DAOU_RESERVEDSTRING			= UrlDecode_GBToUtf8(DAOU_RESERVEDSTRING)


'	Response.write DAOU_RESERVEDSTRING
	DAOU_SPLIT = Split(DAOU_RESERVEDSTRING,"☞")
	DAOU_UBOUND = Ubound(DAOU_SPLIT)
'	Response.End



	Dim strName				: strName	= Trim(DAOU_SPLIT(0))
	Dim mbid1				: mbid1		= Trim(DAOU_SPLIT(1))
	Dim mbid2				: mbid2		= Trim(DAOU_SPLIT(2))

	Dim strTel				: strTel	= Trim(DAOU_SPLIT(3))
	Dim strMob				: strMob	= Trim(DAOU_SPLIT(4))

	Dim strEmail			: strEmail	= Trim(DAOU_SPLIT(5))

	Dim strZip				: strZip	= Trim(DAOU_SPLIT(6))
	Dim strADDR1			: strADDR1	= Trim(DAOU_SPLIT(7))
	Dim strADDR2			: strADDR2	= Trim(DAOU_SPLIT(8))

	Dim totalPrice			: totalPrice			= Trim(DAOU_SPLIT(9))
	Dim totalDelivery		: totalDelivery			= Trim(DAOU_SPLIT(10))
	Dim totalOptionPrice	: totalOptionPrice		= Trim(DAOU_SPLIT(11))
	Dim totalPoint			: totalPoint			= Trim(DAOU_SPLIT(12))

	Dim strOption			: strOption				= Trim(DAOU_SPLIT(13))
	Dim totalVotePoint		: totalVotePoint		= Trim(DAOU_SPLIT(14))

	Dim inUidx				: inUidx				= Trim(DAOU_SPLIT(15))
	Dim paykind				: paykind				= Trim(DAOU_SPLIT(16))
	Dim v_SellCode			: v_SellCode			= Trim(DAOU_SPLIT(17))

	Dim DtoD				: DtoD					= Trim(DAOU_SPLIT(18))			'현장수령여부 2015-03-17

	Dim cuidx				: cuidx					= Trim(DAOU_SPLIT(19))			'cart idx for delete
	arrUidx = Split(cuidx,",")


'	Dim ordersNumber	: ordersNumber = Trim(DAOU_SPLIT(24))
'	Dim strUserID		: strUserID = Trim(DAOU_SPLIT(25))

'	Response.write input_mode
'	Response.End

	'OrderNum = DAOU_RESERVEDINDEX1
	OrderNum = DAOU_ORDERNO
	OIDX = DAOU_RESERVEDINDEX2

'	For i = 0 To DAOU_UBOUND
'		Response.Write i& ":" & DAOU_SPLIT(i) & "<br />"
'	Next


'	Response.Write "@intIDX"			& OIDX & "<br />"
'	Response.Write "@OrderNum"			& orderNum & "<br />"
'	Response.Write "@totalPrice"		& totalPrice & "<br />"
'	Response.Write "@takeName"			& strName & "<br />"
'	Response.Write "@takeZip"			& strZip & "<br />"
'	Response.Write "@takeADDR1"			& strADDR1 & "<br />"
'	Response.Write "@takeADDR2"			& strADDR2 & "<br />"
'	Response.Write "@takeMob"			& strMob & "<br />"
'	Response.Write "@takeTel"			& strTel & "<br />"
'	Response.Write "@orderType"			& v_SellCode & "<br />"
'	Response.Write "@deliveryFee"		& deliveryFee & "<br />"
'	Response.Write "@payType"			& payKind & "<br />"
'	Response.Write "@payState"			& payState & "<br />"

'	Response.Write "@PGCardNum"			& PGCardNum & "<br />"
'	Response.Write "@PGAcceptNum"		& PGAcceptNum & "<br />"
'	Response.Write "@PGinstallment"		& PGinstallment & "<br />"
'	Response.Write "@PGCardCode"		& PGCardCode & "<br />"
'	Response.Write "@PGCardCom"			& PGCardCom & "<br />"
'	Response.Write "@PGACP_TIME"		& PGACP_TIME & "<br />"

'	Response.Write "@DIR_CSHR_Type"			& DIR_CSHR_Type & "<br />"
'	Response.Write "@DIR_CSHR_ResultCode"	& DIR_CSHR_ResultCode & "<br />"
'	Response.Write "@DIR_ACCT_BankCode"		& DIR_ACCT_BankCode & "<br />"

'	Response.Write "@payBankCode"			& payBankCode & "<br />"
'	Response.Write "@payBankAccNum"			& payBankAccNum & "<br />"
'	Response.Write "@payBankDate"			& payBankDate & "<br />"
'	Response.Write "@payBankSendName"		& payBankSendName & "<br />"
'	Response.Write "@payCardAcceptName"		& payCardAcceptName & "<br />"

'	Response.Write "@PGorderNum"			& DAOU_DAOUTRX & "<br />"
'	Response.End














'	If v_SellCode = "02" And nowGradeCnt < 20  Then Call ALERTS("비지니스 회원 매출은 메니져 이상만 가능합니다..","back","")


	Dim bankidx : bankidx = ""
	Dim bankingName : bankingName = ""
	Dim usePoint : usePoint = ""
'

	Dim strSSH1 : strSSH1 = ""
	Dim strSSH2 : strSSH2 = ""

	If usePoint = Null Or usePoint = "" Then usePoint = 0



	payway = "card"
	strDomain = strHostA
	strIDX = DK_SES_MEMBER_IDX
	strUserID = DAOU_RESERVEDINDEX2


'	If strTel1 <> "" And strTel2 <> "" And strTel3 <> "" Then strTel = strTel1 & "-" & strTel2 & "-" & strTel3
'	If strMob1 <> "" And strMob2 <> "" And strMob3 <> "" Then strMob = strMob1 & "-" & strMob2 & "-" & strMob3
'	If takeTel1 <> "" And takeTel2 <> "" And takeTel3 <> "" Then takeTel = takeTel1 & "-" & takeTel2 & "-" & takeTel3
'	If takeMob1 <> "" And takeMob2 <> "" And takeMob3 <> "" Then takeMob = takeMob1 & "-" & takeMob2 & "-" & takeMob3
'	If takeTel = "" Then takeTel = ""
'	If takeMob = "" Then takeMob = ""

	CARD_ACP_TIME = SETTDATE

 state = "101"


	Select Case DAOU_CARDCODE
		Case "CCAM"	: CARDCODE = "24"
		Case "CCNH"	: CARDCODE = "16"
		Case "CCCJ"	: CARDCODE = ""
		Case "CCDI"	: CARDCODE = "04"
		Case "CCHM"	: CARDCODE = "15"
		Case "CCJB"	: CARDCODE = ""
		Case "CCKE"	: CARDCODE = "01"
		Case "CCKM"	: CARDCODE = "06"
		Case "CCLG"	: CARDCODE = "14"
		Case "CCPH"	: CARDCODE = ""
		Case "CCSG"	: CARDCODE = "15"
		Case "CCSS"	: CARDCODE = "12"
		Case "CCKW"	: CARDCODE = "14"
		Case "CCKD"	: CARDCODE = ""
		Case "CCCU"	: CARDCODE = ""
		Case "CCSU"	: CARDCODE = ""
		Case "CAMF"	: CARDCODE = ""
		Case "CJCF"	: CARDCODE = "23"
		Case "CMCF"	: CARDCODE = "22"
		Case "CCLO"	: CARDCODE = "03"
		Case "CCBC"	: CARDCODE = "11"
		Case "CCSH"	: CARDCODE = "14"
		Case "CCCT"	: CARDCODE = ""
		Case "CCCH"	: CARDCODE = ""
		Case "CCHN"	: CARDCODE = "15"
		Case "CDIF"	: CARDCODE = "25"
		Case "CCKJ"	: CARDCODE = ""
		Case "CVSF"	: CARDCODE = "21"
		Case "CCSB"	: CARDCODE = ""
		Case Else : CARDCODE = ""
	End Select




		Select Case UCase(paykind)
		Case "CARD","CARD2"									  'CARD2(엠엔스 인증용카드결제 추가, 2015-11-16)
			v_C_Etc = CARDCODE &"/"&DAOU_DAOUTRX&"/"&orderNum ' 카드사코드/할부기간/주문번호
			payState = "103"

			PGCardNum			= ""				'카드번호 12자리
			PGAcceptNum			= DAOU_AUTHNO				'신용카드 승인번호
			PGinstallment		= ""			'할부기간
			PGCardCode			= CARDCODE				'신용카드사코드
			PGCardCom			= ""			'신용카드발급사
			PGACP_TIME			= SETTDATE			'이니시스승인날짜/시각

			DIR_CSHR_Type		= ""
			DIR_CSHR_ResultCode	= ""
			DIR_ACCT_BankCode	= ""
			PGACP_TIME			= ""
			payBankCode			= ""
			payBankAccNum		= ""
			payBankDate			= ""
			payBankSendName		= ""
			payCardAcceptName	= ""

		Case "DIRECTBANK"
			v_C_Etc = ACCT_BankCode&"/"&orderNum		'은행코드 / 주문번호
			payState = "103"

			PGCardNum			= ""
			PGAcceptNum			= ""
			PGinstallment		= ""
			PGCardCode			= ACCT_BankCode			'은행코드
			PGCardCom			= ""
			PGACP_TIME			= ""

			DIR_CSHR_Type		= CSHR_Type				'현금영수증 발행구분코드
			DIR_CSHR_ResultCode	= CSHR_ResultCode		'현금영수증결과코드
			DIR_ACCT_BankCode	= ACCT_BankCode			'은행코드
			PGACP_TIME			= CARD_ACP_TIME			'이니시스승인날짜/시각

			payBankCode			= ""
			payBankAccNum		= ""
			payBankDate			= ""
			payBankSendName		= ""
			payCardAcceptName	= ""

		Case "VBANK"
			v_C_Etc = VACT_Num&"/"&VACT_BankCode&"/"&VACT_Date&"/"&VACT_InputName&"/"&orderNum	'입금 계좌번호/입금은행코드/입금예정날짜/송금자명/예금주명/주문번호
			payState = "102"

			PGCardNum			= VACT_Num				'입금 계좌번호(카드번호 12자리)
			PGAcceptNum			= ""
			PGinstallment		= ""
			PGCardCode			= VACT_BankCode			'입금은행코드
			PGCardCom			= ""
			PGACP_TIME			= ""
			DIR_CSHR_Type		= ""
			DIR_CSHR_ResultCode	= ""
			DIR_ACCT_BankCode	= ""
			PGACP_TIME			= ""

			payBankCode			= VACT_BankCode			'입금은행코드
			payBankAccNum		= VACT_Num				'입금 계좌번호
			payBankDate			= VACT_Date&VACT_Time	'입금예정날짜/시간	'VACT_Date&VACT_Time
			payBankSendName		= VACT_InputName		'송금자명
			payCardAcceptName	= VACT_Name				'예금주명

	End Select


		DKP_ORDER_UPDATE_PROCEDURE = "DKP_ORDER_CARD_INFO_UPDATE3"
		'DKP_ORDER_TOTAL_PROCEDURE  = "DKP_ORDER_TOTAL2"

		'DKP_ORDER_TOTAL_PROCEDURE  = "DKP_ORDER_TOTAL_MNS2"
		DKP_ORDER_TOTAL_PROCEDURE  = "DKP_ORDER_TOTAL_MNS2_TEST"



	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum), _
		Db.makeParam("@totalPrice",adInteger,adParamInput,0,totalPrice), _
		Db.makeParam("@takeName",adVarWChar,adParamInput,100,strName), _
		Db.makeParam("@takeZip",adVarChar,adParamInput,10,strZip), _
		Db.makeParam("@takeADDR1",adVarWChar,adParamInput,512,strADDR1), _
		Db.makeParam("@takeADDR2",adVarWChar,adParamInput,512,strADDR2), _
		Db.makeParam("@takeMob",adVarChar,adParamInput,50,strMob), _
		Db.makeParam("@takeTel",adVarChar,adParamInput,50,strTel), _
		Db.makeParam("@orderType",adVarChar,adParamInput,20,v_SellCode), _
		Db.makeParam("@deliveryFee",adInteger,adParamInput,0,deliveryFee), _
		Db.makeParam("@payType",adVarChar,adParamInput,20,payKind), _
		Db.makeParam("@payState",adChar,adParamInput,3,payState), _

		Db.makeParam("@PGCardNum",adVarChar,adParamInput,50,PGCardNum), _
		Db.makeParam("@PGAcceptNum",adVarChar,adParamInput,50,PGAcceptNum), _
		Db.makeParam("@PGinstallment",adVarChar,adParamInput,50,PGinstallment), _
		Db.makeParam("@PGCardCode",adVarChar,adParamInput,50,PGCardCode), _
		Db.makeParam("@PGCardCom",adVarChar,adParamInput,50,PGCardCom), _
		Db.makeParam("@PGACP_TIME",adVarChar,adParamInput,20,PGACP_TIME), _

		Db.makeParam("@DIR_CSHR_Type",adVarChar,adParamInput,50,DIR_CSHR_Type), _
		Db.makeParam("@DIR_CSHR_ResultCode",adVarChar,adParamInput,50,DIR_CSHR_ResultCode), _
		Db.makeParam("@DIR_ACCT_BankCode",adVarChar,adParamInput,20,DIR_ACCT_BankCode), _

		Db.makeParam("@payBankCode",adVarWChar,adParamInput,50,payBankCode), _
		Db.makeParam("@payBankAccNum",adVarChar,adParamInput,50,payBankAccNum), _
		Db.makeParam("@payBankDate",adVarChar,adParamInput,50,payBankDate), _
		Db.makeParam("@payBankSendName",adVarWChar,adParamInput,100,payBankSendName), _
		Db.makeParam("@payCardAcceptName",adVarWChar,adParamInput,50,payCardAcceptName), _

		Db.makeParam("@PGorderNum",adVarchar,adParamInput,50,DAOU_DAOUTRX), _

		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec(DKP_ORDER_UPDATE_PROCEDURE,DB_PROC,arrParams,Nothing)
'	PRINT OUTPUT_VALUE


	nowTime = Now
	RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
	Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

	'수령방식 추가 (2015-03-17)
	If DtoD = "T" Then		'택배수령
		v_Rece_Type = "F"
	Else					'현장수령
		v_Rece_Type = "T"
	End If

	If CARD_Quota = "00" Then CARD_Quota = "일시불"


	'CARD_Code:카드코드 CARD_Num:카드번호 12자리 ApplNum:신용카드 승인번호 CARD_Quota:할부기간 / VACT_InputName :가상계좌송금자명
	arrParams = Array(_
		Db.makeParam("@identity",adInteger,adParamInput,4,CS_IDENTITY), _

		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,orderNum),_
		Db.makeParam("@v_SellDAte",adVarChar,adParamInput,10,RegTime),_

		Db.makeParam("@v_Etc1",adVarWChar,adParamInput,250,v_C_Etc),_
		Db.makeParam("@v_Etc2",adVarWChar,adParamInput,250,"웹주문번호:"&orderNum),_

		Db.makeParam("@BankPenName",adVarChar,adParamInput,50,""),_
		Db.makeParam("@v_C_Code",adVarChar,adParamInput,50,PGCardCode),_
		Db.makeParam("@v_C_Number1",adVarChar,adParamInput,50,PGCardNum),_
		Db.makeParam("@v_C_Number2",adVarChar,adParamInput,20,PGAcceptNum),_
		Db.makeParam("@v_C_Name1",adVarWChar,adParamInput,50,strName),_
		Db.makeParam("@v_C_Name2",adVarWChar,adParamInput,50,payBankSendName),_

		Db.makeParam("@v_C_Period1",adVarChar,adParamInput,4,""),_
		Db.makeParam("@v_C_Period2",adVarChar,adParamInput,2,""),_
		Db.makeParam("@v_C_Installment_Period",adVarChar,adParamInput,10,PGinstallment),_
		Db.makeParam("@v_C_Etc",adVarWChar,adParamInput,50,v_C_Etc),_

		Db.makeParam("@T_Time",adVarchar,adParamInput,35,Recordtime), _

		Db.makeParam("@v_Rece_Type",adChar,adParamInput,1,v_Rece_Type),_

		Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamOutput,50,""), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec(DKP_ORDER_TOTAL_PROCEDURE,DB_PROC,arrParams,Nothing)
	OUT_ORDERNUMBER = arrParams(UBound(arrParams)-1)(4)
	OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

	Select Case OUTPUT_VALUE
		Case "FINISH"
			Select Case UCase(DAOU_RESERVEDINDEX1)
				Case "MYOFFICE"						'PC마이오피스결제 카트삭제
					For i = 0 To UBound(arrUidx)
						SQL = "DELETE FROM [DK_CART] WHERE [intIDX] = ? AND [MBID] = ? AND [MBID2]=?"
						arrParams2 = Array(_
						  Db.makeParam("@intIDX",adInteger,adParamInput,0,arrUidx(i)), _
						  Db.makeParam("@MBID",adVarChar,adParamInput,20,mbid1),_
						  Db.makeParam("@MBID2",adInteger,adParamInput,0,mbid2)_
						)
						Call Db.exec(SQL,DB_TEXT,arrParams2,Nothing)
					Next
				Case "MYOFFICE_MOB"					'모바일 마이오피스 결제 카트삭제
					SQL = "DELETE [DK_CART] "
					SQL = SQL & " FROM [DK_CART] AS A, [tbl_Goods] AS B"
					SQL = SQL & " WHERE A.[ncode] = B.[ncode]"
					SQL = SQL & " AND [MBID] = ? AND [MBID2] = ? "
					SQL = SQL & " AND B.[SellCode] = ? "
					arrParams2 = Array(_
					  Db.makeParam("@MBID",adVarChar,adParamInput,20,mbid1), _
					  Db.makeParam("@MBID2",adInteger,adParamInput,0,mbid2), _
					  Db.makeParam("@SELLCODE",adVarChar,adParamInput,10,v_SellCode) _
					)
					Call Db.exec(SQL,DB_TEXT,arrParams2,Nothing)
			End Select
%>
<html>
<body>
<RESULT>SUCCESS</RESULT>
</body>
</html>
<%

		Case "ERROR"
%>
<html>
<body>
<RESULT>ERROR</RESULT>
</body>
</html>
<%
	End Select
%>
