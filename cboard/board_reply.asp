<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	strBoardName = pRequestTF("strBoardName",True)

	intList = pRequestTF("list",True)
	intDepth = pRequestTF("depth",True)
	intRIDX = pRequestTF("ridx",True)
	intIDX = pRequestTF("intIDX",True)

%>
<!--#include file = "board_config.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
<link rel="stylesheet" href="css_common.css" />
<%
	Select Case DK_MEMBER_TYPE
		Case "MEMBER","GUEST","COMPANY"
			If DK_MEMBER_LEVEL < intLevelReply Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
		Case "ADMIN","OPERATOR"

		Case "SADMIN"
			If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
				If DK_MEMBER_LEVEL < intLevelReply Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
			End If
	End Select




	arrParams = Array(_
		Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName) _
	)
	Set DKRS = Db.execRs("DKPA_FORUM_CONFIG_WRITE",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then

		isEditor			= DKRS("isEditor")
		intEditorLevel		= DKRS("intEditorLevel")
		isEmail				= DKRS("isEmail")
		isEmailTF			= DKRS("isEmailTF")
		isMobile			= DKRS("isMobile")
		isMobileTF			= DKRS("isMobileTF")
		isTel				= DKRS("isTel")
		isTelTF				= DKRS("isTelTF")
		isData1				= DKRS("isData1")
		isData1TF			= DKRS("isData1TF")
		intData1MB			= DKRS("intData1MB")
		isData2				= DKRS("isData2")
		isData2TF			= DKRS("isData2TF")
		intData2MB			= DKRS("intData2MB")
		isData3				= DKRS("isData3")
		isData3TF			= DKRS("isData3TF")
		intData3MB			= DKRS("intData3MB")
		isPic				= DKRS("isPic")
		isPicTF				= DKRS("isPicTF")
		intPicMB			= DKRS("intPicMB")
		isLink				= DKRS("isLink")
		isLinkTF			= DKRS("isLinkTF")
		defaultWord			= DKRS("defaultWord")
	Else
		Call ALERTS(LNG_TEXT_INCORRECT_BOARD_SETTING,"back","")
	End If
	Call closeRS(DKRS)


	defaultWord1 = "<span style=""color:#888;"">"&defaultWord&"</span>"
	defaultWord2 = defaultWord


	SQL = "SELECT [strSubject],[strMobile] FROM [DK_NBOARD_CONTENT] WHERE [intIDX] = ?"
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DefaultReplySubject		= DKRS("strSubject")
		DefaultReplyMobile		= DKRS("strMobile")
	End If
	Call closeRS(DKRS)

'	DefaultReplySubject = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)


	' 카테고리 출력 설정
		printCategory = ""
		If isCategoryUse = "T" Then
			arrParams = Array(_
				Db.makeParam("@strBoardName",adVarChar,adParamInput,50,strBoardName), _
				Db.makeParam("@totalCnt",adInteger,adParamOutput,0,0) _
			)
			arrList = Db.execRsList("DKPA_FORUM_WIRTE_CATEGORY",DB_PROC,arrParams,listLen,Nothing)
			CateTotalCnt = arrParams(UBound(arrParams))(4)

			printCategory = ""
			If CateTotalCnt > 0 Then
				printCategory = printCategory&tabs(2)&"<tr>" &VbCrlf
				printCategory = printCategory&tabs(2)&"	<th>"&LNG_TEXT_CATEGORY&"</th>" &VbCrlf
				printCategory = printCategory&tabs(2)&"	<td>" &VbCrlf
				printCategory = printCategory&tabs(2)&"		<select name=""category"" class=""input_select"">" &VbCrlf

				If IsArray(arrList) Then
					For i = 0 To listLen
						printCategory = printCategory&tabs(2)&"			<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
					Next
				End If

				printCategory = printCategory&tabs(2)&"		</select>" &VbCrlf
				printCategory = printCategory&tabs(2)&"	</td>" &VbCrlf
				printCategory = printCategory&tabs(2)&"<tr>" &VbCrlf
			End If
		Else
			printCategory  = ""
		End If



		printHostIP = ""
		If DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE="OPERATOR" Then
			printHostIP = printHostIP&tabs(1)& "	<tr>" &VbCrlf
			printHostIP = printHostIP&tabs(1)& "		<th>"&LNG_TEXT_IP_ADDRESS&"</th>" &VbCrlf
			printHostIP = printHostIP&tabs(1)& "		<td><input type=""text"" name=""hostIP"" class=""input_text"" style=""width:350px;"" value="""&getUserIP()&""" /></td>"
			printHostIP = printHostIP&tabs(1)& "	</tr>" &VbCrlf'
		End If


		printName = ""
		If DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE="OPERATOR" Then
			printName = printName&tabs(1)& "	<tr>" &VbCrlf
			printName = printName&tabs(1)& "		<th>"&LNG_TEXT_WRITER&"</th>" &VbCrlf
			printName = printName&tabs(1)& "		<td><input type=""text"" name=""strName"" class=""input_text"" value="""&DK_MEMBER_NAME&""" /></td>"
			printName = printName&tabs(1)& "	</tr>" &VbCrlf
		Else
			If DK_MEMBER_LEVEL = 0 Then
				printName = printName&tabs(1)& "	<tr>" &VbCrlf
				printName = printName&tabs(1)& "		<th>"&LNG_TEXT_WRITER&"</th>" &VbCrlf
				printName = printName&tabs(1)& "		<td><input type=""text"" name=""strName"" class=""input_text"" value="""" /></td>"
				printName = printName&tabs(1)& "	</tr>" &VbCrlf

				printPass = printPass&tabs(1)& "	<tr>" &VbCrlf
				printPass = printPass&tabs(1)& "		<th>"&LNG_TEXT_PASSWORD&"</th>" &VbCrlf
				printPass = printPass&tabs(1)& "		<td><input type=""password"" name=""strPass"" class=""input_text"" value="""" /></td>"
				printPass = printPass&tabs(1)& "	</tr>" &VbCrlf

			Else
				printName = "<input type=""hidden"" name=""strName"" class=""input_text"" value="""&DK_MEMBER_NAME&""" />"
			End If
		End If




		printEmail = ""
		If isEmail = "T" Then
			printEmail = printEmail&tabs(2)&"<tr>" &VbCrlf
			printEmail = printEmail&tabs(2)&"	<th>"&LNG_TEXT_EMAIL&"</th>" &VbCrlf
			printEmail = printEmail&tabs(2)&"	<td><input type=""text"" name=""strEmail"" class=""input_text"" style=""width:350px;"" value="""&nb_strEmail&""" /></td>"
			printEmail = printEmail&tabs(2)&"</tr>" &VbCrlf
		End If

		printMobile = ""
		If isMobile = "T" Then
			If DK_MEMBER_TYPE="ADMIN" Or DK_MEMBER_TYPE = "OPERATOR" Then
				printMobile = printMobile&tabs(2)&"<tr>" &VbCrlf
				printMobile = printMobile&tabs(2)&"	<th>"&LNG_TEXT_MOBILE&"</th>" &VbCrlf
				printMobile = printMobile&tabs(2)&"	<td><input type=""text"" name=""strMobile"" class=""input_text"" style=""width:350px;"" value="""&DefaultReplyMobile&""" /> 원게시물자의 휴대폰 번호</td>"
				printMobile = printMobile&tabs(2)&"</tr>" &VbCrlf
			Else
				printMobile = printMobile&tabs(2)&"<tr>" &VbCrlf
				printMobile = printMobile&tabs(2)&"	<th>"&LNG_TEXT_MOBILE&"</th>" &VbCrlf
				printMobile = printMobile&tabs(2)&"	<td><input type=""text"" name=""strMobile"" class=""input_text"" style=""width:350px;"" value="""&nb_strMobile&""" /> '010-1234-5678'</td>"
				printMobile = printMobile&tabs(2)&"</tr>" &VbCrlf
			End If
		End If

		printTel = ""
		If isTel = "T" Then
			printTel = printTel&tabs(2)&"<tr>" &VbCrlf
			printTel = printTel&tabs(2)&"	<th>"&LNG_TEXT_TEL&"</th>" &VbCrlf
			printTel = printTel&tabs(2)&"	<td><input type=""text"" name=""strTel"" class=""input_text"" style=""width:350px;"" value="""&nb_strTel&""" /></td>"
			printTel = printTel&tabs(2)&"</tr>" &VbCrlf
		End If

		printData1 = ""
		If isData1 = "T" Then
			printData1 = printData1&tabs(2)&"<tr>" &VbCrlf
			printData1 = printData1&tabs(2)&"	<th>"&LNG_TEXT_FILE1&"</th>" &VbCrlf
			printData1 = printData1&tabs(2)&"	<td><input type=""file"" name=""strData1"" class=""input_file"" style=""width:400px"" value="""" /> ("&intData1MB&" MB↓)</td>"
			printData1 = printData1&tabs(2)&"</tr>" &VbCrlf
		End If

		printData2 = ""
		If isData2 = "T" Then
			printData2 = printData2&tabs(2)&"<tr>" &VbCrlf
			printData2 = printData2&tabs(2)&"	<th>"&LNG_TEXT_FILE2&"</th>" &VbCrlf
			printData2 = printData2&tabs(2)&"	<td><input type=""file"" name=""strData2"" class=""input_file"" style=""width:400px"" value="""" /> ("&intData2MB&" MB↓)</td>"
			printData2 = printData2&tabs(2)&"</tr>" &VbCrlf
		End If


		printData3 = ""
		If isData3 = "T" Then
			printData3 = printData3&tabs(2)&"<tr>" &VbCrlf
			printData3 = printData3&tabs(2)&"	<th>"&LNG_TEXT_FILE3&"</th>" &VbCrlf
			printData3 = printData3&tabs(2)&"	<td><input type=""file"" name=""strData3"" class=""input_file"" style=""width:400px"" value="""" /> ("&intData3MB&" MB )</td>"
			printData3 = printData3&tabs(2)&"</tr>" &VbCrlf
		End If


		printPic = ""
		If isPic = "T" Then
			printPic = printPic&tabs(2)&"<tr>" &VbCrlf
			printPic = printPic&tabs(2)&"	<th>"&LNG_TEXT_THUMBNAIL&"</th>" &VbCrlf
			printPic = printPic&tabs(2)&"	<td><input type=""file"" name=""strPic"" class=""input_file"" style=""width:400px"" value="""" /> ("&intPicMB&" "&LNG_BOARD_WRITE_TEXT18&")</td>"
			printPic = printPic&tabs(2)&"</tr>" &VbCrlf
		End If

		printLink = ""
		If isLink = "T" Then
			printLink = printLink&tabs(2)&"<tr>" &VbCrlf
			printLink = printLink&tabs(2)&"	<th>"&LNG_MOVIE_WRITE_TEXT05&"</th>" &VbCrlf
			printLink = printLink&tabs(2)&"	<td><input type=""text"" name=""strLink"" class=""input_text"" style=""width:400px"" value="""" /> ("&LNG_BOARD_WRITE_TEXT20&")</td>"
			printLink = printLink&tabs(2)&"</tr>" &VbCrlf
		End If


%>
<%=CONST_SmartEditor_JS%>
<script type="text/javascript">
<!--
	 function frmCheck(form){
		<%If (isEditor = "T" And DK_MEMBER_LEVEL >= intEditorLevel) Or (DK_MEMBER_TYPE = "ADMIN" or DK_MEMBER_TYPE = "OPERATOR") Then%>
			oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);
		<%End If%>
		if(!chkNull(form.strSubject, "<%=LNG_JS_TITLE%>")) return false;

		if(!chkNull(form.strName, "<%=LNG_JS_WRITER%>")) return false;
		<%if DK_MEMBER_LEVEL = 0 THEN%>
			if(!chkNull(form.strPass, "<%=LNG_JS_PASSWORD%>")) return false;
		<%end if%>
		if(!chkNull(form.content1, "<%=LNG_JS_CONTENTS%>")) return false;

		if (checkDataImages(form.content1.value)) {
			alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다.");
			return false;
		}

		<%if isEmail = "T" And isEmailTF = "T" then%>	if(!chkNull(form.strEmail, "<%=LNG_JS_EMAIL%>")) return false;<%end if%>
		<%if isEmail = "T" And isEmailTF = "T" then%>	if(!chkMail(form.strEmail, "<%=LNG_JS_EMAIL_CONFIRM%>")) return false;<%end if%>
		<%if isTel = "T" And isTelTF = "T" then%>		if(!chkNull(form.strTel, "<%=LNG_JS_TEL%>")) return false;<%end if%>
		<%if isMobile = "T" And isMobileTF = "T" then%>
			if(!chkNull(form.strMobile, "<%=LNG_JS_MOBILE%>")) return false;
		<%end if%>
		<%if isLink1 = "T" And isLink1TF = "T" then%>	if(!chkNull(form.strLink1, "<%=LNG_JS_LINK1%>")) return false;<%end if%>
		<%if isData1 = "T" And isData1TF = "T" then%>	if(!chkNull(form.strData1, "<%=LNG_JS_FILE1%>")) return false;<%end if%>
		<%if isData2 = "T" And isData2TF = "T" then%>	if(!chkNull(form.strData2, "<%=LNG_JS_FILE2%>")) return false;<%end if%>
		<%if isData3 = "T" And isData3TF = "T" then%>	if(!chkNull(form.strData3, "<%=LNG_JS_FILE3%>")) return false;<%end if%>
		<%if isPic = "T" And isPicTF = "T" then%>		if(!chkNull(form.strPic, "<%=LNG_JS_THUMBNAIL%>")) return false;<%end if%>

	}
	function thisDeChk1() {
		var f = document.frm;

		if (f.firstChk.value == 'T')
		{
			f.firstChk.value = 'F';
			f.content1.value = "";
		}




	}



	function thisDeChk2() {
		var f = document.frm;

		if (f.firstChk.value == 'T')
		{
			f.firstChk.value = 'F';
			document.getElementById("ir1").value = "";
		}



	}
