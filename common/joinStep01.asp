<!--#include virtual="/_lib/strFunc.asp" -->
<%

	If webproIP <> "T" Then
		'Call ALERTS("준비중입니다.","back","")
	End If

	PAGE_SETTING = "COMMON"
	NO_MEMBER_REDIRECT = "F"

'	Response.Redirect "/common/joinStep_n02_g.asp"


	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "F"

	view = 4
	'sview = 1

	If DK_MEMBER_LEVEL > 0 Then
		Response.Redirect "/index.asp"
	End If


%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" type="text/css" href="/css/joinstep.css?" />
<script type="text/javascript">
	$(function(){
		<%Select Case LCase(DK_MEMBER_LNG_CODE)%>
		<%Case "kr" %>
		$('.sub-header-txt').append('<div class="join-header-txt"><p><%=LNG_SITE_TITLE%><%=LNG_JOIN_TEXT_01%></p></div>');
		<%Case "us" %>
		$('.sub-header-txt').append('<div class="join-header-txt"><p><%=LNG_JOIN_TEXT_01%></p></div>');
		<%End Select%>
	});
</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="join01" class="common joinstep">
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
		<!-- <p></p> -->
		<ul>
			<li><%=LNG_JOINSTEP01_TEXT02_1%></li>
			<li><%=LNG_JOINSTEP01_TEXT02_2%></li>
			<li><%=LNG_JOINSTEP01_TEXT02_3%></li>
		</ul>
		<a class="button" onclick="javascript: selectSellMemTF(0)" data-ripplet><%=LNG_TEXT_JOIN%></a>
	</div>
</div>

<script>
	function selectSellMemTF(value) {
		var f = document.mfrm;
		f.S_SellMemTF.value = value;
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
	<input type="hidden" name="S_SellMemTF" value = "" readonly="readonly">
	<input type="hidden" name="sns_auth" value = "" readonly="readonly">
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

<!--#include virtual="/_include/copyright.asp" -->
