<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "ORDERS"
	INFO_MODE = "ORDERS4-1"


	Dim SEARCHTERM		:	SEARCHTERM = Request.Form("SEARCHTERM")
	Dim SEARCHSTR		:	SEARCHSTR = Request.Form("SEARCHSTR")
	Dim PAGESIZE		:	PAGESIZE = Request.Form("PAGESIZE")
	Dim PAGE			:	PAGE = Request.Form("PAGE")
	Dim isDel			:	isDel = Request.Form("isDel")


	If PAGESIZE = "" Then PAGESIZE = 20
	If PAGE = "" Then PAGE = 1
	If SEARCHTERM = "" Or SEARCHSTR = "" Then
		SEARCHTERM = ""
		SEARCHSTR = ""
	End If
	If isDel = "" Then isDel = ""

	arrParams = Array(_
		Db.makeParam("@isDel",adChar,adParamInput,1,isDel),_
		Db.makeParam("@PAGE",adInteger,adParamInput,4,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,4,PAGESIZE),_
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM),_
		Db.makeParam("@SEARCHSTR",adVarWChar,adParamInput,30,SEARCHSTR),_
		Db.makeParam("@ALL_COUNT",adInteger,adParamInput,4,0) _
	)
	arrList = Db.execRsList("DKPA_INICIS_SAFEKEY_LIST",DB_PROC,arrParams,listLen,Nothing)
	ALL_COUNT = arrParams(Ubound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(ALL_COUNT) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = ALL_COUNT
	Else
		CNT = ALL_COUNT - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If






%>
<link rel="stylesheet" href="SafeKey.css" />
<script type="text/javascript" src="SafeKey.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="safekey">
	<div class="search width100">
		<form name="searchform" method="post">
			<table <%=tableatt%> class="width100">
				<col width="200" />
				<col width="*" />
				<!-- <tr>
					<th>결제방식</th>
					<td>
						<label><input type="radio" name="schpayway" value="" class="input_radio" <%=isChecked(schpayway,"")%> />전체</label>
						<label><input type="radio" name="schpayway" value="inbank" class="input_radio" <%=isChecked(schpayway,"inbank")%> />온라인결제</label>
						<label><input type="radio" name="schpayway" value="card" class="input_radio" <%=isChecked(schpayway,"card")%>  />카드결제</label>
					</td>
				</tr><tr>
					<th>주문금액</th>
					<td>
						<input type="text" name="minPrice" class="input_text" value="<%=minPrice%>" /> 원 부터 <input type="text" name="maxPrice" class="input_text"  value="<%=maxPrice%>" /> 원까지
					</td>
				</tr> --><tr>
					<th>조건검색</th>
					<td>
						<select name="SEARCHTERM" class="select_s">
							<option value=''>조건선택</option>
							<option value=''>--------------</option>
							<option value='strName' <%=isSelect(SEARCHTERM,"strName")%>>주문자 이름</option>
						</select>
						<input type="text" name="SEARCHSTR" class="input_text"  value="<%=SEARCHSTR%>" />
					</td>
				</tr><tr>
					<th>정렬방식</th>
					<td>
						<select name="pagesize" class="vmiddle">
							<option value="10" <%=isSelect(pagesize,"10")%>>10개씩 보기</option>
							<option value="20" <%=isSelect(pagesize,"20")%>>20개씩 보기</option>
							<option value="30" <%=isSelect(pagesize,"30")%>>30개씩 보기</option>
							<option value="40" <%=isSelect(pagesize,"40")%>>40개씩 보기</option>
							<option value="50" <%=isSelect(pagesize,"50")%>>50개씩 보기</option>
						</select>
						<input type="image" src="<%=IMG_BTN%>/g_list_search.gif" class="vmiddle" />
					</td>
				</tr>
			</table>
		</form>
	</div>

	<div class="safekey_list">
		<table <%=tableatt%> class="width100">
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<col width="" />
			<tr>
				<th>주문번호<br />거래번호</th>
				<th>지불방법</th>
				<th>상품명</th>
				<th>금액</th>
				<th>성명</th>
				<th>이동전화<br />전자우편</th>
				<th>승인시간<br />DB저장시간</th>
			</tr>
			<%
				If IsArray(arrList) Then
					For i = 0 To listLen
						arrList_ROWNUM				= arrList(0,i)
						arrList_intIDX				= arrList(1,i)
						arrList_isDel				= arrList(2,i)
						arrList_OrderNum			= arrList(3,i)
						arrList_strGoodsName		= arrList(4,i)
						arrList_intPrice			= arrList(5,i)
						arrList_strName				= arrList(6,i)
						arrList_strTel				= arrList(7,i)
						arrList_strEmail			= arrList(8,i)
						arrList_regDate				= arrList(9,i)
						arrList_strTid				= arrList(10,i)
						arrList_strResultCode		= arrList(11,i)
						arrList_strResultMsg		= arrList(12,i)
						arrList_strETC1				= arrList(13,i)
						arrList_strETC2				= arrList(14,i)
						arrList_strETC3				= arrList(15,i)
						arrList_strETC4				= arrList(16,i)
						arrList_strETC5				= arrList(17,i)
						arrList_strETC6				= arrList(18,i)
						arrList_strETC7				= arrList(19,i)
						arrList_strETC8				= arrList(20,i)
						arrList_strETC9				= arrList(21,i)
						arrList_strETC10			= arrList(22,i)
						'goodname			= Request.Form("goodname")
						'price    			= Request.Form("price")
						'buyername   		= Request.Form("buyername")
						'buyertel    		= Request.Form("buyertel")
						'buyeremail  		= Request.Form("buyeremail")
						'isDel				= "F"
						'OrderNum			= Moid
						'strGoodsName		= goodname
						'intPrice			= price
						'strName				= buyername
						'strTel				= buyertel
						'strEmail			= buyeremail
						'strMid				= Tid				' 이니시스 거래번호
						'strResultCode		= resultcode		' 결과코드 (00 일시 지불 성공)
						'strResultMsg		= ResultMsg			' 결과내용
						'strETC1				= PayMethod			' 지불방법
						'strETC2				= PGAuthDate		' 이니시스 승인날짜
						'strETC3				= PGAuthTime		' 이니시스 승인시각
						'strETC4				= AuthCode			' 신용카드 승인번호
						'strETC5				= CardQuota			' 할부기간
						'strETC6				= QuotaInterest		' 무이자할부 여부("1"이면 무이자할부)
						'strETC7				= CardNumber		' 카드번호 12자리
						'strETC8				= CardCode			' 신용카드사 코드 (매뉴얼 참조)
						'strETC9				= CardIssuerCode	' 신용카드 발급사(은행) 코드 (매뉴얼 참조)
						'strETC10			= DK_MEMBER_ID
						INICIS_DATE = Left(arrList_strETC2,4)&"-"&Mid(arrList_strETC2,5,2)&"-"&Right(arrList_strETC2,2)
						INICIS_TIME = Left(arrList_strETC3,2)&":"&Mid(arrList_strETC3,3,2)&":"&Right(arrList_strETC3,2)

			%>
			<tr>
				<td><%=arrList_OrderNum%><br /><%=arrList_strTid%></td>
				<td><%=arrList_strETC1%></td>
				<td><%=arrList_strGoodsName%></td>
				<td><%=num2cur(arrList_intPrice)%></td>
				<td><%=arrList_strName%></td>
				<td><%=arrList_strTel%><br /><%=arrList_strEmail%></td>
				<td><%=INICIS_DATE%>&nbsp;<%=INICIS_TIME%><br /><%=arrList_regDate%></td>
			</tr>
			<%
					Next
				Else
			%>
			<tr>
				<td colspan="7" class="tcenter" style="line-height:100px;">등록된 수동결제내역이 없습니다.</td>
			</tr>
			<%
				End If
			%><tr>
			<td colspan="7" align="center" style="height:45px; border:none;"><%Call pageList(PAGE,PAGECOUNT)%></td>
		</tr>
		</table>
	<form name="frm" method="post" action="">
		<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
		<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
		<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="ORDERS" value="<%=QORDERS%>" />

		<input type="hidden" name="schpayway" value="<%=schpayway%>" />

		<input type="hidden" name="minPrice" value="<%=minPrice%>" />
		<input type="hidden" name="maxPrice" value="<%=maxPrice%>" />



	</form>

	</div>

</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
