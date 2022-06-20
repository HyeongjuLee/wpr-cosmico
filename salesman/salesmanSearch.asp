<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'회원번호,이름으로 검색

	PAGE_SETTING = "BUSINESS"
	ISLEFT = "T"
	ISSUBTOP = "T"

	view = 5
	mNum = 2
	sNum = view

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
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="/css/select.css" />
<link rel="stylesheet" href="salesman.css?v0" />
<!-- <script type="text/javascript" src="/jscript/jcombox-1.0b.packed.js"></script> -->
<script type="text/javascript" src="salesman.js"></script>

</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="pages">

	<div id="bbs_search_top" class="">
		<form action="" method="post" name="search" style="font-size:11px;">
			<span class="searchText tweight vmiddle">판매원번호 </span><input type="text" name="MBID1" class="searchstr vmiddle imes tcenter" style="width:60px;" value="<%=MBID1%>" maxlength="6" /> -<input type="text" name="MBID2" class="searchstr vmiddle" style="width:100px;" value="<%=MBID2%>" <%=onlyKeys%> maxlength="<%=MBID2_LEN%>"/>&nbsp;&nbsp;
			<span class="searchText tweight vmiddle"> 판매원 이름 </span><input type="text" name="M_NAME" class="searchstr vmiddle imes_kr" value="<%=M_NAME%>" size="9" maxlength="20" />&nbsp;&nbsp;
			<span><input type="submit" class="txtBtn j_medium" value="<%=LNG_TEXT_SEARCH%>" /></span>
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
		<!-- <table <%=tableatt%> class="userCWidth2"> -->
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="*" />
			</colgroup>
			<%
				If IsArray(arrList) Then
					PRINT TABS(2)& "<tr>"
					PRINT TABS(2)& "<td colspan=""5"" class=""dataText"">판매원으로 등록된 회원입니다.</td>"
					PRINT TABS(2)& "</tr>"
				Else
					PRINT TABS(2)& "<tr>"
					PRINT TABS(2)& "<td colspan=""5"" class=""notData"">"&NO_DATA_TXT&"</td>"
					PRINT TABS(2)& "</tr>"
				End If

			%>
			<tr>
				<td colspan="5" class="tright pagertop"><!-- <%Call pageListn(PAGE,PAGECOUNT,"sales_pa")%> --></td>
			</tr>
		</table>

	</div>
</div>

<form name="frm" method="post" action="">
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="MBID1" value="<%=MBID1%>" />
		<input type="hidden" name="MBID2" value="<%=MBID2%>" />
		<input type="hidden" name="M_NAME" value="<%=M_NAME%>" />
</form>



<!--#include virtual = "/_include/copyright.asp"-->

