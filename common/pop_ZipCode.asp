<!--#include virtual = "/_lib/strFunc.asp"-->
<%


	target = Trim(gRequestTF("target",False))

	DONG = Trim(pRequestTF("DONG",False))
	popWidth = 430
	popHeight = 270

	viewList = False

	If DONG <> "" Then
		viewList = True
		SQL = "SELECT [ZIPCODE],[SIDO],[GUGUN],[DONG],[BUNJI] FROM [DK_ZIPCODE] WHERE [DONG] LIKE ? ORDER BY [SEQ] ASC"
		arrParams = Array( _
			Db.makeParam("@dong",adVarChar,adParamInput,52,"%"&DONG&"%") _
		)
		arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,DB2)
	End If

'	WITH DKSP
'		.ActiveConnection = db2
'		.CommandType = adCmdStoredProc
'		.CommandText = "DK_ZIPSEARCH"
'
'		.Parameters.Append .CreateParameter("@dong",adVarChar,adParamInput,52,DONG)
'
'		Set DKRS = .EXECUTE
'	End WITH
'	LIST = False
'	If Not DKRS.BOF Or Not DKRS.EOF Then
'		LIST = True
'		RESULT = DKRS.GETROWS()
'		COUNT = UBound(RESULT,2)
'	End If
'End If

%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">
<!--
function checkZipcode(item) {
	var f = document.zz;

	var objOption = item.options[item.selectedIndex];
	var value = objOption.value;
	var addr = objOption.getAttribute('addr');
	<%if target = "" then%>
	try {
		opener.document.cfrm.strzip.value = value;
		opener.document.cfrm.straddr1.value = addr;
		opener.document.cfrm.straddr2.focus();
	}
	<%elseif target = "ori" then%>
	try {
		opener.document.ini.strZip.value = value;
		opener.document.ini.strADDR1.value = addr;
		opener.document.ini.strADDR2.focus();
	}
	<%elseif target = "take" then%>
	try {
		opener.document.ini.takeZip.value = value;
		opener.document.ini.takeADDR1.value = addr;
		opener.document.ini.takeADDR2.focus();
	}


	//shop PG사별 주소선택
	<%elseif target = "inicis" then%>
	try {
		opener.document.ini.strZip.value = value;
		opener.document.ini.strADDR1.value = addr;
		opener.document.ini.strADDR2.focus();
	}
	<%elseif target = "inicis_take" then%>
	try {
		opener.document.ini.takeZip.value = value;
		opener.document.ini.takeADDR1.value = addr;
		opener.document.ini.takeADDR2.focus();
	}
	<%elseif target = "daou" then%>
	try {
		opener.document.frmConfirm.strZip.value = value;
		opener.document.frmConfirm.strADDR1.value = addr;
		opener.document.frmConfirm.strADDR2.focus();
	}
	<%elseif target = "daou_take" then%>
	try {
		opener.document.frmConfirm.takeZip.value = value;
		opener.document.frmConfirm.takeADDR1.value = addr;
		opener.document.frmConfirm.takeADDR2.focus();
	}
	<%elseif target = "kiccp" then%>
	try {
		opener.document.frm_pay.strZip.value = value;
		opener.document.frm_pay.strADDR1.value = addr;
		opener.document.frm_pay.strADDR2.focus();
	}
	<%elseif target = "kiccp_take" then%>
	try {
		opener.document.frm_pay.takeZip.value = value;
		opener.document.frm_pay.takeADDR1.value = addr;
		opener.document.frm_pay.takeADDR2.focus();
	}
	<%end if%>
	catch (e) {}
	self.close();
}


function submitChk(f) {
	if (f.dong.value.stripspace() == "") {
		alert("지역명을 입력해 주세요.");
		f.dong.focus();
		return false;
	}
}

function pageGoto(page){
	var target = '<%=target%>'
	if(page == 1){
		location.href = "pop_ZipCode.asp?target="+target
	}else if(page == 2){
		location.href = "pop_ZipCode_StreetName.asp?target="+target
	}
}
//-->
</script>
<style type="text/css">
	html{overflow:hidden;}
	div#zip_top {clear:both; float:left;width:430px; height:40px; border-bottom:1px solid #777777;  overflow:hidden;}
	div#searchs {width:430px; height:24px; overflow:hidden; text-align:center;}
	div#titles {clear:both;padding-top:10px;padding-top:15px; text-align:center;color:#000;}
	div#close {height:30px;text-align:center;margin-top:13px;}
	div#zipcheck {text-align:center; margin-bottom:10px;}
	.input_text {height:16px; padding-top:2px;border:1px solid #ddd; width:140px;}
	.line1 {height:1px; background-color:#dedede;}
	.line2 {height:2px; background-color:#f4f4f4;}
</style>
</head>
<body onload="document.zz.dong.focus();">

<!-- <form name = "frm" action = "pop_ZipCode_StreetName.asp"  method="get">
	<input type = "hid den" name = "target" value = "<%=target%>">
</form> -->



<div id="zip_top"><img src="<%=IMG_POP%>/tit_addr.gif" width="250" height="40" alt="우편번호 검색 이미지" /></div>
	<div style="margin-left:5px;">
		<label><input type="radio" name="memberType" value="member" checked="checked" onClick="pageGoto(1);">구 지번주소</label>
		<label><input type="radio" name="memberType" value="nonmember" onClick="pageGoto(2);">신 도로명주소</label>
	</div>
<%If viewList = False Then%>
<div id="titles">
	<div>검색할 주소의 <font color="#0e95d4"><strong>동/읍/면을</strong></font> 입력해 주세요.</div>
	<div height="2"style="margin-bottom:11px;">(예 : 역삼동, 둔산리)</div>
</div>
<%Else%>
	<%If Not IsArray(arrList) Then%>
		<%popHeight = 240%>
		<div id="titles">
			<div><font color="#0e95d4">입력하신 읍 면 동은 없습니다.</font></div>
			<div style="margin-bottom:20px;"><font color="#0e95d4">확인후 다시 입력해주세요.</font></div>
		</div>
	<%Else%>
		<div id="titles">
			<div style="margin-bottom:20px;">검색결과 중 해당주소를 <font color="#0e95d4"><strong>선택</strong></font>해 주세요.</div>
		</div>
	<div id="zipcheck">
	<%popHeight = 380%>
	<select size="10" name="zipcode" onChange="checkZipcode(this)" style="width:350px;">
		<%For i = 0 To listLen
			addr_view = arrList(1,i) &" "& arrList(2,i) &" "& arrList(3,i) &" "& arrList(4,i)
			addr_fin = arrList(1,i) &" "& arrList(2,i) &" "& arrList(3,i)
		%>
		<option value="<%=arrList(0,i)%>" addr="<%=addr_fin%>" /><%=addr_view%></option>
		<%
			addr_view = ""
			addr_fin = ""
			Next%>
	</select>
	<%End If%>
	</div>
<%End If%>

<form name="zz" method="post" onsubmit="return submitChk(this)">
	<div id="searchs">
		<div class="fleft" style="margin-left:120px;display:inline;"><input type="text" name="dong" class="input_text" style="vertical-align:middle; width:120px;ime-mode:active;" /></div>
		<div class="fleft" style="margin-left:2px;"><input type="image" src="<%=IMG_POP%>/btn_search.gif" style="width:57px; height:24px;vertical-align:middle;" /></div>
	</div>
</form>
<div id="close">
<div class="line1"></div>
<div class="line2"></div>
<img src="<%=IMG_POP%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:4px;cursor:pointer;" onclick="self.close();" />
</div>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
