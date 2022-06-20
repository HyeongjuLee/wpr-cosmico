<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%
	strBoardName = gRequestTF("bname",True)
%>
<!--#include file = "board_config.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
<link rel="stylesheet" href="css_common.css" />
<link rel="stylesheet" href="/css/board.css?v0" />
<script type="text/javascript" src="/jscript/daterangepicker/moment-with-locales.js"></script>

<script type="text/javascript" src="/jscript/daterangepicker/daterangepicker.js"></script>
<link rel="stylesheet" type="text/css" href="/jscript/daterangepicker/daterangepicker.css" />
<%


	Select Case DK_MEMBER_TYPE
		Case "GUEST"
			If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
		Case "MEMBER","COMPANY"
			If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
			If LCase(strBoardType) = "kin" Then
				If NB_intWriteLimit > 0 Then Call FN_CHECK_BOARD_WRITE_COUNT_KIN(strBoardName,DK_MEMBER_ID,NB_intWriteLimit,"A","0")
			Else
				If NB_intWriteLimit > 0 Then Call FN_CHECK_BOARD_WRITE_COUNT(strBoardName,DK_MEMBER_ID,NB_intWriteLimit,"A")
			End If
		Case "ADMIN","OPERATOR"

		Case "SADMIN"
			If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
				If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
			End If
		Case Else
			Call ALERTS(LNG_JS_MEMBER_LEVEL_NO_EXIST,"back","")
	End Select

