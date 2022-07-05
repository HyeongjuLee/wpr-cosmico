<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "JOIN"
	view = 1
	sview = 1
	ISSUBTOP = "T"

	'Response.Redirect "/m/common/joinStep_n02_g.asp"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="/m/js/ajax.js"></script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="join01" class="joinstep">
	<article>
		<div class="wrap">
			<h6><%=LNG_TEXT_JOIN_CONSUMER_MEMBER%></h6>
			<!-- <p><%=LNG_JOIN_TEXT_03%></p> -->
			<ul>
				<li><%=LNG_JOINSTEP01_TEXT01_1%></li>
				<li><%=LNG_JOINSTEP01_TEXT01_3%></li>
				<li><%=LNG_JOINSTEP01_TEXT01_2%></li>
			</ul>
			<a class="button" onclick="javascript: selectSellMemTF(1)" data-ripplet><%=LNG_TEXT_JOIN%></a>
		</div>
		<div class="wrap">
			<h6><%=LNG_TEXT_JOIN_BUSINESS_MEMBER%></h6>
			<p></p>
			<ul>
				<li><%=LNG_JOINSTEP01_TEXT02_1%></li>
				<li><%=LNG_JOINSTEP01_TEXT02_2%></li>
				<li><%=LNG_JOINSTEP01_TEXT02_3%></li>
			</ul>
			<a class="button" onclick="javascript: selectSellMemTF(0)" data-ripplet><%=LNG_TEXT_JOIN%></a>
			<!-- <a class="button account" onclick="javascript: selectSellMemTF(9)" data-ripplet>계좌인증</a> -->
		</div>
	</article>
</div>


<script>
	function selectSellMemTF(value) {
		var f = document.mfrm;
		f.S_SellMemTF.value = value
		f.submit();
	}
</script>
<%
	'SNS 가입
	snsType = pRequestTF("snsType",False) : If snsType = "" Then snsType = ""
	snsToken = pRequestTF("snsToken",False) : If snsToken = "" Then snsToken = ""
	snsName = pRequestTF("snsName", False)	: If snsName = "" Then snsName = ""
	snsEmail = pRequestTF("snsEmail", False)	: If snsEmail = "" Then snsEmail = ""
	snsBirthday = pRequestTF("snsBirthday", False)	: If snsBirthday = "" Then snsBirthday = ""
	snsBirthyear = pRequestTF("snsBirthyear", False)	: If snsBirthyear = "" Then snsBirthyear = ""
	snsGender = pRequestTF("snsGender", False)	: If snsGender = "" Then snsGender = ""
	snsMobile = pRequestTF("snsMobile", False)	: If snsMobile = "" Then snsMobile = ""
	snsFamilyName = pRequestTF("snsFamilyName", False)	: If snsFamilyName = "" Then snsFamilyName = ""
	snsGivenName = pRequestTF("snsGivenName", False)	: If snsGivenName = "" Then snsGivenName = ""
%>
<form name="mfrm" method="post" action="joinStep02.asp">
	<input type="hidden" name="S_SellMemTF" value = "">
	<input type="hidden" name="sns_auth" value = "">
	<%'SNS 가입%>
	<input type="hidden" name="snsType" value = "<%=snsType%>" readonly="readonly">
	<input type="hidden" name="snsToken" value = "<%=snsToken%>" readonly="readonly">
	<input type="hidden" name="snsName" value = "<%=snsName%>" readonly="readonly">
	<input type="hidden" name="snsEmail" value = "<%=snsEmail%>" readonly="readonly">
	<input type="hidden" name="snsBirthday" value = "<%=snsBirthday%>" readonly="readonly">
	<input type="hidden" name="snsBirthyear" value = "<%=snsBirthyear%>" readonly="readonly">
	<input type="hidden" name="snsGender" value = "<%=snsGender%>" readonly="readonly">
	<input type="hidden" name="snsMobile" value = "<%=snsMobile%>" readonly="readonly">
	<input type="hidden" name="snsFamilyName" value = "<%=snsFamilyName%>" readonly="readonly">
	<input type="hidden" name="snsGivenName" value = "<%=snsGivenName%>" readonly="readonly">
</form>

<!--#include virtual = "/m/_include/copyright.asp"-->
