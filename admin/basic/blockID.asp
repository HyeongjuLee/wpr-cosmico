<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "CONFIG"
	INFO_MODE = "CONFIG3-1"



	arrParams = Array(_
		Db.makeParam("@strSiteID",adVarChar,adParamInput,50,"www") _
	)
	RS_BlockID = Db.execRsData("DKPA_SITE_CONFIG_BLOCKID",DB_PROC,arrParams,Nothing)

'	PRINT RS_BlockID
%>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="config">
	<form name="blockFrm" method="post" action="blockIDHandler.asp">
		<table <%=tableatt%> class="blockClass adminFullWidth">
			<tr>
				<th></th>
			</tr><tr>
				<td><textarea name="blockID" cols="8" rows="9" class="input_area area01"><%=RS_BlockID%></textarea></td>
			</tr><tr>
				<td class="btn_area"><input type="image" src="<%=IMG_BTN%>/btn_rect_confirm.gif" /></td>
			</tr>
		</table>
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
