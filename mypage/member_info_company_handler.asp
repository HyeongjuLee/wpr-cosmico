<!--#include virtual = "/_lib/strFunc.asp" -->
<%
	pT = gRequestTF("pt",False)
	If pt = "" Then pt = ""

	If pT = "shop" Then
		PAGE_SETTING = "SHOP_MYPAGE"
		ptshop = "?pt=shop"
	Else
		PAGE_SETTING = "MYPAGE"
		ptshop = ""
	End If


	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	PAGE_MODE = "PAGE"
	PAGE_SETTING = "MYPAGE"
	view = 1
%>
<!--#include virtual = "/_lib/strFuncJoin.asp"-->
<!--#include virtual = "/_include/document.asp"-->
</head>
<body>
<%

	If Not checkRef(houUrl &"/mypage/member_info.asp") Then Call alerts(LNG_ALERT_WRONG_ACCESS,"go","/mypage/member_info.asp")

	' 값 받아오기
		strPass			= pRequestTF("strPass",True)

		isChgPass		= pRequestTF("isChgPass",False)
		newPass			= pRequestTF("newPass",False)
		newPass2		= pRequestTF("newPass2",False)

		strMobile		= pRequestTF("strMobile",False)

		strZip			= pRequestTF("strzip",False)
		strADDR1		= pRequestTF("strADDR1",False)
		strADDR2		= pRequestTF("strADDR2",False)

		strEmail		= pRequestTF("strEmail",False)

		strTel			= pRequestTF("strTel",False)

		strBirth1		= pRequestTF("birthyy",True)
		strBirth2		= pRequestTF("birthmm",True)
		strBirth3		= pRequestTF("birthdd",True)
		isSolar			= pRequestTF("isSolar",True)

		isMailing		= pRequestTF("sendemail",False)
		isSMS			= pRequestTF("sendsms",False)

		bankCode	 = pRequestTF("bankCode",False)
		bankOwner	 = pRequestTF("bankOwner",False)
		bankNumber	 = pRequestTF("bankNumber",False)

		ori_bankCode	= pRequestTF("ori_bankCode",False)
		ori_bankOwner	= pRequestTF("ori_bankOwner",False)
		ori_bankNumber	= pRequestTF("ori_bankNumber",False)

		If bankCode		= "" Then bankCode		= ori_bankCode
		If bankOwner	= "" Then bankOwner		= ori_bankOwner
		If bankNumber	= "" Then bankNumber	= ori_bankNumber

		'▣cpno 변경
		cpno_Check	= pRequestTF("cpno_Check",False)
		agreement	= pRequestTF("agreement",False)

		If agreement = "T" Then						'약관 동의시 주민번호 입력
			strSSH1	= pRequestTF("ssh1",False)
			strSSH2	= pRequestTF("ssh2",False)
		Else
			SQL_CPNO = "SELECT [cpno] FROM [tbl_memberInfo] WITH(NOLOCK) WHERE [mbid] = ? AND [mbid2] = ?"
			arrParams_CPNO = Array(_
				Db.makeParam("@DK_MEMBER_ID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
			)
			ORI_CPNO = Db.execRsData(SQL_CPNO,DB_TEXT,arrParams_CPNO,DB3)

			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If ORI_CPNO <> "" Then DEC_cpno = objEncrypter.Decrypt(ORI_CPNO)
				On Error GoTo 0
			Set objEncrypter = Nothing

			If DEC_cpno <> "" And Len(DEC_cpno) = 13 Then		'정상주민번호 자릿수
				DEC_strSSH1 = Left(DEC_cpno,6)
				DEC_strSSH2 = Right(DEC_cpno,7)
			Else
				DEC_strSSH1 = ""
				DEC_strSSH2 = ""
			End If

			strSSH1	= DEC_strSSH1
			strSSH2	= DEC_strSSH2
		End If
		strSSH  = strSSH1 & strSSH2

		CPNO_CHANGE_TF	= pRequestTF("CPNO_CHANGE_TF",False)

		'Call ResRW(cpno_Check		,"cpno_Check")
		'Call ResRW(strSSH1		,"strSSH1")
		'Call ResRW(strSSH2		,"strSSH2")
		'Call ResRW(strSSH		,"strSSH")
		'Call ResRW(agreement		,"agreement")
		'Response.end

		If agreement = "T" And CPNO_CHANGE_TF = "T" Then		'주민번호 입력시
			If cpno_Check <> "T" Then Call ALERTS("주민번호 중복체크를 하셔야합니다..","back","")

			If juminCheck(strSSH) = 0 Then	'유효하지 않음
				Call ALERTS("유효하지 않은 주민 번호입니다. 다시한번 확인해주세요.","back","")
			End If
		End If


	' 값 처리

'		If DK_MEMBER_ID = strPass			Then Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT01","back","")
'		If Len(strPass) < 6 Or Len(strPass) > 20 Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK2","back","")
'		If Not checkPass(strPass, 6, 20)	Then Call ALERTS(LNG_JS_PASSWORD_FORM_CHECK","back","")
		If isChgPass = "T" Then
			If Not checkPass(newPass, 6, 20)	Then Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT04&"DDD","back","")
		End If

	''	If strEmail = "" Or strEmail = ""	Then Call ALERTS(LNG_JS_EMAIL,"back","")		'COSMICO XXX


	' 값 병합

		strBirth = ""
		'strTel = ""

		'If strTel1 <> "" And strTel2 <> "" And strTel3 <> "" Then strTel = strTel1 &"-"& strTel2 &"-"& strTel3
		'If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then strBirth = strBirth1 &"-"& strBirth2 &"-"& strBirth3



		'If Not IsDate(strBirth) Then strBirth = ""
		If isSMS = "" Then isSMS = "T"
		If isMailing = "" Then isMailing = "T"

		If isViewID = "" Then isViewID = "N"


		If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV

				If strADDR1			<> "" Then strADDR1		= objEncrypter.Encrypt(strADDR1)
				If strADDR2			<> "" Then strADDR2		= objEncrypter.Encrypt(strADDR2)
				If strTel			<> "" Then strTel		= objEncrypter.Encrypt(strTel)
				If strMobile		<> "" Then strMobile	= objEncrypter.Encrypt(strMobile)

				If DKCONF_ISCSNEW = "T" Then	'▣CS신버전 암/복호화 추가
					If strEmail		<> "" Then strEmail		= objEncrypter.Encrypt(LCase(strEmail))
					If strPass		<> "" Then strPass		= objEncrypter.Encrypt(strPass)
					If newPass		<> "" Then newPass		= objEncrypter.Encrypt(newPass)
					If chgPass		<> "" Then chgPass		= objEncrypter.Encrypt(chgPass)
					If bankNumber	<> "" Then bankNumber	= objEncrypter.Encrypt(bankNumber)
					If strSSH		<> "" Then strSSH		= objEncrypter.Encrypt(strSSH)		'▣cpno 변경
				End If

			Set objEncrypter = Nothing
		End If

		If isChgPass = "F" Or isChgPass = "" Or IsNull(isChgPass) Then
			chgPass = strPass
		ElseIf isChgPass = "T" Then
			chgPass = newPass
		End If

		SQL = "SELECT [WebPassword] FROM [tbl_memberInfo] WHERE [mbid] = ? AND [mbid2] = ?"
		arrParams = Array(_
			Db.makeParam("@DK_MEMBER_ID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
		)
		oriPass = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)
