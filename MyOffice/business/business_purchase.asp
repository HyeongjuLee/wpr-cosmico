<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "BCENTER1-2"

	ISLEFT = "T"
	ISSUBTOP = "T"
	OVERFLOW_VISIBLE = "F"

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,2)
	Call ONLY_CS_MEMBER()
	Call ONLY_BUSINESS(BUSINESS_CODE)

	PAGE		= pRequestTF("PAGE",False)
	PAGESIZE		= pRequestTF("PAGESIZE",False)
	SDATE		= pRequestTF("SDATE",False)
	EDATE		= pRequestTF("EDATE",False)
	SellCode		= pRequestTF("SellCode",False)
	M_NAME	= pRequestTF("M_NAME",False)
	MBID1	= pRequestTF("MBID1",False)
	MBID2	= pRequestTF("MBID2",False)
	SellTF	= pRequestTF("SellTF",False)
	ReturnTF	= pRequestTF("ReturnTF",False)
	ClassCenter	= pRequestTF("ClassCenter",False)

	If PAGE = ""		Then PAGE = 1
	If PAGESIZE = ""	Then PAGESIZE = 20
	If SDATE = ""		Then SDATE = ""
	If EDATE = ""		Then EDATE = ""
	If SellCode = ""		Then SellCode = ""
	If M_NAME = ""		Then M_NAME = ""
	If MBID1 = ""		Then MBID1 = ""
	If MBID2 = ""		Then MBID2 = ""
	If SellTF = ""		Then SellTF = ""
	If ClassCenter = ""	Then ClassCenter = "M"

	If ClassCenter = "M" Then
		BUSINESS_PURCHASE_PROC = "HJP_BUSINESS_PURCHASE_LIST_FOR_MEMBER"				'회원센터별 집계
	Else
		BUSINESS_PURCHASE_PROC = "HJP_BUSINESS_PURCHASE_LIST_FOR_MEMBER_BY_SALESCENTER"		'판매센터별 집계
	End If

	arrParams = Array(_
		Db.makeParam("@NCODE",adVarChar,adParamInput,20,BUSINESS_CODE),_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@SDATE",adVarChar,adParamInput,10,SDATE),_
		Db.makeParam("@EDATE",adVarChar,adParamInput,10,EDATE),_

		Db.makeParam("@SellCode",adVarWChar,adParamInput,100,SellCode),_
		Db.makeParam("@M_NAME",adVarWChar,adParamInput,100,M_NAME),_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,MBID1), _
		Db.makeParam("@mbid2",adVarChar,adParamInput,10,MBID2), _
		Db.makeParam("@SellTF",adChar,adParamInput,1,SellTF),_
		Db.makeParam("@ReturnTF",adChar,adParamInput,1,ReturnTF),_

		Db.makeParam("@SEARCHPV",adDouble,adParamOutput,16,0),_
		Db.makeParam("@SUMPV",adDouble,adParamOutput,16,0),_
		Db.makeParam("@SEARCHSUM",adDouble,adParamOutput,16,0),_
		Db.makeParam("@SUMPRICE",adDouble,adParamOutput,16,0),_
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList(BUSINESS_PURCHASE_PROC,DB_PROC,arrParams,listLen,DB3)
	SEARCHPV = arrParams(UBound(arrParams)-4)(4)
	SUMPV = arrParams(UBound(arrParams)-3)(4)
	SEARCHPRICE = arrParams(UBound(arrParams)-2)(4)
	SUMPRICE = arrParams(UBound(arrParams)-1)(4)
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
<link rel="stylesheet" href="default.css" />
<!-- <link rel="stylesheet" href="/myoffice/css/style_cs.css" /> -->
<!-- <link rel="stylesheet" href="/myoffice/css/layout_cs.css" /> -->
<link rel="stylesheet" href="/css/myoffice-business.css?" />
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript">
	function pageSizeChange(val){
		document.frm.PAGESIZE.value = val;
		document.frm.submit();
	}
