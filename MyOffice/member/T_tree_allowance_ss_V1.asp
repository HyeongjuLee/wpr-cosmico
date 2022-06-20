<!--#include virtual = "/_lib/strFunc.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Webpro.kr - <%=LNG_MYOFFICE_CHART_07%></title>
<%

	'Call ALERTS("잘못된 접근입니다..","BACK","")

	Call ONLY_CS_MEMBER_CLOSE()
'	DK_MEMBER_ID1 = "KR"
'	DK_MEMBER_ID2 = "1"

	Dim CATEGORYS1	:	CATEGORYS1 = Request("cate1")
	Dim CATEGORYS2	:	CATEGORYS2 = Request("cate2")


	SDK_MEMBER_ID1 = Request("sid1")
	SDK_MEMBER_ID2 = Request("sid2")
	SDK_MEMBER_ID3 = Request("sid3")


	If CATEGORYS1 = "" Then CATEGORYS1 = 1
	If CATEGORYS2 = "" Then CATEGORYS2 = 1

	If SDK_MEMBER_ID1 = "" Then SDK_MEMBER_ID1 = DK_MEMBER_ID1
	If SDK_MEMBER_ID2 = "" Then SDK_MEMBER_ID2 = DK_MEMBER_ID2
	If SDK_MEMBER_ID3 = "" Then SDK_MEMBER_ID3 = DK_MEMBER_ID3



	arrParams = Array(_
		Db.makeParam("@DK_MEMBER_ID",adVarChar,adParamInput,20,DK_MEMBER_ID1),_
		Db.makeParam("@DK_MEMBER_ID2",adInteger,adParamInput,0,DK_MEMBER_ID2),_
		Db.makeParam("@SDK_MEMBER_ID",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,SDK_MEMBER_ID2)_
	)
	arrChkData = CInt(Db.execRsData("DKP_TREE_CHECK_SUB01",DB_PROC,arrParams,DB3))
'	arrChkData = CInt(Db.execRsData("DKP_TREE_CHECK_SUB",DB_PROC,arrParams,DB3))

	If arrChkData < 1 Then
		Call ALERTS(LNG_JS_NOT_YOUR_UNDERLINE,"BACK","")
		'Call ALERTS(LNG_JS_NO_ORGANIZATION,"close_pop","")
	End If

%>
<script type="text/javascript" src="/jscript/jquery.min.1.7.1.js"></script>
<script type="text/javascript" src="/jscript/Oc.js"></script>
<script type="text/javascript">
<!--

	$(document).ready(function(){
		$('#cate1')
		  .change(function(){
			chg_category();
		  })
		 .change();
	});

	function chg_category() {
		createRequest();
		var url = 'getMaxMBID3.asp';

		mode = "category2";
		cate = $('#cate1').val();
		smbid1 = '<%=SDK_MEMBER_ID1%>'
		smbid2 = '<%=SDK_MEMBER_ID2%>'
		//alert(smbid1);
		//alert(smbid2);
		postParams = "mode=" + mode;
		postParams += "&cate=" + cate;
		postParams += "&smbid1=" + smbid1;
		postParams += "&smbid2=" + smbid2;

		if (cate.length == 0)
		{
			$("#cate2").attr("disabled",true);
			$("#cate2").html("<option value=''><%=LNG_TEXT_CHOOSE_DEGREE%></option>");
		} else {
			request.open("POST",url,true);
			request.onreadystatechange = function ChgContent() {
				if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
					if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
						var newContent = request.responseText;
						$("#cate2").attr("disabled",false);
						$("#cate2").html(newContent);
						$("#cate2").val("<%=CATEGORYS2%>");
						//alert(document.getElementById("innerMask").innerHTML);
					} else {
						alert("ajax error");
					}
				  }
				}
			request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
			request.send(postParams);
			return;
		}
	}

/*
	function submitSearch() {
		var f = document.sfrm;
			f.action = "";
			f.submit();
	}
*/

//-->
</script>
<link rel="stylesheet" href="/myoffice/css/oc.css" />
<style>
	.fleft {float:left;}
	#top_line {display:block; width:100%; position:fixed; z-index:10; top:0px; background-color:#fff;font-family:verdana;  font-weight:bold; line-height:40px; height:40px; background-color:#000; color:#fff;}
	#top_line .span1 {margin-left:20px;font-size:16px;}
	#top_line .span2 {font-size:12px; color:#c3c3c3; margin-left:10px;}
	#top_line .span2 a {color:#c3c3c3;}
	#top_line .span2 a:hover {color:#e5e5e5;}

	.boardTitle {font-size:15px;font-family:malgun gothic;font-weight:bold;}

