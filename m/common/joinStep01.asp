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
<!-- <script type="text/javascript" src="joinStep_01.js"></script> -->
<style>
	.sub_title {display: none !important;}
</style>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="join01" class="joinstep">
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
</div>


<script>
	function selectSellMemTF(value) {
		var f = document.mfrm;
		f.S_SellMemTF.value = value

		if (value == 0)	{
			//f.action="joinStep02.asp";			//계좌인증 (or + 핸드폰인증)
			//f.action="joinStep_n01_m.asp";		//핸드폰인증 (or + 계좌인증)
		}

		f.submit();
	}
</script>
<form name="mfrm" method="post" action="joinStep_n02_g.asp">
	<input type="hidden" name="S_SellMemTF" value = "">
	<input type="hidden" name="sns_auth" value = "">
</form>

<!--#include virtual = "/m/_include/copyright.asp"-->