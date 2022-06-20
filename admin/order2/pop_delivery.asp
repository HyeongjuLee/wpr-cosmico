<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim popWidth,popHeight
		popWidth = 400
		popHeight = 300

	Dim IDV
		IDV = gRequestTF("idv",True)

'	SQL = "SELECT [orderNum],[DtoDCode],[DtoDNumber],[DtoDDate] FROM [DK_ORDER] WHERE [intIDX] = ?"
	SQL = "SELECT [orderNum],[DtoDCode],[DtoDNumber],[DtoDDate] FROM [DK_ORDER2] WHERE [intIDX] = ?"
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,IDV) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_ORDERNUM		= DKRS("orderNum")
		RS_DtoDCode		= DKRS("DtoDCode")
		RS_DtoDNumber	= DKRS("DtoDNumber")
		RS_DtoDDate		= DKRS("DtoDDate")
	Else
		Call ALERTS("데이터가 존재하지 않습니다.","close","")
	End If



%>

<link rel="stylesheet" href="/admin/css/orders.css" />
<script type="text/javascript" src="/admin/jscript/orders.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
</head>
<body>
<div id="pop_all">
	<div id="delivery">
		<div class="top"><%=viewImg(IMG_POP&"/tit_popup_orderDtoD.gif",250,40,"")%></div>
		<div class="deliveryArea">
			<form name="frmS" method="post" action="pop_deliveryOk.asp" onsubmit="return chkDelivery(this);">
				<input type="hidden" name="intIDX" value="<%=idv%>" />
				<table <%=tableatt%> style="width:400px;">
					<colgroup>
						<col width="100" />
						<col width="*" />
					</colgroup>
					</thead>
					<tbody>
						<tr>
							<th>주문번호</th>
							<td><%=RS_ORDERNUM%></td>
						</tr><tr>
							<th>배송일자</th>
							<td><input type='text' name='DtoDDate' value="<%=RS_DtoDDate%>" class='input_text readonly' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly" /></td>
						</tr><tr>
							<th>배송업체</th>
							<td>
								<select name='DtoDCode'>
									<option value=''>배송업체선택</option>
									<option value='date' style='color:red;' <%=isSelect("0",RS_DtoDCode)%>>배송일자만 입력</option>
									<option value=''>----------------------</option>
									<%
										SQL = "SELECT [intIDX] FROM [DK_DTOD] WHERE [useTF] = 'T' AND [defaultTf] = 'T'"
										basicDtoD = Db.execRsData(SQL,DB_TEXT,Nothing,Nothing)
										SQL = " SELECT * FROM [DK_DTOD] WHERE [useTF] = 'T' ORDER BY [intIDX] ASC "
										arrList2 = Db.execRsList(SQL,DB_TEXT,Nothing,listLen2,Nothing)
										If IsArray(arrList2) Then
											For l = 0 To listLen2
												PRINT "<option value='"&arrList2(0,l)&"'"
												If RS_DtoDCode <> "" Then
													PRINT isSelect(arrList2(0,l),RS_DtoDCode)
												Else
													PRINT isSelect(arrList2(0,l),basicDtoD)
												End If
												PRINT ">"&arrList2(2,l)&"</option>"
											Next
										End If
									%>
								</select>
							</td>
						</tr><tr>
							<th>송장번호</th>
							<td><input type='text' name='DtoDNumber' class='input_text vmiddle' value='<%=RS_DtoDNumber%>' /></td>
						</tr><tr>
							<td style="border:0px none;padding:10px 0px; text-align:center;" colspan="2"><input type="image" src="<%=IMG_BTN%>/btn_insert_01.gif" class="vtop" /></td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
		<div class="bottom">
			<div class="info"><%=viewImg(IMG_POP&"/pop_bottom_info.gif",160,60,"")%></div>
			<div class="btn_area"><%=aImgSt("javascript:self.close()",IMG_BTN&"/btn_close_01.gif",52,23,"","margin-top:20px;margin-right:20px;","")%></div>

		</div>
	</div>
</div>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>


</body>
</html>