</style>
</head>
<body>
<div id="top_line">
	<span class="span1"><%=DKCONF_SITE_TITLE%>&nbsp;<%=LNG_MYOFFICE_CHART_08%></span>
	<span class="span2">by <a href="http://www.webpro.kr" target="_blank">WEBPRO</a></span>
	<div class="fleft" style="padding-left:10px;">
		<form name="sfrm" action="T_tree_allowance_ss_V1.asp" method="post">
			<input type="hidden" name="sid1" value="<%=SDK_MEMBER_ID1%>" />
			<input type="hidden" name="sid2" value="<%=SDK_MEMBER_ID2%>" />
			<input type="hidden" name="sid3" value="<%=SDK_MEMBER_ID3%>" />
			<!-- <input type="hidden" name="CATEGORYS1" value="<%=CATEGORYS1%>" />
			<input type="hidden" name="CATEGORYS2" value="<%=CATEGORYS2%>" /> -->
			<%
				'ZJ 각 수당후원 테이블별 존재확인
				arrParams = Array(_
					Db.makeParam("@SDK_MEMBER_ID1",adVarchar,adParamInput,20,DK_MEMBER_ID1) ,_
					Db.makeParam("@SDK_MEMBER_ID2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
				)
				Set DKRS = Db.execRs("HJP_TREE_MAX_SPON_SUB_CHECK",DB_PROC,arrParams,DB3)
				If Not DKRS.BOF And Not DKRS.EOF Then
					RS_SPON_SUB_CHK01 = DKRS(0)
					RS_SPON_SUB_CHK02 = DKRS(1)
					RS_SPON_SUB_CHK03 = DKRS(2)
					RS_SPON_SUB_CHK04 = DKRS(3)
					RS_SPON_SUB_CHK05 = DKRS(4)
				Else
					RS_SPON_SUB_CHK01 = 0
					RS_SPON_SUB_CHK02 = 0
					RS_SPON_SUB_CHK03 = 0
					RS_SPON_SUB_CHK04 = 0
					RS_SPON_SUB_CHK05 = 0
				End If
				Call CloseRS(DKRS)
			%>
			<div id="cheack_area">
				<%=LNG_TEXT_TYPE%>
				<select id="cate1" name="cate1">
					<option value="" ><%=LNG_TEXT_SELECT%></option>
						<%If RS_SPON_SUB_CHK01 > 0 Then%><option value="1" <%=isSelect(CATEGORYS1,1)%>>MT 1</option><%End If%>
						<%If RS_SPON_SUB_CHK02 > 0 Then%><option value="2" <%=isSelect(CATEGORYS1,2)%>>MT 2</option><%End If%>
						<%If RS_SPON_SUB_CHK03 > 0 Then%><option value="3" <%=isSelect(CATEGORYS1,3)%>>MT 3</option><%End If%>
						<%If RS_SPON_SUB_CHK04 > 0 Then%><option value="4" <%=isSelect(CATEGORYS1,4)%>>MT 4</option><%End If%>
						<%If RS_SPON_SUB_CHK05 > 0 Then%><option value="5" <%=isSelect(CATEGORYS1,5)%>>MT 5</option><%End If%>
					<!-- <%For i= 1 To 5 %>
						<option value=<%=i%><%=isSelect(CATEGORYS1,i)%>>MT <%=i%></option>
					<%Next%> -->
				</select>
				<%=LNG_TEXT_DEGREE%>
				<select id="cate2" name="cate2" disabled="disabled" onchange="submitSearch()"><option value=""></option></select>
				<input type="image" src="<%=IMG%>/tree/tree_search2.png" width="70" height="21" class="vmiddle cp" />
			</div>
		</form>
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
	Select Case CATEGORYS1
		Case "1"
			PROCEDURE_NAME = "HJP_ALLOWANCE_SPON_SUB01"
			PRINT_SELLTYPE = "MT-1"
		Case "2"
			PROCEDURE_NAME = "HJP_ALLOWANCE_SPON_SUB02"
			PRINT_SELLTYPE = "MT-2"
		Case "3"
			PROCEDURE_NAME = "HJP_ALLOWANCE_SPON_SUB03"
			PRINT_SELLTYPE = "MT-3"
		Case "4"
			PROCEDURE_NAME = "HJP_ALLOWANCE_SPON_SUB04"
			PRINT_SELLTYPE = "MT-4"
		Case "5"
			PROCEDURE_NAME = "HJP_ALLOWANCE_SPON_SUB05"
			PRINT_SELLTYPE = "MT-5"
			'PROCEDURE_NAME = "HJP_BOARD_CHART_SUB05"
	End Select

	arrParams = Array(_
		Db.makeParam("@mbid1",adVarChar,adParamInput,20,SDK_MEMBER_ID1),_
		Db.makeParam("@mbid2",adInteger,adParamInput,0,SDK_MEMBER_ID2),_
		Db.makeParam("@mbid3",adInteger,adParamInput,0,CATEGORYS2),_
		Db.makeParam("@DEPTH",adInteger,adParamInput,0,5)_
	)
	arrList = Db.execRsList(PROCEDURE_NAME,DB_PROC,arrParams,listLen,DB3)

Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
	objEncrypter.Key = con_EncryptKey
	objEncrypter.InitialVector = con_EncryptKeyIV

	If IsArray(arrList) Then
		thisLevel = 0
		prevLevel = 0
		For i = 0 To listLen
			TrID = arrList(0,i)&arrList(1,i)&arrList(2,i)
			PaID = arrList(4,i)&arrList(5,i)&arrList(6,i)

			'arrList(2,i) = arrList(2,i) - 1

			'WebID
			arrParams = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,arrList(0,i)), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,arrList(1,i)) _
			)
			Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams,DB3)
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_WebID		= DKRS("WebID")
				On Error Resume Next
					'If DKRS_WebID	<> "" Then DKRS_WebID	= objEncrypter.Decrypt(DKRS_WebID)
				On Error GoTo 0
			Else
				'Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
			End If
			Call closeRS(DKRS)

			If i = 0 Then
				PRINT "<li class=""fnodeATop""><p class=""sellType_"&CATEGORYS1&""">"&PRINT_SELLTYPE&"</p><p style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(4,i)&"&amp;sid2="&arrList(5,i)&"&amp;sid3="&arrList(6,i)&"&CATE1="&CATEGORYS1&"&CATE2="&arrList(6,i)&""">"&LNG_TEXT_TREE_TOP&"</a></p>"
				PRINT "<p style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&"&amp;sid3="&arrList(6,i)&"&CATE1="&CATEGORYS1&"&CATE2="&CATEGORYS2&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"-"&arrList(2,i)&"</a></p>"
				'PRINT "<br />"
				'PRINT "<p "&liClass&">"&LNG_TEXT_NAME&" : "&arrList(3,i)&"</p>"
				'PRINT "<p "&liClass&" style=""height:13px;"">"&objEncrypter.Decrypt(arrList(10,i))&"</p>"
				PRINT "<p "&liClass&" style=""height:13px;"">"&DKRS_WebID&"</p>"
				PRINT "<p "&liClass&">"&date8to10(arrList(11,i))&"</p>"
				'PRINT "<p "&liClass&">"&arrList(2,i)&"차</p>"
				PRINT "<ul id=""T"&TrID&"""></ul></li>"
			Else
				innerHTML = "<li class=""fnodeASub""><p class=""sellType_"&CATEGORYS1&""">"&PRINT_SELLTYPE&"</p><p  style=""font-weight:bold;"" "&liClass&"><a href=""?sid1="&arrList(0,i)&"&amp;sid2="&arrList(1,i)&"&amp;sid3="&arrList(2,i)&"&CATE1="&CATEGORYS1&"&CATE2="&arrList(2,i)&""">"&arrList(0,i)&"-"&Fn_MBID2(arrList(1,i))&"-"&arrList(2,i)&"</a></p>"
				'innerHTML = innerHTML & "<br />"
				'innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_NAME&" : "&arrList(3,i)&"</p>"
				'innerHTML = innerHTML & "<p "&liClass&" style=""height:13px;"">"&objEncrypter.Decrypt(arrList(10,i))&"</p>"
				innerHTML = innerHTML & "<p "&liClass&" style=""height:13px;"">"&DKRS_WebID&"</p>"
				innerHTML = innerHTML & "<p "&liClass&">"&date8to10(arrList(11,i))&"</p>"
				'innerHTML = innerHTML & "<p "&liClass&">"&LNG_TEXT_TREE_ROUND&" : "&arrList(2,i)&"차</p>"
				innerHTML = innerHTML & "<ul id=""T"&TrID&"""></ul></li>"
				trees = trees & "$(""#T"&PaID&""").append('"&innerHTML&"');"&VbCrlf
			End If
		Next
	Else
		'	PRINT "<li class=""fnodeATop""><p></p>"
		'	PRINT "<p></p></br>"
		'	PRINT "<p>차수 선택후 검색</p>"
		'	PRINT "<ul id=""T"&TrID&"""></ul></li>"
	End If
Set objEncrypter = Nothing
%>
</ul>
<!-- <div class="boardTitle" style="width:500px;height:20px;margin-top:40px;text-align:center;}"><%=CATEGORYS1%>차보드 - <%=CATEGORYS2%></div> -->
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

