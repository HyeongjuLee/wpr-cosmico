<!--#include virtual = "/_lib/strFunc.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=DKCONF_SITE_TITLE%> <%=LNG_MYOFFICE_CHART_02%> by Webpro.kr</title>
<script type="text/javascript" src="/jscript/jquery.min.1.7.1.js"></script>
<script type="text/javascript" src="/jscript/Oc.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
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
<link rel="stylesheet" href="/myoffice/css/oc.css" />
<%
	Call ONLY_CS_MEMBER_CLOSE()
'	DK_MEMBER_ID1 = "wg"
'	DK_MEMBER_ID2 = "1"

	SDK_MEMBER_ID1 = gRequestTF("sid1",False)
	SDK_MEMBER_ID2 = gRequestTF("sid2",False)
	toStartDate = request("toStartDate")
	toEndDate = request("toEndDate")

	If SDK_MEMBER_ID1 = "" Then SDK_MEMBER_ID1 = DK_MEMBER_ID1
	If SDK_MEMBER_ID2 = "" Then SDK_MEMBER_ID2 = DK_MEMBER_ID2
	If toStartDate = "" Then toStartDate = ""
	If toEndDate = "" Then toEndDate = ""

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
	arrChkData = Db.execRsData("DKP_TREE_CHECK_VT",DB_PROC,arrParams,DB3)
	If arrChkData < 1 Then
		Call ALERTS(LNG_JS_NOT_YOUR_UNDERLINE,"BACK","")
	End If

	cName			= pRequestTF("cName",False)
	cID				= pRequestTF("cID",False)
	cRegdate		= pRequestTF("cRegdate",False)

	cGrade			= pRequestTF("cGrade",False)
	cCenter			= pRequestTF("cCenter",False)
	cPeriodPV		= pRequestTF("cPeriodPV",False)
	cPeriodCV		= pRequestTF("cPeriodCV",False)

	cLvl			= pRequestTF("cLvl",False)

	If cName		= ""	Then cName 		= 0
	If cID			= ""	Then cID		= 0
	If cRegdate		= ""	Then cRegdate	= 0

	If cGrade		= ""	Then cGrade		= 0
	If cCenter		= ""	Then cCenter	= 0
	If cPeriodPV	= ""	Then cPeriodPV  = 0
	If cPeriodCV	= ""	Then cPeriodCV  = 0


%>
</head>
<body>
<div class="SearchLayer2">
	<div id="search_wrap">
		<div id="search_member">
		<div class="listicon2"><img src="<%=IMG%>/tree/tree_list.png" width="21" height="21" alt="" class="vmiddle" /></div>
			<form name="chkFrm" action="testTree2.asp" method="post" onsubmit="return false;">
				<img src="<%=IMG%>/tree/tree_search_l.png" width="7" height="21" alt="" class="vmiddle" /><input type="text" name="sname" class="input_text2 vmiddle" style="" value="" /><img src="<%=IMG%>/tree/tree_search3.png" width="27" height="21" alt="" onclick="chkNameVoter();" class="vmiddle cp" />
			</form>
		</div>
		<div id="sList" class="listarea"></div>
		<form name="sfrm" action="" method="post">
			<input type="hidden" name="SDK_MEMBER_ID1" value="<%=SDK_MEMBER_ID1%>" />
			<input type="hidden" name="SDK_MEMBER_ID2" value="<%=SDK_MEMBER_ID2%>" />
			<div id="search_period">
				<a href="T_tree_vt_V5.asp"><img src="<%=IMG%>/tree/tree_reset.png" width="80" height="21" alt="" class="vmiddle" style="margin-right:5px" /></a>
				<strong><%=LNG_TEXT_START_DATE%> </strong><input type='text' name='toStartDate' value="<%=toStartDate%>" class='readonly' size='10' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
				~
				<strong><%=LNG_TEXT_END_DATE%> </strong><input type='text' name='toEndDate' value="<%=toEndDate%>" class='inpu t_text readonly' size='10' onclick="openCalendar(event, this, 'YYYY-MM-DD');" readonly="readonly">
			</div>
			<div id="cheack_area">
				<label><input type="hidden" name="cName" value="1" class="input_chk vmiddle" checked="checked"><!-- <%=LNG_TEXT_NAME%> --></label>
				<label><input type="hidden" name="cID" value="1" class="input_chk vmiddle" checked="checked"><!-- <%=LNG_TEXT_ID%> --></label>
				<label><input type="hidden" name="cRegdate" value="1" class="input_chk vmiddle" checked="checked"><!-- <%=LNG_TEXT_REGTIME%> --></label>
				<label><input type="checkbox" name="cGrade" value="1" class="input_chk vmiddle" <%=isChecked(cGrade,"1")%>><%=LNG_TEXT_POSITION%></label>
				<label><input type="checkbox" name="cCenter" value="1" class="input_chk vmiddle" <%=isChecked(cCenter,"1")%>><%=LNG_TEXT_CENTER%></label>
				<label><input type="checkbox" name="cPeriodPV" value="1" class="input_chk vmiddle" <%=isChecked(cPeriodPV,"1")%>><%=LNG_TEXT_TREE_MY_PV%><!-- <%=CS_PV%> --></label>
				<select name="cLvl" class="vmiddle">
					<option value=""   <%=isSelect(cLvl,"")%>><%=LNG_TEXT_TREE_SELECT_LEVEL%></option>
					<%For i = 1 To 10%>
						<option value="<%=i%>"  <%=isSelect(cLvl,i)%>><%=i%></option>
					<%Next%>
				</select>
				<input type="image" src="<%=IMG%>/tree/tree_search2.png" width="70" height="21" class="vmiddle cp" />
			</div>
		</form>
	</div>
	<!-- <div id="zoom" style="margin-right:10px;">
		<a href="#" onClick="zoomIn();" onKeyPress="zoomIn();"><img src="<%=IMG%>/tree/zoomin.png" alt="확대" usemap="#index_cs" ></a>
		<a href="#" onClick="zoomOut();" onKeyPress="zoomOut();"><img src="<%=IMG%>/tree/zoomout.png" alt="축소" usemap="#index_cs" ></a>
	</div> -->
	<!-- <div id="zoom" style="margin-right:10px;">
		<img src="<%=IMG_KR%>/tree/close.png" width="" height="" alt="창 닫기" style="cursor:pointer;" onclick="self.close();"/>
	</div> -->


	<!-- <div style="float:right; margin-top:4px;margin-right:20px;font-weight:bold;"><a href="https://www.google.com/chrome?hl=ko" target="_blank" />구글 크롬</a>을 이용하시면 빠른 속도로 보실 수 있습니다</div> -->

