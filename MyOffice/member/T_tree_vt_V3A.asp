<!--#include virtual = "/_lib/strFunc.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=DKCONF_SITE_TITLE%> <%=LNG_MYOFFICE_CHART_04%> by Webpro.kr</title>
<script type="text/javascript" src="/jscript/jquery.min.1.7.1.js"></script>
<script type="text/javascript" src="/jscript/Oc.js"></script>
<script type="text/javascript">
<!--
 	function chkNameVoter() {
		f = document.chkFrm;
		if (f.sname.value == '')
		{
			alert("<%=LNG_JS_TREE_SEARCH_NAME%>");
			f.sname.focus();
			return false;
		}

		var values = encodeURIComponent(f.sname.value);

		createRequest();

		var url = '/ajax/ajax_tree_vt_v2.asp?sname='+values;

		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("sList").innerHTML = newContent;
			}
		  }
		}
		request.send(null);

	}

// -->
</script>
<link rel="stylesheet" href="/myoffice/css/oc.css"/>
<%


	Call ONLY_CS_MEMBER_CLOSE()

'	DK_MEMBER_ID1 = "HH"
'	DK_MEMBER_ID2 = 971


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
	arrChkData = Db.execRsData("DKP_TREE_CHECK_VT",DB_PROC,arrParams,DB3)
	If arrChkData < 1 Then
		Call ALERTS(LNG_JS_NOT_YOUR_UNDERLINE,"BACK","")
	End If
%>


</head>
<body>
<!-- <div class="SearchLayer">
	<div class="listicon"><img src="<%=IMG%>/tree/tree_list.png" width="21" height="21" alt="" class="vmiddle" /></div>
	<div class="innerSearch">
		<form name="chkFrm" action="testTree2.asp" method="post" onsubmit="return false;">
			<img src="<%=IMG%>/tree/tree_search_l.png" width="7" height="21" alt="" class="vmiddle" /><input type="text" name="sname" class="input_text vmiddle" style="" value="" /><img src="<%=IMG%>/tree/tree_search.png" width="80" height="21" alt="" onclick="chkNameVoter();" class="vmiddle cp" /><a href="T_tree_vt_V3A.asp"><img src="<%=IMG%>/tree/tree_reset.png" width="80" height="21" alt="" class="vmiddle" style="margin-left:3px" /></a></span>
		</form>
	</div>
	<div id="sList" class="listarea"></div>
	<div style="float:right; margin-top:4px;margin-right:20px;font-weight:bold;"><a href="https://www.google.com/chrome?hl=ko" target="_blank" />구글 크롬</a>을 이용하시면 빠른 속도로 보실 수 있습니다</div> -->
<div class="SearchLayer3" style="padding-top:10px; height:40px;">
	<div id="search_wrapAll">
		<!-- <div class="listicon2"><img src="<%=IMG%>/tree/tree_list.png" width="21" height="21" alt="" class="vmiddle" /></div>
			<div class="innerSearch">
				<form name="chkFrm" action="testTree2.asp" method="post" onsubmit="return false;">
					<img src="<%=IMG%>/tree/tree_search_l.png" width="7" height="21" alt="" class="vmiddle" /><input type="text" name="sname" class="input_text vmiddle" style="" value="" /><img src="<%=IMG%>/tree/tree_search.png" width="80" height="21" alt="" onclick="chkNameVoter();" class="vmiddle cp" /><a href="T_tree_vt_V3A.asp"><img src="<%=IMG%>/tree/tree_reset.png" width="80" height="21" alt="" class="vmiddle" style="margin-left:3px" /></a></span>
				</form>
			</div> -->
			<div id="sList" class="listarea"></div>
			<!-- <div style="float:right; margin-top:4px;margin-right:20px;font-weight:bold;"> <%=LNG_TEXT_TREE_MAX_LEVEL%></div></div> -->
			<div style="float:left; margin-top:4px;margin-left:20px;font-weight:bold;font-size:16px;"> <%=LNG_MYOFFICE_CHART_02%></div></div>
	</div>
	<!-- <div id="zoom2" style="margin-right:10px;">
		<a href="#" onClick="zoomIn();" onKeyPress="zoomIn();"><img src="<%=IMG%>/tree/zoomin.png" alt="확대" usemap="#index_cs" width="30"></a>
		<a href="#" onClick="zoomOut();" onKeyPress="zoomOut();"><img src="<%=IMG%>/tree/zoomout.png" alt="축소" usemap="#index_cs" width="30"></a>
	</div> -->
	<div id="zoom2" style="margin-right:10px;margin-top:-4px;">
		<img src="<%=IMG_KR%>/tree/close.png" width="38" height="" alt="창 닫기" style="cursor:pointer;" onclick="self.close();"/>
	</div>
