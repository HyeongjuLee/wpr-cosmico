<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "VENDOR"
	INFO_MODE = "VENDOR1-1"


	intIDX	= gRequestTF("idx",True)

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX) _
	)
	Set DKRS = Db.execRs("DKPA_VENDOR_VIEWS",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX					= DKRS("intIDX")
		DKRS_strShopID				= DKRS("strShopID")
		DKRS_strPass				= DKRS("strPass")
		DKRS_strComName				= DKRS("strComName")
		DKRS_sellerState			= DKRS("sellerState")
		DKRS_regDate				= DKRS("regDate")
		DKRS_AcceptDate				= DKRS("AcceptDate")
		DKRS_RefuseDate				= DKRS("RefuseDate")
		DKRS_StopDate				= DKRS("StopDate")
		DKRS_FeeType				= DKRS("FeeType")
		DKRS_intFee					= DKRS("intFee")
		DKRS_intLimit				= DKRS("intLimit")

	Else

		Call ALERTS("존재하지 않는 판매처입니다.","BACK","")
	End If
%>
<script type="text/javascript" src="/jscript/check.js"></script>
<script type="text/javascript" src="vendor_modify.js"></script>
<link rel="stylesheet" href="vendor.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="vendor" class="view">
	<form name="gform" method="post" action="vendor_handler.asp" onsubmit="return submitInsert(this);">
		<input type="hidden" name="MODE" value="MODIFY" />
		<input type="hidden" name="intIDX" value="<%=DKRS_intIDX%>" />
		<div class="titles">판매처 기본정보</div>
		<table <%=tableatt%>>
			<colgroup>
				<col width="200" />
				<col width="300" />
				<col width="200" />
				<col width="300" />
			</colgroup>
			<tbody>
				<tr>
					<th class="req">판매처 ID<%=starText%></th>
					<td colspan="3"><%=DKRS_strShopID%></td>
				</tr><tr>
					<th class="req">판매처명 <%=starText%> </th>
					<td><input type="text" name="strComName" class="input_text" size="100" maxlength="100" style="width:220px;" value="<%=DKRS_strComName%>" /></td>
					<th class="req">판매처 접속암호 <%=starText%> </th>
					<td><input type="password" name="strPass" class="input_text" size="100" maxlength="100" style="width:220px;" value="<%=DKRS_strPass%>" /></td>
				</tr><tr>
					<th class="req">판매처 상태 <%=starText%> </th>
					<td colspan="3">
						<label><input type="radio" name="sellerState" value="101" <%=isChecked(DKRS_sellerState,"101")%> /> 활동중인 판매처</label>
						<label><input type="radio" name="sellerState" value="100" <%=isChecked(DKRS_sellerState,"100")%> /> 대기중인 판매처</label>
						<label><input type="radio" name="sellerState" value="102" <%=isChecked(DKRS_sellerState,"102")%> /> 정지된 판매처</label>

					</td>
				</tr><tr>
					<th class="req">지불방식 <%=starText%></th>
					<td>
						<select name="FeeType" class="selectbox">
							<option value="">:: 지불방식 선택 ::</option>
							<option value="prev" <%=isSelect(LCase(DKRS_FeeType),"prev")%>>선불</option>
							<option value="next" <%=isSelect(LCase(DKRS_FeeType),"next")%>>착불</option>
							<option value="free" <%=isSelect(LCase(DKRS_FeeType),"free")%>>무료</option>
						<select>
					</td>
					<th>배송비 / 한도<%=starText%></th>
					<td><input type="text" name="intFee" class="input_text vmiddle" style="width:60px" value="<%=DKRS_intFee%>" <%=onLyKeys%> /> 원 / <input type="text" name="intLimit" class="input_text vmiddle" style="width:60px" <%=onLyKeys%> value="<%=DKRS_intLimit%>" /> 원 이상 무료배송</td>
				</tr><tr>
					<th>등록일</th>
					<td><%=DKRS_regDate%></td>
					<th>승인일</th>
					<td><%=DKRS_AcceptDate%></td>
				</tr>
			</tbody>
		</table>







		<div class="submit_area"><input type="submit" class="submit" value="정보 저장" /></div>



	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
