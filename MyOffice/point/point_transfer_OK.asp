<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/strFuncClosePay.asp"-->
<!--#include virtual = "/MyOffice\point\_point_Config.asp"-->
<!--#include virtual = "/_lib/KISA_SHA256.asp"-->
<%
	Call ONLY_CS_MEMBER()						'판매원만
	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call No_Refresh()

	'이체비번 등록 확인
	If CONFIG_SendPassWord = "" Then Call ALERTS(LNG_JS_MONEY_OUTPUT_PIN,"go",MOB_PATH&"/mypage/member_info.asp")

	If 1=2 Then
		If CONFIG_CPNO_OK = "F" Then
			If FN_CLOSEPAY_TOTAL(DK_MEMBER_ID1,DK_MEMBER_ID2) > 0 Then
				Call ALERTS("주민번호가 등록되지 않은 경우 신청을 할 수 없습니다. \n\n주민번호는 마이페이지에서 입력가능합니다.","GO",MOB_PATH&"/mypage/member_info.asp")
			Else
				Call ALERTS("발생한 수당이 없습니다. (불가)","BACK","")
			End IF
		End If

		If CONFIG_BANKINFO = "F" Then
			Call ALERTS("계좌번호가 등록되지 않은 경우 신청을 할 수 없습니다.","back","")
		End If
	End If

'▣체크변수
	Dim Google_OTP		: Google_OTP		= pRequestTF("Google_OTP",False)
	Dim pointCheckTF	: pointCheckTF		= pRequestTF("pointCheckTF",True)	'입력값 확인TF
	Dim OIDX			: OIDX				= pRequestTF("OIDX",True)
	Dim OrderNum		: OrderNum			= pRequestTF("OrderNum",True)

	'마일리지123 분기 / 치환  =============================================S
	Select Case Left(OrderNum,4)
		Case "PT1_"		'mileage
			MILEAGE_TOTAL = MILEAGE_TOTAL
			TRANS_UNIT	  = CONST_CS_TRANS_UNIT						'이체액단위
			MINIMUM_POINT = CONST_CS_MINIMUM_TRANS_POINT	'최소이체액
			MAXIMUM_POINT = CDbl(MILEAGE_TOTAL)						'최대이체액
			FEE_PERCENT		= CONST_CS_FEE_PERCENT_TRANS		'이체 수수료(율)
			GO_URL_QS = "?mn=1"
			TBL_NAME = "tbl_Member_Mileage"

		Case "PT2_"		'Bo
			Call alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
			MILEAGE_TOTAL = MILEAGE2_TOTAL
			TRANS_UNIT	  = CONST_CS_TRANS_UNIT_2						'이체액단위
			MINIMUM_POINT = CONST_CS_MINIMUM_TRANS_POINT_2	'최소이체액
			MAXIMUM_POINT = CDbl(MILEAGE_TOTAL)							'최대이체액
			FEE_PERCENT		= CONST_CS_FEE_PERCENT_TRANS_2		'이체 수수료(율)
			GO_URL_QS = "?mn=2"
			TBL_NAME = "tbl_Member_Mileage_Bo"

		Case "PT3_"		'Za
			Call alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
			MILEAGE_TOTAL = MILEAGE3_TOTAL
			TRANS_UNIT	  = CONST_CS_TRANS_UNIT_3						'이체액단위
			MINIMUM_POINT = CONST_CS_MINIMUM_TRANS_POINT_3	'최소이체액
			MAXIMUM_POINT = CDbl(MILEAGE_TOTAL)							'최대이체액
			FEE_PERCENT		= CONST_CS_FEE_PERCENT_TRANS_3		'이체 수수료(율)
			GO_URL_QS = "?mn=3"
			TBL_NAME = "tbl_Member_Mileage_Za"

		Case Else
			Call alerts(LNG_ALERT_WRONG_ACCESS,"BACK","")
	End Select

	GO_URL = "point_transfer.asp"&GO_URL_QS
	'마일리지123 분기 / 치환  =============================================E


'▣개별 변수 받아오기
	Dim transPoint		: transPoint		= pRequestTF("transPoint",True)
	Dim transPointChk	: transPointChk		= pRequestTF("transPointChk",True)		'입력값 변동체크

	Dim transPointFEE	: transPointFEE		= pRequestTF("transPointFEE",True)		'이체수수료
	Dim SendPassWord	: SendPassWord		= pRequestTF("SendPassWord",True)		'이체비밀번호(입력)

	'▣SHA=256 암호비교(UCase!!)
	SendPassWord = UCase(SHA256_Encrypt(SendPassWord))