'	If DK_MEMBER_LEVEL < intLevelWrite And (DK_MEMBER_TYPE <> "ADMIN" Or DK_MEMBER_TYPE = "OPERATOR") And DK_MEMBER_TYPE <> "ORERATOR") Then Call ALERTS("게시판작성 권한이 없습니다. 관리자에게 문의해주세요.","back","")




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
		intContentMinLimit	= DKRS("intContentMinLimit")
		intReplyMinLimit	= DKRS("intReplyMinLimit")
	Else
		Call ALERTS(LNG_TEXT_INCORRECT_BOARD_SETTING,"back","")
	End If
	Call closeRS(DKRS)


	'defaultWord1 = "<span style=""color:#888;"">"&defaultWord&"</span>"
	defaultWord1 = defaultWord
	defaultWord2 = defaultWord


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
			printName = printName&tabs(1)& "		<td><input type=""text"" name=""strName"" class=""input_text"" value="""&DK_MEMBER_NAME&""" />"

			If strBoardName = "notice" And DK_MEMBER_TYPE = "ADMIN" Then '▣ 메인공지
				printName = printName&tabs(1)& "	<label><input type=""checkbox"" name=""isMainNotice"" class=""input_radio"" value=""T"" /> "&LNG_TEXT_MAIN_NOTICE&"</label>"
			End If

			printName = printName&tabs(1)& "</td>"
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
			ElseIf DK_MEMBER_LEVEL > 0 Then
				printName = printName&tabs(1)& "	<tr>" &VbCrlf
				printName = printName&tabs(1)& "		<th>"&LNG_TEXT_WRITER&"</th>" &VbCrlf
				printName = printName&tabs(1)& "		<td><input type=""hidden"" name=""strName"" class=""input_text"" value="""&DK_MEMBER_NAME&""" />"&DK_MEMBER_NAME&"</td>"
				printName = printName&tabs(1)& "	</tr>" &VbCrlf

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
			printMobile = printMobile&tabs(2)&"<tr>" &VbCrlf
			printMobile = printMobile&tabs(2)&"	<th rowspan=""2"">"&LNG_TEXT_MOBILE&"</th>" &VbCrlf
			printMobile = printMobile&tabs(2)&"	<td style=""padding:3px 0px 3px 10px;""><input type=""text"" name=""strMobile"" class=""input_text"" style=""width:350px;"" value="""&nb_strMobile&""" /> '010-1234-5678' </td>"
			printMobile = printMobile&tabs(2)&"</tr><tr>" &VbCrlf
			printMobile = printMobile&tabs(2)&"	<td class=""lheight160 font_dotum8"">"&LNG_BOARD_WRITE_TEXT12&"</td>" &VbCrlf
			printMobile = printMobile&tabs(2)&"</tr>" &VbCrlf
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
			printData3 = printData3&tabs(2)&"	<td><input type=""file"" name=""strData3"" class=""input_file"" style=""width:400px"" value="""" /> ("&intData3MB&" MB↓)</td>"
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
			printPic2 = printPic2&tabs(2)&"	<th>"&LNG_TEXT_IMAGE2&"</th>" &VbCrlf
			printPic2 = printPic2&tabs(2)&"	<td><input type=""file"" name=""strPic2"" class=""input_file"" style=""width:400px"" value="""" /> ("&intPic2MB&" "&LNG_BOARD_WRITE_TEXT18&")</td>"
			printPic2 = printPic2&tabs(2)&"</tr>" &VbCrlf
		End If
		printPic3 = ""
		If isPic3 = "T" Then
			printPic3 = printPic3&tabs(2)&"<tr>" &VbCrlf
			printPic3 = printPic3&tabs(2)&"	<th>"&LNG_TEXT_IMAGE3&"</th>" &VbCrlf
			printPic3 = printPic3&tabs(2)&"	<td><input type=""file"" name=""strPic3"" class=""input_file"" style=""width:400px"" value="""" /> ("&intPic3MB&" "&LNG_BOARD_WRITE_TEXT18&")</td>"
			printPic3 = printPic3&tabs(2)&"</tr>" &VbCrlf
		End If

		printLink = ""
		If isLink = "T" Then
			If strBoardType = "gallery2" Then '게시판타입 썸네일리스트일경우 strLink → 짧은 설명 대체(2016-03-24)
				printLink = printLink&tabs(2)&"<tr>" &VbCrlf
				printLink = printLink&tabs(2)&"	<th>"&LNG_MOVIE_WRITE_TEXT05&"</th>" &VbCrlf
				printLink = printLink&tabs(2)&"	<td><textarea type=""text"" name=""strLink"" class=""input_text"" style=""width:400px;height:70px;"" value=""""  cols=""50"" rows=""10"" /></textarea></td>"
				printLink = printLink&tabs(2)&"</tr>" &VbCrlf
			Else
				printLink = printLink&tabs(2)&"<tr>" &VbCrlf
				printLink = printLink&tabs(2)&"	<th>"&LNG_TEXT_ARTICLE&"</th>" &VbCrlf
				printLink = printLink&tabs(2)&"	<td><input type=""text"" name=""strLink"" class=""input_text"" style=""width:400px"" value="""" /> ("&LNG_BOARD_WRITE_TEXT20&")</td>"
				printLink = printLink&tabs(2)&"</tr>" &VbCrlf
			End If
		End If


		printMovie = ""
		If isMovie = "T" Then
			printMovie = printMovie & "	<tr>"
			printMovie = printMovie & "		<th>"&LNG_TEXT_SELECT_LINK&"</th>"
			printMovie = printMovie & "		<td>"
			printMovie = printMovie & "			<label><input type=""radio"" name=""movieType"" value=""Y"" class=""input_check"" checked=""checked"" /> "&LNG_TEXT_YOUTUBE&"</label>"
			printMovie = printMovie & "			<label style=""margin-left:7px;""><input type=""radio"" name=""movieType"" value=""V"" class=""input_check""/> "&LNG_TEXT_VIMEO&"</label>"
			printMovie = printMovie & "		</td>"
			printMovie = printMovie & "	</tr><tr>"
			printMovie = printMovie & "		<th>"&LNG_TEXT_MOVIE_ADDRESS&"</th>"
			printMovie = printMovie & "		<td><input type=""text"" name=""movieURL"" class=""input_text"" style=""width:300px;"" value="""" />"
			printMovie = printMovie & "		<br /><span style=""line-height:150%;color:#3366ff;"">"&LNG_MOVIE_WRITE_TEXT03_1&"</span>"
			printMovie = printMovie & "		</td>"
			printMovie = printMovie & "	</tr>"

		End If


		printLimitDate = ""
		If NB_isReplyLimitDate = "T" Then
			printLimitDate = printLimitDate& "	<tr>"
			printLimitDate = printLimitDate& "		<th>"&LNG_TEXT_REPLY_DATE_LIMIT&"</th>"
			printLimitDate = printLimitDate& "		<td>"
			printLimitDate = printLimitDate& "		<input type=""text"" name=""strReplyDateS"" id=""Pick_SDATE"" class=""input_text radiusL tcenter"" style=""width:120px;"" readonly=""readonly"" /><span class=""dateBoth"">~" & _
											 "</span><input type=""text"" name=""strReplyDateE"" id=""Pick_EDATE"" class=""input_text radiusR tcenter"" style=""width:120px;"" readonly=""readonly"" />"
			printLimitDate = printLimitDate& "		"
			printLimitDate = printLimitDate& "		<input type=""button"" class=""button save"" value=""일자초기화"" onclick=""ResetDate();"" /> (미입력시 제한 없음)"
			printLimitDate = printLimitDate& "		</td>"
			printLimitDate = printLimitDate& "</tr>"

		End If



		'If DK_MEMBER_TYPE <> "ADMIN" AND DK_MEMBER_TYPE <> "OPERATOR" Then
		'	BLOCK_WRITER_NAME = Db.execRsData("DKP_NBOARD_BLOCK_WRITER",DB_PROC,Nothing,Nothing)

		'	ARRAY_BLOCK_WRITER_NAME = Split(BLOCK_WRITER_NAME,",")
		'	JS_BLOCK_WRITER_NAME = ""
		'	For b = 0 To UBound(ARRAY_BLOCK_WRITER_NAME)
		'		If b = 0 Then
		'			JS_BLOCK_WRITER_NAME = JS_BLOCK_WRITER_NAME &" """&ARRAY_BLOCK_WRITER_NAME(b)&""" "
		'		Else
		'			JS_BLOCK_WRITER_NAME = JS_BLOCK_WRITER_NAME &" ,"""&ARRAY_BLOCK_WRITER_NAME(b)&""" "
		'		End If
		'	Next
		'End If


%>
<%=CONST_SmartEditor_JS%>
<script type="text/javascript">
<!--
	function ResetDate() {
		var f = document.frm;
		f.strReplyDateS.value = '';
		f.strReplyDateE.value = '';
	}


	function frmCheck(form){
		<%If (isEditor = "T" And DK_MEMBER_LEVEL >= intEditorLevel) Or (DK_MEMBER_TYPE = "ADMIN" or DK_MEMBER_TYPE = "OPERATOR") Then%>
			//oEditors[0].exec("UPDATE_CONTENTS_FIELD", []);
			oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.
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
			//console.log(content);

			if (content == "<p></p>" || content == "" || content == "</span>")
			{
				alert("<%=LNG_JS_CONTENTS%>");
				return false;
			}

			if (checkDataImages(form.content1.value)) {
				alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다.");
				return false;
			}

		/* 최저 글자수 확인 S */
			<%IF intContentMinLimit > 0 THEN%>
			chkTextMin = form.content1.value.replace(/(<([^>]+)>)/ig,"");
			var chkTextCnt = chkTextMin.length;
			if (chkTextCnt < <%=intContentMinLimit%>) {
				alert("해당 게시판의 입력 최저 글자수는 "+<%=intContentMinLimit%>+"글자 입니다\n현재 입력된 글자수는 "+chkTextCnt+"글자 입니다.");
				return false;
			}
			//return false;
			<%END IF%>
		/* 최저 글자수 확인 E */
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
		<%IF isPic = "T" THEN%>
			if (form.strPic.value != "") {
				//if (!checkFileName(form.strPic)) return false;
				if (!checkFileExt(form.strPic, "jpg,gif,png", "<%=LNG_JS_IMAGE_UPLOAD_ONLY%>")) return false;
			}
		<%End If%>

		//디자이너스 (모바일)이미지 첨부
		<%if isPic1 = "T" And isPic1TF = "T" then%>		if(!chkNull(form.strPic1, "<%=LNG_JS_IMAGE1%>")) return false;<%end if%>
		<%IF isPic1 = "T" THEN%>
			if (form.strPic1.value != "") {
				//if (!checkFileName(form.strPic1)) return false;
				if (!checkFileExt(form.strPic1, "jpg,gif,png", "<%=LNG_JS_IMAGE_UPLOAD_ONLY%>")) return false;
			}
		<%End If%>

		<%if isPic2 = "T" And isPic2TF = "T" then%>		if(!chkNull(form.strPic2, "<%=LNG_JS_IMAGE2%>")) return false;<%end if%>
		<%IF isPic2 = "T" THEN%>
			if (form.strPic2.value != "") {
				//if (!checkFileName(form.strPic2)) return false;
				if (!checkFileExt(form.strPic2, "jpg,gif,png", "<%=LNG_JS_IMAGE_UPLOAD_ONLY%>")) return false;
			}
		<%End If%>

		<%if isPic3 = "T" And isPic3TF = "T" then%>		if(!chkNull(form.strPic3, "<%=LNG_JS_IMAGE2%>")) return false;<%end if%>
		<%IF isPic3 = "T" THEN%>
			if (form.strPic3.value != "") {
				//if (!checkFileName(form.strPic3)) return false;
				if (!checkFileExt(form.strPic3, "jpg,gif,png", "<%=LNG_JS_IMAGE_UPLOAD_ONLY%>")) return false;
			}
		<%End If%>
		<%if NB_isReplyLimitDate = "T" then%>
			if ((form.strReplyDateS.value != '' && form.strReplyDateE.value == '') || ((form.strReplyDateS.value == '' && form.strReplyDateE.value != '')))
			{
				alert('댓글허용일자선택은 시작일과 종료일 모두를 선택해야합니다');
				return false;
			}
		<%end if%>
		<%IF isMovie = "T" AND isMovieTF = "T" THEN%> //추가
			if(!chkNull(form.movieURL, "<%=LNG_JS_MOVIE_ADDRESS%>")) return false;
		<%END IF%>
		<%if DK_MEMBER_TYPE <> "ADMIN" AND DK_MEMBER_TYPE <> "OPERATOR" THEN%>
		var word = form.strName.value;

		// 금칙어 적용
		var swear_words_arr = new Array(<%=trim(JS_BLOCK_WRITER_NAME)%>);
		orgword = word.toLowerCase();
		awdrgy = 0;
		while (awdrgy <= swear_words_arr.length - 1) {
			if (orgword.indexOf(swear_words_arr[awdrgy]) > -1) {
				alert(swear_words_arr[awdrgy] + "<%=LNG_BOARD_WRITE_TEXT34%>.");
				form.strName.focus();
				return false;
			}
		awdrgy++;
		}

		<%END IF%>
	}
	function thisDeChk1() {
		var f = document.frm;
		if (f.firstChk.value == 'T') {
			f.firstChk.value = 'F';
			f.content1.value = "";
		}
	}

	function thisDeChk2() {
		var f = document.frm;
		if (f.firstChk.value == 'T') {
			f.firstChk.value = 'F';
			document.getElementById("ir1").value = "";
		}
	}



	$(document).ready(function() {
		if($('#Pick_SDATE, #Pick_EDATE').length){
			var currentDate = moment().format("YYYY-MM-DD");

			$('#Pick_SDATE, #Pick_EDATE').daterangepicker({
				locale: {
						format: 'YYYY-MM-DD'
				},
				"alwaysShowCalendars": true,
				"minDate": currentDate,
				//"maxDate": moment().add('months', 1),
				autoApply: true,
				autoUpdateInput: false,

			}, function(start, end, label) {
				// console.log("New date range selected: ' + start.format('YYYY-MM-DD') + ' to ' + end.format('YYYY-MM-DD') + ' (predefined range: ' + label + ')");
				// Lets update the fields manually this event fires on selection of range
				var selectedStartDate = start.format('YYYY-MM-DD'); // selected start
				var selectedEndDate = end.format('YYYY-MM-DD'); // selected end

				$checkinInput = $('#Pick_SDATE');
				$checkoutInput = $('#Pick_EDATE');

				// Updating Fields with selected dates
				$checkinInput.val(selectedStartDate);
				$checkoutInput.val(selectedEndDate);

				// Setting the Selection of dates on calender on CHECKOUT FIELD (To get this it must be binded by Ids not Calss)
				var checkOutPicker = $checkoutInput.data('daterangepicker');
				checkOutPicker.setStartDate(selectedStartDate);
				checkOutPicker.setEndDate(selectedEndDate);

				// Setting the Selection of dates on calender on CHECKIN FIELD (To get this it must be binded by Ids not Calss)
				var checkInPicker = $checkinInput.data('daterangepicker');
				checkInPicker.setStartDate(selectedStartDate);
				checkInPicker.setEndDate(selectedEndDate);
			});
		}
	});

//-->
</script>
</head>
<!-- <body <%=mouseLock%>> -->
<body>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/header.asp"-->
<%Else%>
<!--#include virtual = "/_include/header.asp"-->
<%End If%>
<!--#include file = "_inc_board_top.asp" -->

<p><%=ViewTopImg%></p>
<div id="forum" class="board write">
	<form name="frm" action="boardHandler.asp" method="post" enctype="multipart/form-data" onsubmit="return frmCheck(this)">
		<input type="hidden" name="mode" value="INSERT" />
		<input type="hidden" name="strUserID" value="<%=DK_MEMBER_ID%>" />
		<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
		<input type="hidden" name="strDomain" value="<%=LOCATIONS%>" />
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="150" />
				<col width="*" />
			</colgroup>
			<%=printCategory%>
			<%=printName%>

			<tr>
				<th><%=LNG_TEXT_TITLE%></th>
				<td class="">
					<input type="text" name="strSubject" class="input_text vmiddle" style="width:500px;" />
					<%If strBoardType <> "kin" Then%>
						<label><input type="checkbox" class="input_radio" name="isSecret" id="isSecret" value="T" /> <%=LNG_BOARD_WRITE_TEXT36%></label>
					<%End If%>
				</td>
			</tr>
			<%=printLimitDate%>
			<%=printPass%>
			<%=printEmail%>
			<%=printTel%>
			<%=printMobile%>
			<tr>
				<td colspan="2" class="contentTD" >
					<%If (isEditor = "T" And DK_MEMBER_LEVEL >= intEditorLevel) Or (DK_MEMBER_TYPE = "ADMIN" or DK_MEMBER_TYPE = "OPERATOR") Then%>
						<input type="hidden" id="WYG_MOD" name="WYG_MOD" value="T" />
						<textarea name="content1" id="ir1" style="width:100%;height:450px;min-width:610px;display:none;" cols="50" rows="10"><%=defaultWord1%></textarea>
						<input type="hidden" name="firstChk" value="T" />
						<%=FN_Print_SmartEditor("ir1","board_content",UCase(DK_MEMBER_NATIONCODE),"","","")%>
					<%Else%>
						<input type="hidden" name="firstChk" value="T" />
						<textarea name="content1" class="input_area lheight160" style="width:99%; min-height:200px;" onclick="thisDeChk1();"><%=backword(defaultWord2)%></textarea>
					<%End If%>
				</td>
			</tr>
			<%=printLink%>
			<%=printPic%>
			<%=printData1%>
			<%=printData2%>
			<%=printData3%>

			<%=printPic1%>
			<%=printPic2%>
			<%=printPic3%>
			<%=printMovie%>
			<%IF intContentMinLimit > 0 THEN%>
				<tr>
					<td colspan="2" class="tcenter" style="color:#ff0000">해당 게시판은 최소 글자 수(<%=num2cur(intContentMinLimit)%>자) 제한이 있습니다.</td>
				</tr>
			<%End If%>

			<%If strBoardType = "kin" Then%>
			<tr>
				<td colspan="2" class="tcenter" style="color:#ff0000">지식인의 경우에는 게시물 작성 후 수정할 수 없으니 신중히 게시해주세요</td>
			</tr>
			<%End If%>

			<tr>
				<td colspan="2" class="btn_area">
					<input type="submit" class="button write" value="<%=LNG_BOARD_BTN_WRITE%>" />
					<input type="button" class="button" value="<%=LNG_BOARD_BTN_LIST%>" onclick="history.back(-1);"/>
					<!--<input type="submit" class="txtBtn small2 pd7" value="<%=LNG_BOARD_BTN_WRITE%>" />
					<input type="button" class="txtBtn small2 pd7" value="<%=LNG_BOARD_BTN_LIST%>" onclick="history.back(-1);"/>
					<input name="image" type="image" src="./images/btn_blog03.gif" style="width:60px; height:23px;" align="middle"  /> <img src="./images/btn_blog02.gif" width="60" height="23" alt="" onclick="history.back(-1);"  <%=s_cursor%> align="middle" /> -->
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