'		Call ResRW(oriPass	,"oriPass")
'		Call ResRW(strPass	,"strPass")




'		Call ResRW(MotherSite	,"MotherSite")
'		Call ResRW(strUserID	,"strUserID")
'		Call ResRW(strPass		,"strPass")
'		Call ResRW(strName		,"strName")
'		Call ResRW(strNickName	,"strNickName")
'		Call ResRW(strMobile	,"strMobile")
'		Call ResRW(strEmail		,"strEmail")
'		Call ResRW(strZip		,"strZip")
'		Call ResRW(straddr1		,"straddr1")
'		Call ResRW(straddr2		,"straddr2")
'		Call ResRW(isViewID		,"isViewID")
'		Call ResRW(strTel		,"strTel")
'		Call ResRW(isSMS		,"isSMS")
'		Call ResRW(isMailing	,"isMailing")
'		Call ResRW(strBirth		,"strBirth")
'		Call ResRW(isSolar		,"isSolar")
'		Call ResRW(oriPass		,"oriPass")
'		Call ResRW(chgPass		,"chgPass")
'	response.End
		If oriPass <> strPass Then Call alerts(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT07,"back","")

		'▣cpno 변경 중복체크
		If agreement = "T" And CPNO_CHANGE_TF = "T" Then		'주민번호 입력/수정시
			SQL = " SELECT COUNT(*) FROM [tbl_MemberInfo] WHERE [cpno] = ?  "
			arrParams = Array(_
				Db.makeParam("@cpno",adVarChar,adParamInput,100,strSSH) _
			)
			SSHCOUNT = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))
			If SSHCOUNT > 0 Then Call alerts("이미 CS에 가입된 주민등록번호 입니다","back","")
		End If

		'▣ 이메일중복체크
		If strEmail <> "" Then
			SQL = "SELECT COUNT([Email]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [Email] = ? AND NOT ([mbid] = ? AND [mbid2] = ?) "
			arrParams = Array(_
				Db.makeParam("@strEmail",adVarWChar,adParamInput,200,strEmail), _
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			Email_CNT = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)
			If Email_CNT > 0 Then Call ALERTS(LNG_AJAX_EMAILCHECK_F,"back","")
		End If

