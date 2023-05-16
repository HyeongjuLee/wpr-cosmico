<%
	arrParams = Array(_
		Db.makeParam("@strSitePK",adVarChar,adParamInput,30,DK_SITE_PK) _
	)
	Set DKFD_RS = Db.execRs("DKP_CONF_SITEPK",DB_PROC,arrParams,Nothing)
	If Not DKFD_RS.BOF And Not DKFD_RS.EOF Then
		DKCONF_SITE_TITLE		= DKFD_RS("strSiteTitle")
		DKCONF_SITE_ADMIN		= DKFD_RS("intAdminLevel")
		DKCONF_SITE_TYPE		= DKFD_RS("strSiteType")
		DKCONF_SITE_ENC			= DKFD_RS("isEncType")
		DKCONF_SITE_PATH		= DKFD_RS("strSiteEng")
		DKCONF_FAVICON			= DKFD_RS("strFavicon")

		DKFD_PGMOD				= DKFD_RS("PGMOD")
		DKCONF_ISCSNEW			= DKFD_RS("isCSNew")		'CS신버전 여부	'암호화필드판단, (이메일, 웹아이디,웹패스워드)

	Else
		'Call ALERTS("설정되지 않은 사이트입니다.","back","")
		Call ALERTS(LNG_STRFUNCDATA_TEXT01,"back","")
	End If
	Call CloseRS(DKFD_RS)





'	If PGIDS = "" Then PGIDS = "aegis"

'	PGURL = DKCONF_SITE_LINK
	PGTITLE = DKCONF_SITE_TITLE


'	SQL = "SELECT COUNT([vNum]) FROM [visit_COUNTER]"
'	TotalVisitCnt = Db.execRsData(SQL,DB_TEXT,Nothing,Nothing)

	VisitYY = Year(nowTime)
	VisitMM = Month(nowTime)
	VisitDD = Day(nowTime)


'	SQL = "SELECT COUNT([vNum]) FROM [visit_COUNTER] WHERE [vYY] = ? AND [vMM] = ? AND [vDD] = ?"
	arrParams = Array(_
		Db.makeParam("@vYY",adSmallInt,adParamInput,0,VisitYY), _
		Db.makeParam("@vMM",adTinyInt,adParamInput,0,VisitMM), _
		Db.makeParam("@vDD",adTinyInt,adParamInput,0,VisitDD), _
		Db.makeParam("@TotalVisitCnt",adInteger,adParamOutput,0,0), _
		Db.makeParam("@todayVisitCnt",adInteger,adParamOutput,0,0) _
	)
