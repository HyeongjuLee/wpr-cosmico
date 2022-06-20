<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE1-3"

	sc_Group			= Request("sc_Group")

%>
<link rel="stylesheet" href="faq.css" />
<%=CONST_SmartEditor_JS%>
<script type="text/javascript" src="faq.js"></script>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="faq">
	<p class="titles">FAQ 그룹 선택 <!-- (<%=UCase(strNationCode)%>) --><p>
	<div class="insert">
		<form name="selectFrm" method="get" action="faq_regist.asp">
			<table <%=tableatt%>>
				<col width="200" />
				<col width="800" />
				<tr>
					<th>FAQ 그룹 선택</th>
					<td><select name="sc_Group" class="cate_sel_type">
						<%
							arrParams = Array(_
								Db.makeParam("@strNationCode",adVarChar,adParamInput,10,viewAdminLangCode) _
							)
							arrList = Db.execRsList("[DKSP_FAQ_CONFIG_LIST_USE_ADMIN]",DB_PROC,arrParams,listLen,Nothing)
							'arrList = Db.execRsList("[DKSP_FAQ_CONFIG_LIST_ADMIN]",DB_PROC,arrParams,listLen,Nothing)
							If IsArray(arrList) Then
								PRINT "<option value="""">FAQ 그룹을 선택해주세요</option>"
								For i = 0 To listLen
									arrList_intIDX			= arrList(0,i)
									arrList_strNationCode	= arrList(1,i)
									arrList_strGroup		= arrList(2,i)
									arrList_strCateCode		= arrList(3,i)
									arrList_isUse			= arrList(4,i)
									arrList_mainVar			= arrList(5,i)
									arrList_SubVar			= arrList(6,i)
									arrList_sViewVar		= arrList(7,i)

									PRINT "<option value="""&arrList_strGroup&""" "&isSelect(arrList_strGroup,sc_Group)&">"&arrList_strGroup&"</option>"

								Next
							Else
								PRINT "<option value="""">FAQ 그룹을 먼저 저장해주세요</option>"
							End If

						%>
						</select>
					</td>
				</tr>
			</table>
		</form>
	</div>

	<%If sc_Group = "" Then%>

	<div class="tcenter width100 text_red" style="padding:20px 0px 50px 0px;">FAQ 그룹을 먼저 선택해주세요 </div>

	<%Else%>


		<p class="titles">FAQ 작성 <!-- (<%=UCase(strNationCode)%>) --></p>
		<form name="regFrm" action="faq_handler.asp" method="post" onsubmit="return chkSubmitFaq(this)">
			<input type="hidden" name="MODE" VALUE="REGIST" />
			<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
			<input type="hidden" name="strGroup" value="<%=sc_Group%>" />
			<table <%=tableatt%> class="width100 regist">
				<col width="18%" />
				<col width="82%" />
				<tr>
					<th>카테고리</th>
					<td>
						<select name="intCate">
							<%
								arrParams = Array( _
									Db.makeParam("@strNation",adVarChar,adParamInput,10,viewAdminLangCode), _
									Db.makeParam("@strGroup",adVarChar,adParamInput,20,sc_Group) _
								)
								arrList = Db.execRsList("DKSP_FAQ_CATEGORY_LIST_ADMIN",DB_PROC,arrParams,listLen,Nothing)
								If IsArray(arrList) Then
							%>
							<option value="">=== 카테고리 선택 ===</option>
							<%

									For i = 0 To listLen
										arrList_intIDX			= arrList(0,i)
										arrList_strNationCode	= arrList(1,i)
										arrList_strGroup		= arrList(2,i)
										arrList_isDel			= arrList(3,i)
										arrList_isView			= arrList(4,i)
										arrList_intSort			= arrList(5,i)
										arrList_strTitle		= arrList(6,i)

										Select Case arrList_isView
											Case "T" : Icon_viewTF = "[보임]"
											Case "F" : Icon_viewTF = "[숨김]"
											Case Else : Icon_viewTF = "[오류]"
										End Select

							%>
							<option value="<%=arrList_intIDX%>"><%=Icon_viewTF%>&nbsp;<%=arrList_strTitle%></option>
							<%
									Next
								Else
							%>
							<option value="">=== 카테고리를 먼저 설정하셔야합니다 ===</option>
							<%
								End If
							%>
						</select>
					</td>
				</tr><tr>
					<th>숨김/감춤</th>
					<td>
						<input type="radio" name="isView" id="isView_T" value="T" class="input_radio" checked="checked"><label for="isView_T">보임</label>
						<input type="radio" name="isView" id="isView_F" value="F" class="input_radio2"><label for="isView_F">숨김</label>
					</td>
				</tr><tr>
					<th>제목</th>
					<td><input type="text" name="strSubject" class="input_text" style="width:650px;" value="" /></td>
				</tr><tr>
					<th>내용</th>
					<td class="contentBox">
						<textarea name="strContent" id="ir1" style="width:100%;height:450px;display:none;" cols="50" rows="10"></textarea>
						<%=FN_Print_SmartEditor("ir1","faq_Content",UCase(viewAdminLangCode),"","","")%>
					</td>
				</tr>
			</table>
			<div class="btn_area"><input type="submit" class="input_submit_b design1" value="확인" /></div>

		</form>
	<%End If%>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
