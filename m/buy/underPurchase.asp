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
			UNDER_PURCHASE_TITLE = LNG_MYOFFICE_BUY_03
			'SQL_LVL = "SELECT MAX(lvl) FROM ufn_Getsubtree_NomGroup(?,?)"
		Case "s"
			If Not SAVE_MENU_USING Then Call WRONG_ACCESS()
			INFO_MODE	 = "BUY1-2"
			UNDER_PURCHASE_TITLE = LNG_MYOFFICE_BUY_02
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
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript" src="/m/js/calendar.js"></script>
<script type="text/javascript" src="underPurchase.js?v3"></script>
<script type="text/javascript">

	$(document).ready(function()	{
		chgUnderPurchaseN(1);
	});

</script>
<link rel="stylesheet" href="/m/css/order.css?v0" />
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->

<div class="orderList">
	<div id="loadings" style="position: absolute; left: 0; top: 0; z-index: 1; width: 100%; height: 100%;">
		<div id="loading_bg">
			<img id="loading-image" src="/images/159.gif" width="50"  alt="" />
		</div>
	</div>

	<form name="dateFrm" action="" method="post">
		<div class="search_form vertical">
			<article>
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
					<button type="button" onclick="chgDate('','');"><%=LNG_TEXT_ALL%></button>
				</div>
				<!-- <input type="submit" class="search_btn" value="<%=LNG_TEXT_SEARCH%>"/> -->
			</article>
			<article id="filter" class="table" style="display: none;" >
				<%'기준회원%>
				<div class="standard">
					<h6><%=LNG_STANDARD_MEMBER%></h6>
					<input type="hidden" id="UnderID1" name="UnderID1" value="<%=UnderID1%>" readonly="readonly" />
					<input type="hidden" id="UnderID2" name="UnderID2" value="<%=UnderID2%>" readonly="readonly" />
					<input type="text" id="UnderName" name="UnderName" class="tweight tcenter input_text" value="<%=UnderName%>" readonly="readonly" />
					<%'#modal dialog%>
					<%If NOT IS_LIMIT_LEVEL Then%>
					<a name="modal" id="underMember" class="button" href="/m/member/pop_underMember.asp?u=<%=underType%>" title="<%=LNG_TEXT_UNDER_MEMBER_SEARCH%>"><%=LNG_TEXT_SEARCH%></a>
					<%End If%>
				</div>
				<div>
					<h6><%=LNG_TEXT_SALES_TYPE%></h6>
					<%
						PRINT TABS(4)&" <select id=""SELLCODE"" name=""SELLCODE"" class=""input_select"" >"
						PRINT TABS(4)&" <option value="""">"&LNG_TEXT_ALL&"</option>"
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
			</article>
			<article>
				<div class="search">
					<input type="button" class="search_btn" onclick="chgUnderPurchaseN(1)" value="<%=LNG_TEXT_SEARCH%>"/>
					<div class="icon-ccw-1 search_reset" onclick="chgUnderPurchaseN(2);"/></div>
					<div class="icon-cog search_filter" onclick="toggle_filter('filter');"/></div>
				</div>
			</article>
		</div>
	</form>

	<div id="AjaxPurchaseContent" >

		<p class="sub_title"><%=LNG_TEXT_LIST%></p>
		<table <%=tableatt%> class="width100 buys purchase board">
			<colgroup>

			</colgroup>
			<thead>
				<tr>
					<th><%=LNG_TEXT_MEMID%></th>
					<th colspan="2"><%=LNG_TEXT_LINE%></th>
					<th rowspan="2"><%=LNG_BTN_DETAIL%></th>
				</tr>
				<tr>
					<th><%=LNG_TEXT_NAME%></th>
					<th><%=LNG_TEXT_NORMAL%></th>
					<th><%=LNG_TEXT_RETURN%></th>
				</tr>
			</thead>
		</table>

	</div>
</div>

<!--#include virtual="/m/_include/modal_config.asp" -->
<!--#include virtual = "/m/_include/copyright.asp"-->
