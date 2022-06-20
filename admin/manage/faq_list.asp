<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE1-2"



	Dim PAGESIZE		:	PAGESIZE = Request("PAGESIZE")
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


%>
<link rel="stylesheet" href="faq.css" />
<script type="text/javascript" src="faq.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="faq">
	<p class="titles">FAQ 그룹 선택 <!-- (<%=UCase(strNationCode)%>) --><p>
	<div class="insert">
		<form name="selectFrm" method="get" action="faq_list.asp">
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
		<p class="titles">FAQ 리스트 <!-- (<%=UCase(strNationCode)%>) --><p>

		<div class="faq_menu width100">
			<ul>
				<%If intCate = "" Then%>
					<li class="on" ><a href="faq_list.asp?sc_group=<%=sc_group%>"><%=LNG_FAQ_LIST_TEXT01%></a></li>
				<%Else%>
					<li ><a href="faq_list.asp?sc_group=<%=sc_group%>"><%=LNG_FAQ_LIST_TEXT01%></a></li>
				<%End If%>

				<%
					arrParams2 = Array(_
						Db.makeParam("@strNationCode",adVarChar,adParamInput,10,LANG), _
						Db.makeParam("@strGroup",adVarChar,adParamInput,20,sc_group) _
					)
					arrList2 = Db.execRsList("DKSP_FAQ_CATEGORY_LIST_ADMIN",DB_PROC,arrParams2,listLen2,Nothing)
					If IsArray(arrList2) Then
						If intCate = "" Then
							classOn = "class=""on"""
						Else
							classOn = ""
						End If

						For j = 0 To listLen2
							arrList2_intIDX			= arrList2(0,j)
							arrList2_strNationCode	= arrList2(1,j)
							arrList2_strGroup		= arrList2(2,j)
							arrList2_isDel			= arrList2(3,j)
							arrList2_isView			= arrList2(4,j)
							arrList2_intSort		= arrList2(5,j)
							arrList2_strTitle		= arrList2(6,j)

							If intCate <> "" Then
								If CInt(intCate) = CInt(arrList2_intIDX) Then
									classOn = "class=""on"""
								Else
									classOn = ""
								End If
							Else
								classOn = ""
							End If

							PRINT "<li "&classOn&"><a href=""faq_list.asp?sc_group="&sc_Group&"&cate="&arrList2_intIDX&""">"&arrList2_strTitle&"</a></li>"
						Next
					End If
				%>
			</ul>
		</div>

		<div class="faq_list width100">
			<ul>
			<%
				arrParams = Array(_
					Db.makeParam("@intCate",adInteger,adParamInput,10,intCate),_
					Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM),_
					Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR),_
					Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
					Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
					Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(viewAdminLangCode)), _
					Db.makeParam("@strGroup",adVarChar,adParamInput,20,sc_Group), _
					Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
				)
				arrList = Db.execRsList("[DKSP_FAQ_LIST_ADMIN]",DB_PROC,arrParams,listLen,Nothing)
				All_Count = arrParams(UBound(arrParams))(4)

				Dim PAGECOUNT,CNT
				PAGECOUNT = int((ccur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
				IF CCur(PAGE) = 1 Then
					CNT = All_Count
				Else
					CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
				End If

				If IsArray(arrList) Then
					For i = 0 To listLen
						arrList_intIDX			= arrList(1,i)
						arrList_strSubject		= arrList(2,i)
						arrList_strContent		= arrList(3,i)
						arrList_isView			= arrList(4,i)
			%>
			<li>
				<h3><%=arrList_strSubject%></h3>
				<div>
					<%=backword_Tag(arrList_strContent)%>
					<hr>
					<a href="faq_modify.asp?idx=<%=arrList_intIDX%>&<%=SC_QUERY%>" class="a_submit design1">수정</a>
					<a href="javascript:faqDelete('<%=arrList_intIDX%>');" class="a_submit design4">삭제</a>
					<!-- <%=aImgOPT("faq_modify.asp?idx="&arrList_intIDX  ,"S",IMG_BTN&"/btn_gray_update.gif",45,22,"","")%>
					<%=aImgOPT("javascript:faqDelete('"&arrList_intIDX&"');","S",IMG_BTN&"/btn_gray_delete.gif",45,22,"","style=""margin-left:4px;""")%></div> -->
			</li>
			<%
					Next
				Else
			%>
			<p class="notFAQ"><%=LNG_FAQ_LIST_TEXT06%></p>
			<%
				End If
			%>

		</div>



	<%End If%>
</div>
<div class="pagingArea pagingNew4" style="margin-top:15px;"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
</form>

<form name="modFrm" action="faq_handler.asp" method="post">
	<input type="hidden" name="MODE" value="" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="values" value="" />
	<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
	<input type="hidden" name="strGroup" value="<%=sc_group%>" />
	<input type="hidden" name="intCate" value="<%=intCate%>" />
</form>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