%>
<%
	If UCase(DK_MEMBER_NATIONCODE) = "KR" And NICE_BANK_CONFIRM_TF = "T" And DK_MEMBER_STYPE = "0" Then

		'▣ CS 계좌번호중복체크
		If bankCode <> "" And bankNumber <> "" Then
			SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [bankcode] = ? AND [bankaccnt] = ? AND NOT ([mbid] = ? AND [mbid2] = ?) "
			arrParams = Array(_
				Db.makeParam("@strBankCode",adVarChar,adParamInput,10,bankCode), _
				Db.makeParam("@bankaccnt",adVarchar,adParamInput,100,bankNumber), _
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			BANKACCNT_COUNT = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))

			If BANKACCNT_COUNT > 0 Then
				Call ALERTS("이미 CS에 등록된 계좌정보가 존재합니다! 본인이 등록하지 않았다면 본사로 문의해주세요.","BACK","")
			End If
		End If


		'■ CS 계좌본인인증 CHECK
		ajaxTF	= pRequestTF("ajaxTF",False)

		If DK_MEMBER_STYPE <> "0" Then ajaxTF = ""

		If ajaxTF = "T" Then

			TempDataNum	= pRequestTF("TempDataNum",False)
			birthYYMMDD	= Right(strBirth1,2)&strBirth2&strBirth3

			'▣암호화후 템프테이블데이터와 비교
			Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If birthYYMMDD	<> "" Then Enc_birthYYMMDD	= objEncrypter.Encrypt(birthYYMMDD)
				On Error GoTo 0
			Set objEncrypter = Nothing

			'계좌인증 체크
			arrParams = Array(_
				Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,TempDataNum),_
				Db.makeParam("@strSSH1",adChar,adParamInput,50,Enc_birthYYMMDD),_
				Db.makeParam("@strSSH2",adChar,adParamInput,50,Enc_birthYYMMDD)_
			)
			Set DKRS = Db.execRs("DKP_MEMBER_JOIN_BANK_VIEW",DB_PROC,arrParams,DB3)

			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_intIDX				= DKRS("intIDX")
				DKRS_TempDataNum		= DKRS("TempDataNum")
				DKRS_strName			= DKRS("strName")
				DKRS_strSSH1			= DKRS("strSSH1")			'생년월일 YYMMDD
				DKRS_strSSH2			= DKRS("strSSH2")			'생년월일 YYMMDD
				DKRS_strCenterName		= DKRS("strCenterName")
				DKRS_strCenterCode		= DKRS("strCenterCode")
				DKRS_strBankCode		= DKRS("strBankCode")
				DKRS_strBankNum			= DKRS("strBankNum")
				DKRS_strBankOwner		= DKRS("strBankOwner")
				DKRS_strOrderNum		= DKRS("strOrderNum")
				DKRS_M_Name_First		= DKRS("M_Name_First")
				DKRS_M_Name_Last		= DKRS("M_Name_Last")
			Else
				Call ALERTS("데이터베이스에 없는 데이터입니다. 다시 시도해주세요2.","BACK","")
			End If
			Call closeRs(DKRS)

			'템프테이블 데이터 복호화후 비교
			Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If DKRS_strSSH1		<> "" Then DKRS_strSSH1		= objEncrypter.Decrypt(DKRS_strSSH1)
				If DKRS_strSSH2		<> "" Then DKRS_strSSH2		= objEncrypter.Decrypt(DKRS_strSSH2)
			Set objEncrypter = Nothing

			If DKRS_strBankCode		<>	bankCode		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.6","BACK","")
			If DKRS_strBankNum		<>	bankNumber		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.7","BACK","")
			'If DKRS_strBankOwner	<>	bankOwner		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.8","BACK","")
			If DKRS_TempDataNum		<>	TempDataNum		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.11","BACK","")
			If DKRS_strSSH1			<>	birthYYMMDD		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.12","BACK","")
			If DKRS_strSSH2			<>	birthYYMMDD		Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요.13","BACK","")

			bankCode	= DKRS_strBankCode
			bankOwner	= DKRS_strBankOwner
			bankNumber	= DKRS_strBankNum

		Else

			bankCode	= ori_bankCode
			bankOwner	= ori_bankOwner
			bankNumber	= ori_bankNumber

			Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV

				If bankNumber	<> "" Then bankNumber	= objEncrypter.Encrypt(bankNumber)

			Set objEncrypter = Nothing

		End If

	End If

