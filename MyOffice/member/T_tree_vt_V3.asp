<!--#include virtual = "/_lib/strFunc.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>이바인 추천조직도 by Webpro.kr</title>
<script type="text/javascript" src="/jscript/jquery.min.1.7.1.js"></script>
<script type="text/javascript" src="/jscript/Oc.js"></script>
<link rel="stylesheet" href="/css/oc.css"/>
<%


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
	arrChkData = Db.execRsData("DKP_TREE_CHECK_VT",DB_PROC,arrParams,Nothing)
	If arrChkData < 1 Then
		Call ALERTS("검색할 수 없습니다. 본인 하선의 회원이 아닙니다.","BACK","")
	End If
%>


</head>
<body>
<div class="SearchLayer">
	<div class="listicon"><img src="<%=IMG%>/tree/tree_list.png" width="21" height="21" alt="" class="vmiddle" /></div>
	<div class="innerSearch">
		<form name="chkFrm" action="testTree2.asp" method="post" onsubmit="return false;">
			<img src="<%=IMG%>/tree/tree_search_l.png" width="7" height="21" alt="" class="vmiddle" /><input type="text" name="sname" class="input_text vmiddle" style="" value="" /><img src="<%=IMG%>/tree/tree_search.png" width="80" height="21" alt="" onclick="chkNameVoter();" class="vmiddle cp" /><a href="T_tree_vt_V3.asp"><img src="<%=IMG%>/tree/tree_reset.png" width="80" height="21" alt="" class="vmiddle" style="margin-left:3px" /></a></span>
		</form>
	</div>
	<div id="sList" class="listarea"></div>
	<!-- <div style="float:right; margin-top:4px;margin-right:20px;font-weight:bold;"><a href="https://www.google.com/chrome?hl=ko" target="_blank" />구글 크롬</a>을 이용하시면 빠른 속도로 보실 수 있습니다</div> -->
</div>
<%
	Response.Buffer = true
	Response.Write("<table id='waiting' height='100%' width='100%'" )
	Response.Write("style='position:absolute; visibility:hidden'> ")
	Response.Write("<tr><td align=""center"" style='font-size:9pt; background:#FFFFFF;'>")
	Response.Write("<img src=""/images/159.gif"" width=""128"" height=""128"" alt="""" /><br>")
	Response.Write("<center><span style=""color:black"">Data Loading<br />데이터가 많을 경우 로딩에 시간이 걸릴 수 있습니다</span></center>")
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
		Db.makeParam("@DEPTH",adInteger,adParamInput,0,3)_
	)
	'arrList = Db.execRsList("DKP_TREE_SPONSOR",DB_PROC,arrParams,listLen,Nothing)
	arrList = Db.execRsList("DKP_TREE_VOTER3",DB_PROC,arrParams,listLen,Nothing)
	If IsArray(arrList) Then
		thisLevel = 0
		prevLevel = 0
		For i = 0 To listLen
			TrID = arrList(0,i)&arrList(1,i)
			'PaID = arrList(3,i)&arrList(4,i)
			PaID = arrList(5,i)&arrList(6,i)

'			viewIcons = viewImg(IMG_ICON&"/person.jpg",40,55,"")
			viewIcons = viewImg(IMG_ICON&"/satOnBlue.gif",46,48,"")
			viewIcons2 = viewImg(IMG_ICON&"/satOnGreen.gif",36,38,"")

			If arrList(7,i) = 1 Then
				leaveCheck = "정상회원"
				liClass = ""
			Else
				leaveCheck = "<span class=""tweight"">탈퇴</span>"
				liClass = "class=""bgs"""
			End If
			If i = 0 Then
				PRINT "<li class=""fnodeTop tweight"">"
				PRINT "<p "&liClass&"><a href=""?sid1="&arrList(5,i)&"&amp;sid2="&arrList(6,i)&""">상위회원</a></p>"
				PRINT "<p "&liClass&">"&viewIcons&"</p>"
				PRINT "<p "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</a></p>"
				PRINT "<p class=""blue2"" "&liClass&">성명  : "&arrList(2,i)&"</p>"
'				PRINT "<p "&liClass&">상태 : "&leaveCheck&"</p>"
				PRINT "<p class = ""green2"""&liClass&" >현직급 : "&arrList(12,i)&"</p>"
				PRINT "<p "&liClass&">가입일 : "&date8to11(arrList(4,i))&"</p>"
				PRINT "<p "&liClass&">소속 :  "&(arrList(15,i))&"</p>"
'				PRINT "<p "&liClass&">추천인 : "&(arrList(13,i))&"</p>"
				PRINT "<p "&liClass&">최종구매일 : "&num2cur(arrList(14,i))&"PV</p>"
				PRINT "<p "&liClass&">구매일 : "&date8to10(arrList(11,i))&"</p>"
				PRINT "<ul id=""T"&TrID&"""></ul></li>"
			Else
				innerHTML = "<li class=""fnodeSub""><!-- <p "&liClass&"><a href=""?sid1="&arrList(5,i)&"&amp;sid2="&arrList(6,i)&""">상위회원</a></p> --><p "&liClass&" class=""tweight""><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</a></p><p "&liClass&">"&viewIcons2&"</p><p "&liClass&" class=""tweight blue2""><!-- 성명 :  -->"&arrList(2,i)&"</p><p "&liClass&"><!-- 직급 : --> "&arrList(12,i)&"</p><!-- <p "&liClass&">상태 :  "&leaveCheck&"</p> --><!-- <p "&liClass&"> 등록일 :  "&date8to11(arrList(4,i))&"</p> --><!-- <p "&liClass&">소속센터 : "&(arrList(8,i))&"</p> --><p "&liClass&" class=""tweight""><!-- 최종구매 : --> "&num2cur(arrList(14,i))&"PV</p><!-- <p "&liClass&">구매일 : "&arrList(11,i)&"</p> --><!-- <p "&liClass&">추천인 : "&(arrList(13,i))&"</p> --><ul id=""T"&TrID&"""></ul></li>"
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
