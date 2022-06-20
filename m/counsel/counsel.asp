<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/m/_include/document.asp"-->
<%
	PAGE_SETTING = "CUSTOMER"

	view = 3
	mNum = 6

	Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)
	'Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)		'고객지원 - 1:1상담 : 회원공개


%>
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script type="text/javascript">

	function chkThisForm(f) {

		if (!chkNull(f.strName,"<%=LNG_JS_NAME%>")) return false;

		if (!checkEmail(f.strEmail.value)) {
			alert("<%=LNG_JS_EMAIL_CONFIRM%>");
			f.strEmail.focus();
			return false;
		}
		if (!chkNull(f.strMobile,"<%=LNG_JS_MOBILE%>")) return false;
		if (!chkNull(f.strSubject,"<%=LNG_COUNSEL_JS04%>")) return false;
		if (!chkNull(f.strContent,"<%=LNG_COUNSEL_JS05%>")) return false;

		if (chkEmpty(f.txtCaptcha)) {
			alert("보안문자를 입력해주세요.");
			//alert("Please input captcha image Characters.");
			f.txtCaptcha.focus();
			return false;
		}
	}
	function RefreshImage(valImageId) {
		var objImage = document.getElementById(valImageId)
		if (objImage == undefined) {
			return;
		}
		var now = new Date();
		objImage.src = objImage.src.split('?')[0] + '?x=' + now.toUTCString();
	}

	$(document).ready(function(){
		RefreshImage('imgCaptcha');
	});

</script>
<link rel="stylesheet" href="/m/css/common.css" />
<link rel="stylesheet" href="counsel.css" />
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_CUSTOMER_01%></div>
<div class="infos" style="">
	<div class="tleft tweight">
		<p><%=LNG_COUNSEL_TEXT01%></p>
		<p><%=LNG_COUNSEL_TEXT02%></p>
		<p><%=LNG_COUNSEL_TEXT03%></p>
	</div>
</div>
<div id="counsel">
	<form name="cfrm" action="counselHandler.asp" method="post" onsubmit="return chkThisForm(this);" data-ajax="false" >
		<div id="" class="counsel">
			<table <%=tableatt%> class="width100 infoForm">
				<col width="105" />
				<col width="*" />
				<tr>
					<th><%=LNG_TEXT_NAME%></th>
					<td><input type="text" name="strName" class="input_text inputbg" style="width:90%;" value="" /></td>
				</tr><tr>
					<th><%=LNG_TEXT_EMAIL%></th>
					<td><input type="email" name="strEmail" class="input_text inputbg imes" style="width:90%;" value="" /></td>
				</tr><tr>
					<th><%=LNG_TEXT_CONTACT_NUMBER%></th>
					<td><input type="text" name="strMobile" class="input_text inputbg" style="width:90%;" maxlength="12" <%=onlyKeys%> value="" /></td>
				</tr><tr>
					<th><%=LNG_COUNSEL_TEXT07%></th>
					<td><input type="text" name="strSubject" class="input_text inputbg" style="width:90%;" value="" /></td>
				</tr><tr>
					<th><%=LNG_COUNSEL_TEXT08%></th>
					<td><textarea name="strContent" rows="10" cols="10" class="input_area inputbg" style="padding:7px; width:88%;height:110px; "></textarea></td>
				</tr>

				<tr>
					<th><%=LNG_COUNSEL_TEXT10%></th>
					<td>
						<div class="fleft" style="border:1px solid #cdcdcd;">
							<img src="/common/captcha.asp" id="imgCaptcha" class="vmiddle" style="height:27px;" />
						</div>
						<div class="fleft">
							<span class="button large2 icon"><span class="refresh"></span><button type="button" onclick="RefreshImage('imgCaptcha');"></button></span>
						</div>
						<div class="fleft" style="">
							<input type="text" name="txtCaptcha" id="txtCaptcha" class="input_text inputbg" style="width:160px;" value="" maxlength="6"/>
						</div>
					</td>
				</tr>
			</table>

			<div id="" class="width100" style="margin-top:20px">
				<div class="width100 tcenter fleft" style="padding:10px 0px;">
					<span><input type="button" class="txtBtn large b_gray" style="min-width:140px;" onclick="this.form.reset();return false;" value="<%=LNG_COUNSEL_BTN02%>"/></span>
					<span class="pL10"><input type="submit" class="txtBtn large b_blue" style="min-width:140px;" value="<%=LNG_COUNSEL_BTN01%>"/></span>
				</div>
			</div>
	</form>
</div>

<!--#include virtual = "/m/_include/copyright.asp"-->