%>
<%

	'#####################################
	'◆	NICE 본인인증(핸드폰)
	'#####################################
	authVal	= pRequestTF("authVal",False)		'= sResponseNumber

	If NICE_MOBILE_CONFIRM_TF = "T" And authVal <> "" And strMobile <> "" Then

		sResponseNumber		= SESSION("sResponseNumber")		'exitAuth_s.asp 생성
		sRequestNumber		= SESSION("REQ_SEQ")				'member_info_mobileAuth.asp 생성

		If authVal <> sResponseNumber Then Call ALERTS("세션값이 다릅니다. 올바른 경로로 접근하시기 바랍니다","BACK")

		'Call ResRW(SESSION("REQ_SEQ"),"SESSION(REQ_SEQ)")
		'Call ResRW(SESSION("sResponseNumber"),"SESSION(sResponseNumber)")

		sResponseNumber = SESSION("sResponseNumber")
		If sResponseNumber = "" Then sResponseNumber = ""

		'MODIFY MOBILE AUTH DATA CHECK
		SQLM = "SELECT * FROM [DKT_MEMBER_MOBILE_AUTH] WITH(NOLOCK) WHERE [sRequestNumber] = ? AND [sType] = 'MODIFY' AND [sResponseNumber] = ?"
		arrParamsM = Array(_
			Db.makeParam("@sRequestNO",adVarChar,adParamInput,30,sRequestNumber), _
			Db.makeParam("@sResponseNumber",adVarChar,adParamInput,30,sResponseNumber) _
		)
		Set DKRSM = Db.execRs(SQLM,DB_TEXT,arrParamsM,Nothing)

		If Not DKRSM.BOF And Not DKRSM.EOF Then
			DKRSM_intIDX			= DKRSM("intIDX")
			DKRSM_sType				= DKRSM("sType")
			DKRSM_sCipherTime		= DKRSM("sCipherTime")
			DKRSM_sRequestNumber	= DKRSM("sRequestNumber")
			DKRSM_sResponseNumber	= DKRSM("sResponseNumber")
			DKRSM_sAuthType			= DKRSM("sAuthType")
			DKRSM_sName				= DKRSM("sName")
			DKRSM_sGender			= DKRSM("sGender")
			DKRSM_sBirthDate		= DKRSM("sBirthDate")
			DKRSM_sNationalInfo		= DKRSM("sNationalInfo")
			DKRSM_sDupInfo			= DKRSM("sDupInfo")				'중복가입 확인값 (DI_64 byte)
			DKRSM_sConnInfo			= DKRSM("sConnInfo")
			DKRSM_sMobileNo			= DKRSM("sMobileNo")
			DKRSM_sMobileCo			= DKRSM("sMobileCo")
			DKRSM_regTime			= DKRSM("regTime")
		Else
			Call ALERTS("본인인증 데이터가 존재하지 않습니다. 본인인증을 다시 하셔야합니다.","BACK","")
		End If
		Call closeRs(DKRSM)


		If strMobile <>	DKRSM_sMobileNo	Then Call ALERTS("데이터에 변조가 있었습니다.다시 진행해주세요. - M05","BACK","")   '풀어야됨



	End If


