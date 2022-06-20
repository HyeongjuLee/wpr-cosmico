<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"

	strNationCode = Request("nc")

%>
<link rel="stylesheet" href="../css/manage.css" />
<link rel="stylesheet" href="../css/popup.css" />
<script type="text/javascript">
<!--

//-->
</script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<iframe src="/hiddens.asp" name="hiddenFrame" frameborder="0" border="0" width="0" height="0" style="display:none;"></iframe>
<div id="popup">
	<!-- <p class="tright" style="padding:5px 0px;"><%=aImg("javascript:openPopReg();",IMG_BTN&"/btn_popup.gif",142,39,"")%><p> -->
	<p class="tright" style="padding:5px 0px;"><%=aImg("javascript:openPopRegGlobal('"&strNationCode&"');",IMG_BTN&"/btn_popup.gif",142,39,"")%><p>
	<table <%=tableatt%> class="adminFullTable list">
		<colgroup>
			<col width="110" />
			<col width="60" />
			<col width="50" />
			<col width="140" />
			<col width="80" />
			<col width="100" />
			<col width="100" />
			<col width="100" />
			<col width="*" />
			<col width="60" />
		</colgroup>
		<thead>
			<tr>
				<th>팝업값</th>
				<th>국가코드</th>
				<th>사용<br />여부</th>
				<th>팝업타이틀</th>
				<!-- <th>팝업<br />미리보기</th> -->
				<th>팝업페이지</th>
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
				SQL = "SELECT * FROM [DK_POPUP] WHERE [strNation] = '"&strNationCode&"' ORDER BY [intIDX] DESC"
				arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,Nothing)

				If IsArray(arrList) Then
					For i = 0 To listLen

						Select Case arrList(10,i)
							Case "P" : popupKind = "일반팝업"
							Case "L" : popupKind = "레이어팝업"
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
						PRINT tabs(3) & "	<td>"&isViewShop&"</td>"
						PRINT tabs(3) & "	<td>"&arrList(5,i)&"px / "&arrList(6,i)&"px</td>"
						PRINT tabs(3) & "	<td>"&arrList(8,i)&"px / "&arrList(9,i)&"px</td>"
						PRINT tabs(3) & "	<td>"&popupKind&"</td>"
						PRINT tabs(3) & "	<td>("&linkType&") "&LinkGo&"</td>"
						PRINT tabs(3) & "	<td><a href=""popup_Modify.asp?thisMode=del&amp;idx="&arrList(0,i)&""" target=""hiddenFrame""><img src="""&IMG_BTN&"/btn_gray_delete.gif""></a></td>"
						PRINT tabs(3) & "</tr>"
					Next

				Else
					PRINT tabs(3) & "<tr>"
					PRINT tabs(3) & "	<td colspan=""10"" class=""notdata"">설정된 팝업이 없습니다.</td>"
					PRINT tabs(3) & "</tr>"
				End If

			%>
		</tbody>
	</table>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