//-->
</script>
<script type="text/javascript" src="/jscript/calendar.js"></script>

</head>
<body>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%Else%>
<!--#include virtual = "/_include/header.asp"-->
<%End If%>
<!--#include file = "_inc_board_top.asp" -->
<!--'include virtual = "/_include/sub_title.asp"-->
<p><%=ViewTopImg%></p>
<div id="forum">
	<form name="frm" action="boardHandler.asp" method="post" enctype="multipart/form-data" onsubmit="return frmCheck(this)">
		<input type="hidden" name="mode" value="REPLY" />
		<input type="hidden" name="strUserID" value="<%=DK_MEMBER_ID%>" />
		<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
		<input type="hidden" name="strDomain" value="<%=LOCATIONS%>" />
		<input type="hidden" name="intList" value="<%=intList%>" />
		<input type="hidden" name="intDepth" value="<%=intDepth%>" />
		<input type="hidden" name="intRIDX" value="<%=intRIDX%>" />
		<table <%=tableatt%> class="userCWidth2 write">
			<colgroup>
				<col width="150" />
				<col width="*" />
			</colgroup>
			<%=printCategory%>
			<tr>
				<th><%=LNG_TEXT_TITLE%></th>
				<td><input type="text" name="strSubject" class="input_text" style="width:500px;" value="RE : <%=backword(DefaultReplySubject)%>"/></td>
			</tr>

			<%=printName%>
			<%=printPass%>
			<%=printEmail%>
			<%=printTel%>
			<%=printMobile%>
			<tr>
				<td colspan="2" class="contentTD">
					<%If (isEditor = "T" And DK_MEMBER_LEVEL >= intEditorLevel) Or (DK_MEMBER_TYPE = "ADMIN" or DK_MEMBER_TYPE = "OPERATOR") Then%>
						<input type="hidden" id="WYG_MOD" name="WYG_MOD" value="T" />
						<textarea name="content1" id="ir1" style="width:100%;height:450px;min-width:610px;display:none;" cols="50" rows="10"><%=backword(defaultWord1)%></textarea>
						<input type="hidden" name="firstChk" value="T" />
						<%=FN_Print_SmartEditor("ir1","board_content",UCase(DK_MEMBER_NATIONCODE),"","","")%>
					<%Else%>
						<input type="hidden" name="firstChk" value="T" />
						<textarea name="content1" class="input_area lheight160" cols="50" rows="10" onclick="thisDeChk1();"><%=backword(defaultWord2)%></textarea>
					<%End If%>

				</td>
			</tr>
			<%=printLink%>
			<%=printPic%>
			<%=printData1%>
			<%=printData2%>
			<%=printData3%>
			<tr>
				<td colspan="2" class="btn_area">

					<input type="submit" class="input_submit design1" value="<%=LNG_BOARD_BTN_SAVE%>" />
					<input type="button" class="input_submit design3" value="<%=LNG_BOARD_BTN_LIST%>" onclick="history.back(-1);"/>
					<!-- <input name="image" type="image" src="./images/btn_bbs03.gif" style="width:59px; height:21px;" align="middle"  /> <img src="./images/btn_bbs02.gif" width="59" height="21" alt="" onclick="history.back(-1);"  <%=s_cursor%> align="middle" /> -->
				</td>
			</tr>
		</table>
	</form>
</div>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
<%Else%>
<!--#include virtual = "/_include/copyright.asp"-->
<%End If%>
