<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "VENDOR"
	INFO_MODE = "VENDOR1-2"

%>
<script type="text/javascript" src="/jscript/check.js"></script>
<script type="text/javascript" src="vendor_regist.js"></script>
<link rel="stylesheet" href="vendor.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="vendor" class="view">
	<form name="gform" method="post" action="vendor_handler.asp" onsubmit="return submitInsert(this);">
		<input type="hidden" name="MODE" value="REGIST" />
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
					<td colspan="3">
						<input type="text" name="strShopID" class="input_text vmiddle imes" style="width:150px"/>
						<img src="<%=IMG_JOIN%>/id_check.gif" width="68" height="20" alt="아이디 중복체크" class="cp vmiddle" onclick="join_idcheck()" />
						<span class="summary" id="idCheck"> 띄어쓰기 없는 영문,숫자 4~20자
							<input type="hidden" name="idcheck" value="F" readonly="readonly" />
							<input type="hidden" name="chkID" value="" readonly="readonly" />
						</span>
					</td>
				</tr><tr>
					<th class="req">판매처명 <%=starText%> </th>
					<td><input type="text" name="strComName" class="input_text" size="100" maxlength="100" style="width:220px;" value="" /></td>
					<th class="req">판매처 접속암호 <%=starText%> </th>
					<td><input type="password" name="strPass" class="input_text" size="100" maxlength="100" style="width:220px;" value="" /></td>
				</tr><tr>
					<th class="req">판매처 상태 <%=starText%> </th>
					<td colspan="3">
						<label><input type="radio" name="sellerState" value="101" checked="checked" /> 활동중인 판매처</label>
						<label><input type="radio" name="sellerState" value="100" /> 대기중인 판매처</label>
						<label><input type="radio" name="sellerState" value="102" /> 정지된 판매처</label>
					</td>
				</tr><tr>
					<th class="req">지불방식 <%=starText%></th>
					<td>
						<select name="FeeType" class="selectbox">
							<option value="">:: 지불방식 선택 ::</option>
							<option value="prev">선불</option>
							<option value="next">착불</option>
							<option value="free" >무료</option>
						<select>
					</td>
					<th>배송비 / 한도<%=starText%></th>
					<td><input type="text" name="intFee" class="input_text vmiddle" style="width:60px" <%=onLyKeys%> /> 원 / <input type="text" name="intLimit" class="input_text vmiddle" style="width:60px" <%=onLyKeys%> /> 원 이상 무료배송</td>
				</tr>
			</tbody>
		</table>







		<div class="submit_area"><input type="submit" class="submit" value="상품 저장" /></div>



	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
