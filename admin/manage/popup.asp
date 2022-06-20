<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	'INFO_MODE = "MANAGE6-1"
	W1200 = "T"
	strNationCode = Request("nc")
	strMobile	  = Request("mb")

	If strMobile = "" Then strMobile = "F"

	arrParams_FA = Array(Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode))
	Set DKRS_FA = Db.execRs("DKSP_SITE_NATION_VIEW",DB_PROC,arrParams_FA,Nothing)
	If Not DKRS_FA.BOF And Not DKRS_FA.EOF Then
		DKRS_FA_strNationName	= DKRS_FA("strNationName")
		DKRS_FA_intSort			= DKRS_FA("intSort")
	Else
		Call ALERTS("설정되지 않은 국가입니다!","BACK","")
	End If

	'모바일 팝업
	If strMobile = "T" Then
		INFO_MODE = "MANAGE6-2-"&DKRS_FA_intSort&""
		INFO_TEXT = DKRS_FA_strNationName
	Else
		INFO_MODE = "MANAGE6-1-"&DKRS_FA_intSort&""
		INFO_TEXT = DKRS_FA_strNationName
	End If

%>
<link rel="stylesheet" href="popup.css" />
<link rel="stylesheet" type="text/css" href="/modP/bootstrap/bootstrap.css" />
<script type="text/javascript" src="popup.js"></script>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<iframe src="/hiddens.asp" name="hiddenFrame" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>
<p class="titles"><%=MAP_DEPTH3%> (<%=UCase(strNationCode)%>)<p>
<div id="popup">
	<!-- <p class="tright" style="padding:5px 0px;"><%=aImg("javascript:openPopReg();",IMG_BTN&"/btn_popup.gif",142,39,"")%><p> -->
	<p class="tright" style="padding:5px 0px;"><a href="javascript:popupRegist();"><img src="<%=IMG_BTN%>/btn_popup.gif" alt="" /></a><p>
	<table <%=tableatt%> class="width100 list">
		<colgroup>
			<col width="140" />
			<col width="60" />
			<col width="50" />
			<col width="140" />
			<!-- <col width="80" /> -->
			<col width="120" />
			<col width="90" />
			<col width="90" />
			<col width="*" />
			<col width="90" />
		</colgroup>
		<thead>
			<tr>
				<th>팝업값</th>
				<th>국가코드</th>
				<th>사용<br />여부</th>
				<th>팝업타이틀</th>
				<!-- <th>팝업<br />미리보기</th> -->
				<!-- <th>팝업페이지</th> -->
				<th>해상도<br />(넓이/높이)</th>
				<th>팝업위치<br />(상단/좌측)</th>
				<th>팝업종류</th>
				<th>연결주소</th>
				<th>기능</th>
			</tr>
		</thead>
		<tbody>
			<%
				'SQL = "SELECT * FROM [DK_POPUP] ORDER BY [intIDX] DESC"
				SQL = "SELECT * FROM [DK_POPUP] WHERE [strNation] = '"&strNationCode&"' AND [isViewMobile] = '"&strMobile&"' ORDER BY [intIDX] DESC"
				arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,Nothing)

				If IsArray(arrList) Then
					For i = 0 To listLen

						Select Case arrList(10,i)
							Case "P" : popupKind = "일반팝업"
							Case "L" : popupKind = "레이어팝업"
							Case "T" : popupKind = "상단팝업"
						End Select
						Select Case arrList(11,i)
							Case "B" : linkType = "새창"
							Case "S" : linkType = "기존창"
							Case Else : linkType = "링크 없음"
						End Select
						Select Case arrList(2,i)
							Case "T"
								thisValues = "F"
								viewMode = "<a href=""popup_Modify.asp?thisMode=edit&amp;thisValue="&thisValues&"&amp;idx="&arrList(0,i)&""" target=""hiddenFrame"">"&viewImg(IMG_DESIGN&"/icon_view.gif",16,16,"")&"</a>"
							Case "F"
								thisValues = "T"
								viewMode = "<a href=""popup_Modify.asp?thisMode=edit&amp;thisValue="&thisValues&"&amp;idx="&arrList(0,i)&""" target=""hiddenFrame"">"&viewImg(IMG_DESIGN&"/icon_hidden.gif",16,16,"")&"</a>"
						End Select

						If arrList(12,i) = "" Or IsNull(arrList(12,i)) Then
							LinkGo = ""
						Else
							LinkGo = "<a href="""&arrList(12,i)&""" target=""_blank"">"&arrList(12,i)&"</a>"
						End If

						Select Case arrList(13,i)
							Case "F" : isViewShop = "<span style=""color:blue;"">메인페이지</span>"
							Case "T" : isViewShop = "<span style=""color:green;"">쇼핑몰메인</span>"
						End Select

						PRINT tabs(3) & "<tr>"
						PRINT tabs(3) & "	<td>"&arrList(1,i)&"</td>"
						PRINT tabs(3) & "	<td>"&strNationCode&"</td>"
						PRINT tabs(3) & "	<td>"&viewMode&"</td>"
						PRINT tabs(3) & "	<td>"&arrList(3,i)&"</td>"
						'PRINT tabs(3) & "	<td>보기</td>"
						'PRINT tabs(3) & "	<td>"&isViewShop&"</td>"
						PRINT tabs(3) & "	<td>"&arrList(5,i)&"px / "&arrList(6,i)&"px</td>"
						PRINT tabs(3) & "	<td>"&arrList(8,i)&"px / "&arrList(9,i)&"px</td>"
						PRINT tabs(3) & "	<td>"&popupKind&"</td>"
						PRINT tabs(3) & "	<td>("&linkType&") "&LinkGo&"</td>"
						PRINT tabs(3) & "	<td><a href=""popup_Modify.asp?thisMode=del&amp;idx="&arrList(0,i)&""" target=""hiddenFrame"" class=""a_submit design4"">삭제</a></td>"
						'PRINT tabs(3) & "	<td><a href=""popup_Modify.asp?thisMode=del&amp;idx="&arrList(0,i)&""" target=""hiddenFrame""><img src="""&IMG_BTN&"/btn_gray_delete.gif""></a></td>"
						PRINT tabs(3) & "</tr>"
					Next

				Else
					PRINT tabs(3) & "<tr>"
					PRINT tabs(3) & "	<td colspan=""9"" class=""notdata"">설정된 팝업이 없습니다.</td>"
					PRINT tabs(3) & "</tr>"
				End If

			%>
		</tbody>
	</table>
