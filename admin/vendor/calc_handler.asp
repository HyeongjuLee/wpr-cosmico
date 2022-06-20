<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "VENDOR"
	INFO_MODE = "VENDOR0-0"


	Dim calcDate : calcDate = pRequestTF("calcDate",True)
	Dim chkCalcB : chkCalcB = pRequestTF("chkCalcB",False)


	Dim PAGE			:	PAGE = pRequestTF("PAGE",False)						: If PAGE = "" Then PAGE = 1
	Dim PAGESIZE		:	PAGESIZE = pRequestTF("PAGESIZE",False)				: If PAGESIZE = "" Then PAGESIZE = 30
	Dim sf_strShopID	:	sf_strShopID = pRequestTF("sf_strShopID",False)		: If sf_strShopID = "" Then sf_strShopID = ""
	Dim sf_isCalcTF		:	sf_isCalcTF = pRequestTF("sf_isCalcTF",False)		: If sf_isCalcTF = "" Then sf_isCalcTF = ""
	Dim sf_isGabogo		:	sf_isGabogo = pRequestTF("sf_isGabogo",False)		: If sf_isGabogo = "" Then sf_isGabogo = ""
	Dim sf_calcDate		:	sf_calcDate = pRequestTF("sf_calcDate",False)		: If sf_calcDate = "" Then sf_calcDate = ""
	Dim sf_OrderNum		:	sf_OrderNum = pRequestTF("sf_OrderNum",False)		: If sf_OrderNum = "" Then sf_OrderNum = ""
	Dim sf_GoodsName	:	sf_GoodsName = pRequestTF("sf_GoodsName",False)		: If sf_GoodsName = "" Then sf_GoodsName = ""



%>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%

	chkCalcB_s = Split(chkCalcB,",")
	chkCalcB_u = Ubound(chkCalcB_s)


	For i = 0 To chkCalcB_u
		'print chkCalcB_s(i)
		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,Trim(chkCalcB_s(i))),_
			Db.makeParam("@calcDate",adDBTimeStamp,adParamInput,16,calcDate),_
			Db.makeParam("@calcID",adVarChar,adParamInput,20,DK_MEMBER_ID),_
			Db.makeParam("@calcIP",adVarChar,adParamInput,20,getUserIP),_

			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("DKPA_CALC_REGIST",DB_PROC,arrParams,Nothing)
		OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
	Next



	Select Case OUTPUT_VALUE
		Case "ERROR" : Call ALERTS(DBERROR,"back","")
		Case "FINISH"
%>
	<form name="rFrm" action="calc_list.asp" method="post">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="sf_strShopID" value="<%=sf_strShopID%>" />
		<input type="hidden" name="sf_isCalcTF" value="<%=sf_isCalcTF%>" />
		<input type="hidden" name="sf_isGabogo" value="<%=sf_isGabogo%>" />
		<input type="hidden" name="sf_calcDate" value="<%=sf_calcDate%>" />
		<input type="hidden" name="sf_OrderNum" value="<%=sf_OrderNum%>" />
		<input type="hidden" name="sf_GoodsName" value="<%=sf_GoodsName%>" />

	</form>
	<script type="text/javascript">
		alert("정상처리되었습니다");
		document.rFrm.submit();
	</script>

<%
		Case Else : Call ALERTS(DBUNDEFINED,"back","")
	End Select


%>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
