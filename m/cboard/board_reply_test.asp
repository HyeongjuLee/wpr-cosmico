<!--#include virtual="/_lib/strFunc.asp"-->
<%
	strBoardName = pRequestTF("strBoardName",True)

	intList = pRequestTF("list",True)
	intDepth = pRequestTF("depth",True)
	intRIDX = pRequestTF("ridx",True)
	intIDX = pRequestTF("intIDX",True)
%>
<!--#include file="board_config.asp"-->
<!--#include virtual = "/m/_include/document.asp"-->
<%
	Select Case DK_MEMBER_TYPE
		Case "MEMBER","GUEST","COMPANY"
			If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
		Case "ADMIN","OPERATOR"

		Case "SADMIN"
			If UCase(DK_MEMBER_GROUP) <> LOCATIONS Then
				If DK_MEMBER_LEVEL < intLevelWrite Then Call ALERTS(LNG_JS_UNAUTHORIZED_WRITE,"back","")
			End If
		Case Else
			Call ALERTS(LNG_JS_MEMBER_LEVEL_NO_EXIST,"back","")
	End Select
%>
<%
	' 게시판 변수 받아오기(설정)
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

%>

<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link href="board.css" rel="stylesheet" type="text/css" />

<!-- <script src="/js/js.js" type="text/javascript"></script> -->
<!-- <script type="text/javascript" src="board.js"></script> -->
<script type="text/javascript" src="check.js"></script>
<script type="text/javascript">
<!--
	 function frmCheck(form){
		<%If (isEditor = "T" And DK_MEMBER_LEVEL >= intEditorLevel) Or (DK_MEMBER_TYPE = "ADMIN" or DK_MEMBER_TYPE = "OPERATOR" OR (DK_MEMBER_TYPE = "SADMIN" And UCase(DK_MEMBER_GROUP) = ucase(LOCATIONS))) Then%>
			oEditors[0].exec("UPDATE_CONTENTS_FIELD", []);
			form.content1.value = document.getElementById("ir1").value;
		<%End If%>
		if(!chkNull(form.strName, "<%=LNG_JS_WRITER%>")) return false;
		if(!chkNull(form.strSubject, "<%=LNG_JS_TITLE%>")) return false;
		<%if DK_MEMBER_LEVEL = 0 THEN%>
			if(!chkNull(form.strPass, "<%=LNG_JS_PASSWORD%>")) return false;
		<%end if%>
		if(!chkNull(form.content1, "<%=LNG_JS_CONTENTS%>")) return false;

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


	$(document).ready(function() {
		$("input:checkbox[name=strNotice]").click(function() {
			//alert($(this).val());
			if ($(this).val() == 'ALL')
			{
				$("input:checkbox[name=strNotice]:not(input:checkbox[id=strNotice_ALL])").attr("checked",false);
				$("input:checkbox[id=strNotice_ALL]").attr("checked",true);
			} else {
				if ($("input:checkbox[name=strNotice]:checkbox[value='ALL']").is(":checked") == true)
				{
					$("input:checkbox[name=strNotice]:checkbox[value='ALL']").attr("checked",false);
				}

			}
		});
	});
	function TagSelect(values) {
		var vals = $("input[name=strTag]").val();
		spl = vals.split(values);
		//alert(spl.length-1);

		if (spl.length-1 > 0)
		{
			$("input[name=strTag]").val(vals.replace(values+",",""));
		} else {
			$("input[name=strTag]").val(vals+values+",");
		}


	}
//-->
</script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
	<div id="board" class="board write reply">
		<div class="sub-title"><%=LNG_BOARD_BTN_WRITE%></div>
		<form name="ifrm" action="boardHandler.asp" method="post" enctype="multipart/form-data" onsubmit="return frmCheck(this)" data-ajax="false">
			<input type="hidden" name="mode" value="REPLY" />
			<input type="hidden" name="strUserID" value="<%=DK_MEMBER_ID%>" />
			<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
			<input type="hidden" name="strDomain" value="m" />
			<input type="hidden" name="intList" value="<%=intList%>" />
			<input type="hidden" name="intDepth" value="<%=intDepth%>" />
			<input type="hidden" name="intRIDX" value="<%=intRIDX%>" />
			<input type="hidden" name="strName" value="<%=DK_MEMBER_NAME%>" />
			<table <%=tableatt%>>
				<col width="22%" />
				<col width="78%" />
				<tbody>
					<tr class="title">
						<th><%=LNG_BOARD_TYPE_BOARD_TEXT02%></th>
						<td><input type="text" name="strSubject" value="RE : <%=backword(DefaultReplySubject)%>" data-theme="w"/></td>
					</tr>
					<%'If DK_MEMBER_ID1 = "" And DK_MEMBER_ID1 = "" Then%>
					
					<tr>
						<th><%=LNG_BOARD_TYPE_BOARD_TEXT12%></th>
						<td><input type="password" name="strPass" value="" class="input_text" style="width:65%;" data-theme="w"/><label><input type="checkbox" name="" /><%=LNG_BOARD_WRITE_TEXT36%></label></td>
					</tr>

					<tr>
						<th rowspan="2"><%=LNG_TEXT_MOBILE%></th>
						<td><input type="text" name="strMobile" value="" class="input_text" style="width:90%;" data-theme="w"/></td>
					</tr>
					<tr>
						<td >
							<p class="red em8">'010-1234-5678'</p>
						</td>
					</tr>
					
					<tr>
						<th colspan="2" class="tcenter" style="padding:10px 4px;"><%=LNG_TEXT_CONTENT%></th>
					</tr><tr>
						<td colspan="2">
						<input type="hidden" name="firstChk" value="T" />
							<textarea name="content1" cols="" rows="" style="width:100%; height:180px;" class="em7" onclick="thisDeChk1();" data-theme="w"><%=backword(defaultWord)%></textarea>
						</td>
					</tr>
					
					<tr>
						<th><%=LNG_JS_FILE1%></th>
						<td><input type="file" name="strData1" class="input_text" style="width:100%" value="" data-theme="w"/><br /> (<%=intData1MB%> <%=LNG_BOARD_WRITE_TEXT16%>)</td>
					</tr>
					
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2" class="tcenter btn_area">
							<input type="submit" class="txtBtn small2 pd7" value="<%=LNG_BOARD_BTN_SAVE%>" />
							<input type="button" class="txtBtn small2 pd7" value="<%=LNG_BOARD_BTN_LIST%>" onclick="history.back(-1);"/>
							<!-- <input type="submit" value="<%=LNG_BOARD_BTN_WRITE%>" style="padding:10px 20px;" data-theme="w"/>
							<input type="button" value="<%=LNG_BOARD_BTN_LIST%>" onclick="history.back(-1);" style="padding:10px 20px;" data-theme="w" /> -->
						</td>
					</tr>
				</tfoot>
			</table>
		</form>
	</div>
</div>

<!--include virtual="/_inc/menuWrapper_hair2.asp"-->
<!--include virtual="/_inc/menuWrapper_hair.asp"-->
<!--include virtual="/_inc/footer.asp"-->

<!--#include virtual = "/m/_include/copyright.asp"-->
</body>
</html>