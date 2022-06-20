<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "DESIGN"

'	strloc = gRequestTF("loc",True)


			INFO_MODE = "DESIGN1-9"
			IMG_ALERT = "높이 80px을 맞춰주세요. (가로 사이즈 상관없음)"




%>
<link rel="stylesheet" href="design.css" />
<script type="text/javascript" src="rolling_banner.js"></script>
<script type="text/javascript" src="/jscript/jquery.rolling.js"></script>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="design" class="banner_insert">
	<p class="titles">이미지등록</p>
	<form name="ifrm" method="post" action="rolling_banner_handler.asp" enctype="multipart/form-data" onsubmit="return chkImg(this);">
		<input type="hidden" name="mode" value="INSERT" />
		<table <%=tableatt%> class="adminFullWidth insert">
			<col width="150" />
			<col width="500" />
			<col width="*" />
			<tr>
				<th>이미지 첨부</th>
				<td><input type="file" name="strImg" class="input_file" style="width:450px" /></td>
				<td><span class="tweight red"><%=IMG_ALERT%></span></td>
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
		SQL = "SELECT * FROM [DK_DESIGN_ROLLING] WHERE [isDel] = 'F' AND [isUse] = 'T' ORDER BY [intSort] ASC"
		'arrParams = Array(_
		'	Db.makeParam("@strLoc",adVarChar,adParamInput,20,strLoc) _
		')

		arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,Nothing)

	%>
	<p class="titles">현재적용 이미지보기</p>
	<div class="preview">
		<div id="DB_banner10">
				<div class="DB_mask">
					<ul class="DB_imgSet">
					<%
						If IsArray(arrList) Then
							For i = 0 To listLen
								arrList_intIDX			= arrList(0,i)
								arrList_intSort			= arrList(1,i)
								arrList_isUse			= arrList(2,i)
								arrList_isDel			= arrList(3,i)
								arrList_isLink			= arrList(4,i)
								arrList_isLinkTarget	= arrList(5,i)
								arrList_strLink			= arrList(6,i)
								arrList_strImg			= arrList(7,i)

								Select Case arrList_isLinkTarget
									Case "S" : targets = "target=""_self"""
									Case "B" : targets = "target=""_blank"""
								End Select
								If arrList_isLink = "T" Then
									linkF = "<a href="""&arrList_strLink&""">"
									linkL = "</a>"
								Else
									linkF = "<a href=""#"">"
									linkL = "</a>"
								End If

					%>
						<li><%=linkF%>><img src="<%=VIR_PATH("rolling")%>/<%=BACKWORD(arrList_strImg)%>" alt=""/><%=linkL%></li>
					<%
							Next
							For i = 0 To listLen
								arrList_intIDX			= arrList(0,i)
								arrList_intSort			= arrList(1,i)
								arrList_isUse			= arrList(2,i)
								arrList_isDel			= arrList(3,i)
								arrList_isLink			= arrList(4,i)
								arrList_isLinkTarget	= arrList(5,i)
								arrList_strLink			= arrList(6,i)
								arrList_strImg			= arrList(7,i)

								Select Case arrList_isLinkTarget
									Case "S" : targets = "target=""_self"""
									Case "B" : targets = "target=""_blank"""
								End Select
								If arrList_isLink = "T" Then
									linkF = "<a href="""&arrList_strLink&""">"
									linkL = "</a>"
								Else
									linkF = "<a href=""#"">"
									linkL = "</a>"
								End If

					%>
						<li><%=linkF%>><img src="<%=VIR_PATH("rolling")%>/<%=BACKWORD(arrList_strImg)%>" alt=""/><%=linkL%></li>
					<%
							Next
						End If
					%>

					</ul>
				</div>
				<span class="DB_dir DB_prev"><img src="<%=IMG_SHARE%>/prevBtn.gif" alt=""/></span>
				<span class="DB_dir DB_next"><img src="<%=IMG_SHARE%>/nextBtn.gif" alt=""/></span>
			</div>
			<script type="text/javascript">
					$('#DB_banner10').DB_slideLogoMove({
						key:'',                   //라이센스키
						moveSpeed:15,             //이동속도(밀리초)
						overMoveSpeed:15         //버튼오버속도
					});
			</script>
	</div>
	<div class="list">

		<p class="titles">리스트</p>
		<table <%=tableatt%> class="adminFullWidth">
			<col width="80" />
			<col width="50" />
			<col width="80" />
			<col width="300" />
			<col width="" />
			<col width="160" />
			<tr>
				<th>사용여부</th>
				<th>순서</th>
				<th>순서변경</th>
				<th>이미지명</th>
				<th>링크</th>
				<th>기능</th>
			</tr>
			<%
				'arrParams = Array(_
				'	Db.makeParam("@strLoc",adVarChar,adParamInput,20,strLoc) _
				')
				arrList = Db.execRsList("DKPA_DESIGN_ROLLING_LIST",DB_PROC,Nothing,listLen,Nothing)

				If IsArray(arrList) Then
					For i = 0 To listLen

						arrList_intIDX				= arrList(0,i)
						arrList_intSort				= arrList(1,i)
						arrList_isUse				= arrList(2,i)
						arrList_isDel				= arrList(3,i)
						arrList_isLink				= arrList(4,i)
						arrList_isLinkTarget		= arrList(5,i)
						arrList_strLink				= arrList(6,i)
						arrList_strImg				= arrList(7,i)
						arrList_regDate				= arrList(8,i)
						arrList_regID				= arrList(9,i)
						arrList_regIP				= arrList(10,i)

			%>
			<tr>
				<td class="tcenter"><%=TFVIEWER(arrList_isUse,"USE")%></td>
				<td class="tcenter"><%=arrList_intSort%></td>
				<td class="tcenter">
				<%
					RESPONSE.WRITE "<span >"&viewImgStJS(IMG_BTN&"/cate_up.gif",16,16,"","","bor1 vmiddle cp","onclick=""submitThisLine('"&arrList_intIDX&"','SORTUP','')""")&"</span>"
					RESPONSE.WRITE "<span >"&viewImgStJS(IMG_BTN&"/cate_down.gif",16,16,"","margin-left:2px;","bor1 vmiddle cp","onclick=""submitThisLine('"&arrList_intIDX&"','SORTDOWN','')""")&"</span>"
				%>
				</td>
				<td class="imgInfo"><%=aImgOPT(VIR_PATH("banner/"&strLoc)&"/"&backword(arrList_strImg),"B",IMG_ICON&"/icon_picT.gif",16,16,"","class=""vmiddle"" ")%>&nbsp;<%=arrList_strImg%></td>
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
<form name="mfrm" method="post" action="rolling_banner_handler.asp" enctype="multipart/form-data">
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="values" value="" />
</form>
<!--#include virtual = "/admin/_inc/copyright.asp"-->