<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	strBoardName = gRequestTF("bname",True)
	If DK_MEMBER_TYPE <> "ADMIN" Then Call ALERTS("관리자가 아닙니다.","close","")


	intIDX = gRequestTF("num",True)


	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX),_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName)_
	)
	Set SMS_DKRS = Db.execRs("DKPA_NBOARD_DEPTH_TOP",DB_PROC,arrParams,Nothing)
	If Not SMS_DKRS.BOF And Not SMS_DKRS.EOF Then

		SMS_strName			= SMS_DKRS("strName")
		SMS_regDate			= SMS_DKRS("regDate")
		SMS_strSubject		= SMS_DKRS("strSubject")
		SMS_strContent		= SMS_DKRS("strContent")
		SMS_strMobile		= SMS_DKRS("strMobile")

	Else
		Call ALERTS("원본글이 없습니다.","CLOSE","")
	End If
	Call closeRS(SMS_DKRS)

	If SMS_isSMSChk = "T" Then
		viewSMSChk = " (이미 보낸 게시물)"
	End If


	arrParams = Array(_
		Db.makeParam("@strSiteID",adVarChar,adParamInput,50,LOCATIONS) _
	)
	defaultSMSNumber = Db.execRsData("DKPA_DEFAULT_SMS_NUMBER",DB_PROC,arrParams,Nothing)




%>
<!--#include file = "board_config.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
<link rel="stylesheet" href="/css/sms.css" />
<script type="text/javascript">
<!--
	$(document).ready(function(){

	// 바이트체크(상품설명)
		$('textarea[name=smscontent]').keyup(function() {
			_cnt = $(this).val().bytes();


			if (_cnt > 80) {
				alert("80바이트를 넘기셨습니다.");
				$(this).val(cutString($(this).val(), 80));
			}

			_cnt = $(this).val().bytes();
			$('span.smsContentCnt').html(_cnt);
		});
	//Jquery 종료
	});


	String.prototype.bytes = function() {
		var l = 0;
		for (var i = 0; i < this.length; i++) {
			l += (this.charCodeAt(i) > 128) ? 2 : 1;
		}
		return l;
	};
	var cutString = function(str, len) {
		var l = 0;
		for (var i = 0; i < str.length; i++) {
			l += (str.charCodeAt(i) > 128) ? 2 : 1;
			if (l > len) {
				return str.substring(0, i);
			}
		}
		return str;
	};

	function chkThisFrm(f) {
		if (f.strMobile.value=='')
		{
			alert("받으시는 분의 연락처가 비어있습니다.");
			f.strMobile.focus();
			return false;
		}
		if (f.callback.value=='')
		{
			alert("보내시는 분의 연락처가 비어있습니다.");
			f.callback.focus();
			return false;
		}
		if (f.smscontent.value=='')
		{
			alert("SMS 내용이 비어있습니다.");
			f.smscontent.focus();
			return false;
		}
		if (confirm("SMS를 전송 하시겠습니까?")) {
			return;
		}else{
			return false;
		}


	}
//-->
</script>
<%

%>
</head>
<body>
<div id="sms">
	<form name="frm" action="smsSendHandler.asp" method="post" onsubmit="return chkThisFrm(this);">
		<input type="hidden" name="idx" value="<%=intIDX%>" />
		<input type="text" name="strMobile" class="input_hidden send" value="<%=SMS_strMobile%>" />
		<input type="text" name="callback" class="input_hidden rese" value="<%=defaultSMSNumber%>" />
		<textarea name="smscontent" class="area_hidden smscontent"><%=backword(defaultSMS)%></textarea>
		<p class="smsbyte">(<span class="smsContentCnt"><%=calcTextLenByte(backword(defaultSMS))%></span> / 80byte)</p>
		<input type="image" class="input_submit" src="<%=IMG_SMS%>/smssubmit.gif" />
	</form>
</div>
<div id="content">
	<table <%=tableatt%> style="width:370px;">
		<col width="110" />
		<col width="260" />
		<tr>
			<th>작성자</th>
			<td><%=SMS_strName%></td>
		</tr><tr>
			<th>작성일</th>
			<td><%=SMS_regDate%></td>
		</tr><tr>
			<th>핸드폰번호</th>
			<td><%=SMS_strMobile%> <%=viewSMSChk%></td>
		</tr><tr>
			<th>원본제목</th>
			<td class="tweight"><%=backword(SMS_strSubject)%></td>
		</tr><tr>
			<th>원본내용</th>
			<td><div class="inContent"><%=backword(SMS_strContent)%></div></td>
		</tr><tr>
			<td colspan="2" class="tright not_bor"><%=viewImgOpt(IMG_BTN&"/btn_close_01.gif",52,23,"창닫기","class=""vmiddle cp"" onclick=""self.close();""")%></td>
		</tr>
	</table>

</div>
</body>
</html>
