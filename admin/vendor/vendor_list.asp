<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "VENDOR"
	INFO_MODE = "VENDOR1-1"



	Dim SEARCHTERM		:	SEARCHTERM = pRequestTF("SEARCHTERM",False)
	Dim SEARCHSTR		:	SEARCHSTR = pRequestTF("SEARCHSTR",False)
	Dim PAGESIZE		:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE			:	PAGE = pRequestTF("PAGE",False)					: If PAGE = "" Then PAGE = 1
	Dim ORDERS			:	ORDERS = pRequestTF("ORDERS",False)

	Dim sellerState		:	sellerState = pRequestTF("sellerState",False)	: If sellerState = "" Then sellerState = ""
	If PAGESIZE = "" Then PAGESIZE = 20

	If SEARCHTERM = "" Or SEARCHSTR = "" Then
		SEARCHTERM = ""
		SEARCHSTR = ""
	End If


	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@sellerState",adChar,adParamInput,3,sellerState), _


		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

	)
	arrList = Db.execRsList("DKPA_VENDOR_LIST",DB_PROC,arrParams,listLen,Nothing)

	All_Count = arrParams(Ubound(arrParams))(4)
'print CATEGORYS
' ===================================================================
		Dim PAGECOUNT,CNT
		PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If



%>
<script type="text/javascript" src="vendor_list.js"></script>
<link rel="stylesheet" href="vendor.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="vendor_search">
	<form name="searchform" action="vendor_list.asp" method="post">
		<table <%=tableatt%> class="goodSearch">
			<colgroup>
				<col width="190" />
				<col width="*" />
			</colgroup>
			<tbody>
			<tr>
				<th>상태조건</th>
				<td>
					<label><input type="radio" name="sellerState" value="" <%=isChecked(sellerState,"")%> /> 전체상태</label>
					<label><input type="radio" name="sellerState" value="101" <%=isChecked(sellerState,"101")%> /> 활동중인 벤더</label>
					<label><input type="radio" name="sellerState" value="100" <%=isChecked(sellerState,"100")%> /> 대기중인 벤더</label>
					<label><input type="radio" name="sellerState" value="102" <%=isChecked(sellerState,"102")%> /> 정지된 벤터</label>
				</td>
			</tr><tr>
				<th>조건</th>
				<td>
					<select name="SEARCHTERM">
						<option value="strShopID">벤더 아이디로 검색</option>
						<option value="strComName">벤더명으로 검색</option>
					</select>
					<input type="text" name="SEARCHSTR" value="<%=searchstr%>" class="input_text" /> <input type="image" src="<%=img_btn%>/g_list_search.gif" />
				</td>
			</tr>
			</tbody>
		</table>
	</form>
</div>


<div id="vendor_list">
	<table <%=tableatt%> class="goodList">
		<colgroup>
			<col width="100" />
			<col width="100" />
			<col width="90" />
			<col width="90" />
			<col width="90" />
			<col width="90" />
			<col width="110" />
			<col width="200" />
			<col width="" />
		</colgroup>
		<thead>
			<tr>
				<th>벤더아이디</th>
				<th>벤더명</th>
				<th>등록일</th>
				<th>상태정보</th>
				<th>승인일</th>
				<th>반려일</th>
				<th>배송비</th>
				<th>배송정책</th>
				<th>기능</th>
			</tr>
		</thead>
		<tbody>
			<%
				If IsArray(arrList) Then
					For i = 0 To listLen
						arrList_intIDX        = arrList(1,i)
						arrList_strShopID     = arrList(2,i)
						arrList_strPass       = arrList(3,i)
						arrList_strComName    = arrList(4,i)
						arrList_sellerState   = arrList(5,i)
						arrList_regDate       = arrList(6,i)
						arrList_AcceptDate    = arrList(7,i)
						arrList_RefuseDate    = arrList(8,i)
						arrList_StopDate      = arrList(9,i)
						arrList_FeeType       = arrList(10,i)
						arrList_intFee        = arrList(11,i)
						arrList_intLimit      = arrList(12,i)


			%>
			<tr>
				<td class="tcenter"><%=arrList_strShopID%></td>
				<td class="tcenter"><%=arrList_strComName%></td>
				<td class="tcenter"><%=cutDate(arrList_regDate,2)%><br /><%=cutDate(arrList_regDate,3)%></td>
				<td class="tcenter"><%=Fn_vender_status(arrList_sellerState)%></td>
				<td class="tcenter"><%=cutDate(arrList_AcceptDate,2)%><br /><%=cutDate(arrList_AcceptDate,3)%></td>
				<td class="tcenter"><%=cutDate(arrList_StopDate,2)%><br /><%=cutDate(arrList_StopDate,3)%></td>
				<td class="tcenter"><%=printDeli(arrList_FeeType)%></td>
				<td class="tcenter"><%=num2cur(arrList_intFee)%> 원<br /><%=num2cur(arrList_intLimit)%> 원 이상 무료배송</td>
				<td class="tcenter">
					<!-- <img src="<%=img_btn%>/b1.gif" width="50" height="20" style="padding-bottom:2px;" alt="저장" /><br /> -->
					<span class="button medium strong icon"><span class="check"></span><a href="vendor_modify.asp?idx=<%=arrList_intIDX%>">수정/보기</a></span><br />
				</td>
			</tr>
			<%Next%><%End If%>
			<tr>
				<td colspan="6" align="center" style="height:45px; border:none;"><%Call pageList(PAGE,PAGECOUNT)%></td>
			</tr>
		</tbody>

	</table>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="sellerState" value="<%=sellerState%>" />
</form>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
