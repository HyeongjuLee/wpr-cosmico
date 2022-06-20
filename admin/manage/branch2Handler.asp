<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
</head>
<body>
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE5-2"


'	MODE = pRequestTF("mode",True)
	mode = pRequestTF("mode",True)


	Select Case UCase(mode)
'	Select Case MODE
		Case "INSERT"
			isUse				= pRequestTF("isUse",True)
			cate1				= pRequestTF("cate1",True)
			cate2				= pRequestTF("cate2",True)
			strBranchName		= pRequestTF("strBranchName",True)
			strBranchOwner		= pRequestTF("strBranchOwner",True)

			strBranchTel1		= pRequestTF("strBranchTel1",True)
			strBranchTel2		= pRequestTF("strBranchTel2",True)
			strBranchTel3		= pRequestTF("strBranchTel3",True)

			strBranchFax1		= pRequestTF("strBranchFax1",False)
			strBranchFax2		= pRequestTF("strBranchFax2",False)
			strBranchFax3		= pRequestTF("strBranchFax3",False)
			strzip				= pRequestTF("strzip",True)
			straddr1			= pRequestTF("straddr1",True)
			straddr2			= pRequestTF("straddr2",True)
			strBranchMapCode	= pRequestTF("strBranchMapCode",False)

			strBankCode1		= pRequestTF("bankCode1",False)
			strBankNumber1		= pRequestTF("bankNumber1",False)
			strBankOwner1		= pRequestTF("bankOwner1",False)

			strBankCode2		= pRequestTF("bankCode2",False)
			strBankNumber2		= pRequestTF("bankNumber2",False)
			strBankOwner2		= pRequestTF("bankOwner2",False)

			strBankCode3		= pRequestTF("bankCode3",False)
			strBankNumber3		= pRequestTF("bankNumber3",False)
			strBankOwner3		= pRequestTF("bankOwner3",False)

			strBankCode4		= pRequestTF("bankCode4",False)
			strBankNumber4		= pRequestTF("bankNumber4",False)
			strBankOwner4		= pRequestTF("bankOwner4",False)






			If isUse <> "T" And isUse <> "F" Then Call ALERTS("사용유무의 값이 올바르지 않습니다.","back","")

			strBranchTel = strBranchTel1 &"-"& strBranchTel2 &"-"& strBranchTel3
			strBranchFax = strBranchFax1 &"-"& strBranchFax2 &"-"& strBranchFax3

			If Left(cate2,3) <> cate1 Then Call ALERTS("로드샵위치의 값이 올바르지 않습니다.","back","")

			BranchCode = cate2



			arrParams = Array(_
				Db.makeParam("@BranchCode",adVarChar,adParamInput,20,BranchCode),_
				Db.makeParam("@strBranchName",adVarChar,adParamInput,100,strBranchName),_
				Db.makeParam("@strZip",adVarChar,adParamInput,10,strZip),_
				Db.makeParam("@strADDR1",adVarChar,adParamInput,512,strADDR1),_
				Db.makeParam("@strADDR2",adVarChar,adParamInput,512,strADDR2),_
				Db.makeParam("@strBranchOwner",adVarChar,adParamInput,50,strBranchOwner),_
				Db.makeParam("@strBranchTel",adVarChar,adParamInput,40,strBranchTel),_
				Db.makeParam("@strBranchFax",adVarChar,adParamInput,40,strBranchFax),_
				Db.makeParam("@strBranchMapCode",adVarChar,adParamInput,8000,strBranchMapCode),_
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse),_

				Db.makeParam("@strBankCode1",adVarChar,adParamInput,100,strBankCode1),_
				Db.makeParam("@strBankNumber1",adVarChar,adParamInput,50,strBankNumber1),_
				Db.makeParam("@strBankOwner1",adVarChar,adParamInput,50,strBankOwner1),_

				Db.makeParam("@strBankCode2",adVarChar,adParamInput,100,strBankCode2),_
				Db.makeParam("@strBankNumber2",adVarChar,adParamInput,50,strBankNumber2),_
				Db.makeParam("@strBankOwner2",adVarChar,adParamInput,50,strBankOwner2),_

				Db.makeParam("@strBankCode3",adVarChar,adParamInput,100,strBankCode3),_
				Db.makeParam("@strBankNumber3",adVarChar,adParamInput,50,strBankNumber3),_
				Db.makeParam("@strBankOwner3",adVarChar,adParamInput,50,strBankOwner3),_

				Db.makeParam("@strBankCode4",adVarChar,adParamInput,100,strBankCode4),_
				Db.makeParam("@strBankNumber4",adVarChar,adParamInput,50,strBankNumber4),_
				Db.makeParam("@strBankOwner4",adVarChar,adParamInput,50,strBankOwner4),_


				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,20,"ERROR") _
			)
			Call Db.exec("DKPA_BRANCH2_INSERT",DB_PROC,arrParams,Nothing)


		Case "MODIFY"
			intIDX				= pRequestTF("intIDX",True)
			isUse				= pRequestTF("isUse",True)
			cate1				= pRequestTF("cate1",True)
			cate2				= pRequestTF("cate2",True)
			strBranchName		= pRequestTF("strBranchName",True)
			strBranchOwner		= pRequestTF("strBranchOwner",True)

			strBranchTel1		= pRequestTF("strBranchTel1",True)
			strBranchTel2		= pRequestTF("strBranchTel2",True)
			strBranchTel3		= pRequestTF("strBranchTel3",True)

			strBranchFax1		= pRequestTF("strBranchFax1",False)
			strBranchFax2		= pRequestTF("strBranchFax2",False)
			strBranchFax3		= pRequestTF("strBranchFax3",False)
			strzip				= pRequestTF("strzip",True)
			straddr1			= pRequestTF("straddr1",True)
			straddr2			= pRequestTF("straddr2",True)
			strBranchMapCode	= pRequestTF("strBranchMapCode",False)


			strBankCode1		= pRequestTF("bankCode1",False)
			strBankNumber1		= pRequestTF("bankNumber1",False)
			strBankOwner1		= pRequestTF("bankOwner1",False)

			strBankCode2		= pRequestTF("bankCode2",False)
			strBankNumber2		= pRequestTF("bankNumber2",False)
			strBankOwner2		= pRequestTF("bankOwner2",False)

			strBankCode3		= pRequestTF("bankCode3",False)
			strBankNumber3		= pRequestTF("bankNumber3",False)
			strBankOwner3		= pRequestTF("bankOwner3",False)

			strBankCode4		= pRequestTF("bankCode4",False)
			strBankNumber4		= pRequestTF("bankNumber4",False)
			strBankOwner4		= pRequestTF("bankOwner4",False)


			If isUse <> "T" And isUse <> "F" Then Call ALERTS("사용유무의 값이 올바르지 않습니다.","back","")

			strBranchTel = strBranchTel1 &"-"& strBranchTel2 &"-"& strBranchTel3
			strBranchFax = strBranchFax1 &"-"& strBranchFax2 &"-"& strBranchFax3

			If Left(cate2,3) <> cate1 Then Call ALERTS("로드샵위치의 값이 올바르지 않습니다.","back","")

			BranchCode = cate2



			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
				Db.makeParam("@BranchCode",adVarChar,adParamInput,20,BranchCode),_
				Db.makeParam("@strBranchName",adVarChar,adParamInput,100,strBranchName),_
				Db.makeParam("@strZip",adVarChar,adParamInput,10,strZip),_
				Db.makeParam("@strADDR1",adVarChar,adParamInput,512,strADDR1),_
				Db.makeParam("@strADDR2",adVarChar,adParamInput,512,strADDR2),_
				Db.makeParam("@strBranchOwner",adVarChar,adParamInput,50,strBranchOwner),_
				Db.makeParam("@strBranchTel",adVarChar,adParamInput,40,strBranchTel),_
				Db.makeParam("@strBranchFax",adVarChar,adParamInput,40,strBranchFax),_
				Db.makeParam("@strBranchMapCode",adVarChar,adParamInput,8000,strBranchMapCode),_
				Db.makeParam("@isUse",adChar,adParamInput,1,isUse),_

				Db.makeParam("@strBankCode1",adVarChar,adParamInput,100,strBankCode1),_
				Db.makeParam("@strBankNumber1",adVarChar,adParamInput,50,strBankNumber1),_
				Db.makeParam("@strBankOwner1",adVarChar,adParamInput,50,strBankOwner1),_

				Db.makeParam("@strBankCode2",adVarChar,adParamInput,100,strBankCode2),_
				Db.makeParam("@strBankNumber2",adVarChar,adParamInput,50,strBankNumber2),_
				Db.makeParam("@strBankOwner2",adVarChar,adParamInput,50,strBankOwner2),_

				Db.makeParam("@strBankCode3",adVarChar,adParamInput,100,strBankCode3),_
				Db.makeParam("@strBankNumber3",adVarChar,adParamInput,50,strBankNumber3),_
				Db.makeParam("@strBankOwner3",adVarChar,adParamInput,50,strBankOwner3),_

				Db.makeParam("@strBankCode4",adVarChar,adParamInput,100,strBankCode4),_
				Db.makeParam("@strBankNumber4",adVarChar,adParamInput,50,strBankNumber4),_
				Db.makeParam("@strBankOwner4",adVarChar,adParamInput,50,strBankOwner4),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,20,"ERROR") _
			)
			Call Db.exec("DKPA_BRANCH2_MODIFY",DB_PROC,arrParams,Nothing)

		Case "DELETE"
			intIDX = pRequestTF("intIDX",True)
'			intIDX = gRequestTF("idx",True)
			'strBoardName	= UPfORM("strBoardName",True)

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_BRANCH2_DELETE",DB_PROC,arrParams,Nothing)

	End Select

	OUTPUT_VALUE = arrParams(UBound(arrParams))(4)

Select Case OUTPUT_VALUE
	Case "ERROR"
		Call alerts("로드샵 정보 수정에 문제가 발생했습니다.","back","")
	Case "FINISH"
		Call ALERTS("정상처리되었습니다.","go","branch2_list.asp" )

End Select

%>

