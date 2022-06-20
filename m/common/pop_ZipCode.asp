<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual="/m/_include/jqueryload.asp"-->

<%

	Dim DKSP : Set DKSP = SERVER.CreateObject("ADODB.COMMAND")

	target = Trim(gRequestTF("target",False))


	DONG = Trim(pRequestTF("DONG",False))
	popWidth = 430
	popHeight = 210

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

<script type="text/javascript">
<!--
function checkZipcode(item) {
	var f = document.zz;

	if (item.value != "")
	{

		var objOption = item.options[item.selectedIndex];
		var value = objOption.value;
		var addr = objOption.getAttribute('addr');
		<%select case target %>
		<%case "order"%>
		try {
			opener.document.frmConfirm.takeZip.value = value;
			opener.document.frmConfirm.takeADDR1.value = addr;
			opener.document.frmConfirm.takeADDR2.focus();
		}
		<%case "inicis"%>
		try {
			opener.document.frmConfirm.strZip.value = value;
			opener.document.frmConfirm.strADDR1.value = addr;
			opener.document.frmConfirm.strADDR2.focus();
		}
		<%case "inicis_take"%>
		try {
			opener.document.frmConfirm.takeZip.value = value;
			opener.document.frmConfirm.takeADDR1.value = addr;
			opener.document.frmConfirm.takeADDR2.focus();
		}
		<%case "daou"%>
		try {
			opener.document.frmConfirm.strZip.value = value;
			opener.document.frmConfirm.strADDR1.value = addr;
			opener.document.frmConfirm.strADDR2.focus();
		}
		<%case "daou_take"%>
		try {
			opener.document.frmConfirm.takeZip.value = value;
			opener.document.frmConfirm.takeADDR1.value = addr;
			opener.document.frmConfirm.takeADDR2.focus();
		}
		<%case else%>
		try {
			opener.document.cfrm.strZip.value = value;
			opener.document.cfrm.strADDR1.value = addr;
			opener.document.cfrm.strADDR2.focus();
		}
		<%end select%>
		catch (e) {}
		self.close();
	}
}


function submitChk(f) {
	if (f.dong.value == "") {
		alert("지역명을 입력해 주세요.");
		f.dong.focus();
		return;
	//	return false;
	}
}

function pageGoto(target){
	page = $("input[name=afType]:checked").val();
	if(page == 1){
		location.href = "pop_ZipCode.asp?target="+target

	}else if(page == 2){
		location.href = "pop_ZipCode_StreetName.asp?target="+target
	}
}

//-->
</script>
<style type="text/css">
	div#titles {clear:both;padding-top:10px;padding-top:15px; text-align:center;color:#000;}
	div#close {height:30px;text-align:center;margin-top:13px;}
	div#zipcheck {text-align:center; margin-bottom:10px;}
	.input_text {height:16px; padding-top:2px;border:1px solid #ddd; width:140px;}
	.line1 {height:1px; background-color:#dedede;}
	.line2 {height:2px; background-color:#f4f4f4;}

	.zipbtn .ui-btn-inner {padding:6px 0px !important;}
	.zipbtn .ui-btn-inner span {padding:0px 0px !important;}
	#zip {position:relative;width:100%; height:66px; background:url(/m/images/header_bg2.png) 0px 0px no-repeat; background-size:100% 66px;}
	#zip .top_logo {position:absolute; top:50%; left:50%; margin:-10px 0px 0px -72px;}


	#loading_bg {width:100%;height:100%;top:0px;left:0px;position:fixed;display:block; opacity:0.7;backgr ound-color:#fff;z-index:99;text-align:center; }
	#loading-image {position:absolute; top:35%; left:40%; z-index:100;}

</style>
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script src="/m/js/icheck/icheck.min.js"></script>
</head>
<body onload="document.zz.dong.focus();">
<div id="zip" class=""><div class="top_logo"><img src="<%=M_IMG%>/zip_top.png" width="140" /></div></div>
<div style="margin:10px 5px 0px 5px;">
	<div style="">
		<div class="fleft" style="width:49%;"><div class="skin-grey2"><input type="radio" name="afType" value="1" checked="checked" /><label>구 지번주소</label></div></div>
		<div class="fright" style="width:49%;"><div class="skin-grey2"><input type="radio" name="afType" value="2" /><label>신 도로명주소</label></div></div>
		<script>
			$(document).ready(function(){
				$('.skin-grey2 input').each(function(){
					var self = $(this),
					label = self.next(),
					label_text = label.text();

					label.remove();
					self.iCheck({
						checkboxClass: 'icheckbox_line-grey',
						radioClass: 'iradio_line-grey',
						insert: '<div class="icheck_line-icon"></div>' + label_text
					}).on('ifChecked',function(event){
					pageGoto('<%=target%>');
				});
			});

			});
		</script>
	</div>

</div>
<%If viewList = False Then%>
<div id="titles" style="font-size:16px; font-weight:bold;">
	<div >검색할 주소의 <span style="color:#0e95d4;"><strong>동/읍/면을</strong></span> 입력해 주세요.</div>
	<div height="2" style="margin-bottom:11px;">(예 : 역삼동, 둔산리)</div>
</div>
<%Else%>
	<%If Not IsArray(arrList) Then%>
		<div id="titles" style="font-size:16px; font-weight:bold;">
			<div><font color="#0e95d4">입력하신 읍 면 동은 없습니다.</font></div>
			<div style="margin-bottom:20px;"><font color="#0e95d4">확인후 다시 입력해주세요.</font></div>
		</div>
	<%Else%>
		<div id="titles" style="font-size:16px; font-weight:bold;">
			<div style="margin-bottom:20px;">검색결과 중 해당주소를 <font color="#0e95d4"><strong>선택</strong></font>해 주세요.</div>
		</div>
		<div id="zipcheck">
		<select name="zipcode" onChange="checkZipcode(this)"  style="font-size:16px; height:25px; line-height:25px;">
			<option value="">총 <%=listLen+1%>개의 주소가 검색되었습니다.</option>
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

<form name="zz" method="post" onsubmit="return submitChk(this)" data-ajax="false">
	<div id="searchs" style="margin:0px 5px;" class="tcenter">

		<input type="text" name="dong" value="<%=DONG%>" style="border-radius:4px 0px 0px 4px; font-size:15px; line-height:32px; height:32px; border:1px solid #ccc; width:40%;"  /><input type="submit" value="검색" style="border-radius:0px 4px 4px 0px; font-size:15px; line-height:32px; height:36px; border:1px solid #ccc; width:20%; border-left:0px none;" />

	</div>
</form>
<div class="close width100 tcenter" style=" margin-top:20px;">
	<div class="line1"></div>
	<div class="line2"></div>
	<input type="button" value="창 닫기" onclick="self.close();" style="border-radius:4px; font-size:15px; line-height:32px; height:36px; border:1px solid #ccc; width:40%; margin-top:15px;" />
</div>
</body>
</html>
