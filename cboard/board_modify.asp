<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	strBoardName = gRequestTF("bname",True)
	intIDX = gRequestTF("num",True)
%>
<!--#include file = "board_config.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
<link rel="stylesheet" href="css_common.css" />
<link rel="stylesheet" href="/css/board.css?" />
<link rel="stylesheet" href="a_btnCss.css" />
<%

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
		'이미지 1,2,3 추가
		isPic1				= DKRS("isPic1")
		isPic1TF			= DKRS("isPic1TF")
		intPic1MB			= DKRS("intPic1MB")
		isPic2				= DKRS("isPic2")
		isPic2TF			= DKRS("isPic2TF")
		intPic2MB			= DKRS("intPic2MB")
		isPic3				= DKRS("isPic3")
		isPic3TF			= DKRS("isPic3TF")
		intPic3MB			= DKRS("intPic3MB")

		isMovie				= DKRS("isMovie")
		isMovieTF			= DKRS("isMovieTF")

	Else
		Call ALERTS(LNG_TEXT_INCORRECT_BOARD_SETTING,"back","")
	End If
	Call closeRS(DKRS)




	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs("DKP_NBOARD_VIEW",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then

		intCate				= DKRS("intCate")
		intNum				= DKRS("intNum")
		intList				= DKRS("intList")
		intDepth			= DKRS("intDepth")
		intRIDX				= DKRS("intRIDX")
		strDomain			= DKRS("strDomain")
		strUserID			= DKRS("strUserID")
		strName				= DKRS("strName")
		regDate				= DKRS("regDate")
		readCnt				= DKRS("readCnt")
		strSubject			= DKRS("strSubject")
		strContent			= DKRS("strContent")
		strEmail			= DKRS("strEmail")
		strTel				= DKRS("strTel")
		strMobile			= DKRS("strMobile")
		strPass				= DKRS("strPass")
		isSecret			= DKRS("isSecret")
		ostrPic				= DKRS("strPic")
		ostrData1			= DKRS("strData1")
		ostrData2			= DKRS("strData2")
		ostrData3			= DKRS("strData3")
		strLink				= DKRS("strLink")
		strMovie			= DKRS("strMovie")
		editDate			= DKRS("editDate")
		REPLYCNT			= DKRS("REPLYCNT")
		HostIP				= DKRS("HostIP")
		isNotice			= DKRS("isNotice")
		isMainNotice		= DKRS("isMainNotice")

		'이미지 1,2,3 추가
		ostrPic1			= DKRS("strPic1")
		ostrPic2			= DKRS("strPic2")
		ostrPic3			= DKRS("strPic3")

		movieType			= DKRS("movieType")		'추가
		movieURL			= DKRS("movieURL")		'추가

		strHashtag			= DKRS("strHashtag")		'추가

	Else
		Call ALERTS(LNG_TEXT_INCORRECT_BOARD_SETTING,"back","")
	End If
	Call closeRS(DKRS)


	Select Case DK_MEMBER_TYPE
		Case "GUEST"
			If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_BOARD_MODIFY_TEXT01,"back","")
			inputPass = pRequestTF("strPass",True)

			'★password암호화
			Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				On Error Resume Next
				If inputPass	<> "" Then inputPass	= objEncrypter.Encrypt(inputPass)
				On Error GoTo 0
			Set objEncrypter = Nothing

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
			)
			OriPass = Db.execRsData("DKP_NBOARD_CONTENT_GUEST_PASSWORD",DB_PROC,arrParams,Nothing)
			If inputPass <> OriPass Then
				Call ALERTS(LNG_JS_PASSWORD_INCORRECT,"back","")
			End If
		Case "MEMBER","COMPANY"
			If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_BOARD_MODIFY_TEXT01,"back","")
			If UCase(strUserID) <> UCase(DK_MEMBER_ID) Then Call ALERTS(DK_MEMBER_ID & LNG_BOARD_TYPE_BOARD_TEXT10,"BACK","")

		Case "ADMIN","OPERATOR"

		Case "SADMIN"
			If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
				If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_BOARD_MODIFY_TEXT01,"back","")
			End If
		Case Else
			Call ALERTS(LNG_JS_MEMBER_LEVEL_NO_EXIST,"back","")
	End Select







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
			printHostIP = printHostIP&tabs(1)& "		<td><input type=""text"" name=""hostIP"" class=""input_text"" style=""width:350px;"" value="""&HostIP&""" /></td>"
			printHostIP = printHostIP&tabs(1)& "	</tr>" &VbCrlf'
		End If




		printName = ""
		If DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE = "OPERATOR" Then
			printName = printName&tabs(1)& "	<tr>" &VbCrlf
			printName = printName&tabs(1)& "		<th>"&LNG_TEXT_WRITER&"</th>" &VbCrlf
			printName = printName&tabs(1)& "		<td class=""""><input type=""text"" name=""strName"" class=""input_text"" value="""&strName&""" />"

			If strBoardName = "notice" And DK_MEMBER_TYPE = "ADMIN" Then
				printName = printName&tabs(1)& "	<label><input type=""checkbox"" name=""isMainNotice"" id=""isMainNotice"" class=""input_radio"" value=""T""  "&isChecked(isMainNotice,"T")&" /> "&LNG_TEXT_MAIN_NOTICE&"</label>"
			End If

			printName = printName&tabs(1)& "</td>"
			printName = printName&tabs(1)& "	</tr>" &VbCrlf
		Else
			If DK_MEMBER_LEVEL = 0 Then
				printName = printName&tabs(1)& "	<tr>" &VbCrlf
				printName = printName&tabs(1)& "		<th>"&LNG_TEXT_WRITER&"</th>" &VbCrlf
				printName = printName&tabs(1)& "		<td><input type=""text"" name=""strName"" class=""input_text"" value="""&strName&""" /></td>"
				printName = printName&tabs(1)& "	</tr>" &VbCrlf
			Else
				''printName = "<input type=""hidden"" name=""strName"" class=""input_text"" value="""&strName&""" />"
				printName = printName&tabs(1)& "	<tr>" &VbCrlf
				printName = printName&tabs(1)& "		<th>"&LNG_TEXT_WRITER&"</th>" &VbCrlf
				printName = printName&tabs(1)& "		<td><input type=""hidden"" name=""strName"" class=""input_text"" value="""&strName&""" />"&strName&"</td>"
				printName = printName&tabs(1)& "	</tr>" &VbCrlf
			End If
		End If


		printEmail = ""
		If isEmail = "T" Then
			printEmail = printEmail&tabs(2)&"<tr>" &VbCrlf
			printEmail = printEmail&tabs(2)&"	<th>"&LNG_TEXT_EMAIL&"</th>" &VbCrlf
			printEmail = printEmail&tabs(2)&"	<td><input type=""text"" name=""strEmail"" class=""input_text"" style=""width:350px;"" value="""&strEmail&""" /></td>"
			printEmail = printEmail&tabs(2)&"</tr>" &VbCrlf
		End If

		printMobile = ""
		If isMobile = "T" Then
			printMobile = printMobile&tabs(2)&"<tr>" &VbCrlf
			printMobile = printMobile&tabs(2)&"	<th>"&LNG_TEXT_MOBILE&"</th>" &VbCrlf
			printMobile = printMobile&tabs(2)&"	<td><input type=""text"" name=""strMobile"" class=""input_text"" style=""width:350px;"" value="""&strMobile&""" /></td>"
			printMobile = printMobile&tabs(2)&"</tr>" &VbCrlf
		End If

		printTel = ""
		If isTel = "T" Then
			printTel = printTel&tabs(2)&"<tr>" &VbCrlf
			printTel = printTel&tabs(2)&"	<th>"&LNG_TEXT_TEL&"</th>" &VbCrlf
			printTel = printTel&tabs(2)&"	<td><input type=""text"" name=""strTel"" class=""input_text"" style=""width:350px;"" value="""&strTel&""" /></td>"
			printTel = printTel&tabs(2)&"</tr>" &VbCrlf
		End If

		printData1 = ""
		If isData1 = "T" Then
			printData1 = printData1&tabs(2)&"<tr>" &VbCrlf
			printData1 = printData1&tabs(2)&"	<th>"&LNG_TEXT_FILE1&"</th>" &VbCrlf
			printData1 = printData1&tabs(2)&"	<td><input type=""file"" name=""strData1"" class=""input_file"" style=""width:400px"" value="""" /> ("&LNG_BOARD_MODIFY_TEXT15&" : "&intData1MB&" MB)</td>"
			printData1 = printData1&tabs(2)&"</tr>" &VbCrlf
		End If

		printData2 = ""
		If isData2 = "T" Then
			printData2 = printData2&tabs(2)&"<tr>" &VbCrlf
			printData2 = printData2&tabs(2)&"	<th>"&LNG_TEXT_FILE2&"</th>" &VbCrlf
			printData2 = printData2&tabs(2)&"	<td><input type=""file"" name=""strData2"" class=""input_file"" style=""width:400px"" value="""" /> ("&LNG_BOARD_MODIFY_TEXT15&" : "&intData2MB&" MB)</td>"
			printData2 = printData2&tabs(2)&"</tr>" &VbCrlf
		End If


		printData3 = ""
		If isData3 = "T" Then
			printData3 = printData3&tabs(2)&"<tr>" &VbCrlf
			printData3 = printData3&tabs(2)&"	<th>"&LNG_TEXT_FILE3&"</th>" &VbCrlf
			printData3 = printData3&tabs(2)&"	<td><input type=""file"" name=""strData3"" class=""input_file"" style=""width:400px"" value="""" /> ("&LNG_BOARD_MODIFY_TEXT15&" : "&intData3MB&" MB)</td>"
			printData3 = printData3&tabs(2)&"</tr>" &VbCrlf
		End If

		printPic = ""
		If isPic = "T" Then
			printPic = printPic&tabs(2)&"<tr>" &VbCrlf
			printPic = printPic&tabs(2)&"	<th>"&LNG_TEXT_THUMBNAIL&"</th>" &VbCrlf
			printPic = printPic&tabs(2)&"	<td><input type=""file"" name=""strPic"" class=""input_file"" style=""width:400px"" value="""" /> ("&intPicMB&" "&LNG_BOARD_WRITE_TEXT18&")</td>"
			printPic = printPic&tabs(2)&"</tr>" &VbCrlf
		End If

		'이미지1,2,3 추가
		printPic1 = ""
		If isPic1 = "T" Then
			printPic1 = printPic1&tabs(2)&"<tr>" &VbCrlf
			printPic1 = printPic1&tabs(2)&"	<th>"&LNG_TEXT_IMAGE1&"</th>" &VbCrlf
			printPic1 = printPic1&tabs(2)&"	<td><input type=""file"" name=""strPic1"" class=""input_file"" style=""width:400px"" value="""" /> ("&intPic1MB&" "&LNG_BOARD_WRITE_TEXT18&")</td>"
			printPic1 = printPic1&tabs(2)&"</tr>" &VbCrlf
		End If
		printPic2 = ""
		If isPic2 = "T" Then
			printPic2 = printPic2&tabs(2)&"<tr>" &VbCrlf
			printPic2 = printPic2&tabs(2)&"	<th>"&LNG_TEXT_IMAGE1&"</th>" &VbCrlf
			printPic2 = printPic2&tabs(2)&"	<td><input type=""file"" name=""strPic2"" class=""input_file"" style=""width:400px"" value="""" /> ("&intPic2MB&" "&LNG_BOARD_WRITE_TEXT18&")</td>"
			printPic2 = printPic2&tabs(2)&"</tr>" &VbCrlf
		End If
		printPic3 = ""
		If isPic3 = "T" Then
			printPic3 = printPic3&tabs(2)&"<tr>" &VbCrlf
			printPic3 = printPic3&tabs(2)&"	<th>"&LNG_TEXT_IMAGE1&"</th>" &VbCrlf
			printPic3 = printPic3&tabs(2)&"	<td><input type=""file"" name=""strPic3"" class=""input_file"" style=""width:400px"" value="""" /> ("&intPic3MB&" "&LNG_BOARD_WRITE_TEXT18&")</td>"
			printPic3 = printPic3&tabs(2)&"</tr>" &VbCrlf
		End If

		printLink = ""
		If isLink = "T" Then
			If strBoardType = "gallery2" Then '게시판타입 썸네일리스트일경우 strLink → 짧은 설명 대체(2016-03-24)
				printLink = printLink&tabs(2)&"<tr>" &VbCrlf
				printLink = printLink&tabs(2)&"	<th>"&LNG_TEXT_ARTICLE&"</th>" &VbCrlf
				printLink = printLink&tabs(2)&"	<td> <textarea type=""text"" name=""strLink"" class=""input_text"" style=""width:400px;height:70px;"" value=""""  cols=""50"" rows=""10""/>"&BACKWORD(strLink)&"</textarea></td>"
				printLink = printLink&tabs(2)&"</tr>" &VbCrlf
			Else
				printLink = printLink&tabs(2)&"<tr>" &VbCrlf
				printLink = printLink&tabs(2)&"	<th>"&LNG_TEXT_ARTICLE&"</th>" &VbCrlf
				printLink = printLink&tabs(2)&"	<td><input type=""text"" name=""strLink"" class=""input_text"" style=""width:400px"" value="""&strLink&""" /> ("&LNG_BOARD_WRITE_TEXT20&")</td>"
				printLink = printLink&tabs(2)&"</tr>" &VbCrlf
			End If
		End If


		printMovie = ""
		If isMovie = "T" Then
			printMovie = printMovie & "	<tr>"
			printMovie = printMovie & "		<th>"&LNG_TEXT_SELECT_LINK&"</th>"
			printMovie = printMovie & "		<td>"
			printMovie = printMovie & "			<label><input type=""radio"" name=""movieType"" value=""Y"" class=""input_check"" "&isChecked(movieType,"Y")&" /> "&LNG_TEXT_YOUTUBE&"</label>"
			printMovie = printMovie & "			<label style=""margin-left:7px;""><input type=""radio"" name=""movieType"" value=""V"" class=""input_check"" "&isChecked(movieType,"V")&" /> "&LNG_TEXT_VIMEO&"</label>"
			printMovie = printMovie & "		</td>"
			printMovie = printMovie & "	</tr><tr>"
			printMovie = printMovie & "		<th>"&LNG_TEXT_MOVIE_ADDRESS&"</th>"
			printMovie = printMovie & "		<td><input type=""text"" name=""movieURL"" class=""input_text"" style=""width:300px;"" value="""&movieURL&""" />"
			printMovie = printMovie & "		<br /><span style=""line-height:150%;color:#3366ff;"">"&LNG_MOVIE_WRITE_TEXT03_1&"</span>"
			printMovie = printMovie & "		</td>"
			printMovie = printMovie & "	</tr>"

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

			if (!checkPass(form.strPass.value, 6, 20) || !checkEngNum(form.strPass.value)){
				alert("<%=LNG_JS_PASSWORD_FORM_CHECK%>");
				form.strPass.focus();
				return false;
			}
		<%end if%>
		if(!chkNull(form.content1, "<%=LNG_JS_CONTENTS%>")) return false;

			//Editor 공백체크 추가
			let content = document.getElementById("ir1").value;
			content = content.replace(/&nbsp;/gi,"");
			content = content.replace(/<br>/gi,"");
			content = content.replace(/ /gi,"");
			content = content.replace(/<p>/gi,"");
			content = content.replace(/<\/p>/gi, "");
			content = content.replace(/<spanstyle="color:#888;">/gi, "");
			content = content.replace(/<span>/gi, "");
			console.log(content);

			<%
				Select Case strBoardType
					Case "video_pop","sns"
					Case Else
			%>
					if (content == "<p></p>" || content == "" || content == "</span>") {
						alert("<%=LNG_JS_CONTENTS%>");
						return false;
					}
			<%
				End Select
			%>
			<%IF strBoardType <> "video_pop" Then	'팝업동영상X%>
				//if (content == "<p></p>" || content == "" || content == "</span>") {
				//	alert("<%=LNG_JS_CONTENTS%>");
				//	return false;
				//}
			<%End If%>

			if (checkDataImages(form.content1.value)) {
				alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다.");
				return false;
			}

		<%if isEmail = "T" And isEmailTF = "T" then%>	if(!chkNull(form.strEmail, "<%=LNG_JS_EMAIL%>")) return false;<%end if%>
		<%if isEmail = "T" And isEmailTF = "T" then%>	if(!chkMail(form.strEmail, "<%=LNG_JS_EMAIL_CONFIRM%>")) return false;<%end if%>
		<%if isTel = "T" And isTelTF = "T" then%>		if(!chkNull(form.strTel, "<%=LNG_JS_TEL%>")) return false;<%end if%>
		<%if isMobile = "T" And isMobileTF = "T" then%>if(!chkNull(form.strMobile, "<%=LNG_JS_MOBILE%>")) return false;<%end if%>
		<%if isLink = "T" And isLinkTF = "T" then%>	if(!chkNull(form.strLink, "<%=LNG_JS_LINK1%>")) return false;<%end if%>
		<%if isData1 = "T" And isData1TF = "T" then%>	if(!chkNull(form.strData1, "<%=LNG_JS_FILE1%>")) return false;<%end if%>
		<%if isData2 = "T" And isData2TF = "T" then%>	if(!chkNull(form.strData2, "<%=LNG_JS_FILE2%>")) return false;<%end if%>
		<%if isData3 = "T" And isData3TF = "T" then%>	if(!chkNull(form.strData3, "<%=LNG_JS_FILE3%>")) return false;<%end if%>
		// <%if isPic = "T" And isPicTF = "T" then%>		if(!chkNull(form.strPic, "<%=LNG_JS_THUMBNAIL%>")) return false;<%end if%>

			<%IF isPic = "T" THEN%>
				if (form.strPic.value != "") {
					//if (!checkFileName(form.strPic)) return false;
					if (!checkFileExt(form.strPic, "jpg,gif,png", "<%=LNG_JS_IMAGE_UPLOAD_ONLY%>")) return false;
				}
			<%End If%>

			//디자이너스 (모바일)이미지 첨부
			<%IF isPic1 = "T" THEN%>
				if (form.strPic1.value != "") {
					//if (!checkFileName(form.strPic1)) return false;
					if (!checkFileExt(form.strPic1, "jpg,gif,png", "<%=LNG_JS_IMAGE_UPLOAD_ONLY%>")) return false;
				}
			<%End If%>

			<%IF isPic2 = "T" THEN%>
				if (form.strPic2.value != "") {
					//if (!checkFileName(form.strPic2)) return false;
					if (!checkFileExt(form.strPic2, "jpg,gif,png", "<%=LNG_JS_IMAGE_UPLOAD_ONLY%>")) return false;
				}
			<%End If%>

			<%IF isPic3 = "T" THEN%>
				if (form.strPic3.value != "") {
					//if (!checkFileName(form.strPic3)) return false;
					if (!checkFileExt(form.strPic3, "jpg,gif,png", "<%=LNG_JS_IMAGE_UPLOAD_ONLY%>")) return false;
				}
			<%End If%>

			<%IF isMovie = "T" AND isMovieTF = "T" THEN%> //추가
				if(!chkNull(form.movieURL, "<%=LNG_JS_MOVIE_ADDRESS%>")) return false;
			<%END IF%>
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
<div class="board-title"><%=LNG_BOARD_BTN_MODIFY%></div>
<div id="forum" class="board write">
	<form name="frm" action="boardHandler.asp" method="post" enctype="multipart/form-data" onsubmit="return frmCheck(this)">
		<input type="hidden" name="mode" value="UPDATE" />
		<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
		<input type="hidden" name="ostrPic" value="<%=ostrPic%>" />
		<input type="hidden" name="ostrPic1" value="<%=ostrPic1%>" />
		<input type="hidden" name="ostrPic2" value="<%=ostrPic2%>" />
		<input type="hidden" name="ostrPic3" value="<%=ostrPic3%>" />

		<input type="hidden" name="ostrData1" value="<%=ostrData1%>" />
		<input type="hidden" name="ostrData2" value="<%=ostrData2%>" />
		<input type="hidden" name="ostrData3" value="<%=ostrData3%>" />
		<input type="hidden" name="intIDX" value="<%=intIDX%>" />
		<input type="hidden" name="strDomain" value="<%=strDomain%>" />

		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="150" />
				<col width="*" />
			</colgroup>
			<%=printCategory%>
			<tr>
				<th><%=LNG_TEXT_TITLE%></th>
				<td class="">
					<input type="text" name="strSubject" class="input_text" style="width:500px;" value="<%=strSubject%>" />
					<%If strBoardType <> "kin" Then%>
						<label><input type="checkbox" class="input_radio" name="isSecret" id="isSecret" value="T" <%=isChecked("T",isSecret)%> /> <%=LNG_BOARD_WRITE_TEXT36%></label>
					<%End If%>
				</td>
			</tr>
			<%=printName%>
			<%=printPass%>
			<%=printEmail%>
			<%=printTel%>
			<%=printMobile%>
			<%
			'	IF strBoardType = "video_pop" Then		'팝업동영상
			'		contentTD_View = "display:none;"
			'	Else
			'		contentTD_View = ""
			'	End If
			%>
			<%
				Select Case strBoardType
					Case "video_pop","sns"
						contentTD_View = "display:none;"
						strBoardTypeDelete = "T"
					Case Else
						contentTD_View = ""
						strBoardTypeDelete = ""
				End Select
			%>
			<tr>
				<td colspan="2" class="contentTD" style="<%=contentTD_View%>">
					<%If (isEditor = "T" And DK_MEMBER_LEVEL >= intEditorLevel) Or (DK_MEMBER_TYPE = "ADMIN" or DK_MEMBER_TYPE = "OPERATOR") Then%>
						<input type="hidden" id="WYG_MOD" name="WYG_MOD" value="T" />
						<textarea name="content1" id="ir1" style="width:100%;height:450px;min-width:610px;display:none;" cols="50" rows="10"><%=backword(strContent)%></textarea>
						<input type="hidden" name="firstChk" value="F" />
						<%=FN_Print_SmartEditor("ir1","board_content",UCase(DK_MEMBER_NATIONCODE),"","","")%>
					<%Else%>
						<input type="hidden" name="firstChk" value="F" />
						<textarea name="content1" class="input_area lheight160" cols="50" rows="10" onclick="thisDeChk1();"><%=backword_Area(strContent)%></textarea>
					<%End If%>

				</td>
			</tr>
			<%=printLink%>

			<%If strBoardType = "sns" Then%>
			<tr>
				<th>HashTag</th>
				<td><input type="text" name="strHashtag" class="input_text" style="width: 100%" value="<%=strHashtag%>" /></td>
			</tr>
			<%End If%>

			<%=printPic%>
			<%=printData1%>
			<%=printData2%>
			<%=printData3%>

			<%=printPic1%>
			<%=printPic2%>
			<%=printPic3%>


			<%=printMovie%>

			<tr>
				<td colspan="2" class="btn_area">
					<input type="submit" class="button write" value="<%=LNG_BOARD_BTN_SAVE%>" />
					<input type="button" class="button" value="<%=LNG_BOARD_BTN_LIST%>" onclick="history.back(-1);"/>

					<%IF DK_MEMBER_TYPE = "ADMIN" And strBoardTypeDelete = "T" Then	'팝업동영상, SNS%>
					<input type="button" class="button delete" value="<%=LNG_BOARD_BTN_DELETE%>" onclick="javascript:delFrm('<%=intIDX%>');"/>
					<%End If%>

				</td>
			</tr>
		</table>
	</form>
</div>
</div>
<%IF strBoardTypeDelete = "T" Then	'팝업동영상, SNSX%>
	<script>
		function delFrm(idx) {
			var f = document.w_form;
			if (confirm("<%=LNG_JS_DELETE_POST%>")) {
				f.action = 'board_delete.asp';
				f.target = "_self";
				f.submit();
			}
		}
	</script>
	<form name="w_form" method="post" action="">
		<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
		<input type="hidden" name="intIDX" value="<%=intIDX%>" />
		<input type="hidden" name="list" value="<%=intList%>" />
		<input type="hidden" name="depth" value="<%=intDepth%>" />
		<input type="hidden" name="ridx" value="<%=intRIDX%>" />
	</form>
<%End If%>

<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
<%Else%>
<!--#include virtual = "/_include/copyright.asp"-->
<%End If%>
