<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	'INFO_MODE = "MANAGE8-2"


	sc_isReply	= Request("sc_isReply")			: If sc_isReply	= "" Then sc_isReply	= ""
	sc_cate1	= Request("sc_cate1")			: If sc_cate1	= "" Then sc_cate1		= ""
	sc_cate2	= Request("sc_cate2")			: If sc_cate2	= "" Then sc_cate2		= ""
	sc_Name		= Request("sc_Name")			: If sc_Name	= "" Then sc_Name		= ""
	sc_ReplyID	= Request("sc_ReplyID")			: If sc_ReplyID	= "" Then sc_ReplyID	= ""
	sc_WebID	= Request("sc_WebID")			: If sc_WebID	= "" Then sc_WebID	= ""
	intIDX		= Request("idx")				: If intIDX = "" Then Call ALERTS("정상적인 접근이 아닙니다","BACK","")

	PAGE = Request("page")						: If PAGE="" Then PAGE = 1 End If

	SC_QUERY = "PAGE="&page
	SC_QUERY = SC_QUERY & "&sc_cate1="&sc_cate1
	SC_QUERY = SC_QUERY & "&sc_cate2="&sc_cate2
	SC_QUERY = SC_QUERY & "&sc_Name="&server.urlencode(sc_Name)
	SC_QUERY = SC_QUERY & "&sc_ReplyID="&server.urlencode(sc_ReplyID)
	SC_QUERY = SC_QUERY & "&sc_WebID="&server.urlencode(sc_WebID)
	SC_QUERY = SC_QUERY & "&sc_isReply="&sc_isReply



	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX),_
		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(viewAdminLangCode)) _
	)
	Set DKRS = Db.execRs("DKSP_COUNSEL_1ON1_VIEW_ADMIN",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX			= DKRS("intIDX")
		DKRS_isDel			= DKRS("isDel")
		DKRS_strCate		= DKRS("strCate")
		DKRS_strUserID		= DKRS("strUserID")
		DKRS_strName		= DKRS("strName")
		DKRS_strEmail		= DKRS("strEmail")
		DKRS_strMobile		= DKRS("strMobile")
		DKRS_strSubject		= DKRS("strSubject")
		DKRS_strContent		= DKRS("strContent")
		DKRS_regDate		= DKRS("regDate")
		DKRS_regIP			= DKRS("regIP")
		DKRS_isSmsSend		= DKRS("isSmsSend")
		DKRS_isMailSend		= DKRS("isMailSend")
		DKRS_isReply		= DKRS("isReply")
		DKRS_repDate		= DKRS("repDate")
		DKRS_strReply		= DKRS("strReply")
		DKRS_strReplyData1	= DKRS("strReplyData1")
		DKRS_strReplyID		= DKRS("strReplyID")
		DKRS_strNation		= DKRS("strNation")
		DKRS_strData1		= DKRS("strData1")
		DKRS_strData2		= DKRS("strData2")
		DKRS_strData3		= DKRS("strData3")
		DKRS_strWebID		= DKRS("strWebID")
		DKRS_memoCnt		= DKRS("memoCnt")


		strDataPath1	= ""
		strDataPath2	= ""
		strDataPath3	= ""
		strReplyDataPath1 = ""


		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If DKRS_strEmail	<> "" Then DKRS_strEmail	= objEncrypter.Decrypt(DKRS_strEmail)
			If DKRS_strMobile	<> "" Then DKRS_strMobile	= objEncrypter.Decrypt(DKRS_strMobile)

		Set objEncrypter = Nothing

		If DKRS_isDel = "T" Then Call ALERTS("삭제된 데이터입니다","GO","1on1_list.asp?PAGE="&PAGE)

		If DKRS_strReply = "" Then

			If UCase(viewAdminLangCode) = "KR" Then
				DKRS_strReply = "안녕하세요. "&DKCONF_SITE_TITLE&"입니다.<br /><br /><br /><br />다른 문의 사항이 있으시면 언제든지 연락주시기 바랍니다.<br /><br />감사합니다."
			Else
				DKRS_strReply = ""
			End If

		End If

		CSID = Split(DKRS_strUserID,"_")
		CSID1 = CSID(1)
		CSID2 = CSID(2)



	Else
		Call ALERTS("데이터가 존재하지 않습니다","GO","1on1_list.asp?PAGE="&PAGE)
	End If
	Call closeRS(DKRS)

%>
<link rel="stylesheet" href="1on1.css" />
<script type="text/javascript">
<!--
	$(document).ready(function() {
		var fileTarget = $('.filebox .upload-hidden');

		fileTarget.on('change', function(){
			if(window.FileReader){ // 파일명 추출
				var filename = $(this)[0].files[0].name;
			} else { // Old IE 파일명 추출
				var filename = $(this).val().split('/').pop().split('\\').pop();
			};
			$(this).siblings('.upload-name').val(filename);
		});



		$("button.commentAdd").click(function(event) {
			event.preventDefault();

			$("#cMode").val('ADD');
			$("#ModalScrollable1").modal('show');

			//setTimeout(function() {$("input[name=sNameSearch]").focus();},500);
		});

		$("button.commentDel").click(function(event) {
			event.preventDefault();
			var idx = $(this).closest("td").find("input[name=delIDX]").val();
			if (confirm('해당 코멘트를 삭제하시겠습니까?'))
			{
				$("#cMode").val('DEL');
				$("#delIDX").val(idx);
				$("form[name=ufrm]").submit();

			}

			//setTimeout(function() {$("input[name=sNameSearch]").focus();},500);
		});

	});




	function chkFrm() {
		var f = document.frm;
		if (confirm('데이터를 저장하시겠습니까?'))
		{
			<%IF DKRS_isReply = "F" THEN%>
			if (f.strReply.value == '')
			{
				alert("답변내용이 등록되지 않았습니다");
				f.strReply.focus();
				return false;
			}
			if ($("input:checkbox[name=isReply]:checked").length > 0)
			{
				if (!confirm('답변완료로 등록하신 경우 답변을 수정할 수 없습니다. 저장하시겠습니까?'))
				{
					return false;
				}
			}
			<%END IF%>
			f.mode.value = 'UPDATE';
			f.submit();
		} else {
			return false;
		}
	}

	function delFrm() {
		var f = document.frm;
		if (confirm('데이터를 삭제하시겠습니까?\n\n삭제후 복원할 수 없습니다'))
		{
			f.mode.value = 'DELETE';
			f.submit();
		}
	}


//-->
</script>
<link rel="stylesheet" type="text/css" href="/modP/bootstrap/bootstrap.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="counseling" class="view">
	<form name="frm" action="1on1_handler.asp" method="post" onsubmit="return chkFrm(this);" enctype="multipart/form-data">
		<input type="hidden" name="sc_isReply" value="<%=sc_isReply%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="sc_cate1" value="<%=sc_cate1%>" />
		<input type="hidden" name="sc_cate2" value="<%=sc_cate2%>" />
		<input type="hidden" name="sc_Name" value="<%=sc_Name%>" />
		<input type="hidden" name="sc_ReplyID" value="<%=sc_ReplyID%>" />
		<input type="hidden" name="sc_WebID" value="<%=sc_WebID%>" />

		<input type="hidden" name="mode" value="UPDATE" />
		<input type="hidden" name="isSmsSend" value="<%=DKRS_isSmsSend%>" />
		<input type="hidden" name="idx" value="<%=DKRS_intIDX%>" />
		<input type="hidden" name="o_strReplyData1" value="<%=DKRS_strReplyData1%>" />

		<%'COSMICO SMS%>
		<input type="hidden" name="strMobile" value="<%=DKRS_strMobile%>" readonly="readonly" />
		<input type="hidden" name="strWebID" value="<%=DKRS_strWebID%>" readonly="readonly" />


		<table <%=tableatt%> class="width100">
			<col width="160" />
			<col width="*" />
			<tr>
				<th class="tdline" colspan="4">질문정보</th>
			</tr>
			<tr>
				<th>제목</th>
				<td><%=BACKWORD(DKRS_strSubject)%></td>
			</tr><tr>
				<th>내용</th>
				<td class="counselContent"><%=BACKWORD_TAG(DKRS_strContent)%></td>
			</tr><tr>
				<th>작성자 / 웹아이디 / CS</th>
				<td><%=DKRS_strName%> / <%=DKRS_strWebID%> / <%=CSID1%>-<%=CSID2%></td>
			</tr><tr>
				<th>이메일 / 연락처</th>
				<td><%=DKRS_strEmail%> / <%=DKRS_strMobile%> </td>
			</tr>
			<tr>
				<th>첨부파일</th>
				<td>
					<%
						If DKRS_strData1 <> "" Then
							strDataSize1 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/counselData1")&"\"&DKRS_strData1) / 1024)
					%>
						<span style="color:#333;" class="tweight"><%=BACKWORD(DKRS_strData1)%></span> <span style="color:#f32000">(<%=num2cur(strDataSize1)%>KB)</span>
						<p style="margin-top:7px;">
						<a href="javascript:fTrans('<%=FN_HR_ENC(DKRS_strData1)%>','<%=FN_HR_ENC("counsel1")%>');">[다운로드]</a>
						<!-- <a href="<%=VIR_PATH("data/data1")%>/<%=DKRS_strData1%>" target="_blank">[바로보기]</a> -->
						</p>
					<%Else%>
					첨부파일 없음
					<%End If%>
				</td>
			</tr>

			<tr>
				<th>작성일</th>
				<td><%=DKRS_regDate%></td>
			</tr><tr>
				<th class="tdline" colspan="4">답변정보</th>
			</tr>
			<%If DKRS_isReply = "T" Then%>
				<tr>
					<th>답변내용</th>
					<td><%=DKRS_strReply%></td>
				</tr>
				<tr>
					<th>답변 첨부파일</th>
					<td>
						<%
							'print
							If DKRS_strReplyData1 <> "" Then
								strDataSize1 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/counselReply")&"\"&DKRS_strReplyData1) / 1024)
						%>
							<a href="javascript:fTrans('<%=FN_HR_ENC(DKRS_strReplyData1)%>','<%=FN_HR_ENC("counselR")%>');">[다운로드]</a> <span style="color:#333;" class="tweight"><%=BACKWORD(DKRS_strReplyData1)%></span> <span style="color:#f32000">(<%=num2cur(strDataSize1)%>KB)</span>
						<%Else%>
						첨부파일 없음
						<%End If%>

					</td>
				</tr>

				<tr>
					<th>답변작성일</th>
					<td><%=DKRS_repDate%></td>
				</tr><tr>
					<th>답변작성자</th>
					<td><%=DKRS_strReplyID%></td>
				</tr>
			<%Else%>
				<tr>
					<th>답변내용</th>
					<td><textarea name="strReply" class="input_area" style="width:100%; height:180px;"><%=BACKWORD_AREA(DKRS_strReply)%></textarea></td>
				</tr><tr>
					<th>답변 첨부파일</th>
					<td>
						<div class="filebox bs3-primary preview-image">
							<input class="upload-name" value="파일선택 (5MB 이하의 파일)" disabled="disabled" style="width:350px">
							<label for="strReplyData1" class="ser">파일찾기</label>
							<input type="file" id="strReplyData1" name="strReplyData1" class="upload-hidden">
						</div>

						<%
							'print
							If DKRS_strReplyData1 <> "" Then
								strDataSize1 = num2cur(ChkFileSize(REAL_PATH2("/uploadData/counselReply")&"\"&DKRS_strReplyData1) / 1024)
						%>
						<hr />
							<span style="color:#333;" class="tweight"><%=BACKWORD(DKRS_strReplyData1)%></span> <span style="color:#f32000">(<%=num2cur(strDataSize1)%>KB)</span>
							<p style="margin-top:7px;">
							<a href="javascript:fTrans('<%=FN_HR_ENC(DKRS_strReplyData1)%>','<%=FN_HR_ENC("counselR")%>');">[다운로드]</a>
							<!-- <a href="<%=VIR_PATH("data/reply")%>/<%=DKRS_strReplyData1%>" target="_blank">[바로보기]</a> -->
							</p>
						<%Else%>
						첨부파일 없음
						<%End If%>

					</td>
				</tr>



				<tr>
					<th>답변처리</th>
					<td>
						<span class="dchk chk2"><input type="radio" name="isReply" id="isReply_T" value="T" <%=isChecked("T",DKRS_isReply)%>><label for="isReply_T">답변완료</label></span>
						<span class="dchk chk2 chkS"><input type="radio" name="isReply" id="isReply_I" value="I" <%=isChecked("I",DKRS_isReply)%>><label for="isReply_I">답변중</label></span>
						<span class="dchk chk2 chkS"><input type="radio" name="isReply" id="isReply_F" value="F" <%=isChecked("F",DKRS_isReply)%>><label for="isReply_F">미답변</label></span>
						<p style="line-height:150%;">
						<br /><span class="text_red">미답변의 경우 답변내용을 볼 수 없습니다.</span>
						<br /><span class="text_red">답변중으로 선택하면 답변내용을 볼 수 있습니다.</span>
						<br /><span class="text_red">답변 완료로 변경 후에는 답변을 수정할 수 없습니다</span>
						<%If DKRS_isSmsSend = "T" Then%><br /><span class="text_red">문의자가 SMS로 답변여부를 받기에 체크한 게시물입니다. 답변체크를 하면 SMS가 전송됩니다</span><%End If%>
						</p>
					</td>
				</tr>
			<%End If%>

		</table>

		<p class="titles">관리자 코멘트	</p>
		<table <%=tableatt%> class="width100 comment">
			<col width="120" />
			<col width="" />
			<col width="150" />
			<tr>
				<th colspan="3"><button type="button" class="input_submit design2 commentAdd"><i class="fas fa-pencil-alt"></i> 작성하기</a></button> <span class="text_red">회원들은 볼 수 없는 관리자 메모기능입니다</span></th>
			</tr>
			<%
				arrParams2 = Array(_
					Db.makeParam("@FK_IDX",adInteger,adParamInput,4,intIDX) _
				)

				arrList2 = Db.execRsList("[DKSP_COUNSEL_1ON1_MEMO_LIST_ADMIN]",DB_PROC,arrParams2,listLen2,Nothing)

				If IsArray(arrList2) Then
					For j = 0 To listLen2
					arrList2_intIDX			= arrList2(0,j)
					arrList2_FK_IDX			= arrList2(1,j)
					arrList2_isDel			= arrList2(2,j)
					arrList2_strUserID		= arrList2(3,j)
					arrList2_strMemo		= arrList2(4,j)
					arrList2_regDate		= arrList2(5,j)
					arrList2_regIP			= arrList2(6,j)
			%>


			<tr>
				<th>답변내용</th>
				<td>
					<p style="padding:15px 0px"><%=arrList2_strMemo%></p>
					<%If DK_MEMBER_LEVEL > 9 Then%>
					<div style="height:1px; width:100%; background-color:#eee;"></div>
					<p style="padding:7px 0px; " class="tright">
					<input type="hidden" name="delIDX" value="<%=arrList2_intIDX%>" />
					<button type="button" class="input_submit design4 commentDel"><i class="fas fa-trash-alt"></i> 삭제</a></button>
					</p>
					<%End If%>
				</td>
				<td class="tcenter"><%=arrList2_strUserID%><br /><%=dateFormat(arrList2_regDate,"yyyy-mm-dd hh:nn:ss")%></td>
			</tr>
			<%
					Next
				Else
			%><tr>
				<td colspan="3" class="notData">등록된 관리자 메모가 없습니다.</td>
			</tr>
			<%End If%>
		</table>

		<div class="btnArea">
			<%If DKRS_isReply <> "T" Then%>
			<a href="javascript:chkFrm();" class="a_submit design1">저장하기</a>
			<%End If%>
			<a href="1on1_list.asp?<%=SC_QUERY%>" class="a_submit design2">목록으로</a>
			<a href="javascript:delFrm();" class="a_submit design4">삭제하기</a>
		</div>
	</form>
</div>
<!-- Modal 1 S -->
	<div class="modal fade modal_category" id="ModalScrollable1" tabindex="-1" role="dialog" aria-labelledby="ModalScrollableTitle1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-scrollable" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title tweight" id="ModalScrollableTitle1">관리자 메모</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				</div>
				<div class="modal-body">
					<form name="ufrm" action="1on1_Comment_Handler.asp" method="post">
						<input type="hidden" name="sc_isReply" value="<%=sc_isReply%>" />
						<input type="hidden" name="PAGE" value="<%=PAGE%>" />
						<input type="hidden" name="sc_cate1" value="<%=sc_cate1%>" />
						<input type="hidden" name="sc_cate2" value="<%=sc_cate2%>" />
						<input type="hidden" name="sc_Name" value="<%=sc_Name%>" />
						<input type="hidden" name="sc_ReplyID" value="<%=sc_ReplyID%>" />
						<input type="hidden" name="sc_WebID" value="<%=sc_WebID%>" />

						<input type="hidden" name="mode" id="cMode" value="ADD" />
						<input type="hidden" name="idx" id="idx" value="<%=DKRS_intIDX%>" />
						<input type="hidden" name="delIDX" id="delIDX" value="" />
						<table <%=tableatt%> class="width100 asList" id="TableGrid1">
							<col width="130" />
							<col width="*" />
							<tbody>

								<tr>
									<th>메모내용</td>
									<td>
										<textarea name="strMemo" class="input_area" style="width:90%; height:230px;"></textarea>
									</td>
								</tr><tr>
									<td colspan="2" class="tcenter"><input type="submit" class="input_submit design1" value="저장"></td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
				<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
<!-- Modal 2 E -->
<script src="/modP/bootstrap/bootstrap.bundle.min.js"></script>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