'	todayVisitCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
	Call Db.exec("DKP_CONF_COUNTERS",DB_PROC,arrParams,Nothing)
	TotalVisitCnt = arrParams(3)(4)
	todayVisitCnt = arrParams(4)(4)


	'마이오피스 게시판
	Function FnNoticeTF(ByVal values)
		Select Case values
			Case "T" : FnNoticeTF = "<span class=""red"";>"&LNG_STRFUNCDATA_TEXT01&"</span> "&LNG_STRFUNCDATA_TEXT02&""
			Case "F" : FnNoticeTF = LNG_STRFUNCDATA_TEXT04
		End Select
	End Function


	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID)_
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RSS_strName		= DKRS("strName")
		RSS_strNickName	= DKRS("strNickName")
		RSS_isViewID	= DKRS("isViewID")
	Else
		RSS_strName		= DK_MEMBER_ID
		RSS_strNickName	= DK_MEMBER_ID
		RSS_isViewID	= "N"
	End If
	Call CloseRS(DKRS)


	MBID2_LEN = 8
	SAVE_MENU_USING = False
	NOM_MENU_USING = False

	If DK_MEMBER_TYPE = "COMPANY" Then
		'▣마이오피스관련▣

			'▣CS 회원번호 뒷자리 길이
			'SQL_2LEN = "SELECT [Member_Code2] FROM [tbl_Config] WITH(NOLOCK)"
			'MBID2_LEN = Db.execRsData(SQL_2LEN,DB_TEXT,Nothing,DB3)

			'▣CS 회원번호 뒷자리 길이, 후원인/추천인 메뉴 사용
			SQL_CONFIG = "SELECT TOP(1) [Member_Code2],[save_uging_Pr_Flag],[nom_uging_Pr_Flag] FROM [tbl_Config] WITH(NOLOCK) "
			Set HJRS = Db.execRs(SQL_CONFIG,DB_TEXT,Nothing,DB3)
			If Not HJRS.BOF And Not HJRS.EOF Then
				MBID2_LEN = HJRS("Member_Code2")
				save_uging_Pr_Flag = HJRS("save_uging_Pr_Flag")
				nom_uging_Pr_Flag = HJRS("nom_uging_Pr_Flag")
				If save_uging_Pr_Flag = "10" Then SAVE_MENU_USING = True
				If nom_uging_Pr_Flag = "10" Then NOM_MENU_USING = True
			Else
				MBID2_LEN = 8
				SAVE_MENU_USING = False
				NOM_MENU_USING = False
			End If
			Call closeRs(HJRS)

			'회원정보
			DarrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			Set DKRSG = Db.execRs("HJP_CS_MEMBER_INFO",DB_PROC,DarrParams,DB3)
			If Not DKRSG.BOF And Not DKRSG.EOF Then
				nowGrade		= DKRSG(0)	'직급
				nowGradeCnt		= DKRSG(1)
				RS_BusinessName	= DKRSG(2)
				Sell_Mem_TF		= DKRSG(3)
				DKRSG_Na_Code	= DKRSG("Na_Code")
				DKRSG_cpno		= DKRSG("cpno")
				DKRSG_LeaveCheck = DKRSG("LeaveCheck")
				DKRSG_LeaveDate	 = DKRSG("LeaveDate")
				DKRSG_CurPoint		= DKRSG("CurPoint")
				DKRSG_CurPointName	= DKRSG("CurPointName")

				'회원탈퇴시 세션(쿠키)초기화
				If DKRSG_LeaveCheck = "0" Or DKRSG_LeaveDate <> "" Then
					Call FN_MEMBER_LOGOUT(LNG_MEMBER_LOGINOK_ALERT08)
				End If

				'Sell_Mem_TF 세션(쿠키) 비교
				If CStr(Sell_Mem_TF) <> CStr(DK_MEMBER_STYPE) Then
					Call FN_MEMBER_LOGOUT(LNG_STRCHECK_TEXT03&" - Sell_Mem_TF")
				End If

				'Na_Code 세션(쿠키) 비교
				If UCase(DKRSG_Na_Code) <> UCase(DK_MEMBER_NATIONCODE) Then
					Call FN_MEMBER_LOGOUT(LNG_STRCHECK_TEXT03&" - Na_Code")
				End If

				If nowGrade = "" Then nowGrade = ""

				'▣cpno(함수)체크
				Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					On Error Resume Next
						If DKRSG_cpno <> "" Then DKRSG_cpno	 = objEncrypter.Decrypt(DKRSG_cpno)				'▣cpno
					On Error GoTo 0
				Set objEncrypter = Nothing

				F_CPNO_CHANGE_TF = "F"
				If DK_MEMBER_TYPE = "COMPANY" And Sell_Mem_TF = "0" Then
					If juminCheck(DKRSG_cpno) = 0 Then '유효하지 않음
						F_CPNO_CHANGE_TF = "T"			'주민번호 변경필요!
					Else
						F_CPNO_CHANGE_TF = "F"
					End If
				End If
				'print F_CPNO_CHANGE_TF

			Else
				Call FN_MEMBER_LOGOUT(LNG_JS_MEMBER_LEVEL_NO_EXIST)
			End If
			Call closeRS(DKRSG)

			'▣ 대수제한 설정
				If nowGradeCnt < 60 Then '코즈미코 본부장(60) 직급 이하 2대까지 보임
					CS_LIMIT_LEVEL = 2		'대수까지      , sFrmSubmit anchor작동 X
					If CS_LIMIT_LEVEL > 0 Then
						IS_LIMIT_LEVEL = True
					End IF
				End IF
			'▣ 대수제한 설정


			MILEAGE_TOTAL = 0
			MILEAGE2_TOTAL = 0
			MILEAGE3_TOTAL = 0
			IF isSHOP_POINTUSE = "T" Then

				'▣SHOP CS포인트 사용관련
				'##### DAOU 일반 카드결제 사용 시 /PG/DAOU/DAOU_FUNCTION.ASP 적용확인 #######
				CONST_CS_POINTUSE_MIN	= CDbl(0)

				'포인트1 이체/출금
				CONST_CS_TRANS_UNIT				= CDbl(1000)		'이체액단위
				CONST_CS_MINIMUM_TRANS_POINT	= CDbl(5000)		'최소이체액
				CONST_CS_FEE_PERCENT_TRANS		= CDbl(0)			'[이체] 수수료(율)
				CONST_CS_WITHDRAW_UNIT			= CDbl(10000)		'출금액단위
				CONST_CS_MINIMUM_WITHDRAW_POINT	= CDbl(30000)		'최소출금액
				CONST_CS_FEE_PERCENT_WITHDRAW	= CDbl(0)			'[출금] 수수료(율)

				'포인트2 이체/출금
				CONST_CS_TRANS_UNIT_2				= CDbl(1000)		'이체액단위
				CONST_CS_MINIMUM_TRANS_POINT_2	= CDbl(1000)		'최소이체액
				CONST_CS_FEE_PERCENT_TRANS_2		= CDbl(0)			'[이체] 수수료(율)
				CONST_CS_WITHDRAW_UNIT_2			= CDbl(10000)		'출금액단위
				CONST_CS_MINIMUM_WITHDRAW_POINT_2	= CDbl(20000)		'최소출금액
				CONST_CS_FEE_PERCENT_WITHDRAW_2	= CDbl(0)			'[출금] 수수료(율)

				'포인트3 이체/출금
				CONST_CS_TRANS_UNIT_3				= CDbl(1000)		'이체액단위
				CONST_CS_MINIMUM_TRANS_POINT_3	= CDbl(1000)		'최소이체액
				CONST_CS_FEE_PERCENT_TRANS_3		= CDbl(0)			'[이체] 수수료(율)
				CONST_CS_WITHDRAW_UNIT_3			= CDbl(10000)		'출금액단위
				CONST_CS_MINIMUM_WITHDRAW_POINT_3	= CDbl(40000)		'최소출금액
				CONST_CS_FEE_PERCENT_WITHDRAW_3	= CDbl(0)			'[출금] 수수료(율)

				'▣ 포인트1
				CarrParams = Array(_
					Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
					Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
				)
				Set HJRSC = Db.execRs("HJP_MILEAGE_INFO",DB_PROC,CarrParams,DB3)
				If Not HJRSC.BOF And Not HJRSC.EOF Then
					PLUS_TOTAL_MILEAGE  = HJRSC(0)
					MINUS_TOTAL_MILEAGE = HJRSC(1)
					PLUS_TOTAL_MILEAGE_AVAIL	= HJRSC(2)
					PLUS_TOTAL_MILEAGE_NOTAVAIL = HJRSC(3)
				Else
					PLUS_TOTAL_MILEAGE  = 0
					MINUS_TOTAL_MILEAGE = 0
					PLUS_TOTAL_MILEAGE_AVAIL	= 0
					PLUS_TOTAL_MILEAGE_NOTAVAIL = 0
				End If
				Call closeRS(HJRSC)
				MILEAGE_TOTAL = PLUS_TOTAL_MILEAGE_AVAIL - MINUS_TOTAL_MILEAGE		'사용가능 마일리지(지급일자 지난 포인트)

				If 1=2 Then
					'▣ 포인트2
					CarrParams = Array(_
						Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
						Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
					)
					Set HJRSC = Db.execRs("HJP_MILEAGE_INFO_2",DB_PROC,CarrParams,DB3)
					If Not HJRSC.BOF And Not HJRSC.EOF Then
						PLUS_TOTAL_MILEAGE2  = HJRSC(0)
						MINUS_TOTAL_MILEAGE2 = HJRSC(1)
						PLUS_TOTAL_MILEAGE2_AVAIL	= HJRSC(2)
						PLUS_TOTAL_MILEAGE2_NOTAVAIL = HJRSC(3)
					Else
						PLUS_TOTAL_MILEAGE2  = 0
						MINUS_TOTAL_MILEAGE2 = 0
						PLUS_TOTAL_MILEAGE2_AVAIL	= 0
						PLUS_TOTAL_MILEAGE2_NOTAVAIL = 0
					End If
					Call closeRS(HJRSC)
					MILEAGE2_TOTAL = PLUS_TOTAL_MILEAGE2_AVAIL - MINUS_TOTAL_MILEAGE2		'사용가능 마일리지(지급일자 지난 포인트)
				End If

				If 1=2 Then
					'▣ 포인트3
					CarrParams = Array(_
						Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
						Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
					)
					Set HJRSC = Db.execRs("HJP_MILEAGE_INFO_3",DB_PROC,CarrParams,DB3)
					If Not HJRSC.BOF And Not HJRSC.EOF Then
						PLUS_TOTAL_MILEAGE3  = HJRSC(0)
						MINUS_TOTAL_MILEAGE3 = HJRSC(1)
						PLUS_TOTAL_MILEAGE3_AVAIL	= HJRSC(2)
						PLUS_TOTAL_MILEAGE3_NOTAVAIL = HJRSC(3)
					Else
						PLUS_TOTAL_MILEAGE3  = 0
						MINUS_TOTAL_MILEAGE3 = 0
						PLUS_TOTAL_MILEAGE3_AVAIL	= 0
						PLUS_TOTAL_MILEAGE3_NOTAVAIL = 0
					End If
					Call closeRS(HJRSC)
					MILEAGE3_TOTAL = PLUS_TOTAL_MILEAGE3_AVAIL - MINUS_TOTAL_MILEAGE3		'사용가능 마일리지(지급일자 지난 포인트)
				End If

			End If


		'If UCase(DK_MEMBER_NATIONCODE) = "KR" Then MILEAGE_TOTAL = 0
			'▣ 구매체크
		'	SQL1 = "SELECT ISNULL(COUNT([OrderNumber]),0) FROM [tbl_salesdetail]"
		'	SQL1 = SQL1 & " WHERE [mbid] = ? AND [mbid2] = ? "
		'	SQL1 = SQL1 & "		AND [ReturnTF] = 1 "		'정상판매
		'	arrParams = Array(_
		'		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		'		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
		'	)
		'	MEMBER_ORDER_CHK = Db.execRsData(SQL1,DB_TEXT,arrParams,DB3)

		'	'▣승인된 회원매출(01) 카운트(스피나 2017-05-11)
		'	arrParams = Array(_
		'		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		'		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
		'	)
		'	MEMBER_APPROVED_ORDER_CHK01 = Db.execRsData("HJP_TOTAL_SALES_COUNT01_APPROVED",DB_PROC,arrParams,DB3)

		'	'▣회원매출 카운트 전체(스피나 2017-05-11)
		'	arrParams = Array(_
		'		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		'		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
		'	)
		'	MEMBER_ORDER_CHK01_ALL = Db.execRsData("HJP_TOTAL_SALES_COUNT01_ALL",DB_PROC,arrParams,DB3)

	End If

%>
