<!--#include virtual = "/_lib/strFunc.asp" -->
<%

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

	If Not checkRef(houUrl &"/shop/mypage/member_info.asp") Then Call alerts("잘못된 접근입니다.","go","/shop/mypage/member_info.asp")

	' 값 받아오기
		strPass			= pRequestTF("strPass",True)

		isChgPass		= pRequestTF("isChgPass",False)
		newPass			= pRequestTF("newPass",False)
		newPass2		= pRequestTF("newPass2",False)


		strMobile1		= pRequestTF("mob_num1",False)
		strMobile2		= pRequestTF("mob_num2",False)
		strMobile3		= pRequestTF("mob_num3",False)

		strZip			= pRequestTF("strzip",False)
		strADDR1		= pRequestTF("strADDR1",False)
		strADDR2		= pRequestTF("strADDR2",False)

		strEmail1		= pRequestTF("mailh",False)
		strEmail2		= pRequestTF("mailt",False)


		strTel1			= pRequestTF("tel_num1",False)
		strTel2			= pRequestTF("tel_num2",False)
		strTel3			= pRequestTF("tel_num3",False)

		strBirth1		= pRequestTF("birthyy",True)
		strBirth2		= pRequestTF("birthmm",True)
		strBirth3		= pRequestTF("birthdd",True)
		isSolar			= pRequestTF("isSolar",True)

		isMailing		= pRequestTF("sendemail",False)
		isSMS			= pRequestTF("sendsms",False)


	' 값 처리

'		If DK_MEMBER_ID = strPass			Then Call ALERTS("아이디와 비밀번호를 동일하게 사용할 수 없습니다.","back","")
'		If Len(strPass) < 6 Or Len(strPass) > 20 Then Call ALERTS("비밀번호는 영문, 숫자 혼합 6자~20자로 해주세요.","back","")
		'If Not checkPass(strPass, 4, 20)	Then Call ALERTS("비밀번호는 영문, 숫자 혼합 6자~20자로 해주세요.","back","")

'		If strEmail1 = "" Or strEmail2 = ""	Then Call ALERTS("이메일 주소를 입력하셔야합니다.","back","")
'		If strMobile1 = "" Or strMobile2 = "" Or strMobile3 = "" Then Call ALERTS("핸드폰 번호를 입력하셔야합니다.","back","")

	' 값 병합

		strTel = ""
		strBirth = ""
		strMobile = ""

		strMobile = strMobile1 &"-"& strMobile2 &"-"& strMobile3
		If strTel1 <> "" And strTel2 <> "" And strTel3 <> "" Then strTel = strTel1 &"-"& strTel2 &"-"& strTel3
		If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then strBirth = strBirth1 &"-"& strBirth2 &"-"& strBirth3
		strEmail = strEmail1 & "@" & strEmail2


		If Not IsDate(strBirth) Then strBirth = ""
		If isSMS = "" Then isSMS = "T"
		If isMailing = "" Then isMailing = "T"

		If isViewID = "" Then isViewID = "N"


		SQL = "SELECT [WebPassword] FROM [tbl_memberInfo] WHERE [mbid] = ? AND [mbid2] = ?"
		arrParams = Array(_
			Db.makeParam("@DK_MEMBER_ID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,4,DK_MEMBER_ID2) _
		)
		oriPass = Db.execRsData(SQL,DB_TEXT,arrParams,DB3)
	'	Call ResRW(oriPass	,"oriPass")
	'	Call ResRW(strPass	,"strPass")

		If oriPass <> strPass Then Call alerts("현재 비밀번호가 일치하지 않습니다. 비밀번호를 확인해주세요.","BACK","")

		If isChgPass = "F" Or isChgPass = "" Or IsNull(isChgPass) Then
			chgPass = strPass
		ElseIf isChgPass = "T" Then
			chgPass = newPass
		End If



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
'		Call ResRW(isSex		,"isSex")
'		response.End

		If DKCONF_SITE_ENC = "T" Then
			Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If strADDR1		<> "" Then strADDR1		= objEncrypter.Encrypt(strADDR1)
				If strADDR2		<> "" Then strADDR2		= objEncrypter.Encrypt(strADDR2)
				If strTel		<> "" Then strTel		= objEncrypter.Encrypt(strTel)
				If strMobile	<> "" Then strMobile	= objEncrypter.Encrypt(strMobile)
			Set objEncrypter = Nothing
		End If

	'print strTel
	nowTime = Now
	RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
	Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)
	strZip = Replace(strZip,"-","")

		arrParams = Array(_
			Db.makeParam("@DK_MBID1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
			Db.makeParam("@DK_MBID1",adInteger,adParamInput,4,DK_MEMBER_ID2), _
			Db.makeParam("@strPass",adVarChar,adParamInput,32,chgPass),_

			Db.makeParam("@strBirth",adVarChar,adParamInput,8,Replace(strBirth,"-","")),_
			Db.makeParam("@isSolar",adChar,adParamInput,1,isSolar),_

			Db.makeParam("@strTel",adVarChar,adParamInput,100,strTel),_
			Db.makeParam("@strMobile",adVarChar,adParamInput,100,strMobile),_
			Db.makeParam("@strEmail",adVarChar,adParamInput,512,strEmail),_

			Db.makeParam("@strZip",adVarChar,adParamInput,10,strZip),_
			Db.makeParam("@strADDR1",adVarWChar,adParamInput,512,strADDR1),_
			Db.makeParam("@strADDR2",adVarWChar,adParamInput,512,strADDR2),_
			Db.makeParam("@RecodTime",adVarChar,adParamInput,19,Recordtime),_

			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
	'	Call Db.exec("DKP_MEMBER_MODIFY2",DB_PROC,arrParams,Nothing)
		Call Db.exec("DKP_MEMBER_INFO_MODIFY",DB_PROC,arrParams,DB3)
		OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

		Select Case OUTPUT_VALUE
			Case "ERROR"		: Call ALERTS("회원정보 저장 중 에러가 발생하였습니다. 지속적인 에러 발생 시 고객센터로 연락바랍니다.","BACK","")
			Case "FINISH"		: Call ALERTS("정보수정이 완료 되었습니다.","go","/shop/mypage/member_info.asp")
			Case Else			: Call ALERTS("지정되지 않은 에러가 발생하였습니다. 오류 상황을 고객센터로 연락바랍니다.","BACK","")
		End Select

%>
