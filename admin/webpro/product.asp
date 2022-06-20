<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"


%>
<link rel="stylesheet" href="product.css" />
<script type="text/javascript" src="product.js"></script>

</head>
<body>


<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="menuColor">
	<form name="colorFrm" action="product_Handler.asp" method="post" enctype="multipart/form-data" onsubmit="return thisForm(this);">
		<table <%=tableatt%> class="adminFullWidth list">
			<col width="250" />
			<col width="200" />
			<col width="200" />
			<col width="350" />
			<tr>
				<th>구분</th>
				<th>오버컬러</th>
				<th>아웃컬러</th>
				<th>설명</th>
			</tr>
			<tr>
				<th>11</th>
				<td><input type="file" name="strThum"></td>
			</tr><tr>
				<td colspan="2" align="center" style="padding:10px 0px;"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
			</tr>

		</table>
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
