<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_MEMBER"

	'Call FNC_ONLY_CS_MEMBER()

	'회원번호,이름으로 검색
	Response.Redirect "/m/salesman/salesmanSearch.asp"


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

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="salesman.css" />
<script type="text/javascript">
 $(document).ready(
	function() {
		$("tbody.htbody tr:last-child td").css("border-bottom", "2px solid #000");
	});
</script>

</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_MEMBERSHIP_SALESMAN_SEARCH%></div>

<div id="salesman" class="member_vote">
	<div id="salesman_search" style="padding:10px 10px;">
		<form name="search" action="" method="post" >
			<div class="st_area fleft">
				<select class="searchterm select vmiddle" name="searchterm">
					<option value="name"<%If SEARCHTERM = "name" Then%> selected="selected"<%End If%>><%=LNG_TEXT_NAME%></option>
					<!-- <option value="hptel"<%If SEARCHTERM = "hptel" Then%> selected="selected"<%End If%>><%=LNG_TEXT_CONTACT_NUMBER%></option> -->
					<option value="WebID"<%If SEARCHTERM = "WebID" Then%> selected="selected"<%End If%>><%=LNG_TEXT_ID%></option>
				</select>
			</div>
			<div class="s_area">
				<div id ="msearch">
					<input type="text" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" class="input_search" title="검색어 입력" placeholder="" >
					<input type="hidden" name="cate" value="<%=CATEGORY%>" />
					<button type="submit" title="" class="btn_search">
						<em></em><i></i>
					</button>
				</div>
			</div>
		</form>
	</div>
<%
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
		<col width="40" />
		<col width="30%" />
		<col width="25%" />
		<col width="*" />
		<tr>
			<th><%=LNG_TEXT_NUMBER%></th>
			<th><%=LNG_TEXT_MEMID%></th>
			<th><%=LNG_TEXT_NAME%></th>
			<!-- <th><%=LNG_TEXT_WEBID%></th> -->
			<th><%=LNG_BTN_DETAIL%></th>
		</tr>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					'print salesTel
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

					PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td class=""tcenter"">"&arrList(0,i)&"</td>"
					PRINT TABS(1) & "		<td class=""tcenter"">"&arrList(1,i)&"-"&Fn_MBID2(arrList(2,i))&"</td>"
					PRINT TABS(1) & "		<td class=""tcenter"">"&arrList(3,i)&"</td>"
					'PRINT TABS(1) & "		<td class=""tcenter"">"&WebID&"</td>"
					PRINT TABS(1) & "		<td><a class=""btn_a"" onclick=""toggle_tbody('tbody"&i&"');"">"&LNG_BTN_DETAIL&"</a></td>"
					PRINT TABS(1) & "	</tr>"
					PRINT TABS(1) & "	<tbody id=""tbody"&i&""" class=""htbody"" style=""display:none;"">"
					PRINT TABS(1) & "		<tr>"
					PRINT TABS(1) & "			<td colspan=""2"" class=""tright"">"&LNG_TEXT_CENTER&"</td>"
					PRINT TABS(1) & "			<td colspan=""2"" class=""pad_l15"">"&arrList(5,i)&"</td>"
					PRINT TABS(1) & "		</tr>"
					PRINT TABS(1) & "		<tr>"
					PRINT TABS(1) & "			<td colspan=""2"" class=""tright"">"&LNG_TEXT_CONTACT_NUMBER&"</td>"
					PRINT TABS(1) & "			<td colspan=""2"" class=""pad_l15"">"&salesTel&"****</td>"
					PRINT TABS(1) & "		</tr>"
					PRINT TABS(1) & "	</tbody>"
				Next

			Else
				PRINT TABS(1) & "	<tr>"
					PRINT TABS(1) & "		<td colspan=""4"" class=""notData"">"&NO_DATA_TXT&"</td>"
				PRINT TABS(1) & "	</tr>"
			End If
		%>

	</table>
</div>

<!--#include virtual = "/m/_include/copyright.asp"-->