<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/m/_include/document.asp"-->

<%


	Call ONLY_MEMBER(DK_MEMBER_LEVEL)

	Gidx = Trim(pRequestTF("Gidx",False))
	Gopt = Trim(pRequestTF("goodsOption",False))
	ea = Trim(pRequestTF("ea",True))
	uidx = Trim(pRequestTF("uidx",False))
	cuidx = Trim(pRequestTF("cuidx",False))
	suidx = trim(pRequestTF("chkCart",False))

	strShopID = trim(pRequestTF("strShopID",False))
	isShopType = trim(pRequestTF("isShopType",False))
	GoodsDeliveryType = trim(pRequestTF("GoodsDeliveryType",False))


	' 값 설정
	If DK_MEMBER_ID = "" Then DK_MEMBER_ID = ""
	If Gopt = ""  Then Gopt = ""




			arrParams = Array( _
				Db.makeParam("@strDomain",adVarChar,adParamInput,50,strHostA), _
				Db.makeParam("@strMemID",adVarChar,adParamInput,20,DK_MEMBER_ID), _
				Db.makeParam("@strIDX",adVarChar,adParamInput,50,DK_SES_MEMBER_IDX), _
				Db.makeParam("@GoodIDX",adInteger,adParamInput,0,Gidx), _
				Db.makeParam("@strOption",adVarChar,adParamInput,512,Gopt), _
				Db.makeParam("@orderEa",adInteger,adParamInput,0,ea), _
				Db.makeParam("@isShopType",adChar,adParamInput,1,isShopType), _
				Db.makeParam("@strShopID",adVarChar,adParamInput,30,strShopID), _
				Db.makeParam("@isDirect",adChar,adParamInput,1,"T"), _
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,UCase(DK_MEMBER_NATIONCODE)), _
				Db.makeParam("@IDENTITY",adInteger,adParamOutput,4,0) _
			)
			Call Db.exec("DKSP_CART_DIRECT",DB_PROC,arrParams,Nothing)
			IDENTITY = arrParams(Ubound(arrParams))(4)
			Call Db.finishTrans(Nothing)

			If Err.Number <> 0 Then
				Call alerts("구매프로세스 작동중 오류가 발생하였습니다. 새로고침 후 지속적으로 오류가 발생하시면 관리자에게 문의해주세요","back","")
			Else
%>
</head>
<body onload="document.frm.submit();">
<form name="frm" method="post" action="/m/shop/order.asp">
	<input type="hidden" name="cuidx" value="<%=IDENTITY%>" />
</form>
<%
			End If



%>