'▣이체비밀번호(Ori)
	Dim ORI_SendPassWord : ORI_SendPassWord	= CONFIG_SendPassWord

	If SendPassWord = "" Then Call alerts(LNG_JS_PASSWORD_TRANSFER&"06","GO",GO_URL)
	If ORI_SendPassWord <> SendPassWord Then Call alerts(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT07&"07","GO",GO_URL)

	If GOOGLE_OTP_USE_TF = "T" Then
		If Google_OTP <> "T" Then Call ALERTS(LNG_GOOGLE_OTP_NOT&"_N01","GO",GO_URL)
	End If

	If pointCheckTF <> "T" Then Call ALERTS("No pointCheckTF","GO",GO_URL)
	If OIDX = "" Or OrderNum = "" Then Call ALERTS(LNG_BOARD_HANDLER_TEXT07&"_N03","GO",GO_URL)

'▣금액비교
	transPoint		= CDbl(CStr(transPoint))
	transPointFEE	= CDbl(CStr(transPointFEE))
''	transPointTOTAL = CDbl(CStr(transPoint))						'총 출금액(수수료 포함)
	transPointTOTAL = CDbl(CStr(transPoint + transPointFEE))		'총 출금액(수수료 제외)

'	Call ResRW(transPoint,		"transPoint_______")
'	Call ResRW(transPointFEE,	"transPointFEE___")
'	Call ResRW(transPointTOTAL, "transPointTOTAL")
'	Call ResRW(MILEAGE_TOTAL,"MILEAGE_TOTAL")

'▣ 소수점 비교에러 추가 S =====================
	MILEAGE_TOTAL = CDbl(CStr(MILEAGE_TOTAL))
'▣ 소수점 비교에러 추가 E =====================

	If CDbl(transPointTOTAL) < CDbl(MINIMUM_POINT) Then Call ALERTS(LNG_CS_POINT_TRANSFER_JS07&"01","GO",GO_URL)
	If transPoint Mod TRANS_UNIT <> 0 Then Call ALERTS(LNG_ALERT_POINT_BY_POINT_UNIT& "("&num2cur(TRANS_UNIT)&")","GO",GO_URL)

	If IsNumeric(transPoint) = False Then Call ALERTS(LNG_CS_POINT_TRANSFER_OK_ALERT01&"03","GO",GO_URL)
	If CDbl(transPointTOTAL) > CDbl(MILEAGE_TOTAL) Then Call ALERTS(LNG_CS_POINT_TRANSFER2CASH_OK_ALERT03&"05","GO",GO_URL)


'▣주문처리페이지 접근시간(updateDate1)
	arrParamUU = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum),_
		Db.makeParam("@hostIP",adVarChar,adParamInput,50,getUserIP), _
		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
	)
	Call Db.exec("HJP_POINT_CHECK_UPDATE_UPDATDATE1",DB_PROC,arrParamUU,DB3)



