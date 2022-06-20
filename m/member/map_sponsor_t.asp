<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "MY_MEMBER"
	Call FNC_ONLY_CS_MEMBER()


	SDK_MEMBER_ID1 = gRequestTF("sid1",False)
	SDK_MEMBER_ID2 = gRequestTF("sid2",False)


	If SDK_MEMBER_ID1 = "" Then SDK_MEMBER_ID1 = DK_MEMBER_ID1
	If SDK_MEMBER_ID2 = "" Then SDK_MEMBER_ID2 = DK_MEMBER_ID2
'	PRINT DK_MEMBER_ID1
'	PRINT DK_MEMBER_ID2
'	PRINT SDK_MEMBER_ID1
'	PRINT SDK_MEMBER_ID2

	arrParams = Array(_
		Db.makeParam("@DK_MEMBER_ID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@SDK_MEMBER_ID",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,SDK_MEMBER_ID2)_
	)
	arrChkData = CInt(Db.execRsData("DKP_TREE_CHECK",DB_PROC,arrParams,DB3))
	If arrChkData < 1 Then
		Call ALERTS(LNG_JS_NOT_YOUR_UNDERLINE,"BACK","")
	End If

%>
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<script type="text/javascript" src="/m/js/Oc.js"></script>
<link type="text/css" rel="stylesheet" href="/m/css/oc.css"  />
</head>
<body onunload="" >
<!--#include virtual = "/m/_include/header.asp"-->
<!--#include virtual = "/m/_include/sub_header.asp"-->
<div id="subTitle" class="width100 tcenter text_noline" ><%=LNG_MYOFFICE_CHART_01%></div>

<div class="cleft" style="width:100%; position:absolute; margin-top:40px;">
<!-- <div class="fleft"><a href="javascript:goScrolls('left');" data-ajax="false" ><img src="<%=IMG%>/go_left.png" width="56" height="56" style="margin-top:20px;margin-left:20px;" /></a></div>
<div class="fright"><a href="javascript:goScrolls('right');" data-ajax="false"><img src="<%=IMG%>/go_right.png" width="56" height="56" style="margin-top:20px;;margin-right:20px;" /></a></div> -->
</div>
<!-- <div id="member">
	<table <%=tableatt%> style="width:100%;" class="member_info">
		<colgroup>
			<col width="110" />
			<col width="*" />
		</colgroup>
		<tbody>

		</tbody>
	</table>
</div> -->
<ul id="org" style="display:none; width:100%;">
<%
'	DK_MEMBER_ID1 = "00"
'	DK_MEMBER_ID2 = 10001
	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,SDK_MEMBER_ID2),_
		Db.makeParam("@DEPTH",adInteger,adParamInput,0,3)_
	)
	arrList = Db.execRsList("DKP_TREE_SPONSOR_NEW",DB_PROC,arrParams,listLen,DB3)
	'arrList = Db.execRsList("DKP_TREE_SPONSOR",DB_PROC,arrParams,listLen,DB3)
	'arrList = Db.execRsList("DKP_TREE_VOTER",DB_PROC,arrParams,listLen,Nothing)
	If IsArray(arrList) Then
		thisLevel = 0
		prevLevel = 0
		For i = 0 To listLen
			TrID = arrList(0,i)&arrList(1,i)
			PaID = arrList(3,i)&arrList(4,i)
			'PaID = arrList(5,i)&arrList(6,i)
			If arrList(11,i) = 1 Then
				'leaveCheck = "정상회원"
				liClass = ""
			Else
				'leaveCheck = "<span class=""tweight"">탈퇴회원</span>"
				liClass = "class=""bgs"""
			End If

			ThisName = Replace(Replace(Replace(Replace(arrList(2,i),vbcrlf, ""),Chr(13)&Chr(10),""),Chr(13),""),Chr(10),"")

			If i = 0 Then
				PRINT "<li class=""fnode""><p style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(3,i)&"&amp;sid2="&arrList(4,i)&""" data-ajax=""false"">"&LNG_TEXT_TREE_TOP&"</a></p><p style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""" data-ajax=""false"">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</a></p><p "&liClass&"><span class=""s320over"">"&LNG_TEXT_NAME&" : </span>"&ThisName&"</p><p "&liClass&"><span class=""s320over"">상태 : </span>"&leaveCheck&"</p><p "&liClass&"><span class=""s320over"">"&LNG_TEXT_REGTIME&" : </span>"&(arrList(8,i))&"</p><!--<p "&liClass&">구매일 : "&arrList(16,i)&"</p>--><ul id=""T"&TrID&"""></ul></li>"
			Else
				'If arrList(5,i) > 1 Then
				'	innerHTML = "<li class=""fnode3""><p  style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""" data-ajax=""false"">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</a></p><p "&liClass&"><span class=""s320over"">성명 : </span>"&arrList(2,i)&"</p><p "&liClass&"><span class=""s320over"">상태 : </span>"&leaveCheck&"</p><p "&liClass&"><span class=""s320over"">등록일 : </span>"&(arrList(8,i))&"</p><!--<p "&liClass&">구매일 : "&arrList(16,i)&"</p>--><ul id=""T"&TrID&"""></ul></li>"
				'	trees = trees & "$(""#T"&PaID&""").append('"&innerHTML&"');"&VbCrlf
				'Else
					innerHTML = "<li class=""fnode2""><p  style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""" data-ajax=""false"">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</a></p><p "&liClass&"><span class=""s320over"">"&LNG_TEXT_NAME&" : </span>"&ThisName&"</p><p "&liClass&"><span class=""s320over"">상태 : </span>"&leaveCheck&"</p><p "&liClass&"><span class=""s320over"">"&LNG_TEXT_REGTIME&" : </span>"&(arrList(8,i))&"</p><!--<p "&liClass&">구매일 : "&arrList(16,i)&"</p>--><ul id=""T"&TrID&"""></ul></li>"
					trees = trees & "$(""#T"&PaID&""").append('"&innerHTML&"');"&VbCrlf
				'End If
			End If
		Next
	End If
%>
</ul>
<div id="chart" class="orgChart"></div>
<script type="text/javascript" language="JScript.Encode">
	//waiting.style.visibility="hidden"
	<%=trees%>

	jQuery(document).ready(function() {

		$('#list-html').text($('#org').html());
		$("#org").bind("DOMSubtreeModified", function() {
			$('#list-html').text('');
			$('#list-html').text($('#org').html());
		});

		var ftableWidth = $("div.jOrgChart table:first-child").width();
		var moveWidth = (ftableWidth/2)-($(window).width()/2)
		$("div.jOrgChart").scrollLeft(moveWidth);
		//alert(moveWidth);
	});

	function goScrolls(moveS) {
		var nowXC = $("div.jOrgChart").scrollLeft();

		var movXC = 100
		var brwXC = $(window).width();
		// alert(brwXC);
		if (moveS == 'left')
		{
			$("div.jOrgChart").scrollLeft(nowXC-brwXC+movXC);

		} else {
			$("div.jOrgChart").scrollLeft(nowXC+brwXC-movXC);


		}



	}
</script>


<!--#include virtual = "/m/_include/copyright.asp"-->