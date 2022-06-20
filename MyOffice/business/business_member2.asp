<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "BCENTER1-1"

	ISLEFT = "T"
	ISSUBTOP = "T"
	OVERFLOW_VISIBLE = "F"

	Call ONLY_CS_MEMBER()
	Call ONLY_BUSINESS(BUSINESS_CODE)
	Dim PAGE
	PAGE		= pRequestTF("PAGE",False)
	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 20

	arrParams = Array(_
		Db.makeParam("@NCODE",adVarChar,adParamInput,20,BUSINESS_CODE),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

	)
	arrList = Db.execRsList("DKP_BUSINESS_MEMBER_LIST",DB_PROC,arrParams,listLen,DB3)
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
<link rel="stylesheet" href="default.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="business" class="member">
	<table <%=tableatt1%> class="userCWidth list">
		<colgroup>
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
		</colgroup>
		<tr>
			<th><%=LNG_TEXT_NUMBER%></th>
			<!-- <th><%=LNG_TEXT_MEMID%></th> -->
			<th><%=LNG_TEXT_WEBID%></th>
			<th><%=LNG_TEXT_NAME%></th>
			<th><%=LNG_STRTEXT_TEXT_SPON%></th>
			<th><%=LNG_STRTEXT_TEXT_NOMIN%></th>

			<th><%=LNG_TEXT_BIRTH%></th>
			<th><%=LNG_TEXT_TEL%></th>
			<!-- <th><%=LNG_TEXT_MOBILE%></th> -->
			<th><%=LNG_TEXT_POSITION%></th>
			<th><%=LNG_TEXT_REGTIME%></th>
			<th><%=LNG_TEXT_GRADE_CONFIRM_DATE%></th>
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
						If arrList(10,i) <> "" Then arrList(10,i) = objEncrypter.Decrypt(arrList(10,i))	'WebID

						'▣ 등급확인일 : 승인된 최초매출일(2016-07-01)
						SQL1 = "SELECT TOP(1) A.[SellDate] FROM [tbl_Salesdetail] AS A "
						SQL1 = SQL1 & " JOIN [tbl_SalesDetail_TF] AS B ON B.[OrderNumber] = A.[OrderNumber] "
						SQL1 = SQL1 & " WHERE A.[mbid] = ? AND A.[mbid2] = ? "
						SQL1 = SQL1 & "  AND A.[ReturnTF] = 1 AND B.[SellTF] = 1 ORDER BY [SellDate] ASC "  '정상판매 AND 승인
						arrParams = Array(_
							Db.makeParam("@mbid",adVarChar,adParamInput,20,arrList(1,i)), _
							Db.makeParam("@mbid2",adInteger,adParamInput,0,arrList(2,i)) _
						)
						CENTER_MEMBER_FIRST_SELLDATE = Db.execRsData(SQL1,DB_TEXT,arrParams,DB3)

						PRINT TABS(1)& "	<tr>"
						PRINT TABS(1)& "		<td>"&ThisNum&"</td>"
						'PRINT TABS(1)& "		<td>"&arrList(1,i)&"-"&Fn_MBID2(arrList_mbid2)&"</td>"
						PRINT TABS(1)& "		<td>"&arrList(10,i)&"</td>"
						PRINT TABS(1)& "		<td>"&arrList(3,i)&"</td>"
						PRINT TABS(1)& "		<td>"&arrList(15,i)&"</td>"
						PRINT TABS(1)& "		<td>"&arrList(16,i)&"</td>"

						PRINT TABS(1)& "		<td>"&Left(arrList(4,i),6)&"</td>"
						PRINT TABS(1)& "		<td>"&arrList(5,i)&"</td>"
						'PRINT TABS(1)& "		<td>"&arrList(6,i)&"</td>"
						PRINT TABS(1)& "		<td>"&arrList(7,i)&"</td>"
						PRINT TABS(1)& "		<td>"&date8to10(arrList(9,i))&"</td>"
						PRINT TABS(1)& "		<td>"&date8to10(CENTER_MEMBER_FIRST_SELLDATE)&"</td>"
						PRINT TABS(1)& "	</tr>"
					Next
				Else
					PRINT TABS(1)& "	<tr>"
					PRINT TABS(1)& "		<td colspan=""10"" style=""height:80px;"">"&LNG_CS_BUSINESS_MEMBER_TEXT09&"</td>"
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