'▣검증
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
		Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum) _
	)
	Set AHJRS = Db.execRs("HJP_POINT_CHECK_VIEW",DB_PROC,arrParams,DB3)
	If Not AHJRS.BOF And Not AHJRS.EOF Then
		AHJRS_intIDX			= AHJRS("intIDX")
		AHJRS_OrderNum			= AHJRS("OrderNum")
		AHJRS_MBID				= AHJRS("MBID")
		AHJRS_MBID2				= AHJRS("MBID2")
		AHJRS_strUsePageName	= AHJRS("strUsePageName")
		AHJRS_GoogleOTPCheck	= AHJRS("GoogleOTPCheck")
		AHJRS_BTC_qoute			= AHJRS("BTC_qoute")
		AHJRS_BTC_QOUTE_1USD	= AHJRS("BTC_QOUTE_1USD")
		AHJRS_FEE_PERCENT		= AHJRS("FEE_PERCENT")
		AHJRS_transPointTOTAL	= AHJRS("transPointTOTAL")
		AHJRS_transPoint		= AHJRS("transPoint")
		AHJRS_transPointFEE		= AHJRS("transPointFEE")
		AHJRS_WITHDRAW_UNIT		= AHJRS("WITHDRAW_UNIT")		'출금(이체)액단위
		AHJRS_MINIMUM_POINT		= AHJRS("MINIMUM_POINT")
		AHJRS_MAXIMUM_POINT		= AHJRS("MAXIMUM_POINT")
		AHJRS_btc_usd			= AHJRS("btc_usd")
		AHJRS_btc_usd_PERCENT	= AHJRS("btc_usd_PERCENT")
		AHJRS_TranBTC			= AHJRS("TranBTC")
		AHJRS_regDate			= AHJRS("regDate")
		AHJRS_updateDate1		= AHJRS("updateDate1")
		If IsNull(AHJRS_updateDate1) = True Then AHJRS_updateDate1 = ""

		'이체 ============================================================================
			HJRSC_BTC_qoute		= 0
		'이체 ============================================================================

		'▣ OTP 2차검증
		If GOOGLE_OTP_USE_TF = "T" Then
			If AHJRS_GoogleOTPCheck <> "T" Then Call ALERTS(LNG_GOOGLE_OTP_NOT&"_N04","GO",GO_URL)
		End If

		'▣ 세션 유효시간 체크 (5분)
		If Abs(Datediff("n", AHJRS_regDate, now())) >= 5 Then Call ALERTS("Your session has expired!","GO",GO_URL)

		If AHJRS_updateDate1 <> "" Then

			'#1-2 동시 중복주문 세션체크(30초) updateDate1 기준
			arrParamsDC = Array(_
				Db.makeParam("@sessionIDX",adVarChar,adParamInput,50,DK_SES_MEMBER_IDX),_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			DUPLICATE_ORDER_POINT_SESSION_CHECK_2 = Db.execRsData("HJP_DUPLICATE_ORDER_POINT_SESSION_CHECK_2",DB_PROC,arrParamsDC,DB3)

			If DUPLICATE_ORDER_POINT_SESSION_CHECK_2 <> "" Then
				'▣중복주문시 주문번호 UPDATE
				arrParamsDP = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
					Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum),_
					Db.makeParam("@sessionIDX",adVarChar,adParamInput,50,DK_SES_MEMBER_IDX),_
					Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
				)
				Call Db.exec("HJP_ORDER_POINT_DUPLICATE_SESSION_BLOCK",DB_PROC,arrParamsDP,DB3)
				OUTPUT_VALUE_DP = arrParamsDP(Ubound(arrParamsDP))(4)

				Call ALERTS("중복 로그인 주문입니다. 로그아웃합니다.!","GO","/common/member_logout.asp")
				Response.End
			End If

		End If


		'▣ 위변조체크(Form)
		If CDbl(transPointFEE) <> CDbl(AHJRS_transPointFEE)		Then Call ALERTS("Data modulation (transPointFEE)!","GO",GO_URL)
		If CDbl(transPoint) <> CDbl(AHJRS_transPoint)			Then Call ALERTS("Data modulation (transPoint)!","GO",GO_URL)
		If CDbl(transPointChk) <> CDbl(AHJRS_transPoint)		Then Call ALERTS("Data modulation (transPointChk)!","GO",GO_URL)
		If CDbl(transPointTOTAL) <> CDbl(AHJRS_transPointTOTAL)	Then Call ALERTS("Data modulation (transPointTOTAL)!","GO",GO_URL)

		If CDbl(HJRSC_BTC_qoute) <> CDbl(AHJRS_BTC_qoute)				Then Call ALERTS("Data modulation (BTC_qoute)!","GO",GO_URL)
		If CDbl(FEE_PERCENT) <> CDbl(AHJRS_FEE_PERCENT)					Then Call ALERTS("Data modulation (FEE_PERCENT)!","GO",GO_URL)
		If CDbl(num2Cur(MINIMUM_POINT)) <> CDbl(AHJRS_MINIMUM_POINT)	Then Call ALERTS("Data modulation (MINIMUM_POINT)!","GO",GO_URL)
		If CDbl(num2Cur(TRANS_UNIT)) <> CDbl(AHJRS_WITHDRAW_UNIT) Then Call ALERTS("Data modulation (WITHDRAW_UNIT)!","GO",GO_URL)


		'▣최소출금 확인
		If CDbl(transPoint) < CDbl(num2Cur(MINIMUM_POINT)) Then
			Call ALERTS(LNG_MINIMUM_TRANS_POINT&" : ("&MINIMUM_POINT&") !","GO",GO_URL)
		End If

		'▣총출금액 확인
		If CDbl(MILEAGE_TOTAL) < CDbl(num2Cur(transPointTOTAL)) Then
			Call ALERTS(LNG_CS_POINT_TRANSFER2CASH_JS02&" !","GO",GO_URL)
		End If

	Else
		Call ALERTS(LNG_TEXT_NO_DATA&"(02)","GO",GO_URL)
	End If
	Call CloseRS(AHJRS)

%>
<%
'▣개별 변수 받아오기(이체회원)
	Dim NominID1		: NominID1			= pRequestTF("NominID1",True)
	Dim NominID2		: NominID2			= pRequestTF("NominID2",True)
	Dim NominWebID		: NominWebID		= pRequestTF("NominWebID",False)
	Dim NominChk		: NominChk			= pRequestTF("NominChk",True)
	Dim targetName		: targetName		= pRequestTF("targetName",True)
