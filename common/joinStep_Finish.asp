<!--#include virtual="/_lib/strFunc.asp" -->
<%
	PAGE_SETTING = "COMMON"
	NO_MEMBER_REDIRECT = "F"

	mbids1 = gRequestTF("m1",True)
	mbids2 = gRequestTF("m2",True)

	'/common/joinStep_Finish.asp?m1=TE&m2=1
	'/common/joinStep_Finish.asp?m1=JcbvK1LyKTt1&m2=X2WpZ1OyXjC0gEVWQ2stdMH2

	'위변조체크 #1
	If Len(mbids1) = 2 Or Len(mbids2) <= MBID2_LEN Then Call ALERTS(LNG_ALERT_WRONG_ACCESS&"1","GO","/index.asp")
	If IsNumeric(mbids2) Then Call ALERTS(LNG_ALERT_WRONG_ACCESS&"2","GO","/index.asp")

	On Error Resume Next
	Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
		mbids1 = Trim(StrCipher.Decrypt(mbids1,EncTypeKey1,EncTypeKey2))
		mbids2 = Trim(StrCipher.Decrypt(mbids2,EncTypeKey1,EncTypeKey2))
	Set StrCipher = Nothing
	On Error GoTo 0

	'복호화값 위변조체크 #2
	If Len(mbids1)> 2 Or Len(mbids2) > MBID2_LEN Then Call ALERTS(LNG_ALERT_WRONG_ACCESS&"3","GO","/index.asp")
	If Not IsNumeric(mbids2) Then Call ALERTS(LNG_ALERT_WRONG_ACCESS&"4","GO","/index.asp")

	ISLEFT = "F"
	ISSUBTOP = "F"
	ISSUBVISUAL = "F"

	view = 0
	'sview = 1

	If DK_MEMBER_LEVEL > 0 Then
		Response.Redirect "/index.asp"
	End If

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
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" type="text/css" href="/css/common.css?" />
<link rel="stylesheet" type="text/css" href="/css/joinstep.css?" />
<script type="text/javascript">
	$(function(){
		$('.sub-header .sub-header-txt').html('<p class="joinStepF"><i class="icon-ok"></i><%=LNG_JOINFINISH_U_ALERT_OUTPUT07%></p>');
	});
</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="joinStepF" class="common joinstep">
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
		<a class="button" href="/index.asp" data-ripplet>MAIN</a>
		<a class="button promise" href="/common/member_login.asp?backURL=/index.asp"><%=LNG_TEXT_LOGIN%></a>
	</div>
</div>


<!--#include virtual="/_include/copyright.asp" -->
