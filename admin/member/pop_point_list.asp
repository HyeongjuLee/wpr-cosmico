<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim popWidth,popHeight
		popWidth = 400
		popHeight = 400

	Dim IDV
		IDV = gRequestTF("idv",True)

' ===================================================================
' ===================================================================
' 데이터 가져오기
' ===================================================================
	SQL = "SELECT * FROM [DK_MEMBER_FINANCIAL] WHERE [strUserID] = ?"
	arrParams = Array(_
		Db.makeParam("@strUserID",adVarChar,adParamInput,20,IDV) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		intPrice = DKRS("intPrice")
		intPriceCnt = DKRS("intPriceCnt")
		intPoint = DKRS("intPoint")
	End If


%>
<script type="text/javascript" src="/admin/jscript/member.js"></script>
<link rel="stylesheet" href="/admin/css/member.css" />
</head>
<body>
<div id="pop_all">
	<div id="point">
		<div class="top"><%=viewImg(IMG_POP&"/tit_point_calc.jpg",250,40,"")%></div>
		<div class="pointarea">
			<form name="frmS" method="post" action="pop_point_calcOk.asp" onsubmit="return chkPoint(this);">
				<input type="hidden" name="sui" value="<%=idv%>" />
				<table <%=tableatt%>>
					<colgroup>
						<col width="100" />
						<col width="*" />
					</colgroup>
					</thead>
					<tbody>
						<tr>
							<th>아이디</th>
							<td><%=IDV%></td>
						</tr><tr>
							<th>총구매액</th>
							<td><%=num2cur(intPrice)%> 원</td>
						</tr><tr>
							<th>현재포인트</th>
							<td><%=num2cur(intPoint)%> 원</td>
						</tr><tr>
							<th>포인트</th>
							<td class="tleft"><input type="text" name="intPoint" class="input_text vmiddle" style="width:165px" /> 원</td>
						</tr><tr>
							<th>코멘트</th>
							<td class="tleft"><input type="text" name="pComment" class="input_text vtop" style="width:255px" maxlength="50" /></td>
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
