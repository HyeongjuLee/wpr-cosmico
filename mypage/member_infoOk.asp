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

	If Not checkRef(houUrl &"/mypage/member_info.asp") Then Call alerts("잘못된 접근입니다.","go","/mypage/member_info.asp")

	' 값 받아오기
		strPass			= pRequestTF("strPass",True)

		isChgPass = pRequestTF("isChgPass",False)
		newPass = pRequestTF("newPass",False)
		newPass2 = pRequestTF("newPass2",False)


		strMobile1		= pRequestTF("mob_num1",False)
		strMobile2		= pRequestTF("mob_num2",False)
		strMobile3		= pRequestTF("mob_num3",False)

		strZip			= pRequestTF("strzip",False)
		strADDR1		= pRequestTF("straddr1",False)
		strADDR2		= pRequestTF("straddr2",False)

		strEmail		= pRequestTF("strEmail",False)
		'strEmail2		= pRequestTF("mailt",False)

		isViewID		= pRequestTF("isViewID",True)


		strTel1			= pRequestTF("tel_num1",False)
		strTel2			= pRequestTF("tel_num2",False)
		strTel3			= pRequestTF("tel_num3",False)




		strBirth1		= pRequestTF("birthyy",False)
		strBirth2		= pRequestTF("birthmm",False)
		strBirth3		= pRequestTF("birthdd",False)
		isSolar			= pRequestTF("isSolar",False)

		isMailing		= pRequestTF("sendemail",False)
		isSMS			= pRequestTF("sendsms",False)


	' 값 처리

		If DK_MEMBER_ID = strPass			Then Call ALERTS("아이디와 비밀번호를 동일하게 사용할 수 없습니다.","back","")


		If Not checkPass(strPass, 4, 20)	Then Call ALERTS("비밀번호는 영문, 숫자 혼합 6자~20자로 해주세요.","back","")

'		If strEmail1 = "" Or strEmail2 = ""	Then Call ALERTS("이메일 주소를 입력하셔야합니다.","back","")
'		If strMobile1 = "" Or strMobile2 = "" Or strMobile3 = "" Then Call ALERTS("핸드폰 번호를 입력하셔야합니다.","back","")

	' 값 병합

		strTel = ""
		strBirth = ""
		strMobile = ""

		strMobile = strMobile1 &"-"& strMobile2 &"-"& strMobile3
		If strTel1 <> "" And strTel2 <> "" And strTel3 <> "" Then strTel = strTel1 &"-"& strTel2 &"-"& strTel3
		If strBirth1 <> "" And strBirth2 <> "" And strBirth3 <> "" Then strBirth = strBirth1 &"-"& strBirth2 &"-"& strBirth3
		'strEmail = strEmail1 & "@" & strEmail2


		If Not IsDate(strBirth) Then strBirth = ""
		If isSMS = "" Then isSMS = "T"
		If isMailing = "" Then isMailing = "T"

		If isViewID = "" Then isViewID = "N"




		If DKCONF_SITE_ENC = "T" Then
			SQL = "SELECT [strPass] FROM [DK_MEMBER] WHERE [strUserID] = ?"
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID) _
			)
			oriPass = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

			Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If straddr1		<> "" Then straddr1		= objEncrypter.Encrypt(strADDR1)
				If straddr2		<> "" Then straddr2		= objEncrypter.Encrypt(strADDR2)
				If strTel		<> "" Then strTel		= objEncrypter.Encrypt(strTel)
				If strMobile	<> "" Then strMobile	= objEncrypter.Encrypt(strMobile)
				If strEmail		<> "" Then strEmail		= objEncrypter.Encrypt(strEmail)

				oriPass = objEncrypter.Decrypt(oriPass)
				If oriPass <> strPass Then Call alerts("현재 비밀번호가 일치하지 않습니다. 비밀번호를 확인해주세요.","back","")
				If isChgPass = "F" Or isChgPass = "" Or IsNull(isChgPass) Then
					chgPass = oriPass
				ElseIf isChgPass = "T" Then
					chgPass = newPass
				End If
				If chgPass		<> "" Then chgPass		= objEncrypter.Encrypt(chgPass)
			Set objEncrypter = Nothing
		Else
			' 암호화 하지 않는 경우
			SQL = "SELECT [strPass] FROM [DK_MEMBER] WHERE [strUserID] = ?"
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,30,DK_MEMBER_ID) _
			)
			oriPass = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

			If oriPass <> strPass Then Call alerts("현재 비밀번호가 일치하지 않습니다. 비밀번호를 확인해주세요.","back","")

			If isChgPass = "F" Or isChgPass = "" Or IsNull(isChgPass) Then
				chgPass = oriPass
			ElseIf isChgPass = "T" Then
				chgPass = newPass
			End If
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




'#######2013-04-11 회원수정 CS연동 :CS_BirthDay 형식변경#######
		CS_BirthDay = strBirth1 & strBirth2 & strBirth3

		If isSolar = "S" Then
			CS_BirthDayTF = 1
		Else
			CS_BirthDayTF = 2
		End If

		Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)


		'■사업자회원 수정사항 연동기록 : Web + CS(tbl_Memberinfo_Mod) 2014-08-27
		arrParams = Array(_
			Db.makeParam("@strUserID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
			Db.makeParam("@strPass",adVarChar,adParamInput,150,chgPass),_

			Db.makeParam("@strMobile",adVarChar,adParamInput,150,strMobile),_
			Db.makeParam("@strEmail",adVarChar,adParamInput,512,strEmail),_

			Db.makeParam("@strZip",adVarChar,adParamInput,10,strZip),_
			Db.makeParam("@strADDR1",adVarChar,adParamInput,512,straddr1),_
			Db.makeParam("@strADDR2",adVarChar,adParamInput,512,straddr2),_

			Db.makeParam("@isViewID",adChar,adParamInput,1,isViewID),_

			Db.makeParam("@strTel",adVarChar,adParamInput,150,strTel),_
			Db.makeParam("@isSMS",adChar,adParamInput,1,isSMS),_
			Db.makeParam("@isMailing",adChar,adParamInput,1,isMailing),_

			Db.makeParam("@strBirth",adDBTimeStamp,adParamInput,16,strBirth),_
			Db.makeParam("@isSolar",adChar,adParamInput,1,isSolar),_

			Db.makeParam("@CS_BirthDay",adVarChar,adParamInput,8,CS_BirthDay),_
			Db.makeParam("@CS_BirthDayTF",adSmallInt,adParamInput,1,CS_BirthDayTF),_

			Db.makeParam("@Recordtime",adVarChar,adParamInput,19,Recordtime), _

			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("DKP_MEMBER_MODIFY2",DB_PROC,arrParams,Nothing)
'		Call Db.exec("DKP_MEMBER_MODIFY",DB_PROC,arrParams,Nothing)
'		Db.makeParam("@RecodTime",adVarWChar,adParamInput,30,Recordtime),_

		OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
		Select Case OUTPUT_VALUE
			Case "ERROR"		: Call ALERTS("회원정보 저장 중 에러가 발생하였습니다. 지속적인 에러 발생 시 고객센터로 연락바랍니다.","BACK","")
			Case "FINISH"		: Call ALERTS("정보수정이 완료 되었습니다.","go","/mypage/member_info.asp")
			Case Else			: Call ALERTS("지정되지 않은 에러가 발생하였습니다. 오류 상황을 고객센터로 연락바랍니다.","BACK","")
		End Select

%>
