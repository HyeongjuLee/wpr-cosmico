<!--#include virtual = "/_lib/strFunc.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Webpro.kr - Web Organization Chart</title>
<script type="text/javascript" src="/jscript/jquery.min.1.7.1.js"></script>
<script type="text/javascript" src="/jscript/Oc.js"></script>
<link rel="stylesheet" href="/css/oc.css" />
<%

	Call ONLY_CS_MEMBER_CLOSE()
'	DK_MEMBER_ID1 = "wg"
'	DK_MEMBER_ID2 = "1"

	SDK_MEMBER_ID1 = gRequestTF("sid1",False)
	SDK_MEMBER_ID2 = gRequestTF("sid2",False)
	SDK_MEMBER_ID3 = gRequestTF("sid3",False)


	If SDK_MEMBER_ID1 = "" Then SDK_MEMBER_ID1 = DK_MEMBER_ID1
	If SDK_MEMBER_ID2 = "" Then SDK_MEMBER_ID2 = DK_MEMBER_ID2
	If SDK_MEMBER_ID3 = "" Then SDK_MEMBER_ID3 = DK_MEMBER_ID3


	arrParams = Array(_
		Db.makeParam("@DK_MEMBER_ID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@SDK_MEMBER_ID",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,SDK_MEMBER_ID2)_
	)
	arrChkData = CInt(Db.execRsData("DKP_TREE_CHECK_SUB",DB_PROC,arrParams,Nothing))
	If arrChkData < 1 Then
		Call ALERTS("검색할 수 없습니다. 본인 하선의 회원이 아닙니다.","BACK","")
	End If

	'회차
	SDK_MEMBER_ID3	= pRequestTF("SDK_MEMBER_ID3",False)
%>


</head>
<body>
<div class="SearchLayer">
	<!-- <div class="listicon"><img src="<%=IMG%>/tree/tree_list.png" width="21" height="21" alt="" class="vmiddle" /></div>
	<div class="innerSearch">
		<form name="chkFrm" action="testTree2.asp" method="post" onsubmit="return false;">
			<img src="<%=IMG%>/tree/tree_search_l.png" width="7" height="21" alt="" class="vmiddle" /><input type="text" name="sname" class="input_text vmiddle" style="" value="" /><img src="<%=IMG%>/tree/tree_search.png" width="80" height="21" alt="" onclick="chkNameSponsorSUB();" class="vmiddle cp" /><a href="T_tree_allowance_V2.asp"><img src="<%=IMG%>/tree/tree_reset.png" width="80" height="21" alt="" class="vmiddle" style="margin-left:3px" /></a></span>&nbsp;&nbsp;
		</form>
	</div> -->
	<div id="sList" class="listarea"></div>
	<div class="fleft" style="padding-left:10px;">
		<form name="sfrm" action="" method="post">
			<input type="hidden" name="SDK_MEMBER_ID1" value="<%=SDK_MEMBER_ID1%>" />
			<input type="hidden" name="SDK_MEMBER_ID2" value="<%=SDK_MEMBER_ID2%>" />
			<div id="cheack_area">
				<select name="SDK_MEMBER_ID3" class="vmiddle">
					<option value=""   <%=isSelect(SDK_MEMBER_ID3,"")%>>회차선택</option>
					<%	'MAX 회차수 불러오기
						arrParams = Array(_
							Db.makeParam("@SDK_MEMBER_ID1",adVarchar,adParamInput,20,SDK_MEMBER_ID1) ,_
							Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,SDK_MEMBER_ID2) ,_
							Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,1) _
						)
						MAX_MBID3 = Db.execRsData("HJP_TREE_MAX_MBID3_SUB",DB_PROC,arrParams,Nothing)

						If MAX_MBID3 = "" Or ISNULL(MAX_MBID3) Then MAX_MBID3 = 1
					%>
					<%For i= 1 To MAX_MBID3 %>
						<option value=<%=i%><%=isSelect(SDK_MEMBER_ID3,i)%>><%=i%></option>
					<%Next%>
				</select>
				<input type="image" src="<%=IMG%>/tree/tree_search2.png" width="70" height="21" class="vmiddle cp" />
			</div>
		</form>
	</div>
	<div id="sList" class="listarea"></div>
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
'	SDK_MEMBER_ID1 = "HA"
'	SDK_MEMBER_ID2 = 68
'	SDK_MEMBER_ID3 = 3

	If SDK_MEMBER_ID3 = "" Then SDK_MEMBER_ID3 = 1
	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,SDK_MEMBER_ID2),_
		Db.makeParam("@mbid3",adInteger,adParamInput,0,SDK_MEMBER_ID3),_
		Db.makeParam("@DEPTH",adInteger,adParamInput,0,2)_
	)
	arrList = Db.execRsList("DKP_TREE_SPONSOR_SUB",DB_PROC,arrParams,listLen,Nothing)

	If IsArray(arrList) Then
		thisLevel = 0
		prevLevel = 0
		For i = 0 To listLen
			TrID = arrList(0,i)&arrList(1,i)&arrList(2,i)
			PaID = arrList(3,i)&arrList(4,i)&arrList(5,i)

			If i = 0 Then
				PRINT "<li class=""fnodeATop""><p style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(3,i)&"&amp;sid2="&arrList(4,i)&"&amp;sid3="&arrList(5,i)&""">상위회원</a></p>"
				PRINT "<p style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"-"&arrList(2,i)&"</a></p>"
				PRINT "<p "&liClass&">성명 : "&arrList(6,i)&"</p>"
				PRINT "<p "&liClass&">회차 : "&SDK_MEMBER_ID3&"</p>"
				PRINT "<ul id=""T"&TrID&"""></ul></li>"
			Else
			'	innerHTML = "<li class=""fnodeASub""><p  style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"-"&arrList(2,i)&"</a></p>"
				innerHTML = "<li class=""fnodeASub""><p  style=""font-weight:bold;"" "&liClass&">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"-"&arrList(2,i)&"</p>"
				innerHTML = innerHTML & "<p "&liClass&">성명 : "&arrList(6,i)&"</p>"
				innerHTML = innerHTML & "<p "&liClass&">회차 : "&SDK_MEMBER_ID3&"</p>"
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
