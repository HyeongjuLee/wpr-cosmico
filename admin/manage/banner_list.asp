<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE7-1"


%>
<link rel="stylesheet" href="banner.css" />
<script type="text/javascript" src="banner.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="design" class="partner">
	<div class="fleft" >
		<p class="titles">현재 설정된 이미지</p>
		<div class="cleft bor_a tcenter ovhi" style="width:250px; padding-bottom:50px;">
			<div class="" style="width:185px; margin:0 auto;">
			<p style="margin-top:30px;"><%=viewIMG(IMG_MANAGE&"/partner_banner_top.jpg",185,40,"")%></p>
			<%

				arrList = Db.execRsList("DKP_PARTNER_BANNER_LIST",DB_PROC,Nothing,listLen,Nothing)

				If IsArray(arrList) Then
					For i = 0 To listLen

						arrList_intIDX				= arrList(0,i)
						arrList_isUse				= arrList(1,i)
						arrList_isDel				= arrList(2,i)
						arrList_isType				= arrList(3,i)
						arrList_intSort				= arrList(4,i)
						arrList_strLink				= arrList(5,i)
						arrList_strImg				= arrList(6,i)
						arrList_regDate				= arrList(7,i)
						arrList_regID				= arrList(8,i)
						arrList_regIP				= arrList(9,i)


						If i Mod 2 = 0 Then
							divClass = "fleft"
						Else
							divClass = "fright"
						End If

						imgWidth = 0
						imgHeight = 0
						imgPath = VIR_PATH("banner/partner/")&backword(arrList_strImg)
						Call imgInfo(imgPath,imgWidth,imgHeight,"")

						Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")

							Select Case arrList_isType
								Case "P" : PRINT "<div class="""&divClass&" partner_ban bor_a"">"&viewImgOPT(imgPath,imgWidth,imgHeight,"","")&"</div>"
								Case "S"
									arrList_strLink		= Trim(StrCipher.Decrypt(arrList_strLink,EncTypeKey1,EncTypeKey2))		'아이디
									PRINT "<div class="""&divClass&" partner_ban bor_a"">"&aImgOPT(arrList_strLink,"B",imgPath,imgWidth,imgHeight,"","")&"</div>"
								Case "B"
									arrList_strLink		= Trim(StrCipher.Decrypt(arrList_strLink,EncTypeKey1,EncTypeKey2))		'아이디
									PRINT "<div class="""&divClass&" partner_ban bor_a"">"&aImgOPT(arrList_strLink,"B",imgPath,imgWidth,imgHeight,"","")&"</div>"
							End Select
						Set StrCipher = Nothing

					Next
				Else
			%>
				<p class="tcenter" style="padding:50px 0px;">설정된 배너가 없습니다.</p>
			<%
				End If
			%>
			</div>
		</div>


	</div>


	<div class="fright" style="margin-left:20px;">
		<p class="titles">이미지 등록</p>
		<form name="ifrm" method="post" action="banner_handler.asp" enctype="multipart/form-data" onsubmit="return chkImg(this);">
			<input type="hidden" name="mode" value="REGIST" />
			<input type="hidden" name="strloc" value="index_right" />
			<table <%=tableatt%> style="width:720px;">
				<col width="110" />
				<col width="400" />
				<col width="*" />
				<tr>
					<th>이미지 첨부</th>
					<td class="tdpl"><input type="file" name="strImg" class="input_file" style="width:340px" /></td>
					<td class="tdpl"><span class="tweight red">90 * 60</span> 에 최적화</td>
				</tr><tr>
					<th>배너타입</th>
					<td class="tdpl">
						<label><input type="radio" name="isType" value="P" class="input_radio vmiddle" checked="checked" /> 검색어</label>
						<label><input type="radio" name="isType" value="B" class="input_radio vmiddle" /> 새창링크</label>
						<label><input type="radio" name="isType" value="S" class="input_radio vmiddle" /> 같은창링크</label>
					</td>
					<td class="tdpl"></td>
				</tr><tr>
					<th>검색어/링크</th>
					<td class="tdpl"><input type="text" name="strLink" class="input_text vmiddle" style="width:250px" /> </td>
					<td class="tdpl">(링크로 사용시 http:// 포함)</td>
				</tr><tr>
					<th>사용여부</th>
					<td class="tdpl">
						<label><input type="radio" name="isUse" class="input_radio vmiddle" value="T" checked="checked" /> 즉시사용</label>
						<label><input type="radio" name="isUse" class="input_radio vmiddle" value="F" /> 사용보류</label>
					</td>
					<td class="tdpl"></td>
				</tr><tr>
					<td colspan="3" class="tcenter"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
				</tr>
			</table>
		</form>
		<div class="cleft">
			<p class="titles">리스트</p>
			<table <%=tableatt%> style="width:720px;">
				<col width="60" />
				<col width="200" />

				<col width="*" />
				<col width="200" />
				<tr>
					<th>사용여부</th>
					<th>이미지명</th>
					<th>검색어</th>
					<th>기능</th>
				</tr>
				<%
					arrParams = Array(_
						Db.makeParam("@strLoc",adVarChar,adParamInput,20,"index_right") _
					)
					arrList = Db.execRsList("DKPA_DESIGN_BANNER_LIST",DB_PROC,arrParams,listLen,Nothing)
					Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")

					If IsArray(arrList) Then
						For i = 0 To listLen
							arrList_intIDX		= arrList(0,i)
							arrList_isUse		= arrList(1,i)
							arrList_isDel		= arrList(2,i)
							arrList_isType		= arrList(3,i)
							arrList_intSort		= arrList(4,i)
							arrList_strLink		= arrList(5,i)
							arrList_strImg		= arrList(6,i)
							arrList_regDate		= arrList(7,i)
							arrList_regID		= arrList(8,i)
							arrList_regIP		= arrList(9,i)
							arrList_strLink		= Trim(StrCipher.Decrypt(arrList_strLink,EncTypeKey1,EncTypeKey2))		'아이디


				%>
				<tr>
					<td class="tcenter"><%=TFVIEWER(arrList_isUse,"USE")%></td>
					<td class="imgInfo tdpl"><%=viewImgOPT(IMG_ICON&"/icon_picT.gif",16,16,"","class=""vmiddle"" ")%>&nbsp;<%=arrList_strImg%></td>
					<td class="imgInfo tdpl">
						<select name="isType<%=arrList_intIDX%>" class="select20" id="isType<%=arrList_intIDX%>" >
							<option value="P" <%=isSelect(arrList_isType,"P")%>>검색어</option>
							<option value="B" <%=isSelect(arrList_isType,"B")%>>새창링크</option>
							<option value="S" <%=isSelect(arrList_isType,"S")%>>같은창링크</option>
						</select>
						<input type="text"  name="strLink<%=arrList_intIDX%>" id="strLink<%=arrList_intIDX%>" value="<%=arrList_strLink%>" class="input_text" style="width:135px;" />
						<input type="hidden" name="isType<%=arrList_intIDX%>" id="isType<%=arrList_intIDX%>" value="<%=arrList_strLink%>" />
					</td>
					<td class="tcenter">
						<%
							If arrList_isUse = "T" Then
								PRINT aImgOPT("javascript:submitThisLine('"&arrList_intIDX&"','USE','F')","S",IMG_BTN&"/btn_chg_useF_85.gif",85,22,"","")
							Else
								PRINT aImgOPT("javascript:submitThisLine('"&arrList_intIDX&"','USE','T')","S",IMG_BTN&"/btn_chg_useT_85.gif",85,22,"","")
							End If
						%>
						<%=aImgOPT("javascript:modifyThisLine('strLink"&arrList_intIDX&"','isType"&arrList_intIDX&"','"&arrList_intIDX&"','MODIFY')","S",IMG_BTN&"/btn_gray_update.gif",45,22,"","")%>
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
					Set StrCipher = Nothing

				%>
			</table>
		</div>
	</div>
</div>

<form name="mfrm" method="post" action="banner_handler.asp" enctype="multipart/form-data">
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="values" value="" />	<!-- strLink -->
	<input type="hidden" name="values2" value="" /><!-- isType -->
</form>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
