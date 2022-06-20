<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE7-1"





%>
<link rel="stylesheet" href="cloudTag.css" />
<script type="text/javascript" src="cloudTag.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="manage" class="banner_insert">
	<p class="titles">태그 입력</p>
	<form name="ifrm" method="post" action="cloudTag_handler.asp" onsubmit="return chkImg(this);">
		<input type="hidden" name="mode" value="REGIST" />
		<table <%=tableatt%> class="adminFullWidth insert">
			<col width="150" />
			<col width="550" />
			<col width="*" />
			<tr>
				<th>태그명</th>
				<td>
					<input type="text" name="strTag" class="input_text vmiddle" style="width:250px" /></td>
				<td>15자 내외로 작성해주세요. </td>
			</tr><tr>
				<td colspan="3" class="tcenter"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
			</tr>
		</table>
	</form>



	<p class="titles">리스트 <span class="f11px tnormal red"></span></p>
	<table <%=tableatt%> class="width100 list">
		<col width="*" />
		<col width="190" />
		<tr>

			<th>태그</th>
			<th>기능</th>
		</tr>
		<%
			arrList = Db.execRsList("DKPA_CLOUDTAG_LIST",DB_PROC,Nothing,listLen,Nothing)
			If IsArray(arrList) Then
				For i = 0 To listLen
					arrList_intIDX      	= arrList(0,i)
					arrList_isDel       	= arrList(1,i)
					arrList_isUse       	= arrList(2,i)
					arrList_strTag      	= arrList(3,i)
					arrList_strLink     	= arrList(4,i)
					arrList_regDate     	= arrList(5,i)

					Select Case arrList_isUse
						Case "T" : arrList_isViewIcon = "<a href=""javascript:chgView('"&arrList_intIDX&"','F');""><img src="""&IMG_ICON&"/icon_view.gif"" class=""vmiddle"" alt="""" /></a>"
						Case "F" : arrList_isViewIcon = "<a href=""javascript:chgView('"&arrList_intIDX&"','T');""><img src="""&IMG_ICON&"/icon_hidden.gif"" class=""vmiddle"" alt="""" /></a>"
					End Select
		%>
		<tr <%=trClass%>>

			<td class="tcenter"><%=arrList_strTag%></td>
			<td class="tcenter">
				<a href="javascript:delThis('<%=arrList_intIDX%>');"><img src="<%=IMG_BTN%>/btn_gray_delete.gif" alt="" /></a>
			</td>
		</tr>
		<%
				Next
			Else
		%>
		<tr>
			<td colspan="6" class="notData">등록된 인덱스 비주얼 배너가 없습니다.</td>
		</tr>
		<%
			End If
		%>
	</table>






</div>
<form name="mfrm" method="post" action="cloudTag_handler.asp">
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="value1" value="" />
</form>
<!--#include virtual = "/admin/_inc/copyright.asp"-->