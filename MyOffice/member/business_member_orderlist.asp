<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "MEMBER2-3"

	ISLEFT = "T"
	ISSUBTOP = "T"
	OVERFLOW_VISIBLE = "F"

	Call ONLY_CS_MEMBER()
	Call ONLY_BUSINESS(BUSINESS_CODE)
	Dim PAGE
	PAGE		= pRequestTF("PAGE",False)
	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 20


	'M_Name = pRequestTF("M_Name",False)

	mid1 = Request("mid1")
	mid2 = Request("mid2")

	If mid1 = "" Then mid1 = ""
	If mid2 = "" Then mid2 = ""


		'Db.makeParam("@M_name",adVarWChar,adParamInput,100,M_Name), _
	arrParams = Array(_
		Db.makeParam("@NCODE",adVarChar,adParamInput,20,BUSINESS_CODE),_
		Db.makeParam("@MBID",adVarChar,adParamInput,20,mid1),_
		Db.makeParam("@MBID2",adVarChar,adParamInput,20,mid2),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKP_BUSINESS_PURCHASE_LIST",DB_PROC,arrParams,listLen,DB3)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If




%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<link rel="stylesheet" href="/myoffice/business/default.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="buy" class="orderList">
	<form name="searchform" action="business_member_orderlist.asp" method="post">
		<table <%=tableatt%> class="userCWidth table1">
			<colgroup>
				<col width="190" />
				<col width="*" />
			</colgroup>
			<tbody>
			<tr>
				<th><%=LNG_TEXT_MEMID%></th>
				<td>
					<!-- <input type="text" name="M_Name" value="<%=M_Name%>" class="input_text vtop" style="width:180px; padding:2px 5px;"> -->
					<input type="text" name="mid1" value="<%=mid1%>" class="input_text vtop" style="width:30px; padding:2px 5px;"> -
					<input type="text" name="mid2" value="<%=mid2%>" class="input_text vtop" style="width:100px; padding:2px 5px;">
					<input type="submit" class="txtBtn small3 radius3 tweight" value="<%=LNG_TEXT_SEARCH%>"/>
					<input type="button" class="txtBtn small3 radius3" value="<%=LNG_TEXT_INITIALIZATION%>" onclick="location.href='business_member_orderlist.asp';"/>
				</td>
			</tr>
			</tbody>
		</table>
	</form>
</div>
<div id="business" class="member" style="margin-top:15px;">
	<table <%=tableatt1%> class="userCWidth list">
		<colgroup>
			<col width="" />
			<col width="" />
			<col width="" />
			<!-- <col width="" />
			<col width="" /> -->
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
		</colgroup>
		<tr>
			<th><%=LNG_TEXT_NUMBER%></th>
			<th><%=LNG_TEXT_MEMID%></th>
			<th><%=LNG_TEXT_NAME%></th>
			<!-- <th><%=LNG_TEXT_BIRTH%></th>
			<th><%=LNG_TEXT_TEL%></th>
			<th><%=LNG_TEXT_MOBILE%></th> -->
			<th><%=LNG_TEXT_POSITION%></th>
			<th><%=LNG_TEXT_REGTIME%></th>
			<th><%=LNG_TEXT_TOTAL_PURCHASE_CNT%></th>
			<th colspan="2"><%=LNG_TEXT_PURCHASE%></th>
		</tr>
		<%
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV


				pgisc = 0
				If IsArray(arrList) Then
					For i = 0 To listLen

						ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1

						If arrList(4,i) <> "" Then arrList(4,i) = objEncrypter.Decrypt(arrList(4,i))
						If arrList(5,i) <> "" Then arrList(5,i) = objEncrypter.Decrypt(arrList(5,i))
						If arrList(6,i) <> "" Then arrList(6,i) = objEncrypter.Decrypt(arrList(6,i))
						PRINT TABS(1)& "	<tr>"
						PRINT TABS(1)& "		<td>"&ThisNum&"</td>"
						PRINT TABS(1)& "		<td>"&arrList(1,i)&"-"&Fn_MBID2(arrList(2,i))&"</td>"
						PRINT TABS(1)& "		<td>"&arrList(3,i)&"</td>"
						'PRINT TABS(1)& "		<td>"&Left(arrList(4,i),6)&"</td>"
						'PRINT TABS(1)& "		<td>"&arrList(5,i)&"</td>"
						'PRINT TABS(1)& "		<td>"&arrList(6,i)&"</td>"
						PRINT TABS(1)& "		<td>"&arrList(7,i)&"</td>"
						PRINT TABS(1)& "		<td>"&date8to10(arrList(9,i))&"</td>"
						PRINT TABS(1)& "		<td>"&arrList(10,i)&"</td>"
						PRINT TABS(1)& "		<td><span class=""button medium vmiddle icon""><span class=""check""></span><a href=""/myoffice/buy/goodsList_4_downmember.asp?mid1="&arrList(1,i)&"&mid2="&arrList(2,i)&" "">"&LNG_CS_GOODSLIST_TEXT11&"</a></span></td>"
						PRINT TABS(1)& "		<td><span class=""button medium vmiddle icon""><span class=""check""></span><a href=""/myoffice/buy/cart_4_downMember.asp?mid1="&arrList(1,i)&"&mid2="&arrList(2,i)&" "">"&LNG_MYPAGE_03&"</a></span></td>"
						PRINT TABS(1)& "	</tr>"
					Next
				Else
					PRINT TABS(1)& "	<tr>"
					PRINT TABS(1)& "		<td colspan=""8"" style=""height:80px;"">"&LNG_CS_BUSINESS_MEMBER_TEXT09&"</td>"
					PRINT TABS(1)& "	</tr>"
				End If
			Set objEncrypter = Nothing

		%>
	</table>
	<div class="pagingArea pagingNew">
		<% Call pageListNew(PAGE,PAGECOUNT)%>
	</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
</form>




<!--#include virtual = "/_include/copyright.asp"-->