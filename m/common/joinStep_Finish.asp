<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MEMBERSHIP"
	view = 0
	ISSUBTOP = "F"

	mbids1 = gRequestTF("m1",true)
	mbids2 = gRequestTF("m2",true)

	'/m/common/joinStep_Finish.asp?m1=TE&m2=1
	'/m/common/joinStep_Finish.asp?m1=JcbvK1LyKTt1&m2=X2WpZ1OyXjC0gEVWQ2stdMH2

	'위변조체크 #1
	If Len(mbids1) = 2 Or Len(mbids2) <= MBID2_LEN Then Call ALERTS(LNG_ALERT_WRONG_ACCESS&"1","GO","/m/index.asp")
	If IsNumeric(mbids2) Then Call ALERTS(LNG_ALERT_WRONG_ACCESS&"2","GO","/m/index.asp")

	On Error Resume Next
	Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
		mbids1 = Trim(StrCipher.Decrypt(mbids1,EncTypeKey1,EncTypeKey2))
		mbids2 = Trim(StrCipher.Decrypt(mbids2,EncTypeKey1,EncTypeKey2))
	Set StrCipher = Nothing
	On Error GoTo 0

	'복호화값 위변조체크 #2
	If Len(mbids1)> 2 Or Len(mbids2) > MBID2_LEN Then Call ALERTS(LNG_ALERT_WRONG_ACCESS&"3","GO","/m/index.asp")
	If Not IsNumeric(mbids2) Then Call ALERTS(LNG_ALERT_WRONG_ACCESS&"4","GO","/m/index.asp")

	ISLEFT = "F"

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/m/index.asp"

	SQLWI = "SELECT [Webid] FROM [tbl_memberinfo] WITH(NOLOCK) WHERE [MBID] = ? AND [MBID2] = ?"
	arrParamsWI = Array(_
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,mbids1), _
		Db.makeParam("@MBID2",adInteger,adParamInput,0,mbids2) _
	)
	Set HJRSWI = Db.execRs(SQLWI,DB_TEXT,arrParamsWI,DB3)
	If Not HJRSWI.BOF And Not HJRSWI.EOF Then
		Webid = HJRSWI("Webid")
	Else
		Call ALERTS(LNG_ALERT_WRONG_ACCESS&"5","GO","/index.asp")
	End If
	Call closeRs(HJRSWI)
%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="/m/js/ajax.js"></script>
<!-- <script type="text/javascript" src="joinStep_01.js"></script> -->
<link rel="stylesheet" href="joinStep.css?" />
<link rel="stylesheet" href="/m/css/join.css?" />
<link rel="stylesheet" type="text/css" href="/m/css/common.css?" />
<script type="text/javascript">
	// $(function(){
	// 	$('.sub-header .sub-header-txt').html('<p class="joinStepF"><i class="icon-ok"></i><%=LNG_JOINFINISH_U_ALERT_OUTPUT07%></p>');
	// });
</script>
</head>
<body onunload="">
<!--#include virtual = "/m/_include/header.asp"-->
<div id="joinStepF" class="common">
	<h6><i class="icon-ok"></i><%=LNG_JOINFINISH_U_ALERT_OUTPUT07%></h6>
	<div class="wrap">
		<ul>
			<li>
				<div><%=LNG_TEXT_MEMID%></div>
				<p><%=mbids1%>-<%=mbids2%></p>
			</li>
			<%If CS_AUTO_WEBID_TF = "T" Then%>
			<li>
				<div><%=LNG_TEXT_ID%></div>
				<p><%=Webid%></p>
			</li>
			<%End If%>
		</ul>
		<div class="btnZone">
			<a class="button" href="/m/shop/index.asp" data-ripplet>MAIN</a>
			<a class="button promise" href="/m/common/member_login.asp?backURL=/m/index.asp"><%=LNG_TEXT_LOGIN%></a>
		</div>
	</div>
	<!--#include virtual = "/m/_include/copyright.asp"-->
</div>

<script>
	function selectSellMemTF(value) {
		var f = document.mfrm;
		f.S_SellMemTF.value = value
		/*
		if (value == 0)	{
			f.action="joinStep02.asp";			//계좌인증
			//f.action="joinStep_n01_m.asp";		//핸드폰인증 (+ 계좌인증)
		}
		*/

		f.submit();
	}
</script>
<form name="mfrm" method="post" action="joinStep_n02_g.asp">
	<input type="hidden" name="S_SellMemTF" value = "">
	<input type="hidden" name="sns_auth" value = "">
</form>