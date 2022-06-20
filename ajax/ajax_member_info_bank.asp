<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_lib/md5.asp" -->
<%
'	Option Explicit
	'===== 회원정보수정(member_info_company.asp) or 소비자 판매원 전환시(conversion_customer.asp)  ======

	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"


	Dim niceUid, svcPwd, strResId, strNm, strBankCode, strAccountNo, strGbn, svcGbn, strOrderNo, service, svc_cls, inq_rsn

	'##################################################
	'###### ▣ 회원사 ID 설정   - 계약시에 발급된 회원사 ID를 설정하십시오. ▣
	'###### ▣ 회원사 PW 설정   - 계약시에 발급된 회원사 PASSWORD를 설정하십시오. ▣
	'###### ▣ 조회사유  설정   - 10:회원가입 20:기존회원가입 30:성인인증 40:비회원확인 90:기타사유 ▣
	'###### ▣ 개인/사업자 설정 - 1:개인 2:사업자 ▣
	'##################################################
	niceUid			=	NICE_BANK_UID					'한국신용정보에서 고객사에 부여한 구분 id
	svcPwd			=	NICE_BANK_PWD					'한국신용정보에서 고객사에 부여한 서비스 이용 패스워드

	inq_rsn			=	"10"									'조회사유 - 10:회원가입 20:기존회원가입 30:성인인증 40:비회원확인 90:기타사유
	strGbn			=	"1"										'1 : 개인, 2: 사업자
	'##################################################