%>
<%
	Call Db.beginTrans(Nothing)


	'71	이체+
	'72	이체-

	'마일리지 보내기 -
	'SQL = "INSERT INTO [tbl_Member_Mileage] ("
	SQL = "INSERT INTO ["&TBL_NAME&"] ("
	SQL = SQL & "[T_Time],[mbid],[mbid2],[M_Name],[MinusValue],[MinusKind],[Minus_OrderNumber],[User_id],[ETC1],[hostIP]"
	SQL = SQL & " ) VALUES ( "
	SQL = SQL & " CONVERT(VARCHAR,GETDATE(),121),?,?,?,?,?,?,?,?,? "
	SQL = SQL & " )"
		SQL = SQL & "SELECT ? = @@IDENTITY"

	arrParams = Array(_
		Db.makeParam("@v_Mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@v_Mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
		Db.makeParam("@v_Name",adVarWchar,adParamInput,100,DK_MEMBER_NAME), _
		Db.makeParam("@v_InputMile",adInteger,adParamInput,30,transPointTOTAL), _
		Db.makeParam("@MinusKind",adVarchar,adParamInput,2,"72"), _
		Db.makeParam("@v_OrderNumber",adVarchar,adParamInput,30,NominID1&"-"&Right("0000000000"&NominID2,MBID2_LEN)), _
		Db.makeParam("@User_id",adVarchar,adParamInput,30,"web"), _
		Db.makeParam("@ETC1",adVarWchar,adParamInput,300,""), _
		Db.makeParam("@hostIP",adVarChar,adParamInput,50,getUserIP), _
			Db.makeParam("@IDENTITY",adInteger,adParamOutput,0,0) _
	)
	Call Db.exec(SQL,DB_TEXT,arrParams,DB3)
	CS_T_IDENTITY = arrParams(UBound(arrParams))(4)

	'(상대방이) 마일리지 받기 +
	'SQL = "INSERT INTO [tbl_Member_Mileage] ("
	SQL = "INSERT INTO ["&TBL_NAME&"] ("
	SQL = SQL & "[T_Time],[mbid],[mbid2],[M_Name],[PlusValue],[PlusKind],[Plus_OrderNumber],[User_id],[ETC1],[hostIP]"
	SQL = SQL & " ) VALUES ( "
	SQL = SQL & " CONVERT(VARCHAR,GETDATE(),121),?,?,?,?,?,?,?,?,? "
	SQL = SQL & " )"
	arrParams = Array(_
		Db.makeParam("@v_Mbid",adVarChar,adParamInput,20,NominID1), _
		Db.makeParam("@v_Mbid2",adInteger,adParamInput,0,NominID2), _
		Db.makeParam("@v_Name",adVarWchar,adParamInput,100,targetName), _
		Db.makeParam("@v_InputMile",adInteger,adParamInput,30,transPoint), _
		Db.makeParam("@PlusKind",adVarchar,adParamInput,2,"71"), _
		Db.makeParam("@v_OrderNumber",adVarchar,adParamInput,30,DK_MEMBER_ID1&"-"&Right("0000000000"&DK_MEMBER_ID2,MBID2_LEN)), _
		Db.makeParam("@User_id",adVarchar,adParamInput,30,"web"), _
		Db.makeParam("@ETC1",adVarWchar,adParamInput,300,""), _
		Db.makeParam("@hostIP",adVarChar,adParamInput,50,getUserIP) _
	)
	Call Db.exec(SQL,DB_TEXT,arrParams,DB3)

	'▣ 마일리지 테이블 T_index값 UPDATE / TEMP주문 삭제
	On Error Resume Next
	If CS_T_IDENTITY > 0 Then
		arrParamsPU = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,0,OIDX), _
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum), _
			Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
			Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
			Db.makeParam("@strUsePageName",adVarChar,adParamInput,50,AHJRS_strUsePageName),_
			Db.makeParam("@CS_T_index",adInteger,adParamInput,0,CS_T_IDENTITY), _

			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("HJP_POINT_INFO_UPDATE_FINISH",DB_PROC,arrParamsPU,DB3)
		OUTPUT_VALUE = arrParamsPU(UBound(arrParamsPU))(4)
	End If
	On Error GoTo 0


	Call Db.finishTrans(Nothing)

	If MOB_PATH = "/m" Then
		chgPath = "/m"
	Else
		chgPath = "/myoffice"
	End If

	If Err.Number <> 0 Then
		Call ALERTS(LNG_ALERT_UPDATE_ERROR,"back","")
	Else
		Call ALERTS(LNG_CS_POINT_TRANSFER_OK_ALERT05,"GO",chgPath&"/point/point_list.asp"&GO_URL_QS)
	End If




%>
