<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "HEALING"
	INFO_MODE = "HEALING1-1"

	strNationCode = Request("nc")

	arrParams_FA = Array(Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode))
	Set DKRS_FA = Db.execRs("DKSP_SITE_NATION_VIEW",DB_PROC,arrParams_FA,Nothing)
	If Not DKRS_FA.BOF And Not DKRS_FA.EOF Then
		DKRS_FA_strNationName	= DKRS_FA("strNationName")
		DKRS_FA_intSort			= DKRS_FA("intSort")
	Else
		Call ALERTS("설정되지 않은 국가입니다!","BACK","")
	End If

	INFO_MODE = "HEALING1-1-"&DKRS_FA_intSort&""
	INFO_TEXT = DKRS_FA_strNationName





%>
<link rel="stylesheet" href="category.css" />
<script type="text/javascript" src="Category.js"></script>

</head>
<body onload="document.frms.strTitle.focus();">
<!--#include virtual = "/admin/_inc/header.asp"-->


<div id="inCate" class="width100">
	<form name="frms" method="post" action="Category_Handler.asp" onsubmit="return menuIn(this)">
	<input type="hidden" name="mode" value="INSERT" />
	<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />
	<table <%=tableatt%> class="width100">
		<colgroup>
			<col width="180" />
			<col width="*" />
		</colgroup>
		<thead>
			<tr>
				<th colspan="4">메뉴 추가</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<th>메뉴명</td>
				<td ><input type="text" name="strTitle" class="input_text" style="width:300px;" /></td>
			</tr><tr>
				<th>메뉴 보임</td>
				<td class="tds2">
					<label><input type="radio" name="isView" value="T" class="vmiddle" checked="checked" /> 메뉴 보임</label>
					<label><input type="radio" name="isView" value="F" class="vmiddle" /> 메뉴 숨김</label>
				</td>
			</tr>
		</tbody>
		<tr>
			<td colspan="2" align="center" style="padding:3px 0px;"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
		</tr>
	</table>
	</form>

</div>
<div id="divList">
	<%
		col_width01 = 90
		col_width02 = 70
		col_width03 = 70
		col_width04 = 550


	%>

	<table <%=tableatt%> class="width100">
		<colgroup>
			<col width="<%=col_width01%>" />
			<col width="<%=col_width02%>" />
			<col width="<%=col_width03%>" />
			<col width="<%=col_width04%>" />

			<col width="*" />
		</colgroup>
			<tr>
				<th>노출순서</th>
				<th>순서변경</th>
				<th>노출</th>
				<th>메뉴명</th>


				<th>비고</th>
			</tr>
	</table>
	<%

		arrParams = Array(_
			Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode) _
		)
		arrList = Db.execRsList("DKSP_HEALING_CATE_LIST_ADMIN",DB_PROC,arrParams,listLen,Nothing)

		styleWidth = 60
		If IsArray(arrList) Then
			For i = 0 To listLen
				arrList_intIDX            	= arrList(0,i)
				arrList_strNationCode     	= arrList(1,i)
				arrList_isDel             	= arrList(2,i)
				arrList_isView             	= arrList(3,i)
				arrList_intSort           	= arrList(4,i)
				arrList_strTitle          	= arrList(5,i)



	%>
				<form name="frmc<%=i%>" method="post" action="Category_Handler.asp" onsubmit="return menuMode(this)">
					<input type="hidden" name="mode" value="UPDATE" />
					<input type="hidden" name="strNationCode" value="<%=arrList_strNationCode%>" />
					<input type="hidden" name="intIDX" value="<%=arrList_intIDX%>" />
					<table <%=tableatt%> class="width100">
						<colgroup>
							<col width="<%=col_width01%>" />
							<col width="<%=col_width02%>" />
							<col width="<%=col_width03%>" />
							<col width="<%=col_width04%>" />
							<col width="*" />
						</colgroup>
						<tr>
							<td><%=arrList_intSort%></td>
							<td><%=viewImgStJS(IMG_BTN&"/cate_up.gif",16,16,"","","bor1 vmiddle cp","onclick=""sortUp('"&arrList_intIDX&"')""")%><%=viewImgStJS(IMG_BTN&"/cate_down.gif",16,16,"","margin-left:2px;","bor1 vmiddle cp","onclick=""sortDown('"&arrList_intIDX&"')""")%></td>
							<td>
								<select name="isView" class="select2">
									<option value="T" <%=isSelect(arrList_isView,"T")%>>노출</option>
									<option value="F" <%=isSelect(arrList_isView,"F")%>>숨김</option>
								</select>
							</td>
							<td><input type="text" name="strTitle" value="<%=arrList_strTitle%>" class="input_text" style="width:90%;" /></td>


							<td><input type="image" src="<%=IMG_BTN%>/btn_modify.gif" class="vmiddle" /><img src="<%=IMG_BTN%>/btn_del.gif" width="34" height="17" alt="현재행삭제" style="margin-left:5px;" class="cp vmiddle" onclick="delok('<%=arrList_intIDX%>')" /></td>
						</tr>
					</table>
				</form>
		<%
			Next
		Else
			PRINT "	<table "&tableatt&" class=""width100"">" & VbCrlf
			PRINT "		<colgroup>" & VbCrlf
			PRINT "			<col width="""&col_width01&""" />"
			PRINT "			<col width="""&col_width02&""" />"
			PRINT "			<col width="""&col_width03&""" />"
			PRINT "			<col width="""&col_width04&""" />"
			PRINT "			<col width=""*"" />"
			PRINT "		</colgroup>"
			PRINT "		<tr>"
			PRINT "			<td colspan=""5"" height=""80""> 등록된 카테고리가 없습니다.</td>"
			PRINT "		</tr>"
			PRINT "	</table>"
		End If

	%>



</div>

<form name="delFrm" action="Category_Handler.asp" method="post">
	<input type="hidden" name="mode" value="DELETE" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />
</form>
<form name="sortFrm" action="Category_Handler.asp" method="post" >
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />
</form>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