'	strResId		=	Request("JUMINNO")			' 주민번호
'	strNm			=	Request("USERNM")			' 성명
'	strBankCode		=	Request("strBankCode")		' 은행코드
'	strAccountNo	=	Request("strAccountNo")		' 계좌번호
'	service			=	Request("service")			' 서비스 구분
'	svcGbn			=	Request("svcGbn") 			' 업무구분
'	svc_cls			=	Request("svc_cls")			' 내-외국인구분
'	strOrderNo		=	makeOrderNo()				' 주문번호


	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_mbid				= DKRS("mbid")
		DKRS_mbid2				= DKRS("mbid2")
		DKRS_M_Name				= DKRS("M_Name")
		DKRS_E_name				= DKRS("E_name")
		DKRS_Email				= DKRS("Email")
		DKRS_cpno				= DKRS("cpno")
		DKRS_Addcode1			= DKRS("Addcode1")
		DKRS_Address1			= DKRS("Address1")
		DKRS_Address2			= DKRS("Address2")
		DKRS_Address3			= DKRS("Address3")
		DKRS_reqtel				= DKRS("reqtel")
		DKRS_officetel			= DKRS("officetel")
		DKRS_hometel			= DKRS("hometel")
		DKRS_hptel				= DKRS("hptel")
		DKRS_LineCnt			= DKRS("LineCnt")
		DKRS_N_LineCnt			= DKRS("N_LineCnt")
		DKRS_Recordid			= DKRS("Recordid")
		DKRS_Recordtime			= DKRS("Recordtime")
		DKRS_businesscode		= DKRS("businesscode")
		DKRS_bankcode			= DKRS("bankcode")
		DKRS_banklocal			= DKRS("banklocal")
		DKRS_bankaccnt			= DKRS("bankaccnt")
		DKRS_bankowner			= DKRS("bankowner")
		DKRS_Regtime			= DKRS("Regtime")
		DKRS_Saveid				= DKRS("Saveid")
		DKRS_Saveid2			= DKRS("Saveid2")
		DKRS_Nominid			= DKRS("Nominid")
		DKRS_Nominid2			= DKRS("Nominid2")
		DKRS_RegDocument		= DKRS("RegDocument")
		DKRS_CpnoDocument		= DKRS("CpnoDocument")
		DKRS_BankDocument		= DKRS("BankDocument")
		DKRS_Remarks			= DKRS("Remarks")
		DKRS_LeaveCheck			= DKRS("LeaveCheck")
		DKRS_LineUserCheck		= DKRS("LineUserCheck")
		DKRS_LeaveDate			= DKRS("LeaveDate")
		DKRS_LineUserDate		= DKRS("LineUserDate")
		DKRS_LeaveReason		= DKRS("LeaveReason")
		DKRS_LineDelReason		= DKRS("LineDelReason")
		DKRS_WebID				= DKRS("WebID")
		DKRS_WebPassWord		= DKRS("WebPassWord")
		DKRS_BirthDay			= DKRS("BirthDay")
		DKRS_BirthDay_M			= DKRS("BirthDay_M")
		DKRS_BirthDay_D			= DKRS("BirthDay_D")
		DKRS_BirthDayTF			= DKRS("BirthDayTF")
		DKRS_Ed_Date			= DKRS("Ed_Date")
		'DKRS_Ed_TF				= DKRS("Ed_TF")				'신버전삭제
		DKRS_PayStop_Date		= DKRS("PayStop_Date")
		DKRS_PayStop_TF			= DKRS("PayStop_TF")
		DKRS_For_Kind_TF		= DKRS("For_Kind_TF")
		DKRS_Sell_Mem_TF		= DKRS("Sell_Mem_TF")
		DKRS_CurGrade			= DKRS("CurGrade")
		DKRS_Remarks			= DKRS("Remarks")			'비고
		DKRS_Reg_bankaccnt			= DKRS("Reg_bankaccnt")			'비고

		'If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If DKRS_Address1		<> "" Then DKRS_Address1	= objEncrypter.Decrypt(DKRS_Address1)
					If DKRS_Address2		<> "" Then DKRS_Address2	= objEncrypter.Decrypt(DKRS_Address2)
					If DKRS_Address3		<> "" Then DKRS_Address3	= objEncrypter.Decrypt(DKRS_Address3)
					If DKRS_hometel			<> "" Then DKRS_hometel		= objEncrypter.Decrypt(DKRS_hometel)
					If DKRS_hptel			<> "" Then DKRS_hptel		= objEncrypter.Decrypt(DKRS_hptel)
					If DKRS_bankaccnt		<> "" Then DKRS_bankaccnt	= objEncrypter.Decrypt(DKRS_bankaccnt)
					If DKRS_Reg_bankaccnt		<> "" Then DKRS_Reg_bankaccnt	= objEncrypter.Decrypt(DKRS_Reg_bankaccnt)

					'If DKCONF_ISCSNEW = "T" Then	''▣CS신버전 암/복호화 추가
						If DKRS_Email		<> "" Then DKRS_Email		= objEncrypter.Decrypt(DKRS_Email)
						'If DKRS_WebID		<> "" Then DKRS_WebID		= objEncrypter.Decrypt(DKRS_WebID)
						If DKRS_WebPassWord	<> "" Then DKRS_WebPassWord	= objEncrypter.Decrypt(DKRS_WebPassWord)
						If DKRS_cpno		<> "" Then DKRS_cpno		= objEncrypter.Decrypt(DKRS_cpno)				'▣cpno
					'End If
				On Error GoTo 0
			'	PRINT  objEncrypter.Decrypt("Z0SPQ6DkhLd4e")
			Set objEncrypter = Nothing
		'End If
	Else
		Msg = "회원정보가 없습니다. 세션이 만료되었을 수 있습니다. 새로고침 후 다시 시도해주세요."
		'Msg = server.urlencode(Msg)
		Response.Write "{""statusCode"":""9999"",""message"":"""&Msg&""",""result"":""""}"
		Response.End

	End If


