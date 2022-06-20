<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	'INFO_MODE = "MANAGE1-3"


	Dim PAGE			:	PAGE = Request("PAGE")
	Dim SEARCHTERM		:	SEARCHTERM = Request("SEARCHTERM")
	Dim SEARCHSTR		:	SEARCHSTR = Request("SEARCHSTR")
	Dim intCate			:	intCate = Request("cate")
	sc_Group			= Request("sc_Group")

	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1
	If intCate = "" Then intCate = ""


	If SEARCHTERM = "" Or SEARCHSTR = "" Then
		SEARCHTERM = ""
		SEARCHSTR = ""
	End If

	SC_QUERY = ""
	SC_QUERY = SC_QUERY & "PAGE="&PAGE
	SC_QUERY = SC_QUERY & "&sc_Group="&sc_Group
	SC_QUERY = SC_QUERY & "&Cate="&intCate
	SC_QUERY = SC_QUERY & "&SEARCHTERM="&server.urlencode(SEARCHTERM)
	SC_QUERY = SC_QUERY & "&SEARCHSTR="&server.urlencode(SEARCHSTR)



	intIDX		  = gRequestTF("idx",True)




	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs("[DKSP_FAQ_VIEW_ADMIN]",DB_PROC,arrParams,Nothing)
	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX				= DKRS("intIDX")
		DKRS_isDel				= DKRS("isDel")
		DKRS_isView				= DKRS("isView")
		DKRS_intCate			= DKRS("intCate")
		DKRS_strSubject			= DKRS("strSubject")
		DKRS_strContent			= DKRS("strContent")
		DKRS_regDate			= DKRS("regDate")

	Else
		Call ALERTS("삭제 된 카테고리에 속해있거나 삭제된 FAQ 입니다.","BACK","")
	End If



%>
<link rel="stylesheet" href="faq.css" />
<%=CONST_SmartEditor_JS%>
<script type="text/javascript" src="faq.js"></script>


</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="faq">
	<p class="titles">FAQ 수정 <!-- (<%=UCase(strNationCode)%>) --></p>
	<form name="regFrm" action="faq_handler.asp" method="post" onsubmit="return chkSubmitFaq(this)">
		<input type="hidden" name="MODE" VALUE="MODIFY" />
		<input type="hidden" name="intIDX" VALUE="<%=DKRS_intIDX%>" />
		<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
		<input type="hidden" name="strGroup" value="<%=sc_Group%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
		<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
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
							<option value="<%=arrList_intIDX%>" <%=isSelect(arrList_intIDX,DKRS_intCate)%>><%=Icon_viewTF%>&nbsp;<%=arrList_strTitle%></option>
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
					<input type="radio" name="isView" id="isView_T" value="T" class="input_radio"  <%=isChecked("T",DKRS_isView)%>><label for="isView_T">보임</label>
					<input type="radio" name="isView" id="isView_F" value="F" class="input_radio2" <%=isChecked("F",DKRS_isView)%>><label for="isView_F">숨김</label>
				</td>
			</tr><tr>
				<th>제목</th>
				<td><input type="text" name="strSubject" class="input_text" style="width:650px;" value="<%=DKRS_strSubject%>" /></td>
			</tr><tr>
				<th>내용</th>
				<td class="contentBox">
					<textarea name="strContent" id="ir1" style="width:100%;height:450px;display:none;" cols="50" rows="10"><%=backword(DKRS_strContent)%></textarea>
					<%=FN_Print_SmartEditor("ir1","faq_Content",UCase(viewAdminLangCode),"","","")%>
				</td>
			</tr>
		</table>
		<div class="btn_area"><input type="submit" class="input_submit_b design1" value="확인" /></div>

	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
