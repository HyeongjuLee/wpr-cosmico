<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "COMMON"
	view = 2
	ISSUBTOP = "T"

	NO_MEMBER_REDIRECT = "F"
	link_mod = gRequestTF("mod",False)

	backURL = gRequestTF("backURL",false)

	If backURL = "" Then
		backURL = Request.ServerVariables("HTTP_REFERER")
	Else
		backURL = Replace(backURL,"§","&")
	End If


'	If DK_MEMBER_ID1 <> "" And DK_MEMBER_ID2 <> "" Then
'		Call ALERTS(LNG_ALERT_WRONG_ACCESS,"GO","/m/index.asp")
'	End If

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"

	If DK_MEMBER_ID <> "GUEST" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"GO","/m/index.asp")

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script src="/m/js/icheck/zepto.js"></script>
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script src="/m/js/icheck/icheck.min.js"></script>
<!-- <script src="member_login.js"></script> -->
<script type="text/javascript">
<!--
	function search_idcheck() {

		var ids = $("#memberName")
		var mails = $("#memberMail")
		//var isCom = $("input[name=isCompany]:checked");
		//alert(ids.val());
		//alert(mails.val());

		if (ids.val() == '')
		{
			alert("<%=LNG_JS_NAME%>");
			ids.focus();
			return false;
		}

		if (mails.val() == '')
		{
			alert("<%=LNG_JS_EMAIL%>");
			mails.focus();
			return false;
		}

		if (!checkEmail(mails.val())) {
			alert("<%=LNG_JS_EMAIL_CONFIRM%>");
			mails.focus();
			return false;
		}

		$("#loadingsA").show();
		$.ajax({
			type: "POST"
			,url: "member_search_id_ajax.asp"
			,data: {
				 "memberName"		: ids.val()
				,"memberMail"		: mails.val()
				,"isCom"			: 'T'
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				$("#login_alert").css({"display":""}).html(data);

				$("#loadingsA").hide();
			}
			,error:function(data) {
				alert("<%=LNG_AJAX_ERROR_MSG%>"+data.status+" "+data.statusText+" "+data.responseText);
				$("#loadingsA").hide();
			}
		});
	}

	function search_pwdcheck() {

		// alert("본사로 문의해주세요.");
		// return false;

		var memid = $("#memberId")
		var memname = $("#memberNameP")
		var mails = $("#memberMailP")
		var isCom = $("input[name=isCompany]:checked");
		//alert(isCom.val());

		if (memid.val() == '')
		{
			alert("<%=LNG_JS_ID%>1");
			memid.focus();
			return false;
		}

		if (memname.val() == '')
		{
			alert("<%=LNG_JS_NAME%>22");
			memname.focus();
			return false;
		}

		if (mails.val() == '')
		{
			alert("<%=LNG_JS_EMAIL%>ee");
			mails.focus();
			return false;
		}

		if (!checkEmail(mails.val())) {
			alert("<%=LNG_JS_EMAIL_CONFIRM%>");
			mails.focus();
			return false;
		}

		$("#loadingsA").show();
		$.ajax({
			type: "POST"
			,url: "member_search_pw_ajax.asp"
			,data: {
				 "memberName"		: memname.val()
				,"memberMail"		: mails.val()
				//,"isCom"			: isCom.val()
				,"isCom"			: 'T'
				,"memberId"			: memid.val()
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				$("#login_alertP").html(data);
				$("#login_alertP").addClass("green tweight");
				//loadings();

				$("#loadingsA").hide();
			}
			,error:function(data) {
				alert("<%=LNG_AJAX_ERROR_MSG%>"+data.status+" "+data.statusText+" "+data.responseText);
				$("#loadingsA").hide();
			}
		});
	}

// -->
</script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<%
	Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
		objEncrypter.Key = con_EncryptKey
		objEncrypter.InitialVector = con_EncryptKeyIV
		'PRINT objEncrypter.Encrypt("a12345")
			If backURL	<> "" Then backURL	 = objEncrypter.Encrypt(backURL)
	Set objEncrypter = Nothing
%>
<style>
	/* loading */
	#loadingsA {position:fixed;z-index:99999;width:100%;height:100%;top:0px;left:0px;background:url(/images_kr/loading_bg70.png) 0 0 repeat;display:none;}
	#loadingsA .loadingImg {position:relative; top:40%; text-align:center;}
</style>
<div id="loadingsA">
	<div class="loadingImg"><img src="<%=IMG%>/159.gif" width="60" alt="loadingImg" /></div>
</div>
<div id="idpw" class="common">
	<div class="wrap">
		<h6><%=LNG_MEMBER_IDPW_TEXT04%></h6>
		<input type="hidden" name="isCompany" value="T" id="memType-2" checked="checked"/>

		<div class="input-wrap">
			<label>
				<span><%=LNG_TEXT_NAME%></span>
				<input type="text" id="memberName" name="memberName" value />
			</label>
			<label>
				<span><%=LNG_TEXT_EMAIL%></span>
				<input type="text" id="memberMail" name="memberMail" value />
			</label>
		</div>

		<input class="button" onclick="search_idcheck();" value="<%=LNG_TEXT_CONFIRM%>" />
		<div id="login_alert" class="tcenter"></div>
	</div>

	<div class="wrap">
		<h6><%=LNG_MEMBER_IDPW_TEXT10%></h6>
		<input type="hidden" name="isCompany" value="T" id="memType-2" checked="checked" />

		<div class="input-wrap">
			<label>
				<span><%=LNG_TEXT_ID%></span>
				<input type="text" id="memberId" name="memberId" value />
			</label>
			<label>
				<span><%=LNG_TEXT_NAME%></span>
				<input type="text" id="memberNameP" name="memberNameP" value />
			</label>
			<label>
				<span><%=LNG_TEXT_EMAIL%></span>
				<input type="text" id="memberMailP" name="memberMailP" value />
			</label>
		</div>
		<input class="button" onclick="search_pwdcheck();" value="<%=LNG_TEXT_CONFIRM%>" />
		<div id="login_alertP" class="tcenter" ></div>

		<!-- <div class="input-wrap">
			<p class="text-box">본사로 문의 바랍니다.</p>
		</div>
		<input class="button" onclick="search_pwdcheck();" value="<%=LNG_TEXT_CONFIRM%>" /> -->

	</div>
</div>


<!--#include virtual = "/m/_include/copyright.asp"-->



