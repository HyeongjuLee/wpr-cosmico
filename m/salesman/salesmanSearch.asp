<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'PAGE_SETTING = "MY_MEMBER"
	PAGE_SETTING = "BUSINESS"
	PAGE_SETTING2 = "SUBPAGE"

	view = 4

	Dim MBID1			:	MBID1		= Request.Form("MBID1")
	Dim MBID2			:	MBID2		= Request.Form("MBID2")
	Dim M_NAME			:	M_NAME		= Request.Form("M_NAME")
	Dim PAGESIZE		:	PAGESIZE	= Request.Form("PAGESIZE")
	Dim PAGE			:	PAGE		= Request.Form("PAGE")

	If PAGESIZE = "" Then PAGESIZE = 16
	If PAGE = "" Then PAGE = 1



	If MBID1 = "" Or MBID2 = "" Or M_NAME = "" Then
		MBID1 = ""
		MBID2 = ""
		M_NAME = ""
	End If
	If M_NAME = "" Then
		NO_DATA_TXT = LNG_SALESMAN_TEXT01
	Else
		NO_DATA_TXT = LNG_SALESMAN_TEXT02
	End If

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link rel="stylesheet" href="/m/css/salesman.css?" />
<!-- <script type="text/javascript">
 $(document).ready(
	function() {
		$("tbody.htbody tr:last-child td").css("border-bottom", "2px solid #000");
	});
</script> -->

</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->

	<div id="search_form">
		<form action="" method="post" name="search">
			<article>
				<h6>판매원 번호</h6>
				<div class="inputs">
					<input type="text" name="MBID1" value="<%=MBID1%>" maxlength="4" />
					<span>-</span>
					<input type="tel" name="MBID2" value="<%=MBID2%>" <%=onlyKeys%> maxlength="<%=MBID2_LEN%>"/>
				</div>
			</article>
			<article>
				<h6>판매원 이름</h6>
				<div class="search">
					<input type="text" name="M_NAME" class="input_text" value="<%=M_NAME%>" maxlength="20" />
					<label class="button">
						<input type="submit" value="<%=LNG_TEXT_SEARCH%>" />
						<i class="icon-search-sharp"></i>
					</label>
				</div>
			</article>
		</form>
	</div>
	<div id="salesman">
	<%
			arrParams = Array(_
				Db.makeParam("@MBID1",adVarChar,adParamInput,20,MBID1),_
				Db.makeParam("@MBID2",adInteger,adParamInput,0,MBID2),_
				Db.makeParam("@M_name",adVarWChar,adParamInput,50,M_NAME),_
				Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
				Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
				Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
			)
			arrList = Db.execRsList("DKPS_SALESMAN_SEARCH_ID",DB_PROC,arrParams,listLen,DB3)
			All_Count = arrParams(UBound(arrParams))(4)

			Dim PAGECOUNT,CNT
			PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
			IF CCur(PAGE) = 1 Then
				CNT = All_Count
			Else
				CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
			End If
	%>
		<table <%=tableatt%> class="width100 board">
			<col width="*" />
			<%
				If IsArray(arrList) Then
						PRINT TABS(1) & "	<tr>"
						PRINT TABS(1) & "		<td class=""dataText"">판매원으로 등록된 회원입니다</td>"
						PRINT TABS(1) & "	</tr>"
				Else
					PRINT TABS(1) & "	<tr>"
						PRINT TABS(1) & "		<td class=""notData"">"&NO_DATA_TXT&"</td>"
					PRINT TABS(1) & "	</tr>"
				End If
			%>
		</table>
	</div>

	<form name="frm" method="post" action="">
			<input type="hidden" name="PAGE" value="<%=PAGE%>" />
			<input type="hidden" name="MBID1" value="<%=MBID1%>" />
			<input type="hidden" name="MBID2" value="<%=MBID2%>" />
			<input type="hidden" name="M_NAME" value="<%=M_NAME%>" />
	</form>
</div>

<!--#include virtual = "/m/_include/copyright.asp"-->