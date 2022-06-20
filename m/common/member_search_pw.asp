<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_LOGIN"
	NO_MEMBER_REDIRECT = "F"
	link_mod = gRequestTF("mod",False)

	backURL = gRequestTF("backURL",false)

	If backURL = "" Then
		backURL = Request.ServerVariables("HTTP_REFERER")
	End If


	If DK_MEMBER_ID1 <> "" And DK_MEMBER_ID2 <> "" Then
		Call ALERTS(LNG_ALERT_WRONG_ACCESS,"GO","/m/index.asp")
	End If


%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<script src="/m/js/icheck/zepto.js"></script>
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script src="/m/js/icheck/icheck.min.js"></script>

<script src="/m/js/check.js"></script>
<!-- <script src="member_search.js"></script> -->
<script type="text/javascript">
<!--
	function search_pwdcheck() {

		alert("본사로 문의해주세요.");
		return false;

		var memid = $("#memberId")
		var ids = $("#memberName")
		var mails = $("#memberMail")
		var isCom = $("input[name=isCompany]:checked");
		//alert(isCom.val());

		if (memid.val() == '')
		{
			alert("<%=LNG_JS_ID%>");
			memid.focus();
			return false;
		}

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


		$.ajax({
			type: "POST"
			,url: "member_search_pw_ajax.asp"
			,data: {
				 "memberName"		: ids.val()
				,"memberMail"		: mails.val()
				,"isCom"			: isCom.val()
				,"memberId"			: memid.val()
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				$("#login_alert").html(data);
				//loadings();

				//alert($("."+DivGoods).parent().tagName);


			}
			,error:function(data) {
				alert("<%=LNG_AJAX_ERROR_MSG%>"+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
	}

// -->
</script>
<link rel="stylesheet" href="/m/css/common.css" />
<link rel="stylesheet" href="/m/css/membership.css" />

</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
<div id="idpw" class="memberWrap">
	<div class="tit"><!-- 패스워드찾기 --><%=LNG_TEXT_FIND_PASSWORD%><i></i></div>
	<div class="radio_btn width100"><!--회원구분-->
		<div class="inner">
			<label>
				<input type="radio" name="isCompany" value="T" id="memType-2" checked="checked" />
				<i><u></u></i>
				<%=LNG_TEXT_BUSINESS_MEMBER%>
			</label>
		</div>
	</div>
	<div class="inputWrap width100">
		<!-- <div class="input">
			<input type="text" id="memberId" name="memberId" value placeholder="<%=LNG_TEXT_ID%>" />
		</div>
		<div class="input">
			<input type="text" id="memberName" name="memberName" value placeholder="<%=LNG_TEXT_NAME%>" />
		</div>
		<div class="input">
			<input type="text" id="memberMail" name="memberMail" value placeholder="<%=LNG_TEXT_EMAIL%>" />
		</div> -->
		<div class="mem_btn">
			<input type="button" onclick="search_pwdcheck();" value="<%=LNG_TEXT_CONFIRM%>" />
		</div>
	</div>

	<div class="mem_search">
		<div class="inner">
			<div class="login mem"><a href="/m/common/member_login.asp"><%=LNG_TEXT_LOGIN%></a></div>
			<i></i>
			<div class="idpw mem"><a href="/m/common/member_search_id.asp"><%=LNG_TEXT_FIND_ID%></a></div>
		</div>
	</div>
	<div id="login_alert" class="tcenter"></div>

	<script>
	$(document).ready(function(){
		$('.skin-blue input').each(function(){
			var self = $(this),
			label = self.next(),
			label_text = label.text();

			label.remove();
			self.iCheck({
				checkboxClass: 'icheckbox_line-blue',
				radioClass: 'iradio_line-blue',
				insert: '<div class="icheck_line-icon"></div>' + label_text
			});
		});

	});
	</script>
</div>
<!--#include virtual = "/m/_include/copyright.asp"-->