Set XTEncrypt = new XTclsEncrypt
TempDataNum = "C_"&makeMemTempNum&RandomChar(10)		'C_....

	birthYY			= DKRS_BirthDay				'생년월일 YYYY
	birthMM			= DKRS_BirthDay_M			'생년월일 MM
	birthDD			= DKRS_BirthDay_D			'생년월일 DD

	strBankCode		= pRequestTF2("bankCode",True)
	strBankNum		= pRequestTF2("BankNumber",True)

	strBankOwner	= DKRS_M_Name

	strBankOwner = Replace(strBankOwner," ","")			'KR 이름공백제거
	strBankNum2	= Replace(strBankNum,"-","")

	If birthYY = "" Or birthMM = "" Or birthDD = "" Then
		Msg = "생년월일정보가 회원정보에 없습니다. 본사에 문의해주세요"
		'Msg = server.urlencode(Msg)
		Response.Write "{""statusCode"":""9999"",""message"":"""&Msg&""",""result"":""""}"
		Response.End
	End If

	'**** 18-11-19 추가 (주민번호 체크)
'	strSSH1 		= pRequestTF2("ssh1", True)
'	strSSH2 		= pRequestTF2("ssh2", True)

'	If (DKRS_cpno <> (strSSH1&strSSH2)) Then
'		Msg = "기존입력된 주민번호와 다릅니다. 본사에 문의해주세요"
'		Msg = server.urlencode(Msg)
'		Response.Write "{""statusCode"":""9999"",""message"":"""&Msg&""",""result"":""""}"
'		Response.End
'	End If
	'**** 주민번호 체크 E

	'외국인 여부 체크
	SexCheck = Mid(DKRS_cpno, 7, 1)

	Select Case SexCheck
		Case "1", "2", "3", "4"
			ForeignerType = False
		Case Else
			ForeignerType = True
	End Select


	'##################################################
	'###### ▣ 계좌인증용 내용 변환
	'##################################################
	'strResId		= strSSH1&strSSH2
	strResId		= Right(birthYY,2)&birthMM&birthDD			'생년월일 YYMMDD
	strNm			= strBankOwner
	strBankCode		= strBankCode
	strAccountNo	= strBankNum2
	service			= 1
	svcGbn			= 5
	svc_cls			= ""
	strOrderNo		= makeOrderNo()

	'▣주민번호 암호화입력
	'strSSH = strSSH1&strSSH2

'print strResId
'print strSSH
'print strSSH1
'print strSSH2
'Response.end
	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		If strResId		<> "" Then Enc_strResId		= objEncrypter.Encrypt(strResId)			'생년월일 암호화(YYMMDD)
		If strBankNum	<> "" Then Enc_strBankNum	= objEncrypter.Encrypt(strBankNum)

	Set objEncrypter = Nothing

	'▣기존 은행정보와 비교 - 1이면 튕김
	strBankCodeVARCHAR = Right("000"&strBankCode,3)


	'▣ CS 계좌번호중복체크
	SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [bankcode] = ? AND [bankaccnt] = ? AND NOT ([mbid] = ? AND [mbid2] = ?) "
	arrParams = Array(_
		Db.makeParam("@strBankCode",adVarChar,adParamInput,10,strBankCode), _
		Db.makeParam("@bankaccnt",adVarchar,adParamInput,100,Enc_strBankNum), _
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	BANKACCNT_COUNT = CInt(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))

	If BANKACCNT_COUNT > 0 Then
		Msg = "이미 CS에 등록된 계좌정보가 존재합니다! 본인이 등록하지 않았다면 본사로 문의해주세요."
		Response.Write "{""statusCode"":""9999"",""message"":"""&Msg&""",""result"":""""}"
		Response.End
	End If


	Call GetMLBMCode()	' 함수 CALL

	Public Sub GetMLBMCode()

		Dim ServerXMLHTTP, oHttp
		Dim strMLBResponseText
		Dim strParam, strTargetURL, strResponseText, strParamLength
		Dim strRetcd, OrderNum, ResultCD, DetailCD, Msg

		strResponseText = ""
		'strTargetURL = "https://secure.nuguya.com/nuguya/service/realname/sprealnameactconfirm.do"
		strTargetURL = "https://secure.nuguya.com/nuguya2/service/realname/sprealnameactconfirm.do"		'UTF-8 URL

		strParam = "niceUid="&niceUid&"&svcPwd="&svcPwd&"&strResId="&strResId&"&strNm="&strNm&"&strBankCode="&strBankCode&"&strAccountNo="&strAccountNo&"&service="&service&"&strGbn="&strGbn&"&svcGbn="&svcGbn&"&strOrderNo="&strOrderNo&"&svc_cls="&svc_cls&"&inq_rsn="&inq_rsn&"&seq=0000001"

		strParamLength = Len(strParam)

		set oHttp = Server.CreateObject("MSXML2.ServerXMLHTTP")
		'타임아웃
		Dim lngResolveTimeout, lngConnectTimeout, lngSendTimeout, lngReceiveTimeout
		lngResolveTimeout = 1000 * 10	'10초
		lngConnectTimeout = 1000 * 10	'10초
		lngSendTimeout    = 1000 * 10	'10초
		lngReceiveTimeout = 1000 * 10	'10초
		oHttp.SetTimeouts lngResolveTimeout, lngConnectTimeout, lngSendTimeout, lngReceiveTimeout


		With oHttp
			.setOption 2, 13056
			.open "POST", strTargetURL, false
			.setRequestHeader "Host", "secure.nuguya.com"
			.setRequestHeader "Connection", "Keep-Alive"
			.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
			.setRequestHeader "Content-Length", "&strParamLength&"
			.send strParam

			strResponseText = .responseText
		End With

		strMLBResponseText = strResponseText

		strRetcd = Split(strMLBResponseText,"|")

		OrderNum	= strRetcd(0)		' 주문번호
		ResultCD	= strRetcd(1)		' 결과코드
		Msg			= strRetcd(2)		' 메세지
  '      Msg         = LEFT(Msg, 3)