</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="myoffice_business" class="purchase">
	<form name="dateFrm" action="business_purchase.asp" method="post">
		<div class="search_form">
			<article class="date">
				<h6><%=LNG_TEXT_SALES_DATE%></h6>
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
			<article class="members">
				<h6><%=LNG_TEXT_MEMID%></h6>
				<div class="memberNum">
					<div class="inputs">
						<input type="text" name="MBID1" class="input_text" value="<%=MBID1%>" maxlength="2" onkeyup="this.value=this.value.replace(/[^a-zA-Z]/g,'');"/>
						<span>-</span>
						<input type="text" name="MBID2" class="input_text" value="<%=MBID2%>" maxlength="<%=MBID2_LEN%>" <%=onlyKeys%> />
					</div>
				</div>
				<h6><%=LNG_TEXT_NAME%></h6>
				<div class="name">
					<input type="text" name="M_NAME" class="input_text" value="<%=M_NAME%>" maxlength="10" />
				</div>
				<h6><%=LNG_TEXT_SALES_TYPE%></h6>
				<div class="rank">
					<select name="SellCode" class="input_select">
						<option value="" selected disabled><%=LNG_TEXT_POSITION%></option>
						<%
							SQL_SC = "SELECT [SellCode],[SellTypeName] FROM [tbl_SellType] WITH(NOLOCK) ORDER BY [SellCode] ASC"
							arrList_SC = Db.execRsList(SQL_SC,DB_TEXT,Nothing,listLenBC,DB3)
							If IsArray(arrList_SC) Then
								For i = 0 To listLenBC
									arrList_SellCode 	= arrList_SC(0,i)
									arrList_SellTypeName = arrList_SC(1,i)
									PRINT "<option value="""&arrList_SellCode&""" """&isSelect(SellCode,arrList_SellCode)&""">"&arrList_SellTypeName&"</option>"
								Next
							Else
								PRINT TABS(5)& "	<option value="""">"&LNG_JOINSTEP03_U_TEXT10&"</option>"
							End If
						%>
					</select>
				</div>
				<h6><%=LNG_TEXT_PAY_CATEGORY%></h6>
				<div class="level">
					<select name="ReturnTF" class="input_select">
						<option value="" <%=isSelect(ReturnTF,"")%> ><%=LNG_TEXT_ALL%></option>
						<option value="1" <%=isSelect(ReturnTF,"1")%> ><%=LNG_TEXT_NORMAL%></option>
						<option value="2" <%=isSelect(ReturnTF,"2")%> ><%=LNG_TEXT_RETURN%></option>
						<option value="3" <%=isSelect(ReturnTF,"3")%> ><%=LNG_TEXT_EXCHANGE%></option>
						<option value="4" <%=isSelect(ReturnTF,"4")%> ><%=LNG_TEXT_PARTIAL_RETURN%></option>
						<option value="5" <%=isSelect(ReturnTF,"5")%> ><%=LNG_TEXT_POINT_CANCEL%></option>
					</select>
				</div>
			</article>
			<article class="searchs label-wrap">
				<h6><%=LNG_TEXT_ORDER_APPROVAL_TF%></h6>
				<div class="labels rank">
					<label><input type="radio" name="SellTF" value="" <%=isChecked(SellTF,"")%> checked="checked"><span><i class="icon-ok"></i><%=LNG_TEXT_ALL%></span></label>
					<label><input type="radio" name="SellTF" value="1" <%=isChecked(SellTF,"1")%> ><span><i class="icon-ok"></i><%=LNG_TEXT_ORDER_APPROVAL%></span></label>
					<label><input type="radio" name="SellTF" value="0" <%=isChecked(SellTF,"0")%> ><span><i class="icon-ok"></i><%=LNG_TEXT_ORDER_DISAPPROVAL%></span></label>
				</div>
				<h6><%=LNG_SEARCH_CATEGORY%></h6>
				<div class="labels">
					<label><input type="radio" name="ClassCenter" value="M" <%=isChecked(ClassCenter,"M")%> checked="checked" ><span><i class="icon-ok"></i>회원센터별</span></label>
					<label><input type="radio" name="ClassCenter" value="S" <%=isChecked(ClassCenter,"S")%> ><span><i class="icon-ok"></i>판매센터별</span></label>
				</div>
				<input type="submit" value="<%=LNG_TEXT_SEARCH%>" class="search_btn" />
				<a href="<%=Request.ServerVariables("SCRIPT_NAME")%>" class="search_reset"><%=LNG_TEXT_INITIALIZATION%></a>
			</article>
		</div>
	</form>

	<p class="titles"><%=LNG_TEXT_POINT_SEARCH_TOTAL%></p>
	<table <%=tableatt%> class="total">
		<colgroup>
			<col width="25%" />
			<col width="25%" />
			<col width="25%" />
			<col width="25%" />
		</colgroup>
		<thead>
			<tr>
				<th><%=LNG_TEXT_TOTAL_SALES_PRICE%></th>
				<th><%=LNG_CS_BUSINESS_PURCHASE_TEXT03%><%=CS_PV%></th>
				<th><%=LNG_CS_BUSINESS_PURCHASE_TEXT04%></th>
				<th><%=LNG_CS_BUSINESS_PURCHASE_TEXT04%><%=CS_PV%></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><%=num2cur(SUMPRICE)%></td>
				<td><%=num2cur(SUMPV)%></td>
				<td><%=num2cur(SEARCHPRICE)%></td>
				<td><%=num2cur(SEARCHPV)%></td>
			</tr>
		</tbody>
	</table>

	<%
		'table sorter
		'<thead></thead> 필수!
	%>
	<!-- <link rel="stylesheet" href="/jscript/tablesorter/jquery.wprTablesorter.css"> -->
	<link rel="stylesheet" href="/css/sortTable.css?">
	<script type="text/javascript" src="/jscript/tablesorter/jquery.wprTablesorter.js"></script>
	<script type="text/javascript">
		//table sorter
		$(document).ready(function() {
			$("#sortTable").wprTablesorter({
				firstColFix : false,	//첫번째열 고정
				firstColasc : false,	//첫번째열 오름차순 여부	//firstColFix=true일 경우 필수값
				//noSortColumns : [0]		//정렬안하는 컬럼
			});
		});
	</script>
	<p class="titles"><%=LNG_TEXT_LIST%>
		<select name="PAGESIZE" class="fright" style="width: 80px;" onchange="pageSizeChange(this.value);">
			<option value="10" <%=isSelect(PAGESIZE,"10")%>>10 개</option>
			<option value="20" <%=isSelect(PAGESIZE,"20")%>>20 개</option>
			<option value="30" <%=isSelect(PAGESIZE,"30")%>>30 개</option>
			<option value="40" <%=isSelect(PAGESIZE,"40")%>>40 개</option>
			<option value="50" <%=isSelect(PAGESIZE,"50")%>>50 개</option>
			<option value="100" <%=isSelect(PAGESIZE,"100")%>>100 개</option>
		</select>
	</p>
	<table id="sortTable" <%=tableatt%> class="sortTable tcenter">
		<colgroup>
			<col width="70" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
		</colgroup>
		<thead>
			<tr>
				<th><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_TEXT_MEMID%></th>
				<th><%=LNG_TEXT_NAME%></th>
				<th><%=LNG_TEXT_SALES_DATE%></th>
				<th><%=LNG_TEXT_SALES_PRICE%></th>
				<th><%=CS_PV%></th>
				<th><%=LNG_TEXT_SALES_TYPE%></th>
				<th><%=LNG_TEXT_ORDER_APPROVAL_TF%></th>
				<th><%=LNG_TEXT_PAY_CATEGORY%></th>
			</tr>
		</thead>
		<%
			If IsArray(arrList) Then
				For i = 0 To listLen
					'ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1
					ThisNum 		 		= arrList(0,i)
					arrList_mbid	 		= arrList(1,i)
					arrList_mbid2	 		= arrList(2,i)
					arrList_M_Name	 		= arrList(3,i)
					arrList_SellDate		= arrList(4,i)
					arrList_SellTypeName	= arrList(5,i)
					arrList_TotalPrice			= arrList(6,i)
					arrList_TotalPV			= arrList(7,i)
					arrList_TotalCV			= arrList(8,i)
					arrList_ReturnTF		= arrList(9,i)
					arrList_SellCode		= arrList(10,i)
					arrList_Approval		= arrList(11,i)
					arrList_Sell_Mem_TF		= arrList(12,i)
					arrList_Ordernumber		= arrList(13,i)
					arrList_Re_BaseOrderNumber		= arrList(14,i)		'취소/반품 원주문번호
					arrList_Re_OrderNumber		= arrList(15,i)			'취소/반품 주문번호
					arrList_Re_ReturnTF		= arrList(16,i)		'취소/반품 상태코드

					If arrList_Approval = 1 Then
						arrList_Approval = LNG_TEXT_ORDER_APPROVAL	'"승인"
					ElseIf arrList_Approval = 0 Then
						arrList_Approval = "<span class=""red"">"&LNG_TEXT_ORDER_DISAPPROVAL&"</span>"	'"미승인"
					Else
						arrList_Approval = ""
					End If

					'반품, 교환, 취소 여부
					CANCEL_STATUS = FN_CANCEL_STATUS(arrList_ReturnTF)

					'정상주문 이후 반품, 교환, 취소 여부
					mline= ""
					Re_CANCEL_STATUS= ""
					If arrList_ReturnTF = "1" And arrList_Re_ReturnTF > 1 Then
						Re_CANCEL_STATUS = "("&FN_CANCEL_STATUS(arrList_Re_ReturnTF)&")"
						mline= "mline"
					End If

					PRINT TABS(1)& "	<tr>"
					PRINT TABS(1)& "		<td>"&ThisNum&"</td>"
					PRINT TABS(1)& "		<td>"&arrList_mbid&"-"&Fn_MBID2(arrList_mbid2)&"</td>"
					PRINT TABS(1)& "		<td>"&arrList_M_Name&"</td>"
					PRINT TABS(1)& "		<td>"&date8to10(arrList_SellDate)&"</td>"
					PRINT TABS(1)& "		<td class=""inPrice "&mline&" "">"&num2cur(arrList_TotalPrice)&"</td>"
					PRINT TABS(1)& "		<td class=""inPrice "&mline&" "">"&num2cur(arrList_TotalPV)&"</td>"
					PRINT TABS(1)& "		<td>"&arrList_SellTypeName&"</td>"
					PRINT TABS(1)& "		<td>"&arrList_Approval&"</td>"
					PRINT TABS(1) & "		<td><span class="&mline&">"&CANCEL_STATUS&"</span> "&Re_CANCEL_STATUS&"</td>"
					PRINT TABS(1)& "	</tr>"
				Next
			Else
				PRINT TABS(1)& "	<tr>"
				PRINT TABS(1)& "		<td colspan=""9"" style=""height:80px;"">"&LNG_CS_BUSINESS_PURCHASE_TEXT12&"</td>"
				PRINT TABS(1)& "	</tr>"
			End If
			print TOTAL_PV
		%>
	</table>
	<div class="pagingArea pagingNew3"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
	<input type="hidden" name="SDATE" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="EDATE" value="<%=convSql(SEARCHSTR)%>" />
	<input type="hidden" name="SellCode" value="<%=SellCode%>" />
	<input type="hidden" name="M_NAME" value="<%=M_NAME%>" />
	<input type="hidden" name="MBID1" value="<%=MBID1%>" />
	<input type="hidden" name="MBID2" value="<%=MBID2%>" />
	<input type="hidden" name="SellTF" value="<%=SellTF%>" />
	<input type="hidden" name="ClassCenter" value="<%=ClassCenter%>" />
</form>
<!--#include virtual = "/_include/copyright.asp"-->
