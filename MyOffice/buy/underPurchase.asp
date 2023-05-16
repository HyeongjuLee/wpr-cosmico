<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"

	ISLEFT = "T"
	ISSUBTOP = "T"

	Call ONLY_CS_MEMBER()

	'(추천/후원) 하선구매내역 통합
	underType	= gRequestTF("u",True)
	If underType = ""	Then underType = "v"

	Select Case underType
		Case "v"
			If Not NOM_MENU_USING Then Call WRONG_ACCESS()
			INFO_MODE	 = "BUY1-3"
			'SQL_LVL = "SELECT MAX(lvl) FROM ufn_Getsubtree_NomGroup(?,?)"
		Case "s"
			If Not SAVE_MENU_USING Then Call WRONG_ACCESS()
			INFO_MODE	 = "BUY1-2"
			'SQL_LVL = "SELECT MAX(lvl) FROM ufn_Getsubtree_MemGroup(?,?)"
		Case Else
			Call WRONG_ACCESS()
	End Select

	'하선 최대 레벨수
	'arrParams = Array(_
	'	Db.makeParam("@mbid",adVarChar,adParamInput,20,UnderID1) ,_
	'	Db.makeParam("@mbid2",adInteger,adParamInput,0,UnderID2) _
	')
	'MAXLEVEL = Db.execRsData(SQL_LVL,DB_TEXT,arrParams,DB3)

	SDATE = pRequestTF("SDATE",False)
	EDATE = pRequestTF("EDATE",False)

	If SDATE = "" Then SDATE = ""
	If EDATE = "" Then EDATE = ""

	'하선기준회원 검색
	UnderID1 = pRequestTF("UnderID1",False)
	UnderID2 = pRequestTF("UnderID2",False)
	UnderName = pRequestTF("UnderName",False)
	SELLCODE = pRequestTF("SELLCODE",False)
	sLvl = pRequestTF("sLvl",False)

	If UnderID1 = "" Then UnderID1 = DK_MEMBER_ID1
	If UnderID2 = "" Then UnderID2 = DK_MEMBER_ID2
	If UnderName = "" Then UnderName = DK_MEMBER_NAME
	If SELLCODE = "" Then SELLCODE = ""
	If sLvl = "" Then sLvl = ""		'기본대수
%>
<!--#include virtual = "/_include/document.asp"-->
<!-- <link rel="stylesheet" href="/css/style_cs.css?v4" /> -->
<link rel="stylesheet" href="/css/pay2.css?" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />
<style>
	.cur {font-size: 13px; width: 25px; display: inline-block; text-align: left; padding-left: 4px;}
	.cur1 {font-size: 14px; width: 25px; display: inline-block; text-align: left; padding-left: 4px;}
	.cur2 {font-size: 13px; width: 25px; display: inline-block; text-align: left; padding-left: 4px;}
</style>
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript" src="underPurchase.js?v4"></script>
<script type="text/javascript">

	$(document).ready(function()	{
		chgUnderPurchaseN(1);

		let contentWidth = $("#content").width();
	});

</script>
<style>
	.search_form article.table > div h6 {margin-right: 3rem !important;}
	.search_form article.table .search {width: 25% !important;}
</style>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="loadings" class="loadings userCWidth">
	<div class="loadingsInner"><img src="<%=IMG%>/159.gif" width="60" alt="" /></div>
</div>

