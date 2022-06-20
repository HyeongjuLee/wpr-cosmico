<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "DESIGN"

	strloc = gRequestTF("loc",True)

	Select Case strloc
		Case "headerLeft"
			INFO_MODE = "DESIGN1-1"
			IMG_ALERT = "260px * 80px"
		Case "headerLogo"
			INFO_MODE = "DESIGN1-2"
			IMG_ALERT = "330px * 84px"
		Case "indexBanner1"
			INFO_MODE = "DESIGN1-5"
			IMG_ALERT = "245px * 265px"
		Case "indexBanner2"
			INFO_MODE = "DESIGN1-6"
			IMG_ALERT = "245px * 245px"
		Case "indexBanner3"
			INFO_MODE = "DESIGN1-7"
			IMG_ALERT = "330px * 84px"
		Case "botLogo"
			INFO_MODE = "DESIGN1-8"
			IMG_ALERT = "168px * 66px"
		Case Else
			Call ALERTS("정상적인 접근이 아닙니다.","BACK","")
	End Select




%>
<link rel="stylesheet" href="design.css" />
<script type="text/javascript" src="banner.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="design" class="banner_insert">
	<p class="titles">이미지등록</p>
	<form name="ifrm" method="post" action="banner_handler.asp" enctype="multipart/form-data" onsubmit="return chkImg(this);">
		<input type="hidden" name="mode" value="INSERT" />
		<input type="hidden" name="strloc" value="<%=strloc%>" />
		<table <%=tableatt%> class="adminFullWidth insert">
			<col width="150" />
			<col width="550" />
			<col width="*" />
			<tr>
				<th>이미지 첨부</th>
				<td><input type="file" name="strImg" class="input_file" style="width:450px" /></td>
				<td><span class="tweight red"><%=IMG_ALERT%></span> 에 최적화</td>
			</tr><tr>
				<th>링크</th>
				<td>
					<select name="isLink" class="select20 vmiddle">
						<option value="F">링크 사용 안함</option>
						<option value="T">링크 사용 함</option>
					</select>
					<select name="isLinkTarget" class="select20 vmiddle">
						<option value="S">같은창으로</option>
						<option value="B">새창으로</option>
					</select>
					<input type="text" name="strLink" class="input_text vmiddle" style="width:250px" /></td>
				<td>링크가 있을시에만 삽입</td>
			</tr><tr>
				<td colspan="3" class="tcenter"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
			</tr>
		</table>
	</form>

	<%
		arrParams = Array(_
			Db.makeParam("@strLoc",adVarChar,adParamInput,20,strLoc) _
		)
		TEMP_IMG = Db.execRsData("DKP_DESIGN_BANNER_ONE_VIEW_FOR_ADMIN",DB_PROC,arrParams,Nothing)
		If TEMP_IMG <> "" Then
			imgPath = VIR_PATH("banner/"&strLoc)&"/"&TEMP_IMG
			imgWidth = 0
			imgHeight = 0
			Call imgInfo(imgPath,imgWidth,imgHeight,"")
			viewTopImg = viewImg(imgPath,imgWidth,imgHeight,"")

		Else
			viewTopImg = "현재 적용된 이미지가 없습니다."
		End If
	%>
	<div class="preview">
		<p class="titles">현재적용 이미지보기</p>
		<table <%=tableatt%> class="adminFullWidth">
			<tr>
				<td class="tcenter tweight"><%=viewTopImg%></td>
			</tr>
		</table>
	</div>
	<div class="list">

		<p class="titles">리스트</p>
		<table <%=tableatt%> class="adminFullWidth">
			<col width="80" />
			<col width="300" />
			<col width="70" />
			<col width="70" />
			<col width="" />
			<col width="160" />
			<tr>
				<th>사용여부</th>
				<th>이미지명</th>
				<th>넓이</th>
				<th>높이</th>
				<th>링크</th>
				<th>기능</th>
			</tr>
			<%
				arrParams = Array(_
					Db.makeParam("@strLoc",adVarChar,adParamInput,20,strLoc) _
				)
				arrList = Db.execRsList("DKP_DESIGN_BANNER_LIST_FOR_ADMIN",DB_PROC,arrParams,listLen,Nothing)

				If IsArray(arrList) Then
					For i = 0 To listLen

						arrList_intIDX				= arrList(0,i)
						arrList_isUse				= arrList(1,i)
						arrList_isDel				= arrList(2,i)
						arrList_strLoc				= arrList(3,i)
						arrList_isLink				= arrList(4,i)
						arrList_isLinkTarget		= arrList(5,i)
						arrList_strLink				= arrList(6,i)
						arrList_strImg				= arrList(7,i)
						arrList_intImgWidth			= arrList(8,i)
						arrList_intImgHeight		= arrList(9,i)
						arrList_regDate				= arrList(10,i)
						arrList_regID				= arrList(11,i)
						arrList_regIP				= arrList(12,i)

			%>
			<tr>
				<td class="tcenter"><%=TFVIEWER(arrList_isUse,"USE")%></td>
				<td class="imgInfo"><%=aImgOPT(VIR_PATH("banner/"&strLoc)&"/"&backword(arrList_strImg),"B",IMG_ICON&"/icon_picT.gif",16,16,"","class=""vmiddle"" ")%>&nbsp;<%=arrList_strImg%></td>
				<td class="pxinfo tright"><%=arrList_intImgWidth%> px</td>
				<td class="pxinfo tright"><%=arrList_intImgHeight%> px</td>
				<td class="imgInfo">
					<%
						If arrList_isLink = "T" Then
							PRINT TFVIEWER(arrList_isLinkTarget,"LINKTARGET")
							PRINT "<a href="""&arrList_strLink&""" target=""_blank"">"&cutString2(arrList_strLink,20)&"</a>"
						Else
							PRINT "링크 사용하지 않음"
						End If

					%>
				</td>
				<td class="tcenter">
					<%=aImgOPT("javascript:submitThisLine('"&arrList_intIDX&"','USE','T')","S",IMG_BTN&"/btn_isUseT.gif",45,22,"","")%>
					<%=aImgOPT("javascript:submitThisLine('"&arrList_intIDX&"','USE','F')","S",IMG_BTN&"/btn_isUseF.gif",45,22,"","")%>
					<%=aImgOPT("javascript:submitThisLine('"&arrList_intIDX&"','DELETE','T')","S",IMG_BTN&"/btn_gray_delete.gif",45,22,"","")%>
				</td>
			</tr>
			<%
					Next
				Else
			%>
			<tr>
				<td colspan="6" class="notData"></td>
			</tr>
			<%
				End If
			%>
		</table>
	</div>
</div>
<form name="mfrm" method="post" action="banner_handler.asp" enctype="multipart/form-data">
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="strloc" value="<%=strloc%>" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="values" value="" />
</form>
<!--#include virtual = "/admin/_inc/copyright.asp"-->