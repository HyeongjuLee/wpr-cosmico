<!--#include virtual = "/_lib/strFunc.asp"-->

<%
	Session.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Pragma","no-cache"
	Response.AddHeader "Expires","0"
%>
<%
	'strName = Trim(pRequestTF("name",True))
    M_Name_Last		= Trim(pRequestTF_JSON("M_Name_Last",True))
    M_Name_First	= Trim(pRequestTF_JSON("M_Name_First",True))

	M_Name_Last		= Replace(M_Name_Last," ","")
	M_Name_First	= Replace(M_Name_First," ","")

	'이름 합치기(한국: 성+이름, else 이름 + 성)
	If UCase(Lang) = "KR" Then
		strName = M_Name_Last&M_Name_First
	elseIf UCase(Lang) = "MN" Then
		strName = M_Name_Last&" "&M_Name_First		'몽골 :  성+이름 2019-10-23
	else
		strName = M_Name_First&" "&M_Name_Last
	End If

    birthYY	= Trim(pRequestTF_JSON("birthYY",True))
    birthMM	= Trim(pRequestTF_JSON("birthMM",True))
    birthDD	= Trim(pRequestTF_JSON("birthDD",True))

	strSSH  = Right(birthYY,2)&birthMM&birthDD&"0000000"

	'CS 주민번호중복체크 : 암호화 & 비교
	If DKCONF_SITE_ENC = "T" Then
		Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If strSSH	<> "" Then strSSH	= objEncrypter.Encrypt(strSSH)
		Set objEncrypter = Nothing
	End If

	'▣ CS 이름 + 주민번호(YYMMDD0000000) 중복체크(탈퇴회원 중복대상제외)
'	SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [cpno] = ? And [LeaveCheck] = 1"
'	arrParams = Array(_
'		Db.makeParam("@M_Name",adVarWchar,adParamInput,100,strName), _
'		Db.makeParam("@cpno",adVarWchar,adParamInput,100,strSSH) _
'	)
'	CSDBJoinCnt = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

	'▣ CS 이름 + 생년월일 중복체크(탈퇴회원 중복대상제외 '→ 전체회원중복체크)
	'SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? And [LeaveCheck] = 1"
	SQL = "SELECT COUNT([mbid]) FROM [tbl_memberinfo] WHERE [M_Name] = ? And [BirthDay] = ? And [BirthDay_M] = ? And [BirthDay_D] = ? "	'→ 전체회원중복체크
	arrParams = Array(_
		Db.makeParam("@M_Name",adVarWchar,adParamInput,100,strName), _
		Db.makeParam("@BirthDay",adVarchar,adParamInput,4,birthYY), _
		Db.makeParam("@BirthDay_M",adVarchar,adParamInput,2,birthMM), _
		Db.makeParam("@BirthDay_D",adVarchar,adParamInput,2,birthDD) _
	)
	CSDBJoinCnt = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)

	flagRs1 = False

	If Int(CSDBJoinCnt) > 0 Then flagRs1 = True

	If flagRs1 Then
		PRINT "{""result"":""error"",""message"":"""&LNG_JS_ALREADY_REGISTERED_MEMBER2&"""}"
		Response.End
	End If

	PRINT "{""result"":""success"",""message"":"""&LNG_JS_MEMBER_REGIST_POSSIBLE&""", ""datas"": {""name"":"""&strName&""",""M_Name_Last"":"""&M_Name_Last&""",""M_Name_First"":"""&M_Name_First&""",""birthYY"":"""&birthYY&""",""birthMM"":"""&birthMM&""",""birthDD"":"""&birthDD&"""} }"
	Response.End

%>