</div>

<%

	Response.Buffer = true

	Response.Write("<div style='padding-top:25px;'>")
	Response.Write("<table id='waiting' height='90%' width='100%'" )
	Response.Write("style='position:absolute; visibility:hidden'> ")
	Response.Write("<tr><td align=""center"" style='font-size:9pt; background:#FFFFFF;'>")
	Response.Write("<img src=""/images_kr/159.gif"" width=""128"" height=""128"" alt="""" /><br>")
	Response.Write("<center><span style=""color:black"">Data Loading<br />"&LNG_TEXT_TAKE_TIME_TO_LOAD&"</span></center>")
	Response.Write("</td></tr></table></div> ")

	Response.Write("<script type=""text/javascript""> ")
	Response.Write("waiting.style.visibility='visible' ")
	Response.Write("</script>")
	Response.Flush() '여기까지의 내용을 일단 Flush

%>
<ul id="org" style="display:none">
<%

'	DK_MEMBER_ID1 = "00"s
'	DK_MEMBER_ID2 = 10001

	If cLvl = "" Then cLvl = 2		'default 대수
	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,SDK_MEMBER_ID2),_
		Db.makeParam("@DEPTH",adInteger,adParamInput,0,cLvl),_
		Db.makeParam("@SDATE",adVarChar,adParamInput,20,toStartDate) ,_
		Db.makeParam("@EDATE",adVarChar,adParamInput,20,toEndDate) _
	)
	arrList = Db.execRsList("DKP_TREE_VOTER_DETAIL_NEW",DB_PROC,arrParams,listLen,DB3)


Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
	objEncrypter.Key = con_EncryptKey
	objEncrypter.InitialVector = con_EncryptKeyIV
	If IsArray(arrList) Then
		thisLevel = 0
		prevLevel = 0

		CHKBOX_CNT =  CInt(cGrade) + CInt(cCenter) + CInt(cPeriodPV) + CInt(cPeriodCV)

		If CHKBOX_CNT = 0 Then C_HEIGHT = 0
		If CHKBOX_CNT = 1 Then C_HEIGHT = 1
		If CHKBOX_CNT = 2 Then C_HEIGHT = 2
		If CHKBOX_CNT = 3 Then C_HEIGHT = 3
		If CHKBOX_CNT = 4 Then C_HEIGHT = 4
		If CHKBOX_CNT = 5 Then C_HEIGHT = 5
		If CHKBOX_CNT = 6 Then C_HEIGHT = 6
		If CHKBOX_CNT = 7 Then C_HEIGHT = 7
		If CHKBOX_CNT = 8 Then C_HEIGHT = 8


		For i = 0 To listLen

			TrID = arrList(0,i)&arrList(1,i)
			PaID = arrList(7,i)&arrList(8,i)	'추천인아이디

'			viewIcons = viewImg(IMG_ICON&"/person.jpg",40,55,"")
			viewIcons = viewImg(IMG_ICON&"/satOnBlue.gif",46,48,"")
			'viewIcons2 = viewImg(IMG_ICON&"/satOnGreen.gif",36,38,"")

			If arrList(9,i) = 1 Then
				'leaveCheck = "정상회원"
				liClass = ""
			Else
				'leaveCheck = "<span class=""tweight"">탈퇴</span>"
				liClass = "class=""bgs"""
			End If

			ThisName = Replace(Replace(Replace(Replace(arrList(2,i),vbcrlf, ""),Chr(13)&Chr(10),""),Chr(13),""),Chr(10),"")

			arr_WebID =	arrList(16,i)
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
					If arr_WebID <> "" Then arr_WebID	= objEncrypter.Decrypt(arr_WebID)
				On Error GoTo 0
			Set objEncrypter = Nothing

			If i = 0 Then
				PRINT "<li class=""fnodeTop"&C_HEIGHT&" tweight"">"
				PRINT "<p "&liClass&"><a href=""?sid1="&arrList(7,i)&"&amp;sid2="&arrList(8,i)&"&amp;toStartDate="&toStartDate&"&amp;toEndDate="&toEndDate&""">"&LNG_TEXT_TREE_TOP&"</a></p>"
				'PRINT "<p "&liClass&">"&viewIcons&"</p>"
				PRINT "<p "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</a></p>"
				PRINT "<p "&liClass&" class=""blue2"">"&LNG_TEXT_NAME&" : "&ThisName&"("&arrList(4,i)&")"&"</p>"
				'PRINT "<p "&liClass&">"&arr_WebID&"</p>"
				'PRINT "<p "&liClass&" class=""blue2"" style=""height:13px;""><!-- "&LNG_TEXT_ID&" :  -->"&objEncrypter.Decrypt(arrList(16,i))&"</p>"
				PRINT "<p "&liClass&">"&LNG_TEXT_REGTIME&" : "&date8to13(arrList(6,i))&"</p>"
				If cGrade	 = "1" Then
					PRINT "<p "&liClass&" class=""green2"">"&LNG_TEXT_POSITION&" : "&arrList(13,i)&"</p>"
				End If
				If cCenter	 = "1" Then
					PRINT "<p "&liClass&">"&LNG_TEXT_CENTER&" :  "&arrList(14,i)&"</p>"
				End If
				If cPeriodPV = "1" Then
					'PRINT "<p "&liClass&">"&LNG_TEXT_TREE_MY_PV&" : "&num2cur(arrList(15,i))&"</p>"
					PRINT "<p "&liClass&">"&LNG_TEXT_TREE_MY_PV&" : "&num2curINT(arrList(15,i))&"</p>"
				End If
				PRINT "<ul id=""T"&TrID&"""></ul></li>"
			Else
					innerHTML = "<li class=""fnodeSub"&C_HEIGHT&""">"
					innerHTML = innerHTML & "<p "&liClass&" class=""tweight""><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&"&amp;toStartDate="&toStartDate&"&amp;toEndDate="&toEndDate&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"</a></p>"
				'	innerHTML = innerHTML & "<p "&liClass&">"&viewIcons2&"</p>"
					'innerHTML = innerHTML & "<p "&liClass&"><img src=""/images_kr/icon/satOnGreen.gif"" width=""36"" height=""38"" /></p>"
					innerHTML = innerHTML & "<p "&liClass&" class=""blue2 tweight"">"&LNG_TEXT_NAME&" : "&ThisName&"("&arrList(4,i)&")"&"</p>"
					'innerHTML = innerHTML & "<p "&liClass&" class=""blue2 tweight"" style=""height:13px;""><!-- "&LNG_TEXT_ID&" :  -->"&objEncrypter.Decrypt(arrList(16,i))&"</p>"
					'innerHTML = innerHTML & "<p "&liClass&">"&arr_WebID&"</p>"
					innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_REGTIME&" : "&date8to13(arrList(6,i))&"</p>"
					If cGrade	 = "1" Then
						innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_POSITION&" : "&arrList(13,i)&"</p>"
					End If
					If cCenter	 = "1" Then
						innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_CENTER&" :"&(arrList(14,i))&"</p>"
					End If
					If cPeriodPV = "1" Then
						'innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_TREE_MY_PV&" : "&num2cur(arrList(15,i))&"</p>"
						innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_TREE_MY_PV&" : "&num2curINT(arrList(15,i))&"</p>"
					End If
					innerHTML = innerHTML & "<ul id=""T"&TrID&"""></ul></li>"
					trees = trees & "$(""#T"&PaID&""").append('"&innerHTML&"');"&VbCrlf
			End If
		Next
	End If
	Set objEncrypter = Nothing
%>
</ul>
<div id="chart" class="orgChart"></div>
<script type="text/javascript" language="JScript.Encode" >
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
