<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MEMBER"
	INFO_MODE = "MEMBER2-2"
' ===================================================================


' ===================================================================
' 데이터 가져오기
' ===================================================================

	arrList = Db.execRsList("DKPA_NBOARD_WRITER_MATCHING_LIST",DB_PROC,Nothing,listLen,Nothing)

	All_Count = arrParams(UBound(arrParams))(4)

' ===================================================================



%>
<link rel="stylesheet" href="/admin/css/member.css" />
<script type="text/javascript" src="/admin/jscript/member.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="matching_list">
	<p class="titles">매칭 추가<p>
	<form name="frm" method="post" action="matchingHandler.asp" enctype="multipart/form-data" onsubmit="return regThisFrm(this);">
		<input type="hidden" name="mode" value="" />
		<input type="hidden" name="idx" value="" />
		<table <%=tableatt%> class="adminFullTable table_fixed">
			<colgroup>
				<col width="5%" />
				<col width="15%" />
				<col width="65%" />
				<col width="*" />
			</colgroup>
			<thead>
				<tr>
					<th></th>
					<th>매칭작성자</th>
					<th>매칭이미지</th>
					<th>비고</th>
				</tr>
			</thead>
			<tr>
				<td class="tcenter">등록</td>
				<td class="tcenter"><input type="text" name="MatchingID" class="input_text" style="width:130px" value="" /></td>
				<td class="pl1 lh160"><input type="file" name="MatchingImg" class="input_file" style="width:350px;" /> 100px * 25px 이하로 올려주세요.</td>
				<td class="tcenter"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" class="vmiddle" /></td>
			</tr>
		</table>
	</form>
	<p class="titles">매칭 리스트<p>
	<table <%=tableatt%> class="adminFullTable table_fixed">
		<colgroup>
			<col width="5%" />
			<col width="15%" />
			<col width="25%" />
			<col width="40%" />
			<col width="*" />
		</colgroup>
		<thead>
			<tr>
				<th>ID Num</th>
				<th>매칭작성자</th>
				<th>매칭이미지</th>
				<th>변경</th>
				<th>비고</th>
			</tr>
		</thead>
	</table>
	<%
		If IsArray(arrList) Then
			For i = 0 To listLen

				imgPath = VIR_PATH("Matching")&"/"&arrList(2,i)
				imgWidth = 0
				imgHeight = 0
				Call ImgInfo(imgPath,imgWidth,imgHeight,"")
	%>
	<form name="frms<%=i%>" action="matchingHandler.asp" method="post" enctype="multipart/form-data" onsubmit="return chkThisFrm(this);">
		<input type="hidden" name="mode" value="MODIFY">
		<input type="hidden" name="idx" value="<%=arrList(0,i)%>">
		<input type="hidden" name="ori_icon" value="<%=arrList(2,i)%>">
		<table <%=tableatt%> class="adminFullTable table_fixed">
			<colgroup>
				<col width="5%" />
				<col width="15%" />
				<col width="25%" />
				<col width="40%" />
				<col width="*" />
			</colgroup>
			<tr>
				<td class="tcenter"><%=arrList(0,i)%></td>
				<td class="tcenter"><input type="text" name="MatchingID" class="input_text" style="width:130px" value="<%=arrList(1,i)%>" /></td>
				<td class="tcenter lh160"><p><%=viewImg(imgPath,imgWidth,imgHeight,"")%></p><p style="margin-top:5px;"><%=arrList(2,i)%></p></td>
				<td class="pl1 lh160"><input type="file" name="MatchingImg" class="input_file" style="width:350px;" /><br />100px * 25px 이하로 올려주세요.</td>
				<td class="tcenter"><input type="image" src="<%=IMG_BTN%>/btn_gray_update.gif" class="vmiddle" /> <%=aImg("javascript:delThisFrm('"&arrList(0,i)&"')",IMG_BTN&"/btn_gray_delete.gif",45,22,"")%></td>
			</tr>
		</table>
	</form>
	<%
			Next
		Else
			PRINT "	<table "&tableatt&" class=""adminFullTable table_fixed"">"
			PRINT "		<tr>"
			PRINT "			<td class=""notData"">등록된 매칭내역이 없습니다</td>"
			PRINT "		</tr>"
			PRINT "</table>"
		End If
	%>
	</table>


</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
