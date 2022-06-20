<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "CONFIG"
	INFO_MODE = "CONFIG3-1"


	arrParams = Array(_
		Db.makeParam("@SquenceType",adChar,adParamInput,1,"S"), _
		Db.makeParam("@feeType",adChar,adParamInput,4,""), _
		Db.makeParam("@intFee",adInteger,adParamInput,0,""), _
		Db.makeParam("@intLimit",adInteger,adParamInput,0,""), _
		Db.makeParam("@regID",adVarChar,adParamInput,30,""), _
		Db.makeParam("@hostIP",adVarChar,adParamInput,30,"") _
	)
	Set DKRS = Db.execRs("DKP_DELIVERY",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		feeType = DKRS(0)
		fee = DKRS(1)
		limit = DKRS(2)
	Else
		feeType = "free"
		fee = 0
		limit = 0
	End If


%>
<link rel="stylesheet" href="/admin/css/delivery.css" />
<script type="text/javascript">
<!--
	function checkFrm(f) {
		if (f.Fee.value=='')
		{
			alert("배송비를 입력해주세요");
			f.Fee.focus();
			return false;
		}
		if (f.limit.value=='')
		{
			alert("무료배송비를 입력해주세요");
			f.limit.focus();
			return false;
		}

	}
//-->
</script>
</head>
<body>


<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="deliveryFee" class="">
	<form name="frm" method="post" action="delivery_handling.asp" onsubmit="return checkFrm(this);">
	<table <%=tableatt%>>
		<colgroup>
			<col width="200" />
			<col width="800" />
		</colgroup>
		<thead>
			<tr>
				<th>기능</th>
				<th>설정</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>배송비타입</th>
				<td>
					<label><input type="radio" name="feeType" value="free" <%=isChecked(feeType,"free")%> /> 무료배송</label>
					<label><input type="radio" name="feeType" value="prev" <%=isChecked(feeType,"prev")%> /> 선불배송</label>
					<label><input type="radio" name="feeType" value="next" <%=isChecked(feeType,"next")%> /> 착불배송</label>
				</td>
			</tr><tr>
				<th>배송비</th>
				<td><input type="text" name="Fee" class="input_text tright" value="<%=fee%>" />원</td>
			</tr><tr>
				<th>무료배송비</th>
				<td><input type="text" name="limit" class="input_text tright" value="<%=limit%>"  />원 이상 무료배송</td>
			</tr><tr>
				<th>비고</th>
				<td>
					배송비타입이 무료배송인 경우 배송비 및 무료배송비는 0원을 입력해주세요.

				</td>
			</tr>
		</tbody>
	</table>
	<p><input type="submit" value="기본배송비 저장" class="submit" /></p>
	</form>
</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->