<div id="buy" class="orderList voter">
	<form name="dateFrm" action="" method="post">
		<div class="search_form">
			<article class="date">
				<h6><%=LNG_TEXT_DATE_SEARCH%></h6>
				<div class="inputs">
					<input type="text" id="SDATE" name="SDATE" value="<%=SDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
					<span>~</span>
					<input type="text" id="EDATE" name="EDATE" value="<%=EDATE%>" readonly="readonly" onclick="openCalendar(event, this, 'YYYY-MM-DD');" />
				</div>
				<div class="buttons">
					<button type="button" onclick="chgDate('<%=DateAdd("m",-1,ThisM_1stDate)%>','<%=DateAdd("d",-1,ThisM_1stDate)%>');"><%=LNG_TEXT_LASTMONTH%></button>
					<button type="button" onclick="chgDate('<%=ThisM_1stDate%>','<%=nowDate%>');"><%=LNG_TEXT_THISMONTH%></button>
					<button type="button" onclick="chgDate('<%=DateAdd("m",-3,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_3MONTH%></button>
					<button type="button" onclick="chgDate('<%=nowDate%>','<%=nowDate%>');"><%=LNG_TEXT_TODAY%></button>
					<button type="button" onclick="chgDate('<%=DateAdd("m",-6,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_6MONTH%></button>
					<button type="button" onclick="chgDate('<%=DateAdd("yyyy",-1,nowDate)%>','<%=nowDate%>');"><%=LNG_TEXT_1YEAR%></button>
					<button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button>
				</div>
			</article>
			<article class="searchs">
				<%'기준회원%>
				<h6><%=LNG_STANDARD_MEMBER%></h6>
				<div class="standard">
					<div class="input">
						<input type="hidden" id="UnderID1" name="UnderID1" value="<%=UnderID1%>" readonly="readonly" />
						<input type="hidden" id="UnderID2" name="UnderID2" value="<%=UnderID2%>" readonly="readonly" />
						<input type="text" id="UnderName" name="UnderName" class="tweight tcenter input_text" value="<%=UnderName%>" readonly="readonly" />
						<%'#modal dialog%>
						<%If NOT IS_LIMIT_LEVEL Then%>
						<a name="modal" id="popUnderMember" class="button" href="/myoffice/member/pop_underMember.asp?u=<%=underType%>" title="<%=LNG_TEXT_UNDER_MEMBER_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
						<%End If%>
					</div>
				</div>
				<h6><%=LNG_TEXT_SALES_TYPE%></h6>
				<div class="type">
					<%
						PRINT TABS(4)&" <select id=""SELLCODE"" name=""SELLCODE"" class=""input_select"">"
						PRINT TABS(4)&" 	<option value="""">"&LNG_TEXT_ALL&"</option>"
						arrListB = Db.execRsList("DKP_SELLTYPE_LIST",DB_PROC,Nothing,listLenB,DB3)
						If IsArray(arrListB) Then
							For i = 0 To listLenB
								PRINT TABS(4)&"	<option value="""&arrListB(0,i)&""">"&arrListB(1,i)&"</option>"
							Next
						Else
							PRINT TABS(4)&"	<option value="""">"&LNG_SHOP_ORDER_DIRECT_PAY_06&"</option>"
						End If
						PRINT TABS(4)&"	</select>"
					%>
				</div>
				<%'검색%>
				<input type="button" class="search_btn" onclick="chgUnderPurchaseN(1)" value="<%=LNG_TEXT_SEARCH%>"/>
				<input type="button" class="search_reset" onclick="chgUnderPurchaseN(2)" value="<%=LNG_TEXT_INITIALIZATION%>"/>
			</article>
		</div>
	</form>

	<div id="AjaxPurchaseContent" >
		<p class="titles"><%=LNG_TEXT_LIST%></p>
		<table <%=tableatt%> class="table">
			<colgroup>
				<col width="18%" />
				<col width="10%" />
				<col width="10%" />
				<col width="6%" />
				<col width="6%" />
				<col width="20%" />
				<col width="20%" />
				<col width="10%" />
			</colgroup>
			<thead>
				<tr>
					<th><%=LNG_TEXT_MEMID%></th>
					<th colspan="2"><%=LNG_TEXT_NAME%>
					<!-- <th><%=LNG_MEMBER_LOGIN_TEXT12%></th> -->
					<th><%=LNG_TEXT_LEVEL%></th>
					<th><%=LNG_TEXT_LINE%></th>
					<th><%=LNG_TEXT_NORMAL%></th>
					<th><%=LNG_TEXT_RETURN%></th>
					<th><%=LNG_BTN_DETAIL%></th>
				</tr>
			</thead>
		</table>
	</div>
</div>

<%
	MODAL_CONTENT_WIDTH = 600
	'MODAL_CSS_TYPE = "BLUE"
%>

<!--#include virtual="/_include/modal_config.asp" -->
</div>
<!--#include virtual = "/_include/copyright.asp"-->
