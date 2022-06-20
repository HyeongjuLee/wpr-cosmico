<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%
	PAGE_SETTING = "CUSTOMER"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"


	view = 4
	mNum = 5

'	Call ONLY_MEMBER_CONFIRM(DK_MEMBER_LEVEL)

	Call ONLY_BUSINESS_MEMBER(DK_MEMBER_LEVEL,1)		'고객지원 - 1:1상담 : 회원공개


%>
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
<link rel="stylesheet" href="counsel.css" />
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<!--'include virtual = "/_include/sub_title.asp"-->
	<!-- <p class="infos" style="border:1px solid #ccc;background-color:#eee;padding:20px 0px;text-align:center;"><%=viewImg("./images/consulation_alert.png",350,60,"")%></p> -->
	<div id="page" class="layout_inner">
		<form name="cfrm" action="counselHandler.asp" method="post" onsubmit="return chkThisForm(this);">
			<div class="counsel_wrap">
				<div class="counsel_bg">
					<img src="/images/content/counsel_bg.jpg" alt="" />
				</div>
				<!-- <div class="counsel_tit"><%=sub_title_d3%></div> -->
				<div class="counsel_inner">
					<div class="infos">
						<div class="txt">
							<ul>
								<li><i></i><%=LNG_COUNSEL_TEXT01%></li>
								<li><i></i><%=LNG_COUNSEL_TEXT02%></li>
								<li><i></i><%=LNG_COUNSEL_TEXT03%></li>
							</ul>
						</div>
					</div>
					<div class="name"><span><input type="text" name="strName" value="" placeholder="<%=LNG_TEXT_NAME%>" /><i></i></span></div>
					<div class="email"><span><input type="text" name="strEmail" value="" placeholder="<%=LNG_TEXT_EMAIL%>" /><i></i></span></div>
					<div class="number"><span><input type="text" name="strMobile" maxlength="12" <%=onlyKeys%> value="" placeholder="<%=LNG_TEXT_CONTACT_NUMBER%>" /><i></i></span></div>
					<div class="title"><span><input type="text" name="strSubject" value="" placeholder="<%=LNG_COUNSEL_TEXT07%>" /><i></i></span></div>
					<div class="textarea"><span><textarea name="strContent" rows="10" cols="10" value="" placeholder="<%=LNG_COUNSEL_TEXT08%>" ></textarea><i></i></span></div>
					<div class="imgCaptcha">
						<div class="wrap">
							<div class="inner">
								<div class="img"><img src="/common/captcha.asp" id="imgCaptcha" class="vmiddle" /></div>
								<div class="btn">
									<span class="refresh">Refresh</span><button type="button" onclick="RefreshImage('imgCaptcha');"></button>
								</div>
							</div>
							<div class="txtCaptcha"><input type="text" name="txtCaptcha" id="txtCaptcha" value="" maxlength="6" placeholder="<%=LNG_COUNSEL_TEXT10%>" /></div>
						</div>
					</div>

					<div class="btn_wrap">
						<div class="btn01"><input type="button" onclick="this.form.reset();return false;" value="<%=LNG_COUNSEL_BTN02%>"/></div>
						<div class="btn02"><input type="submit" value="<%=LNG_COUNSEL_BTN01%>"/></div>
					</div>
				</div>
			</div>
		</form>
	</div>

<!--#include virtual = "/_include/copyright.asp"-->
