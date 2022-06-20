<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE1-1"

	sc_Group		= Request("sc_Group")


%>
<link rel="stylesheet" href="faq.css" />
<script type="text/javascript" src="faq.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="faq">
	<p class="titles">FAQ 그룹 선택 <!-- (<%=UCase(strNationCode)%>) --><p>
	<div class="insert">
		<form name="selectFrm" method="get" action="faq_category.asp">
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

		<p class="titles">카테고리 등록 <!-- (<%=UCase(strNationCode)%>) --><p>
		<div class="insert">
			<form name="iFrm" method="post" action="faq_category_Handler.asp" onsubmit="return ChkCateIns(this)">
				<input type="hidden" name="MODE" value="REGIST">
				<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
				<input type="hidden" name="strGroup" value="<%=sc_Group%>" />

				<table <%=tableatt%>>
					<col width="200" />
					<col width="800" />
					<tr>
						<th>카테고리명</th>
						<td><input type="text" name="strTitle" class="input_text" style="width:330px;" value="" /> <input type="submit" class="input_submit design3" value="등록" /></td>
					</tr>
				</table>
			</form>
		</div>


		<p class="titles">카테고리 목록 <!-- (<%=UCase(strNationCode)%>) --></p>
		<div class="list">
			<table <%=tableatt%> class="width100">
				<col width="60" />
				<col width="80" />
				<col width="80" />
				<col width="" />
				<col width="180" />
				<tr>
					<th>순서</th>
					<th>순서변경</th>
					<th>보임/감춤</th>
					<th>카테고리명</th>
					<th>기능</th>
				</tr>
				<%
					arrParams = Array( _
						Db.makeParam("@strNation",adVarChar,adParamInput,10,viewAdminLangCode), _
						Db.makeParam("@strGroup",adVarChar,adParamInput,20,sc_Group) _
					)
					arrList = Db.execRsList("DKSP_FAQ_CATEGORY_LIST_ADMIN",DB_PROC,arrParams,listLen,Nothing)
					If IsArray(arrList) Then
						For i = 0 To listLen
							arrList_intIDX			= arrList(0,i)
							arrList_strNationCode	= arrList(1,i)
							arrList_strGroup		= arrList(2,i)
							arrList_isDel			= arrList(3,i)
							arrList_isView			= arrList(4,i)
							arrList_intSort			= arrList(5,i)
							arrList_strTitle		= arrList(6,i)

							Select Case arrList_isView
								Case "T" : Icon_viewTF = aImgOPT("javascript:chgViewTF('"&arrList_isView&"','"&arrList_intIDX&"');","S",IMG_DESIGN&"/icon_view.gif",16,16,"","")
								Case "F" : Icon_viewTF = aImgOPT("javascript:chgViewTF('"&arrList_isView&"','"&arrList_intIDX&"');","S",IMG_DESIGN&"/icon_hidden.gif",16,16,"","")
								Case Else : Icon_viewTF = "오류"
							End Select
				%>
				<tr>
					<td class="tcenter"><%=arrList_intSort%></td>
					<td class="tcenter">
						<a href="javascript:sortUp('<%=i%>','<%=arrList_intIDX%>')" style="font-size:19px;"><i class="fas fa-arrow-circle-up"></i></a>
						<a href="javascript:sortDown('<%=i%>','<%=arrList_intIDX%>','<%=listLen%>')" style="font-size:19px;"><i class="fas fa-arrow-circle-down"></i></i></a>
					</td>
					<td class="tcenter"><%=Icon_viewTF%></td>
					<td class="padding_left7"><input type="text" id="strTitle<%=i%>" name="strTitle<%=i%>" class="input_text" value="<%=arrList_strTitle%>" style="width:330px;" /></td>
					<td class="tcenter">
						<input type="button" class="a_submit design1" value="수정" onclick="cateModify('<%=arrList_intIDX%>','strTitle<%=i%>')" />
						<input type="button" class="a_submit design4" value="삭제" onclick="cateDelete('<%=arrList_intIDX%>')" />
						<!-- <%=aImgOPT("javascript:cateModify('"&arrList_intIDX&"','strTitle"&i&"');","S",IMG_BTN&"/btn_gray_update.gif",45,22,"","")%>
						<%=aImgOPT("javascript:cateDelete('"&arrList_intIDX&"');","S",IMG_BTN&"/btn_gray_delete.gif",45,22,"","style=""margin-left:4px;""")%>						 -->
					</td>
				</tr>
				<%
						Next
					Else
				%>
				<tr>
					<td colspan="5" class="notData">등록된 FAQ가 없습니다.</td>
				</tr>
				<%
					End If
				%>
			</table>
		</div>
	<%End If%>
</div>
<form name="modFrm" action="faq_category_handler.asp" method="post">
	<input type="hidden" name="MODE" value="" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="values" value="" />
	<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
	<input type="hidden" name="strGroup" value="<%=sc_Group%>" />
</form>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
