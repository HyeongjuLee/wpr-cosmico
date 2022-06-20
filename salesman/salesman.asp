<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'회원번호,이름으로 검색
	Response.Redirect "/salesman/salesmanSearch.asp"

	PAGE_SETTING = "BUSINESS"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = 5
	mNum = 2
	sNum = view

	Dim PAGESIZE		:	PAGESIZE = Request.Form("PAGESIZE")
	Dim PAGE			:	PAGE = Request.Form("PAGE")
	Dim SEARCHTERM		:	SEARCHTERM = Request.Form("SEARCHTERM")
	Dim SEARCHSTR		:	SEARCHSTR = Request.Form("SEARCHSTR")

	If PAGESIZE = "" Then PAGESIZE = 16
	If PAGE = "" Then PAGE = 1


	If SEARCHTERM = "" Or SEARCHSTR = "" Then
		SEARCHTERM = ""
		SEARCHSTR = ""
	End If
	If SEARCHSTR = "" Then
		NO_DATA_TXT = LNG_SALESMAN_TEXT01
	Else
		NO_DATA_TXT = LNG_SALESMAN_TEXT02
	End If

	DEPTH1 = "<a href=""/index"">HOME</a>"
	DEPTH2 = "<a href=""/page/business.asp?view=1"">"&LNG_SALESMAN_TEXT03&"</a>"


%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/css/select.css" />
<link rel="stylesheet" href="salesman.css" />
ㄴ<script type="text/javascript" src="salesman.js"></script>

</head>
<body>
<!--#include virtual = "/_include/header.asp"-->

<div id="pages">

	<div id="bbs_search_top" class="">
		<form action="" method="post" name="search">
			<select class="searchterm select vmiddle" name="searchterm">
				<option value="name"<%If SEARCHTERM = "name" Then%> selected="selected"<%End If%>><%=LNG_TEXT_NAME%></option>
				<!-- <option value="hptel"<%If SEARCHTERM = "hptel" Then%> selected="selected"<%End If%>><%=LNG_TEXT_CONTACT_NUMBER%></option> -->
				<option value="WebID"<%If SEARCHTERM = "WebID" Then%> selected="selected"<%End If%>><%=LNG_TEXT_ID%></option>
			</select>
			<input type="text" class="searchstr vmiddle" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" /></td>
			<button type="submit" class="searchBoard fright cp" />
				<div class="searchGlass"></div>
			</button>
			<!-- <input type="image" src="<%=IMG_ETC%>/search.gif" class="vmiddle" /> -->
		</form>
	</div>
	<div id="salesman">
		<%
			'====================================================================================
			If DKCONF_SITE_ENC = "T" Then
				'If SEARCHTERM = "hptel" Or SEARCHTERM = "WebID" Then
				If SEARCHTERM = "hptel" Then
					Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV

						If SEARCHSTR <> "" Then SEARCHSTR	= objEncrypter.Encrypt(SEARCHSTR)

					Set objEncrypter = Nothing
				End If
			End If
			'====================================================================================

			arrParams = Array(_
				Db.makeParam("@SEARCHTERM",adVarWChar,adParamInput,30,SEARCHTERM),_
				Db.makeParam("@SEARCHSTR",adVarWChar,adParamInput,100,SEARCHSTR),_
				Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
				Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
				Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
			)
			arrList = Db.execRsList("DKPS_SALESMAN_SEARCH",DB_PROC,arrParams,listLen,DB3)
			All_Count = arrParams(UBound(arrParams))(4)

			Dim PAGECOUNT,CNT
			PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
			IF CCur(PAGE) = 1 Then
				CNT = All_Count
			Else
				CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
			End If

		%>
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="10%" />
				<col width="23%" />
				<col width="23%" />
				<col width="23%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_TEXT_MEMID%></th>
				<th><%=LNG_TEXT_CENTER%><!-- <%=LNG_TEXT_NATION%> --></th>
				<th><%=LNG_TEXT_NAME%></th>
				<th><%=LNG_TEXT_CONTACT_NUMBER%></th>
			</tr>
			<%
				If IsArray(arrList) Then
					For i = 0 To listLen
'						print salesTel
						salesTel	 = arrList(4,i)
						salesWebID   = arrList(6,i)
						salesNa_Code = arrList(7,i)

						If DKCONF_SITE_ENC = "T" Then
							Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
								objEncrypter.Key = con_EncryptKey
								objEncrypter.InitialVector = con_EncryptKeyIV
								If salesTel		<> "" Then salesTel		= objEncrypter.Decrypt(salesTel)
								'If salesWebID	<> "" Then salesWebID	= objEncrypter.Decrypt(salesWebID)
							Set objEncrypter = Nothing
						End If

						If salesTel = "" Then salesTel = "--"
						salesTelLen = Len(salesTel)
						salesTel = Left(salesTel,salesTelLen-4)

						If salesNa_Code = "" Then salesNa_Code = "KR"

						PRINT TABS(2)& "	<tr class=""for_td"">"
						PRINT TABS(2)& "		<td>"&arrList(0,i)&"</td>"
						PRINT TABS(2)& "		<td>"&arrList(1,i)&"-"&Fn_MBID2(arrList(2,i))&"</td>"
						'PRINT TABS(2)& "		<td>"&salesNa_Code&"</td>"
						PRINT TABS(2)& "		<td>"&arrList(5,i)&"</td>"
						PRINT TABS(2)& "		<td>"&arrList(3,i)&"</td>"
						'PRINT TABS(2)& "		<td>"&salesWebID&"</td>"
						PRINT TABS(2)& "		<td>"&salesTel&"****</td>"
						PRINT TABS(2)& "	</tr>"
					Next
				Else
					PRINT TABS(2)& "<tr>"
					PRINT TABS(2)& "<td colspan=""5"" class=""notData"">"&NO_DATA_TXT&"</td>"
					PRINT TABS(2)& "</tr>"
				End If

			%><tr>
				<td colspan="5" class="tright pagertop"><%Call pageListn(PAGE,PAGECOUNT,"sales_pa")%></td>
			</tr>
		</table>

	</div>
</div>

<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
</form>



<!--#include virtual = "/_include/copyright.asp"-->

