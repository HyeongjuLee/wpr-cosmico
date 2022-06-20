<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%

	mode = pRequestTF("mode",True)



	Select Case mode
		Case "INSERT"

			PhoneName = pRequestTF("PhoneName",True)
			isView = pRequestTF("isView",False)

			If isView = "" Then isView = "F"

			arrParams = Array(_
				Db.makeParam("@PhoneName",adVarChar,adParamInput,100,PhoneName),_
				Db.makeParam("@isView",adChar,adParamInput,1,isView),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,20,"ERROR") _
			)
			Call Db.exec("DKP_BRANCH_PHONE_INSERT",DB_PROC,arrParams,Nothing)

		Case "UPDATE"

			intIDX = pRequestTF("intIDX",True)
			phoneName = pRequestTF("phoneName",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@phoneName",adVarChar,adParamInput,100,phoneName), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKP_BRANCH_PHONE_UPDATE",DB_PROC,arrParams,Nothing)
		Case "CHGVIEW"

			intIDX = pRequestTF("intIDX",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKP_BRANCH_PHONE_CHGSTATUS",DB_PROC,arrParams,Nothing)


	End Select

	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

Select Case OUTPUT_VALUE
	Case "ERROR"
		Call alerts("파트너 정보 수정에 문제가 발생했습니다.","back","")
	Case "FINISH"
		If cmode = "DELETE" Then
			Call sbDeleteFiles(REAL_PATH("xml/mainFlash")&"/"&oriImg)
		End If
		Call ALERTS("정상처리되었습니다.","go","branchPhone.asp")

End Select

%>

