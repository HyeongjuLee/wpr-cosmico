<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "CONFIG"
	INFO_MODE = "CONFIG3-2"

%>
<script type="text/javascript" src="/admin/jscript/dtod.js"></script>
<link rel="stylesheet" href="/admin/css/dtod.css" />
</head>
<body>


<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="dtod">
	<p>택배사 추가</p>
	<form name="frm_insert" method="post" action="dtod_insert.asp" onsubmit="return insertChk(this);">
	<input type="hidden" name="iMode" value="I" />
	<table <%=tableatt%> class="input">
		<colgroup>
			<col width="200" />
			<col width="800" />
		</colgroup>
		<tr>
			<th>택배사명</th>
			<td><input type="text" name="strDtoDName" class="input_text" style="width:200px" /></td>
		</tr><tr>
			<th>고객센터 번호</th>
			<td><input type="text" name="strDtoDTel" class="input_text" style="width:200px" /></td>
		</tr><tr>
			<th>홈페이지 주소</th>
			<td><input type="text" name="strDtoDURL" class="input_text" style="width:400px" /></td>
		</tr><tr>
			<th>배송추적 주소</th>
			<td><input type="text" name="strDtoDTrace" class="input_text" style="width:600px" /></td>
		</tr><tr>
			<th>노출여부</th>
			<td><label><input type="checkbox" name="useTF" value="T" class="vmiddle" style="margin-left:10px;" /> 등록과 동시에 노출시킵니다.</label></td>
		</tr><tr>
			<td colspan="2" class="tcenter" ><input type="submit" value="택배사 추가" class="submit" /></td>
		</tr>
	</table>
	</form>
	<p>택배사 리스트</p>
	<form name="frm_update" method="post" action="dtod_insert.asp">
		<input type="hidden" name="iMode" value="" />
		<input type="hidden" name="intIDX" value="" />
		<input type="hidden" name="SORT_TYPE" value="" />
	</form>
	<table <%=tableatt%> class="list">
		<colgroup>
			<col width="50" />
			<col width="70" />
			<col width="150" />
			<col width="150" />
			<col width="*" />
			<col width="90" />
			<col width="140" />
		</colgroup>
		<thead>
			<tr>
				<th>No</th>
				<th>정렬</th>
				<th>택배사명</th>
				<th>고객센터 번호</th>
				<th>홈페이지</th>
				<th>노출여부</th>
				<th>비고</th>
			</tr>
		</thead>
		<tbody>
		<%
			SQL = "SELECT * FROM [DK_DtoD] ORDER BY [intSort] ASC"
			arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,Nothing)
			If IsArray(arrList) Then
				For i = 0 To listLen
					Select Case arrList(6,i)
						Case "T" : isUsed = spans("노출","#000",10,"normal")
						Case "F" : isUsed = "미노출"
					End Select

					If i = 0 Then
						SORT_UP = viewImgStJS(IMG_BTN&"/cate_up.gif",16,16,"","","bor1 vmiddle cp","onclick=""alert('더이상 올릴 수 없습니다.')""")
						SORT_DOWN = viewImgStJS(IMG_BTN&"/cate_down.gif",16,16,"","margin-left:2px;","bor1 vmiddle cp","onclick=""sortDown('"&arrList(0,i)&"')""")
					ElseIf i = listLen Then
						SORT_UP = viewImgStJS(IMG_BTN&"/cate_up.gif",16,16,"","","bor1 vmiddle cp","onclick=""sortUp('"&arrList(0,i)&"')""")
						SORT_DOWN = viewImgStJS(IMG_BTN&"/cate_down.gif",16,16,"","margin-left:2px;","bor1 vmiddle cp","onclick=""alert('더이상 내릴 수 없습니다.')""")
					Else
						SORT_UP = viewImgStJS(IMG_BTN&"/cate_up.gif",16,16,"","","bor1 vmiddle cp","onclick=""sortUp('"&arrList(0,i)&"')""")
						SORT_DOWN = viewImgStJS(IMG_BTN&"/cate_down.gif",16,16,"","margin-left:2px;","bor1 vmiddle cp","onclick=""sortDown('"&arrList(0,i)&"')""")
					End If
					dtod_name = arrList(2,i)
					If arrList(7,i) = "T" Then dtod_name = "<strong><span style=""color:#da5c00;"">(기본) </span>"&dtod_name&"</strong>"



					PRINT Tabs(2)&"<tr>"
					PRINT Tabs(3)&"<td>"&arrList(1,i)&"</td>"
					PRINT Tabs(3)&"<td>"&SORT_UP&SORT_DOWN&"</td>"
					PRINT Tabs(3)&"<td>"&dtod_name&"</td>"
					PRINT Tabs(3)&"<td>"&arrList(3,i)&"</td>"
					PRINT Tabs(3)&"<td class=""tleft"" style=""padding-left:5px;"">"&arrList(4,i)&" "&viewImgStJS(IMG_ICON&"/icon_dtod.gif",16,16,"","","vmiddle cp","onclick=""dtod_trace('"&arrList(5,i)&"');""")&"</td>"
					PRINT Tabs(3)&"<td><a href=""javascript:useChg('"&arrList(0,i)&"');"">"&isUsed&"</a></td>"
					PRINT Tabs(3)&"<td>"&viewImgStJS(IMG_BTN&"/btn_default_dtod.gif",85,18,"","","cp vmiddle","onclick=""dfchgok('"&arrList(0,i)&"')""")&"<img src="""&IMG_BTN&"/btn_del.gif"" width=""34"" height=""17"" alt=""현재행삭제"" style=""margin-left:5px;"" class=""cp vmiddle"" onclick=""delok('"&arrList(0,i)&"')"" /></td>"
					PRINT Tabs(2)&"</tr>"
					'
					'"&arrList(5,i)&"
					'					PRINT Tabs(3)&"<td>"&</td>"

				Next
			Else
				PRINT tabs(1)&"<tr>"
				PRINT tabs(2)&"<td colspan=""8"" style=""padding:60px 0px;text-align:center;"">등록된 택배사가 없습니다.</td>"
				PRINT tabs(1)&"</tr>"

			End If
		%>
		</tbody>
	</table>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->

