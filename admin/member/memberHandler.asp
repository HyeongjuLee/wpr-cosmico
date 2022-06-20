<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%

	mode			= pRequestTF("mode",False)


	strUserID		= pRequestTF("strUserID",True)
print mode
print strUserID

	Select Case UCase(mode)
		'정보수정
		Case "MODIFY"
			strName			= pRequestTF("strName",True)
			strPass			= pRequestTF("strPass",True)

			strzip			= pRequestTF("strzip",True)
			straddr1		= pRequestTF("straddr1",True)
			straddr2		= pRequestTF("straddr2",True)

			strTel1			= pRequestTF("tel_num1",False)
			strTel2			= pRequestTF("tel_num2",False)
			strTel3			= pRequestTF("tel_num3",False)

			strMobile1		= pRequestTF("mob_num1",True)
			strMobile2		= pRequestTF("mob_num2",True)
			strMobile3		= pRequestTF("mob_num3",True)
			isSMS			= pRequestTF("sendsms",True)

			strEmail1		= pRequestTF("mailh",False)
			strEmail2		= pRequestTF("mailt",False)
			isMailing		= pRequestTF("sendemail",True)


			strBirth1		= pRequestTF("birthYY",True)
			strBirth2		= pRequestTF("birthMM",True)
			strBirth3		= pRequestTF("birthDD",True)

			isSolar			= pRequestTF("isSolar",True)


			strTel = ""
			strMobile = ""


			strMobile = strMobile1 &"-"& strMobile2 &"-"& strMobile3
			strTel = strTel1 &"-"& strTel2 &"-"& strTel3


			strEmail = strEmail1 & "@" & strEmail2

			strBirth = strBirth1 &"-"& strBirth2 &"-"& strBirth3

			If Not IsDate(strBirth) Then strBirth = ""
			If isSMS = "" Then isSMS = "T"
			If isMailing = "" Then isMailing = "T"


			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID),_
				Db.makeParam("@strPass",adVarChar,adParamInput,32,strPass),_
				Db.makeParam("@strName",adVarChar,adParamInput,30,strName),_

				Db.makeParam("@strBirth",adDBTimeStamp,adParamInput,16,strBirth),_
				Db.makeParam("@isSolar",adChar,adParamInput,1,isSolar),_
				Db.makeParam("@strTel",adVarChar,adParamInput,20,strTel),_
				Db.makeParam("@strMobile",adVarChar,adParamInput,20,strMobile),_
				Db.makeParam("@isSMS",adChar,adParamInput,1,isSMS),_

				Db.makeParam("@strEmail",adVarChar,adParamInput,512,strEmail),_
				Db.makeParam("@isMailing",adChar,adParamInput,1,isMailing),_
				Db.makeParam("@strzip",adVarChar,adParamInput,10,strzip),_
				Db.makeParam("@strADDR1",adVarChar,adParamInput,512,straddr1),_
				Db.makeParam("@strADDR2",adVarChar,adParamInput,512,straddr2),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_MEMBER_INFO_MODIFY",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

			Select Case OUTPUT_VALUE
				Case "ERROR"	: Call ALERTS(DBERROR,"back","")
				Case "FINISH"	: Call ALERTS(DBFINISH,"go","member_info.asp?mid="&strUserID)
				Case Else		: Call ALERTS(DBUNDEFINED,"back","")
			End Select

		'관리자 회원탈퇴시
		Case "ADMIN_LEAVE"
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID), _
				Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_MEMBER_LEAVE_ADMIN",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

			Select Case OUTPUT_VALUE
				Case "ERROR"	: Call ALERTS(DBERROR,"back","")
				Case "FINISH"	: Call ALERTS(DBFINISH,"go","member_list.asp")
				Case Else		: Call ALERTS(DBUNDEFINED,"back","")
			End Select
		Case "LEAVEOK"
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID), _
				Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_MEMBER_LEAVEOK",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

			Select Case OUTPUT_VALUE
				Case "ERROR"	: Call ALERTS(DBERROR,"back","")
				Case "FINISH"	: Call ALERTS(DBFINISH,"go","member_list.asp")
				Case Else		: Call ALERTS(DBUNDEFINED,"back","")
			End Select
		' 회원탈퇴 철회
		Case "LEAVECANCEL"
			arrParams = Array(_
				Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID), _
				Db.makeParam("@regID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@STATUS",adChar,adParamOutput,3,"101"), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_MEMBER_LEAVE_CANCEL",DB_PROC,arrParams,Nothing)
			PAGESTATUS = arrParams(UBound(arrParams)-1)(4)
			OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

			Select Case PAGESTATUS
				Case "101"	: GOPAGE = "member_list.asp"
				Case "443"	: GOPAGE = "member_list443.asp"
				Case "444"	: GOPAGE = "member_list444.asp"
				Case "445"	: GOPAGE = "member_list445.asp"
				Case Else	: Call ALERTS(DBUNDEFINED,"back","")
			End Select


			Select Case OUTPUT_VALUE
				Case "ERROR"	: Call ALERTS(DBERROR,"back","")
				Case "FINISH"	: Call ALERTS(DBFINISH,"go",GOPAGE)
				Case Else		: Call ALERTS(DBUNDEFINED,"back","")
			End Select




		Case Else : Call ALERTS(UNDEFINED_C,"back","")
	End Select


'	Call ResRW(strUserID,"strUserID")





















'	strUserID = pRequestTF("strUserID",True)




'	state = pRequestTF("state",True)




'	arrParams = Array(_
'		Db.makeParam("@strUserID",adVarChar,adParamInput,20,strUserID),_
'		Db.makeParam("@STATE",adVarChar,adParamInput,10,state),_
'		Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR")_
'	)
'	Call Db.exec("DKPA_MEMBER_STATE_HANDLER",DB_PROC,arrParams,Nothing)
'	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)
'
'
'	Select Case OUTPUT_VALUE
'		Case "ERROR" : Call alerts("변경에 오류가 발생하였습니다.관리자에게 문의해주세요","back","")
'
'		Case "FINISH" : Call alerts("변경되었습니다.","go","member_list1.asp")
'	End Select
'





%>
</body>
</html>
