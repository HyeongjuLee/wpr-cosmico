<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "HEALING"
	INFO_MODE = "HEALING1-2"

	strNationCode = Request("nc")

	arrParams_FA = Array(Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode))
	Set DKRS_FA = Db.execRs("DKSP_SITE_NATION_VIEW",DB_PROC,arrParams_FA,Nothing)
	If Not DKRS_FA.BOF And Not DKRS_FA.EOF Then
		DKRS_FA_strNationName	= DKRS_FA("strNationName")
		DKRS_FA_intSort			= DKRS_FA("intSort")
	Else
		Call ALERTS("설정되지 않은 국가입니다!","BACK","")
	End If

	INFO_MODE = "HEALING1-2-"&DKRS_FA_intSort&""
	INFO_TEXT = DKRS_FA_strNationName

	FK_IDX = pRequestTF("fIDX",False)

	'print FK_IDX


%>
<link rel="stylesheet" href="healing.css" />
<script type="text/javascript" src="healing.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="inCate" class="width100">
	<form name="frms" method="post" action="healing_list.asp?nc=<%=strNationCode%>">
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="180" />
				<col width="*" />
			</colgroup>
			<thead>
				<tr>
					<th colspan="4">메뉴선택</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>메뉴명</td>
					<td>
						<select name="fIDX" class="select02 vtop">
							<option value="">전체보기</option>
							<%
								arrParams = Array(_
									Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode) _
								)
								arrList = Db.execRsList("DKSP_HEALING_CATE_LIST",DB_PROC,arrParams,listLen,Nothing)
								If IsArray(arrList) Then
									For i = 0 To listLen
										arrList_intIDX            	= arrList(1,i)
										arrList_strNationCode     	= arrList(2,i)
										arrList_isDel             	= arrList(3,i)
										arrList_isView             	= arrList(4,i)
										arrList_intSort           	= arrList(5,i)
										arrList_strTitle          	= arrList(6,i)


							%>
								<option value="<%=arrList_intIDX%>" <%=isSelect(arrList_intIDX,FK_IDX)%>><%=arrList_strTitle%></option>
							<%
									Next
								End If
							%>
						</select> <input type="image" class="vtop" src="<%=IMG_BTN%>/btn_search.gif" />

					</td>
				</tr>
			</tbody>
		</table>
	</form>

</div>
<div id="divList">
	<%
		col_width01 = 90
		col_width02 = 70
		col_width03 = 150
		col_width04 = 70
		col_width05 = 450


	%>

	<table <%=tableatt%> class="width100">
		<colgroup>
			<col width="<%=col_width01%>" />
			<col width="<%=col_width02%>" />
			<col width="<%=col_width03%>" />
			<col width="<%=col_width04%>" />
			<col width="<%=col_width05%>" />

			<col width="*" />
		</colgroup>
		<tr>
			<th>노출순서</th>
			<th>순서변경</th>
			<th>카테고리</th>
			<th>노출</th>
			<th>메뉴명</th>


			<th>비고</th>
		</tr>

		<%

			arrParams = Array(_
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode), _
				Db.makeParam("@FK_IDX",adInteger,adParamInput,4,FK_IDX) _
			)
			arrList = Db.execRsList("DKSP_HEALING_CONTENT_LIST_ADMIN",DB_PROC,arrParams,listLen,Nothing)

			styleWidth = 60
			If IsArray(arrList) Then
				For i = 0 To listLen
					arrList_intIDX            	= arrList(0,i)
					arrList_FK_IDX           	= arrList(1,i)
					arrList_strNationCode     	= arrList(2,i)
					arrList_isDel             	= arrList(3,i)
					arrList_isView             	= arrList(4,i)
					arrList_intSort           	= arrList(5,i)
					arrList_strSubject         	= arrList(6,i)
					arrList_regDate         	= arrList(7,i)

					SQL = "SELECT [strTitle] FROM [DK_HEALING_CATE] WHERE [intIDX] = ?"
					arrParams = Array(_
						Db.makeParam("@intIDX",adInteger,adParamInput,4,arrList_FK_IDX) _
					)
					ThisTitle = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)



		%>

		<tr>
			<td><%=arrList_intSort%></td>
			<td><%=viewImgStJS(IMG_BTN&"/cate_up.gif",16,16,"","","bor1 vmiddle cp","onclick=""sortUp('"&arrList_intIDX&"')""")%><%=viewImgStJS(IMG_BTN&"/cate_down.gif",16,16,"","margin-left:2px;","bor1 vmiddle cp","onclick=""sortDown('"&arrList_intIDX&"')""")%></td>
			<td><%=ThisTitle%></td>
			<td><%=TFVIEWER(arrList_isView,"VIEW")%></td>
			<td class="tleft"><%=arrList_strSubject%></td>


			<td><a href="healing_modify.asp?nc=<%=strNationCode%>&idx=<%=arrList_intIDX%>"><img  src="<%=IMG_BTN%>/btn_modify.gif" class="vmiddle" alt="" /></a><img src="<%=IMG_BTN%>/btn_del.gif" width="34" height="17" alt="현재행삭제" style="margin-left:5px;" class="cp vmiddle" onclick="delok('<%=arrList_intIDX%>')" /></td>
		</tr>

		<%
			Next
		Else
		End If

	%>
	</table>



</div>

<form name="delFrm" action="healing_Handler.asp" method="post">
	<input type="hidden" name="mode" value="DELETE" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />
</form>
<form name="sortFrm" action="healing_Handler.asp" method="post" >
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />
</form>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