%>
<%
		'▣ CS 핸드폰 중복체크
		If strMobile <> "" Then
			SQL_MC = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [hptel] = ? AND NOT ([mbid] = ? AND [mbid2] = ?) "
			arrParams_MC = Array(_
				Db.makeParam("@hptel",adVarChar,adParamInput,100,strMobile), _
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			DbCheckMobile = CInt(Db.execRsData(SQL_MC,DB_TEXT,arrParams_MC,DB3))
			If DbCheckMobile > 0 Then
				Call ALERTS("이미 등록된 핸드폰 번호입니다.\n본인이 회원가입을 하지 않았다면 본사로 문의해주세요.!","BACK","")
			End If
		End If


	'print strTel
	nowTime = Now
	RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
	Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)
	strZip = Replace(strZip,"-","")

			'Db.makeParam("@strBirth",adVarChar,adParamInput,8,Replace(strBirth,"-","")),_
		arrParams = Array(_
			Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@DK_MBID1",adInteger,adParamInput,4,DK_MEMBER_ID2), _
			Db.makeParam("@strPass",adVarWChar,adParamInput,100,chgPass),_

			Db.makeParam("@strBirth1",adVarChar,adParamInput,4,strBirth1),_
			Db.makeParam("@strBirth2",adVarChar,adParamInput,2,strBirth2),_
			Db.makeParam("@strBirth3",adVarChar,adParamInput,2,strBirth3),_
			Db.makeParam("@isSolar",adChar,adParamInput,1,isSolar),_

			Db.makeParam("@strTel",adVarChar,adParamInput,100,strTel),_
			Db.makeParam("@strMobile",adVarChar,adParamInput,100,strMobile),_
			Db.makeParam("@strEmail",adVarChar,adParamInput,512,strEmail),_

			Db.makeParam("@strZip",adVarChar,adParamInput,10,strZip),_
			Db.makeParam("@strADDR1",adVarWChar,adParamInput,700,strADDR1),_
			Db.makeParam("@strADDR2",adVarWChar,adParamInput,700,strADDR2),_

			Db.makeParam("@bankCode",adVarChar,adParamInput,10,bankCode), _
			Db.makeParam("@bankOwner",adVarWChar,adParamInput,50,bankOwner), _
			Db.makeParam("@bankNumber",adVarChar,adParamInput,200,bankNumber), _

				Db.makeParam("@cpno",adVarWChar,adParamInput,100,strSSH), _

			Db.makeParam("@RecodTime",adVarChar,adParamInput,19,Recordtime),_
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
	'	Call Db.exec("DKP_MEMBER_MODIFY2",DB_PROC,arrParams,Nothing)
		'Call Db.exec("DKP_MEMBER_INFO_MODIFY",DB_PROC,arrParams,DB3)
		Call Db.exec("DKP_MEMBER_INFO_MODIFY_CPNO",DB_PROC,arrParams,DB3)
		OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

		Select Case OUTPUT_VALUE
			Case "ERROR"
				Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT08,"BACK","")

			Case "FINISH"
				'■ CS 계좌인증 UPDATE
				If ajaxTF = "T" And bankNumber <> "" And NICE_BANK_CONFIRM_TF = "T" And DK_MEMBER_STYPE = "0"  Then
					On Error Resume Next
					SQL_ACC = "UPDATE [tbl_Memberinfo] SET [Reg_bankaccnt] = ? WHERE [mbid] = ? AND [mbid2] = ? "
					arrParams_ACC = Array(_
						Db.makeParam("@Reg_bankaccnt",adVarWChar,adParamInput,50,bankNumber), _
						Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
						Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
					)
					Call Db.exec(SQL_ACC,DB_TEXT,arrParams_ACC,DB3)
					On Error GoTo 0
				End If

				'◆ 핸드폰인증 중복가입 확인값 UPDATE
				If authVal <> "" And strMobile <> "" And DKRSM_sDupInfo <> "" Then
					SQLMU = "UPDATE [tbl_memberinfo] SET [mobileAuth] = ? WHERE [mbid] = ? AND [mbid2] = ? "
					arrParamsMU = Array(_
						Db.makeParam("@sDupInfo",adVarWChar,adParamInput,100,DKRSM_sDupInfo), _
						Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
						Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
					)
					Call Db.exec(SQLMU,DB_TEXT,arrParamsMU,DB3)
				End If

				Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT09,"go","/mypage/member_info.asp"&ptshop)

			Case Else
				Call ALERTS(LNG_MYPAGE_INFO_COMPANY_HANDLER_ALERT10,"BACK","")
		End Select

%>