</div>
</div>
<%
	Response.Buffer = true
	Response.Write("<table id='waiting' height='100%' width='100%'" )
	Response.Write("style='position:absolute; visibility:hidden'> ")
	Response.Write("<tr><td align=""center"" style='font-size:9pt; background:#FFFFFF;'>")
	Response.Write("<img src=""/images_kr/159.gif"" width=""128"" height=""128"" alt="""" /><br>")
	Response.Write("<center><span style=""color:black"">Data Loading<br />"&LNG_TEXT_TAKE_TIME_TO_LOAD&"</span></center>")
	Response.Write("</td></tr></table> ")

	Response.Write("<script type=""text/javascript""> ")
	Response.Write("waiting.style.visibility='visible' ")
	Response.Write("</script>")
	Response.Flush() '여기까지의 내용을 일단 Flush

%>
<ul id="org" style="display:none">
<%
'	DK_MEMBER_ID1 = "00"
'	DK_MEMBER_ID2 = 10001
	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,SDK_MEMBER_ID2),_
		Db.makeParam("@DEPTH",adInteger,adParamInput,0,2)_
	)
	arrList = Db.execRsList("DKP_TREE_VOTER_NEW",DB_PROC,arrParams,listLen,DB3)
	'arrList = Db.execRsList("DKP_TREE_VOTER2",DB_PROC,arrParams,listLen,DB3)
	If IsArray(arrList) Then
		thisLevel = 0
		prevLevel = 0

		For i = 0 To listLen
			TrID = arrList(0,i)&arrList(1,i)
			PaID = arrList(5,i)&arrList(6,i)

'			viewIcons = viewImg(IMG_ICON&"/person.jpg",40,55,"")
			viewIcons = viewImg(IMG_ICON&"/satOnBlue.gif",46,48,"")
			'viewIcons2 = viewImg(IMG_ICON&"/satOnGreen.gif",36,38,"")

			If arrList(7,i) = 1 Then
				'leaveCheck = "정상회원"
				liClass = ""
			Else
				'leaveCheck = "<span class=""tweight"">탈퇴</span>"
				liClass = "class=""bgs"""
			End If

			ThisName = Replace(Replace(Replace(Replace(arrList(2,i),vbcrlf, ""),Chr(13)&Chr(10),""),Chr(13),""),Chr(10),"")

			If i = 0 Then
				PRINT "<li class=""fnodeTopA tweight"">"
				PRINT "<p "&liClass&"><a href=""?sid1="&arrList(5,i)&"&amp;sid2="&arrList(6,i)&""">"&LNG_TEXT_TREE_TOP&"</a></p>"
				'PRINT "<p "&liClass&">"&viewIcons&"</p>"
				PRINT "<p "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</a></p>"
				PRINT "<p "&liClass&" class=""blue2""><!-- "&LNG_TEXT_NAME&" : --> "&ThisName&"</p>"
				PRINT "<p "&liClass&" class=""green2"">"&LNG_TEXT_POSITION&" : "&arrList(12,i)&"</p>"
				PRINT "<p "&liClass&">"&LNG_TEXT_REGTIME&" : "&date8to13(arrList(4,i))&"</p>"
			'	PRINT "<p "&liClass&">단계 :  "&arrList(11,i)&"</p>"
			'	PRINT "<p "&liClass&">"&LNG_TEXT_CENTER&" :  "&arrList(8,i)&"</p>"
				PRINT "<ul id=""T"&TrID&"""></ul></li>"
			Else
				'convSql = rejectIjt(Replace(convSql,chr(13)&chr(10), "<br />"))arrList(2,i)

				innerHTML = "<li class=""fnodeSubA"">"
				innerHTML = innerHTML & "<p "&liClass&" class=""tweight""><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</a></p>"
			'	innerHTML = innerHTML & "<p "&liClass&">"&viewIcons2&"</p>"
				'innerHTML = innerHTML & "<p "&liClass&"><img src=""/images_kr/icon/satOnGreen.gif"" width=""36"" height=""38"" /></p>"
				innerHTML = innerHTML & "<p "&liClass&" class=""blue2 tweight"">"&ThisName&"</p>"
				innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_POSITION&" : "&arrList(12,i)&"</p>"
				innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_REGTIME&" : "&date8to13(arrList(4,i))&"</p>"
			'	innerHTML = innerHTML & "<p "&liClass&">단계 :"&arrList(11,i)&"</p>"
				innerHTML = innerHTML & "<ul id=""T"&TrID&"""></ul></li>"
				trees = trees & "$(""#T"&PaID&""").append('"&innerHTML&"');"&VbCrlf
			End If
		Next
	End If
%>
</ul>
<div id="chart" class="orgChart"></div>
<script type="text/javascript" language="JScript.Encode">
	waiting.style.visibility="hidden"
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
</body>
</html>
<%Response.Flush()%>
