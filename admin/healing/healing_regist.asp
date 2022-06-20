<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "HEALING"
	INFO_MODE = "HEALING1-3"

	strNationCode = Request("nc")
	strNationCode = UCase(viewAdminLangCode)

	arrParams_FA = Array(Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode))
	Set DKRS_FA = Db.execRs("DKSP_SITE_NATION_VIEW",DB_PROC,arrParams_FA,Nothing)
	If Not DKRS_FA.BOF And Not DKRS_FA.EOF Then
		DKRS_FA_strNationName	= DKRS_FA("strNationName")
		DKRS_FA_intSort			= DKRS_FA("intSort")
	Else
		Call ALERTS("설정되지 않은 국가입니다!","BACK","")
	End If

	INFO_MODE = "HEALING1-3-"&DKRS_FA_intSort&""
	INFO_TEXT = DKRS_FA_strNationName

	'FK_IDX = pRequestTF("fIDX",False)

	'print FK_IDX


%>
<link rel="stylesheet" href="healing.css" />
<%=CONST_SmartEditor_JS%>
<script type="text/javascript" src="healing.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="">
	<form name="frm" method="post" action="healing_Handler.asp" onsubmit="return chkGFrm(this)">
	<input type="hidden" name="mode" value="INSERT" />
	<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />
	<div class="ContentArea2">
		<table <%=tableatt%> class="width100">
			<col width="*" />
			<col width="870" />
			<tr>
				<th>메뉴 위치</th>
				<td class="ContentArea1">
					<select name="fIDX" class="select02 vtop">
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
							<option value="<%=arrList_intIDX%>"><%=arrList_strTitle%></option>
						<%
								Next
							End If
						%>
					</select>
				</td>
			</tr><tr>
				<th>메뉴 보임</th>
				<td class="ContentArea1">
					<label><input type="radio" name="isView" value="T" class="input_radio" checked="checked" /> 메뉴 보임</label>
					<label><input type="radio" name="isView" value="F" class="input_radio" /> 메뉴 숨김</label>
				</td>
			</tr><tr>
				<th>콘텐츠 제목</th>
				<td class="ContentArea1"><input type="text" name="strSubject" class="input_text" style="width:550px;" value="" /></td>
			</tr><tr>
				<th>콘텐츠</th>
				<td class="ContentArea2">
					<textarea name="strContent" id="ir1" style="width:100%;height:350px;display:none;" cols="50" rows="10"></textarea>
					<%=FN_Print_SmartEditor("ir1","healing",UCase(viewAdminLangCode),"","","")%>
				</td>
			</tr>
		</table>
	</div>
	<div class="submit_area"><input type="submit" class="submit" value="내용 저장" /></div>
</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