'		Response.Write "주문번호 : " & OrderNum & "<br>"
'		Response.Write "결과코드 : " & ResultCD & "<br>"
'		Response.Write "메세지   : " & Replace(Msg, ")", "")      & "<br>"
'		Response.End

		'결과값이 정상인 경우
		If ResultCD = "0000" Or (ForeignerType And ResultCD = "S606") Then
		''	SQL = "UPDATE tbl_memberInfo SET [bankCode] = ?, [bankowner] = ?, [bankaccnt] = ?, [reg_bankaccnt] = ?"
		''	SQL = SQL & " WHERE [mbid] = ? AND [mbid2] = ?"
		''
		''	arrParams = Array(_
		''		Db.makeParam("@strBankCode",adVarChar,adParamInput,10,strBankCode),_
		''		Db.makeParam("@strBankOwner",adVarWChar,adParamInput,100,strBankOwner),_
		''		Db.makeParam("@strBankNum",adVarChar,adParamInput,100,Enc_strBankNum),_
		''		Db.makeParam("@strBankNum",adVarChar,adParamInput,100,Enc_strBankNum),_
		''
		''		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		''		Db.makeParam("@mbid2",adinteger,adParamInput,4,DK_MEMBER_ID2) _
		''	)
		''	Call Db.exec(SQL,DB_TEXT,arrParams,DB3)
		''
		''	SQL = " INSERT INTO tbl_memberinfo_mod ( "
		''	SQL = SQL & " mbid,mbid2,ChangeDetail,beforedetail,afterdetail,ModRecordid,ModRecordtime "
		''	SQL = SQL & " ) VALUES ( "
		''	SQL = SQL & " ?,?,?,?,?,?,? "
		''	SQL = SQL & " ) "
		''
		''	MODIFYID = "WEB_" & DK_MEMBER_ID1 & DK_MEMBER_ID2
		''
		''	nowTime = Now
		''	RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
		''	Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)
		''
		''	arrParams = Array(_
		''		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		''		Db.makeParam("@mbid2",adinteger,adParamInput,4,DK_MEMBER_ID2),_
		''		Db.makeParam("@ChangeDetail",adVarChar,adParamInput,100,"bankowner"),_
		''		Db.makeParam("@beforedetail",adVarChar,adParamInput,100,DKRS_bankowner),_
		''		Db.makeParam("@afterdetail",adVarChar,adParamInput,20,strBankOwner), _
		''		Db.makeParam("@ModRecordid",adVarChar,adParamInput,20,MODIFYID), _
		''		Db.makeParam("@Recordtime",adVarChar,adParamInput,30,Recordtime) _
		''	)
		''	Call Db.exec(SQL,DB_TEXT,arrParams,DB3)


			arrParams = Array(_
				Db.makeParam("@TempDataNum",adVarChar,adParamInput,50,TempDataNum),_
				Db.makeParam("@strName",adVarWChar,adParamInput,50,strBankOwner),_
				Db.makeParam("@M_Name_First",adVarWChar,adParamInput,50,""),_
				Db.makeParam("@M_Name_Last",adVarWChar,adParamInput,50,""),_
				Db.makeParam("@strSSH1",adVarChar,adParamInput,50,Enc_strResId),_
				Db.makeParam("@strSSH2",adVarChar,adParamInput,50,Enc_strResId),_
				Db.makeParam("@strCenterName",adVarChar,adParamInput,30,""),_
				Db.makeParam("@strCenterCode",adVarChar,adParamInput,30,""),_
				Db.makeParam("@strBankCode",adVarChar,adParamInput,10,strBankCode),_
				Db.makeParam("@strBankNum",adVarChar,adParamInput,100,Enc_strBankNum),_
				Db.makeParam("@strBankOwner",adVarWChar,adParamInput,100,strBankOwner),_
				Db.makeParam("@strOrderNum",adVarChar,adParamInput,30,strOrderNo), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKP_MEMBER_JOIN_BANK_INSERT",DB_PROC,arrParams,DB3)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

			If OUTPUT_VALUE = "FINISH" Then

				SQL = "SELECT [bankName] FROM [tbl_Bank] WHERE [ncode] = ?"
				arrParams = Array(_
					Db.makeParam("@ncode",adVarChar,adParamInput,10,strBankCode) _
				)
				DKRS_bankName = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

				''Msg2 = "<span id=\""bankText\""><span class=\""text_blue\"">[인증계좌]</span>"
				''Msg2 = Msg2 & " ["&DKRS_bankName&"] "&strBankNum&"  ["&LNG_TEXT_BANKOWNER&"] : "&strBankOwner &"</span>"

				Msg1 = "계좌인증에 성공하였습니다"
				'Msg1 = server.urlencode(Msg1)
				'Msg = server.urlencode(Msg)
				'Response.Write "{""statusCode"":""0000"",""message"":"""&Msg1&""",""result"":"""&Msg2&"""}"
				Response.Write "{""statusCode"":""0000"",""message"":"""&Msg1&""",""result"":"""&Msg1&""",""data"":"""&TempDataNum&"""}"
				Response.End
			Else
				Msg1 = "데이터베이스 입력에 실패하였습니다."
				Response.Write "{""statusCode"":""9999"",""message"":"""&Msg1&""",""result"":"""&Msg&"""}"
				Response.End
			End If
		Else
			Msg1 = "계좌확인에 실패하였습니다"
			Response.Write "{""statusCode"":""9999"",""message"":"""&Msg1&""",""result"":"""&Msg&"""}"
			Response.End
		End If

	End Sub

	function makeOrderNo()
		Dim yyyymmdd, yyyy, mm, dd
		yyyy = Year(Now)
		mm   = Right("0" & Month(Now), 2)
		dd   = Right("0" & Day(Now), 2)
		yyyymmdd = yyyy & mm & dd
		Dim rand_num,max,min
		min = 1000000000
		max = 9999999999
		Randomize
		rand_num = int((max-min+1)*rnd+min)
		makeOrderNo	=	yyyymmdd & rand_num		' 주문번호

	End Function
%>