<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "GOODS"
	INFO_MODE = "GOODS3-5"
%>
</head>
<body>
<%

	MODE = pRequestTF("MODE",True)


	Select Case MODE
		Case "REGIST"

			strShopID	= pRequestTF("strShopID",True)
			strComName	= pRequestTF("strComName",True)
			FeeType		= pRequestTF("FeeType",True)
			intFee		= pRequestTF("intFee",True)
			intLimit	= pRequestTF("intLimit",True)
			hostIP		= getUserIP()

			If FeeType = "free" Then intFee = 0

			'기존 등록 ID 체크
			SQL = "SELECT COUNT(*) FROM [DK_DELIVERY_FEE_BY_COMPANY] WHERE [strShopID] = ?"
			arrParams = Array(_
				Db.makeParam("@strShopID",adVarChar,adParamInput,30,strShopID) _
			)
			ShopIdCheckCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

			If ShopIdCheckCnt > 0 Then Call ALERTS("이미 등록된 제조사(판매처) 아이디 입니다.\n\n 하단 리스트에서 수정해주세요.","back","")


			arrParams = Array(_
				Db.makeParam("@strShopID",adVarChar,adParamInput,30,LCase(strShopID)),_
				Db.makeParam("@strComName",adVarWChar,adParamInput,100,strComName),_
				Db.makeParam("@FeeType",adChar,adParamInput,4,FeeType), _
				Db.makeParam("@intFee",adInteger,adParamInput,0,intFee), _
				Db.makeParam("@intLimit",adInteger,adParamInput,0,intLimit), _
				Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
				Db.makeParam("@hostIP",adVarChar,adParamInput,30,hostIP),_

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJPA_DELIVERY_FEE_BY_COMPANY_REGIST",DB_PROC,arrParams,Nothing)
'			Call Db.exec("HJPA_DELIVERY_FEE_REGIST2",DB_PROC,arrParams,Nothing)

			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)


		Case "MODIFY"
			intIDX		= pRequestTF("intIDX",True)
			FeeType		= pRequestTF("FeeType",True)
			intFee		= pRequestTF("intFee",True)
			intLimit	= pRequestTF("intLimit",True)

			If FeeType = "free" Then intFee = 0

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@FeeType",adChar,adParamInput,4,FeeType), _
				Db.makeParam("@intFee",adInteger,adParamInput,0,intFee), _
				Db.makeParam("@intLimit",adInteger,adParamInput,0,intLimit), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_DELIVERY_FEE_MODIFY",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case "DELETE"
			intIDX		= pRequestTF("intIDX",True)
			isDel		= pRequestTF("isDel",True)

			strShopID	= pRequestTF("strShopID",True)

			'판매처 삭제전 판매중인 상품 체크
			SQL = "SELECT COUNT(*) FROM [DK_GOODS2] WHERE [DelTF] = 'F' AND [strShopID] = ?"
			arrParams = Array(_
				Db.makeParam("@strShopID",adVarChar,adParamInput,30,strShopID) _
			)
			GoodsViewTFCnt = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)

			If GoodsViewTFCnt > 0 Then Call ALERTS("판매중인 상품이 존재합니다.\n\n 상품을 먼저 삭제해주세요.","back","")


			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX), _
				Db.makeParam("@isDel",adChar,adParamInput,1,isDel), _

				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("HJPA_DELIVERY_FEE_DELETE",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)


'		Case "USE"
'			intIDX	= pRequestTF("intIDX",True)
'			isUse	= pRequestTF("values",True)
'
'			arrParams = Array(_
'				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
'				Db.makeParam("@isUse",adChar,adParamInput,1,isUse), _
'
'				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
'			)
'
'			Call Db.exec("HJPA_PHONE_USECHG",DB_PROC,arrParams,Nothing)
'			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

		Case Else
	End Select
	Select Case OUTPUT_VALUE
		Case "FINISH" : Call ALERTS(DBFINISH,"GO","deliveryFee_Manage.asp")
		Case "ERROR" : Call ALERTS(DBERROR,"BACK","")
		Case Else : Call ALERTS(DBUNDEFINED,"BACK","")
	End Select








%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<!--#include virtual = "/admin/_inc/copyright.asp"-->