</div>
<!-- Modal 1 S -->
	<div class="modal fade modal_category" id="ModalScrollable1" tabindex="-1" role="dialog" aria-labelledby="ModalScrollableTitle1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-scrollable" role="document" style="width:580px;">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title tweight" id="ModalScrollableTitle1">팝업 등록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				</div>
				<div class="modal-body" id="popup">
					<form name="frms" method="post" action="popup_registGlobalOk.asp" onsubmit="return chkPopupRegist(this)" enctype="multipart/form-data">
						<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />
						<input type="hidden" name="isViewCom" value="T" />
						<input type="hidden" name="isViewShop" value="F" />
						<input type="hidden" name="isViewMobile" value="<%=strMobile%>" />
						<!-- <input type="hidden" name="popKind" value="P" /> -->
						<!-- <input type="hidden" name="popKind" value="L" /> -->
						<table <%=tableatt%> class="tables1">
							<colgroup>
								<col width="100" />
								<col width="*" />
							</colgroup>
							<tbody>
								<tr>
									<th>국가코드</th>
									<td><%=strNationCode%></td>
								</tr>
								<tr>
									<th>팝업값</th>
									<td>자동설정</td>
								</tr><tr>
									<th>사용유무</th>
									<td>
										<span class="dchk chk2"><input type="radio" name="useTF" id="useTF_T" value="T"><label for="useTF_T">사용함</label></span>
										<span class="dchk chk2 chkS"><input type="radio" name="useTF" id="useTF_F" value="F" checked="checked"><label for="useTF_F">사용안함</label></span>
									</td>
								</tr><tr>
									<th>팝업종류</th>
									<td>
										<!-- <label><input type="radio" name="popKind" class="vmiddle" value="P" checked="checked"/>일반팝업</label> -->
										<span class="dchk chk2"><input type="radio" name="popKind" id="popKind_L" value="L" checked="checked" <%' If strMobile = "T" Then PRINT "checked" %>/><label for="popKind_L">레이어팝업</label></span>
										<% If strMobile = "F" Then %>
										<!-- <span class="dchk chk2 chkS"><input type="radio" name="popKind" id="popKind_T" value="T" onClick="pageGoto(2,'<%=strNationCode%>','<%=strMobile%>');"/><label for="popKind_T">상단팝업</label></span> -->
										<% End If %>
									</td>
								</tr><tr>
									<th>팝업타이틀</th>
									<td><input type="text" name="popTitle" class="input_text" style="width:270px;" /></td>
								</tr>
							</tbody>
							<tbody id="layerTD">
								<tr>
									<th>팝업이미지</th>
									<td>
										<div class="filebox bs3-primary preview-image">
											<input class="upload-name" value="파일선택 (5MB 이하의 파일)" disabled="disabled" style="width:350px">
											<label for="imgName" class="ser">파일찾기</label>
											<input type="file" id="imgName" name="imgName" class="upload-hidden">
										</div>
									</td>
								</tr><tr>
									<th>팝업위치</th>
									<td>
										상단 : <input type="text" name="marginTop" class="input_text vmiddle" style="width:50px;" <%=onLyKeys%> /> PX &nbsp;&nbsp;&nbsp;
										좌측 : <input type="text" name="marginLeft" class="input_text vmiddle" style="width:50px;" <%=onLyKeys%> /> PX
									</td>
								</tr>
							</tbody>
							<tbody id="topTD" style="display:none;">
								<tr>
									<th>짧은 설명</th>
									<td>
										<p><input type="text" name="strScontent" class="input_text" style="width:370px;" /></p>
										<p style="margin-top:7px;"><span style="line-height:120%;">한글기준 30자 이내로 작성해주세요.</span></p>
									</td>
								</tr>
							</tbody>
							<tbody>
								<tr>
									<th>연결주소</th>
									<td>
										<select name="linkType" class="input_select">
											<option value="">==선택==</option>
											<option value="F">링크없음</option>
											<option value="S">기존창링크</option>
											<option value="B">새 창 링크</option>
										</select> <input type="text" name="linkUrl" class="input_text" style="width:300px;" />
									</td>
								</tr><!-- <tr>
									<th>팝업페이지</th>
									<td><label><input type="radio" name="isViewShop" class="vmiddle" value="F" checked="checked" />메인페이지</label> <label><input type="radio" name="isViewShop" class="vmiddle" value="T" />쇼핑몰메인페이지</label></td>
								</tr> -->
							</tbody>
							<tfoot>
								<tr>
									<td colspan="2" class="submit_area tcenter"><input type="image" src="<%=IMG_BTN%>/btn_popup.gif" style="width:142px;height:39px" /></td>
								</tr>
							</tfoot>
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
