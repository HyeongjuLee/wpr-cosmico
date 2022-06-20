<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_include/document.asp"-->
<%
	PAGE_SETTING = "MYOFFICE"
	INFO_MODE	 = "CHART1-1"

	ISLEFT = "T"
	ISSUBTOP = "T"
	OVERFLOW_VISIBLE = "F"

	If DK_MEMBER_LEVEL < 2 Then Call CONFIRM(LNG_STRCHECK_TEXT06&LNG_STRCHECK_TEXT05,"go_back","/common/member_login.asp?backURL="&ThisPageURL&"","")
	Call ONLY_CS_MEMBER()
	Call ONLY_CS_MEMBER_CLOSE()

	SDK_MEMBER_ID1 = gRequestTF("sid1",False)
	SDK_MEMBER_ID2 = gRequestTF("sid2",False)

	If SDK_MEMBER_ID1 = "" Then SDK_MEMBER_ID1 = DK_MEMBER_ID1
	If SDK_MEMBER_ID2 = "" Then SDK_MEMBER_ID2 = DK_MEMBER_ID2

	arrParams = Array(_
		Db.makeParam("@DK_MEMBER_ID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@SDK_MEMBER_ID",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,SDK_MEMBER_ID2)_
	)
	arrChkData = Db.execRsData("DKP_TREE_CHECK",DB_PROC,arrParams,DB3)
	If arrChkData < 1 Then
		Call ALERTS(LNG_JS_NOT_YOUR_UNDERLINE,"BACK","")
	End If

%>
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript" src="/jscript/Oc.js"></script>
<link rel="stylesheet" href="/myoffice/css/Oc2.css"/>
<link rel="stylesheet" href="/myoffice/css/style_cs.css" />
<link rel="stylesheet" href="/myoffice/css/layout_cs.css" />

</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="chart" class="orgChart" style="border:1px solid #c7c7c7;margin-top:20px;height:450px;overf low-y:scroll;" align="center">
	<div id="top_line" style="margin-bottom:10px;">
		<span class="span1"><%=LNG_MYOFFICE_CHART_01%></span>
		<span class="button medium vmiddle fright" style="position:relative;margin:8px 10px 0px 0px;"><span class="add"></span><a href="/myoffice/member/T_tree_ss_V3A.asp" target="_blank"><%=LNG_CS_T_TREE_SS_PAGE_TEXT02%></a></span>
	</div>
</div>
<ul id="org" style="display:none;width:100%;">
<%
'	DK_MEMBER_ID1 = "00"
'	DK_MEMBER_ID2 = 10001

	le_vel = 1
	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,SDK_MEMBER_ID2),_
		Db.makeParam("@DEPTH",adInteger,adParamInput,0,le_vel)_
	)
	arrList = Db.execRsList("DKP_TREE_SPONSOR",DB_PROC,arrParams,listLen,DB3)
'	arrList = Db.execRsList("DKP_TREE_SPONSOR2",DB_PROC,arrParams,listLen,DB3)
	If IsArray(arrList) Then
		thisLevel = 0
		prevLevel = 0

		For i = 0 To listLen
			TrID = arrList(0,i)&arrList(1,i)
			PaID = arrList(3,i)&arrList(4,i)	'후원인아이디

'			viewIcons = viewImg(IMG_ICON&"/person.jpg",40,55,"")
			viewIcons = viewImg(IMG_ICON&"/satOnBlue.gif",46,48,"")
'			viewIcons2 = viewImg(IMG_ICON&"/satOnGreen.gif",36,38,"")

			If arrList(11,i) = 1 Then
				'leaveCheck = "정상회원"
				liClass = ""
			Else
				'leaveCheck = "<span class=""tweight"">탈퇴</span>"
				liClass = "class=""bgs"""
			End If

			ThisName = Replace(Replace(Replace(Replace(arrList(2,i),vbcrlf, ""),Chr(13)&Chr(10),""),Chr(13),""),Chr(10),"")

			If i = 0 Then
				PRINT "<li class=""fnodeTopA tweight"">"
				'PRINT "<p "&liClass&"><a href=""?sid1="&arrList(3,i)&"&amp;sid2="&arrList(4,i)&""">"&LNG_TEXT_TREE_TOP&"</a></p>"
				PRINT "<p "&liClass&"></p>"
				PRINT "<p "&liClass&">"&viewIcons&"</p>"
				'PRINT "<p "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</a></p>"
				PRINT "<p "&liClass&">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</p>"
				PRINT "<p "&liClass&" class=""blue2"">"&LNG_TEXT_NAME&" : "&arrList(2,i)&"("&arrList(6,i)&")"&"</p>"
				PRINT "<p "&liClass&" class=""green2"">"&LNG_TEXT_POSITION&" : "&arrList(17,i)&"</p>"
				PRINT "<p "&liClass&">"&LNG_TEXT_REGTIME&" : "&date8to13(arrList(8,i))&"</p>"
				PRINT "<p "&liClass&">"&LNG_TEXT_CENTER&" :  "&arrList(12,i)&"</p>"
				PRINT "<ul id=""T"&TrID&"""></ul></li>"
			Else
				innerHTML = "<li class=""fnodeSubA"">"
				'innerHTML = innerHTML & "<p "&liClass&" class=""tweight""><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</a></p>"
				innerHTML = innerHTML & "<p "&liClass&" class=""tweight"">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</p>"
				innerHTML = innerHTML & "<p "&liClass&"><img src=""/images/icon/satOnGreen.gif"" width=""36"" height=""38"" /></p>"
				innerHTML = innerHTML & "<p "&liClass&" class=""blue2 tweight"">"&LNG_TEXT_NAME&" : "&arrList(2,i)&"("&arrList(6,i)&")"&"</p>"
				innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_POSITION&" : "&arrList(17,i)&"</p>"
				innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_REGTIME&" : "&date8to13(arrList(8,i))&"</p>"
				innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_CENTER&" :"&(arrList(12,i))&"</p>"
				innerHTML = innerHTML & "<ul id=""T"&TrID&"""></ul></li>"
				trees = trees & "$(""#T"&PaID&""").append('"&innerHTML&"');"&VbCrlf
			End If
		Next
	End If
%>
</ul>

<script type="text/javascript" language="JScript.Encode" >
	//waiting.style.visibility="hidden"
	<%=trees%>

	jQuery(document).ready(function() {

		$('#list-html').text($('#org').html());
		$("#org").bind("DOMSubtreeModified", function() {
			$('#list-html').text('');
			$('#list-html').text($('#org').html());
		});

		var ftableWidth = $("div.orgChart table:first-child").width();
		var moveWidth = (ftableWidth/2)-($(window).width()/2)
		$("html,body").scrollLeft(moveWidth);

	});
</script>


<!--#include virtual = "/_include/copyright.asp"-->