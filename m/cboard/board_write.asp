<!--#include virtual="/_lib/strFunc.asp"-->
<%
	strBoardName = gRequestTF("bname",True)

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
	Else
		Call ALERTS(LNG_TEXT_INCORRECT_BOARD_SETTING,"back","")
	End If
	Call closeRS(DKRS)


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

%>

<!--#include virtual = "/m/_include/jqueryload.asp"-->
<link href="board.css" rel="stylesheet" type="text/css" />

<!-- <script src="/js/js.js" type="text/javascript"></script> -->
<!-- <script type="text/javascript" src="board.js"></script> -->
<script type="text/javascript" src="check.js"></script>
<script type="text/javascript">
<!--
	 function frmCheck(form){
		/*
		<%'If (isEditor = "T" And DK_MEMBER_LEVEL >= intEditorLevel) Or (DK_MEMBER_TYPE = "ADMIN" or DK_MEMBER_TYPE = "OPERATOR" OR (DK_MEMBER_TYPE = "SADMIN" And UCase(DK_MEMBER_GROUP) = ucase(LOCATIONS))) Then%>
			oEditors[0].exec("UPDATE_CONTENTS_FIELD", []);
			form.content1.value = document.getElementById("ir1").value;
		<%'End If%>
		*/
		if(!chkNull(form.strName, "<%=LNG_JS_WRITER%>")) return false;
		if(!chkNull(form.strSubject, "<%=LNG_JS_TITLE%>")) return false;
		<%if DK_MEMBER_LEVEL = 0 THEN%>
			if(!chkNull(form.strPass, "<%=LNG_JS_PASSWORD%>")) return false;

			if (!checkPass(form.strPass.value, 6, 20) || !checkEngNum(form.strPass.value)){
				alert("<%=LNG_JS_PASSWORD_FORM_CHECK%>");
				form.strPass.focus();
				return false;
			}
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
		<%if isPic = "T" then%>
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



		<%IF Left(strBoardType,5) = "movie" THEN%> //추가
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
		/*
		if (f.firstChk.value == 'T')
		{
			f.firstChk.value = 'F';
			f.content1.value = "";
		}
		*/
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

	var fileNameChange = function(){
		var file = $('tr.file').find('input[type="file"]');
		$('tr.file input[type="file"]').on('change', function(){
			var fileName = $(this).val();
			$(this).parents('td').find('.upload-name').attr('placeholder', fileName);
			//debugger;
		});
	}

	$(function(){
		fileNameChange();
	});

</script>
</head>
<body>
<!--#include virtual = "/m/_include/header.asp"-->
	<div class="board write">
		<div class="sub-title"><%=LNG_BOARD_BTN_WRITE%></div>
		<form name="ifrm" action="boardHandler.asp" method="post" enctype="multipart/form-data" onsubmit="return frmCheck(this)" data-ajax="false">
			<input type="hidden" name="mode" value="INSERT" />
			<input type="hidden" name="strUserID" value="<%=DK_MEMBER_ID%>" />
			<input type="hidden" name="strBoardName" value="<%=strBoardName%>" />
			<input type="hidden" name="strDomain" value="m" />

			<table <%=tableatt%>>
				<col width="22%" />
				<col width="78%" />
				<tbody>
				<%If DK_MEMBER_TYPE = "ADMIN" Or DK_MEMBER_TYPE = "OPERATOR" Then%>
					<tr class="writer admin">
						<th><%=LNG_TEXT_WRITER%></th>
						<td>
							<input type="text" name="strName" value="<%=DK_MEMBER_NAME%>" />
							<%If strBoardName = "notice" And DK_MEMBER_TYPE = "ADMIN" Then '▣ 메인공지%>
								<label><input type="checkbox" name="isMainNotice" value="T" /><i class="icon-ok"></i><span><%=LNG_TEXT_MAIN_NOTICE%></span></label>
							<%End If%>
						</td>
					</tr>
				<%Else%>
					<%If DK_MEMBER_LEVEL = 0 Then%>
						<tr class="writer guest">
							<th><%=LNG_TEXT_WRITER%></th>
							<td>
								<input type="text" name="strName" value="<%=DK_MEMBER_NAME%>" />
							</td>
						</tr>
						<tr class="password guest">
							<th><%=LNG_TEXT_PASSWORD%></th>
							<td>
								<input type="password" name="strPass" value="" placeholder="<%=LNG_JS_PASSWORD%>" />
							</td>
						</tr>
					<%Else%>
						<tr class="writer readonly">
							<th><%=LNG_TEXT_WRITER%></th>
							<td>
								<input type="hidden" name="strName" value="<%=DK_MEMBER_NAME%>" /><%=DK_MEMBER_NAME%>
							</td>
						</tr>
					<%End If%>
				<%End If%>
				<tr class="title">
					<!-- <th><%=LNG_TEXT_TITLE%></th> -->
					<td colspan="2">
						<input type="text" name="strSubject" value="" placeholder="<%=LNG_TEXT_TITLE%>" />
						<label><input type="checkbox" name="isSecret" value="T" /><i class="icon-ok"></i><span><%=LNG_BOARD_WRITE_TEXT36%></span></label>
					</td>
				</tr>
				<%'If DK_MEMBER_ID1 = "" And DK_MEMBER_ID1 = "" Then%>
				<%If DK_MEMBER_LEVEL = 0 Then%>
					<tr class="password">
						<!-- <th><%=LNG_BOARD_TYPE_BOARD_TEXT12%></th> --> <!--비밀번호 입력-->
						<!-- <th><%=LNG_TEXT_PASSWORD%></th> --> <!--비밀번호-->
						<td colspan="2">
							<input type="password" name="strPass" value="" placeholder="<%=LNG_TEXT_PASSWORD%>"/>
							<label><input type="checkbox" name="" /><i class="icon-ok"></i><span><%=LNG_BOARD_WRITE_TEXT36%></span></label>
						</td>
					</tr>
				<%End If%>
				<%If isMobile = "T" Then%>
					<tr class="mobile">
						<!-- <th><%=LNG_TEXT_MOBILE%></th> -->
						<td colspan="2">
							<input type="text" name="strMobile" value="" placeholder="<%=LNG_TEXT_MOBILE%> ex) 010-1234-5678" />
							<!-- <p class="em">'010-1234-5678'</p> -->
						</td>
					</tr>
				<%End If%>
				<tr class="contents">
					<td colspan="2">
						<input type="hidden" name="firstChk" value="T" />
						<!-- <textarea name="content1" cols="" rows="" style="width:98%; height:180px;resize:none;" onclick="thisDeChk1();" ><%=backword(defaultWord)%></textarea> -->
						<!-- <textarea name="content1" cols="" rows="" placeholder="<%=LNG_TEXT_CONTENT%>" onclick="thisDeChk1();" ><%=backword(defaultWord)%></textarea> --> <!--내용-->
						<textarea name="content1" cols="" rows="" placeholder="<%=LNG_JS_CONTENTS%>" onclick="thisDeChk1();" ><%=backword(defaultWord)%></textarea><!--내용을 입력해 주세요.-->
					</td>
				</tr>

				<%If isPic = "T" Then%>
					<tr class="file">
						<th><%=LNG_TEXT_THUMBNAIL%></th>
						<td>
							<div>
								<input class="upload-name" readonly placeholder="<%=intPicMB%> <%=LNG_BOARD_WRITE_TEXT18%>">
								<label>
									<input type="file" name="strPic" value="" />
									<span><%=LNG_1on1_FILE_SEARCH%></span>
								</label>
							</div>
							<!-- <p>(<%=intPicMB%> <%=LNG_BOARD_WRITE_TEXT18%>)</p> -->
						</td>
					</tr>
				<%End If%>

				<%If isData1 = "T" Then%>
					<tr class="file">
						<th><%=LNG_TEXT_FILE1%></th>
						<td>
							<div>
								<input class="upload-name" readonly placeholder="<%=intData1MB%> MB↓">
								<label>
									<input type="file" name="strData1" value="" />
									<span><%=LNG_1on1_FILE_SEARCH%></span>
								</label>
							</div>
							<!-- <p>(<%=intData1MB%> MB↓)</p> -->
						</td>
					</tr>
				<%End If%>
				<%If isData2 = "T" Then%>
					<tr class="file">
						<th><%=LNG_TEXT_FILE2%></th>
						<td>
							<div>
								<input class="upload-name" readonly placeholder="<%=intData2MB%> MB↓">
								<label>
									<input type="file" name="strData2" value="" />
									<span><%=LNG_1on1_FILE_SEARCH%></span>
								</label>
							</div>
							<!-- <p>(<%=intData2MB%> MB↓)</p> -->
						</td>
					</tr>
				<%End If%>
				<%If isData3 = "T" Then%>
					<tr class="file">
						<th><%=LNG_TEXT_FILE3%></th>
						<td>
							<div>
								<input class="upload-name" readonly placeholder="<%=intData3MB%> MB↓">
								<label>
									<input type="file" name="strData3" value="" />
									<span><%=LNG_1on1_FILE_SEARCH%></span>
								</label>
							</div>
							<!-- <p>(<%=intData3MB%> MB↓)</p> -->
						</td>
					</tr>
				<%End If%>

				<%If isPic1 = "T" Then%>
					<tr class="file">
						<th><%=LNG_TEXT_IMAGE1%></th>
						<td>
							<div>
								<input class="upload-name" readonly placeholder="<%=intPic1MB%> MB↓">
								<label>
									<input type="file" name="strPic1" value="" />
									<span><%=LNG_1on1_FILE_SEARCH%></span>
								</label>
							</div>
							<!-- <p>(<%=intPic1MB%> MB↓)</p> -->
						</td>
					</tr>
				<%End If%>
				<%If isPic2 = "T" Then%>
					<tr class="file">
						<th><%=LNG_TEXT_IMAGE2%></th>
						<td>
							<div>
								<input class="upload-name" readonly placeholder="<%=intPic2MB%> MB↓">
								<label>
									<input type="file" name="strPic2" value="" />
									<span><%=LNG_1on1_FILE_SEARCH%></span>
								</label>
							</div>
							<!-- <p>(<%=intPic2MB%> MB↓)</p> -->
						</td>
					</tr>
				<%End If%>
				<%If isPic3 = "T" Then%>
					<tr class="file">
						<th><%=LNG_TEXT_IMAGE3%></th>
						<td>
							<div>
								<input class="upload-name" readonly placeholder="<%=intPic3MB%> MB↓">
								<label>
									<input type="file" name="strPic3" value="" />
									<span><%=LNG_1on1_FILE_SEARCH%></span>
								</label>
							</div>
							<!-- <p>(<%=intPic3MB%> MB↓)</p> -->
						</td>
					</tr>
				<%End If%>

				<%If Left(strBoardType,5) = "movie" Then '동영상 추가%>
					<tr class="movie">
						<th><%=LNG_TEXT_SELECT_LINK%></th>
						<td>
							<label><input type="radio" name="movieType" value="Y" checked="checked" /><i class="icon-ok"></i><span><%=LNG_TEXT_YOUTUBE%></span></label>
							<label><input type="radio" name="movieType" value="V"/><i class="icon-ok"></i><span><%=LNG_TEXT_VIMEO%></span></label>
						</td>
					</tr>
					<tr class="movie">
						<th><%=LNG_TEXT_MOVIE_ADDRESS%></th>
						<td><input type="text" name="movieURL" value="" placeholder="" />
							<p><%=LNG_MOVIE_WRITE_TEXT03_1%></p>
						</td>
					</tr>
				<%End If%>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="2">
							<input type="submit" class="button admin" value="<%=LNG_BOARD_BTN_WRITE%>" />
							<input type="button" class="button" value="<%=LNG_BOARD_BTN_LIST%>" onclick="history.back(-1);"/>
							<!-- <input type="submit" value="<%=LNG_BOARD_BTN_WRITE%>" style="padding:10px 20px;" />
							<input type="button" value="<%=LNG_BOARD_BTN_LIST%>" onclick="history.back(-1);" style="padding:10px 20px;"  /> -->
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