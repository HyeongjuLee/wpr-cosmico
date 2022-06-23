<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	W1200 = "T"

	ADMIN_LEFT_MODE = "DESIGN"

	bn = Request("bn")			'banner No

	AREA = gRequestTF("area",True)

	IM_DESIGN = Left(AREA,3)
	IM_AREA = Right(AREA,1)

	INFO_MODE = UCase("DESIGN_"&AREA)
	INFO_TEXT = DKRS_FA_strNationName

	Select Case LCase(AREA)
		Case "n01_a01","n02_a01","n03_a01"
		Case "m01_a01"
		Case "m02_a01"
		'Case "s01_a01"
		'Case "s02_a01","s02_a02","s02_a03","s02_a04"
		Case Else
			Call ALERTS("존재하지 않는 영역을 선택하셨습니다.","BACK","")
	End Select

	viewTitle		= "F"
	viewSubTitle	= "F"
	viewDesc		= "F"

	Select Case LCase(AREA)
		Case "n01_a01"	'홈페이지 메인
			IMG_WIDTH	= "2000"
			IMG_HEIGHT	= "900"
			TOPCNT		= 3
		Case "n02_a01" 	'홈페이지 인덱스 new
			IMG_WIDTH  = "440"
			IMG_HEIGHT = "440"
			'TOPCNT	   = 10
			viewTitle = "T"
			viewDesc = "T"
		Case "n03_a01" 	'홈페이지 인덱스 서브
			IMG_WIDTH  = "300"
			IMG_HEIGHT = "300"
			TOPCNT	   = 10
			viewTitle = "T"
			'viewSubTitle	= "T"
			viewDesc		= "T"
		'Case "s01_a01"
		'	IMG_WIDTH  = "2000"
		'	IMG_HEIGHT = "460"
		'	TOPCNT = 4
		'	viewTitle = "T"
		'Case "s02_a01"
		'	IMG_WIDTH  = "600"
		'	IMG_HEIGHT = "600"
		'	TOPCNT = 1
		'Case "s02_a02"
		'	IMG_WIDTH  = "570"
		'	IMG_HEIGHT = "280"
		'	TOPCNT = 1
		'Case "s02_a03","s02_a04"
		'	IMG_WIDTH  = "270"
		'	IMG_HEIGHT = "290"
		'	TOPCNT = 1

		'모바일
		Case "m01_a01"
			IMG_WIDTH  = "640"
			IMG_HEIGHT = "560"
			TOPCNT = 5
		Case "m02_a01"
			IMG_WIDTH  = "300"
			IMG_HEIGHT = "300"
			TOPCNT = 10
			viewTitle = "T"
			'viewSubTitle	= "T"
			viewDesc		= "T"

		'Case "m02_a02"
		'	IMG_WIDTH  = "280"
		'	IMG_HEIGHT = "290"
		'	TOPCNT = 1
		'Case "m02_a03"
		'	IMG_WIDTH  = "280"
		'	IMG_HEIGHT = "290"
		'	TOPCNT = 1
		Case Else
			Call ALERTS("존재하지 않는 영역을 선택하셨습니다.","BACK","")
	End Select

	IMG_ALERT  = "<BLINK><span class=""jBlink red tweight"" style=""font-size:13px;line-height:22px;height:22px;"">"&IMG_WIDTH&"px * "&IMG_HEIGHT&"px</span></BLINK>"

	strTitleMaxLength1	= 30
	strTitleMaxLength2	= 40
	strContentMaxLength = 80
	strContentMaxLength2 = 148
	strTitleMaxRow = 2

%>
<link rel="stylesheet" href="design.css?v=2" />
<script type="text/javascript" src="shop_design_banner.js?v=1"></script>
<link rel="stylesheet" type="text/css" href="/modP/bootstrap/bootstrap.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="design" class="banner_insert fleft width100">
	<div id="bannerRegistForm" class="width100">
		<p class="titles">이미지등록 (<%=UCase(viewAdminLangCode)%>)</p>
		<form name="ifrm" method="post" action="shop_design_banner_handler.asp" enctype="multipart/form-data" onsubmit="return chkImg(this);">
			<input type="hidden" name="mode" value="REGIST" />
			<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
			<input type="hidden" name="IMG_WIDTH" value="<%=IMG_WIDTH%>" />
			<input type="hidden" name="IMG_HEIGHT" value="<%=IMG_HEIGHT%>" />
			<input type="hidden" name="strArea" value="<%=AREA%>" />

			<table <%=tableatt%> class="width100 insert">
				<col width="150" />
				<col width="800" />
				<col width="*" />
				<tr>
					<th>이미지 첨부</th>
					<td><input type="file" name="strImg" class="input_file" style="width:450px" /></td>
					<td><span class="tweight red"><%=IMG_ALERT%></span></td>
				</tr>
				<tr>
					<th>보이기 유무</th>
					<td>
						<span class="dchk chk2"><input type="radio" name="isUse" id="isUse_T" value="T" checked="checked"><label for="isUse_T">즉시 보이기</label></span>
						<span class="dchk chk2 chkS"><input type="radio" name="isUse" id="isUse_F" value="F" ><label for="isUse_F">우선 감추기</label></span>
					</td>
					<td></td>
				</tr>
				<tr>
					<th>링크</th>
					<td>
						<select name="isLink">
							<option value="F">링크 사용 안함</option>
							<option value="T">링크 사용 함</option>
						</select>
						<select name="isLinkTarget" >
							<option value="S">같은창으로</option>
							<option value="B">새창으로</option>
						</select>
						<input type="text" name="strLink" class="input_text " style="width:450px;" />
					</td>
					<td>링크가 있을시에만 삽입</td>
				</tr>
				<%If viewTitle = "T" Then%>
					<tr>
						<th>타이틀</th>
						<td>
							<input type="text" name="strTitle" class="input_text fleft" style="width: 80%;" />
							<div class="remainingTXT fleft">&nbsp;(<span class="count">0</span> / <span class="maxCount"><%=strTitleMaxLength2%></span> byte)
						</td>
						<td class="tweight red">최대 <%=strTitleMaxLength2%> byte 까지 작성 가능합니다.</td>
					</tr>
				<%End If%>
				<%If viewSubTitle = "T" Then%>
					<tr>
						<th>서브 타이틀</th>
						<td>
							<input type="text" name="strSubTitle" class="input_text fleft" style="width: 80%;" />
							<div class="remainingTXT fleft">&nbsp;(<span class="count">0</span> / <span class="maxCount"><%=strContentMaxLength%></span> byte)
						</td>
						<td class="tweight red">최대 <%=strTitleMaxLength2%> byte 까지 작성 가능합니다.</td>
					</tr>
				<%End If%>
				<%If viewDesc = "T" Then%>
					<tr>
						<th>짧은 설명</th>
						<td>
							<textarea name="strScontent" class="input_area fleft" cols="50" rows="10" style="width:80%; height:80px;resize:none;"></textarea>
							<div class="remainingTXT fleft">&nbsp;(<span class="count">0</span> / <span class="maxCount"><%=strContentMaxLength2%></span>byte) / <span class="maxRow"><%=strTitleMaxRow%></span>줄</div>
						</td>
						<td class="tweight red">최대 <%=strContentMaxLength2%> byte / <%=strTitleMaxRow%>줄 까지 작성 가능합니다.</td>
					</tr>
				<%End If%>
				<tr>
					<td colspan="3" class="tcenter"><input type="submit" class="input_submit design1" value="등록" /></td>
				</tr>
			</table>
		</form>
	</div>

	<div id="bannerList">
		<p class="titles">노출 배너 리스트 (<%=UCase(viewAdminLangCode)%>)<span class="f11px tnormal red"></span></p>
		<table <%=tableatt%> class="width100 list">
			<col width="55" />
			<col width="55" />
			<col width="55" />
			<col width="280" />
			<col width="280" />
			<col width="*" />
			<col width="70" />
			<tr>
				<th>우선순위</th>
				<th>정렬</th>
				<th>노출</th>
				<th>이미지</th>
				<th>링크/타겟<br/>링크주소</th>
				<th>기타</th>
				<th>기능</th>
			</tr>
			<%
				Set Image = Server.CreateObject("TABSUpload4.Image")

				viewPoint = 0
				listLenAllCnt = 0
				arrParams = Array(_
					Db.makeParam("@strArea",adVarChar,adParamInput,20,AREA), _
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,viewAdminLangCode) _
				)
				arrList = Db.execRsList("DKSP_SHOP_DESIGN_BANNERS_LIST_ADMIN",DB_PROC,arrParams,listLen,Nothing)
				If IsArray(arrList) Then
					For i = 0 To listLen
						arrList_intIDX          = arrList(0,i)
						arrList_strArea         = arrList(1,i)
						arrList_intSort         = arrList(2,i)
						arrList_isUse           = arrList(3,i)
						arrList_isDel           = arrList(4,i)
						arrList_strTitle        = arrList(5,i)
						arrList_isLink          = arrList(6,i)
						arrList_isLinkTarget    = arrList(7,i)
						arrList_strLink         = BACKWORD(arrList(8,i))
						arrList_strImg          = BACKWORD(arrList(9,i))
						arrList_regDate         = arrList(10,i)
						arrList_regID           = arrList(11,i)
						arrList_regIP			= arrList(12,i)
						arrList_strLink2        = BACKWORD(arrList(13,i))		'모바일링크
						arrList_strNation       = arrList(14,i)
						arrList_strSubTitle     = BACKWORD(arrList(15,i))
						arrList_strScontent     = arrList(16,i)
						arrList_strImg2         = BACKWORD(arrList(17,i))		'추가

						Select Case arrList_isUse
							Case "T" : arrList_isViewIcon = "<a href=""javascript:chgView('"&arrList_intIDX&"','F');""><img src="""&IMG_ICON&"/icon_view.gif"" class=""vmiddle"" alt="""" /></a>"
							Case "F" : arrList_isViewIcon = "<a href=""javascript:chgView('"&arrList_intIDX&"','T');""><img src="""&IMG_ICON&"/icon_hidden.gif"" class=""vmiddle"" alt="""" /></a>"
						End Select

						If arrList_isUse = "T" Then
							viewPoint = viewPoint + 1
						End If

						viewSort = ""
						If viewPoint =< usePoint And arrList_isUse = "T" Then trClass = "trbg" Else trClass = ""
						listLenAllCnt = listLen + 1

						Status = Image.Load(REAL_PATH("shop_design_Banner_T")&"\"&arrList_strImg)
						If Status = Ok Then
							This_imgWidth		= Image.Width
							This_imgHeight		= Image.Height
							Image.Close
						Else
							This_imgWidth		= "이미지 오류"
							This_imgHeight		= "이미지 오류"
						End If

						If arrList_strLink = "#" Then
							viewLink = "없음"
						Else
							viewLink = "<a href="""&arrList_strLink&""" target=""_blank"">"&arrList_strLink&"</a>"
						End If

						Select Case arrList_isLink
							Case "F"	: txtLinks = "<span class=""red"">링크 미사용</span>"
							Case "T"	: txtLinks = "<span class=""blue"">링크 사용</span>"
							Case Else 	: txtLinks = "<span class=""green"">ERROR</span>"
						End Select
						Select Case arrList_isLinkTarget
							Case "S"	: txtTarget = "같은창으로"
							Case "B"	: txtTarget = "새창으로"
							Case Else 	: txtTarget = "ERROR"
						End Select

						txtTitle = ""
						txtSubTitle = ""
						txtContent = ""

						If viewTitle = "T" Then
							txtTitle = "타이틀 : <span class=""strTitle"">" & arrList_strTitle & "</span>"
						End If
						If viewSubTitle = "T" Then
							txtSubTitle = "<br />서브타이틀 : <span class=""strTitle"">" & arrList_strSubTitle & "</span>"
						End If
						If viewDesc = "T" Then
							txtContent = "<hr />짧은설명 : " & arrList_strScontent
						End If

			%>
				<tr id="trBody<%=arrList_intIDX%>">
					<td class="tcenter"><%=arrList_intSort%>
						<input type="hidden" name="intIDX" value="<%=arrList_intIDX%>" />
						<input type="hidden" name="isUse" value="<%=arrList_isUse%>" />
						<input type="hidden" name="OristrImg" value="<%=arrList_strImg%>" />
						<input type="hidden" name="strTitle" value="<%=arrList_strTitle%>" />
						<input type="hidden" name="isLink" value="<%=arrList_isLink%>" />
						<input type="hidden" name="isLinkTarget" value="<%=arrList_isLinkTarget%>" />
						<input type="hidden" name="strLink" value="<%=arrList_strLink%>" />
						<input type="hidden" name="strSubTitle" value="<%=(arrList_strSubTitle)%>" />
						<input type="hidden" name="strScontent" value="<%=BACKWORD_area(arrList_strScontent)%>" />
					</td>
					<td class="tcenter lheight160">
						<a href="javascript:sortUp('<%=arrList_intIDX%>')" style="font-size:19px;"><i class="fas fa-arrow-circle-up"></i></a>
						<a href="javascript:sortDown('<%=arrList_intIDX%>')" style="font-size:19px;"><i class="fas fa-arrow-circle-down"></i></i></a>
					</td>
					<td class="tcenter"><%=arrList_isViewIcon%></td>
					<td class="tleft lheight160">이미지 사이즈 :<%=("<BLINK><span class=""jBlink red tweight"" style=""font-size:13px;line-height:22px;height:22px;"">"&This_imgWidth&"px * "&This_imgHeight&"px</span></BLINK>")%><br />
						<div class="fleft " style="margin-bottom: 10px;">
							<%If arrList_strImg <> "" Then%>
								이미지 : <img src="<%=IMG_ICON%>/icon_picT.gif" alt="" class="vmiddle" /> <strong><a href="<%=VIR_PATH("shop_design_Banner_T")%>/<%=arrList_strImg%>" target="_blank" class="strImg"><%=arrList_strImg%></a></strong>
							<%Else%>
								<span class="fleft10"><strong>이미지 </strong> : <%=viewImgSt(IMG_ICON&"/icon_picF.gif",16,16,"","","vmiddle")%> 이미지 없음</span>
							<%End If%>
						</div>
					</td>
					<td class="tleft lheight160"><%=txtLinks%> / <%=txtTarget%><br /><%=viewLink%></td>
					<td class="lheight160"><%=txtTitle%><%=txtSubTitle%><%=(txtContent)%></td>
					<td class="tcenter">
						<div class="btnArea"><input type="button" class="a_submit design1" value="수정" onclick="openModify('trBody<%=arrList_intIDX%>')" /></div>
						<div class="btnArea"><input type="button" class="a_submit design4" value="삭제" onclick="delThis('<%=arrList_intIDX%>')" /></div>
						<!-- <span class="button icon medium"><span class="check"></span><button type="button" onclick="openModify('trBody<%=arrList_intIDX%>');">수정</button></span><br />
						<span class="button icon medium" style="margin-top:4px;"><span class="delete"></span><a onclick="javascript:delThis('<%=arrList_intIDX%>');">삭제</a></span>						 -->
						<!-- <a href="javascript:delThis('<%=arrList_intIDX%>');"><img src="<%=IMG_BTN%>/btn_gray_delete.gif" alt="" /></a> -->
					</td>
				</tr>
			<%
						If (listLen + 1) <> TOPCNT Then
							If (i+1) = TOPCNT Then
								PRINT "</table>"
								PRINT "<div id=""bannerList2"">"
								PRINT "		<p class=""titles"">비 노출 배너 리스트 <span class=""f11px tnormal red""></span></p>"
								PRINT "		<table "&tableatt&" class=""width100 list"">"
								PRINT "			<col width=""55"" />"
								PRINT "			<col width=""55"" />"
								PRINT "			<col width=""55"" />"
								PRINT "			<col width=""280"" />"
								PRINT "			<col width=""280"" />"
								PRINT "			<col width=""*"" />"
								PRINT "			<col width=""70"" />"
								PRINT "			<tr>"
								PRINT "				<th>우선순위</th>"
								PRINT "				<th>정렬</th>"
								PRINT "				<th>노출</th>"
								PRINT "				<th>이미지</th>"
								PRINT "				<th>링크/타겟<br/>링크주소</th>"
								PRINT "				<th>기타</th>"
								PRINT "				<th>기능</th>"
								PRINT "			</tr>"
							End If
						End If
					Next
				Else
			%>
			<tr>
				<td colspan="7" class="notData">등록된 배너가 없습니다.</td>
			</tr>
			<%
				End If
			%>
		</table>
	</div>

</div>

<!-- Modal 1 S -->
	<div class="modal fade modal_category" id="ModalScrollable1" tabindex="-1" role="dialog" aria-labelledby="ModalScrollableTitle1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-scrollable" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title tweight" id="ModalScrollableTitle1">배너 수정</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				</div>
				<div class="modal-body" id="bannerModify">
					<form name="frmc" method="post" action="shop_design_banner_handler.asp" enctype="multipart/form-data" onsubmit="return menuMode(this)">
						<input type="hidden" name="mode" value="UPDATE" />
						<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
						<input type="hidden" name="IMG_WIDTH" value="<%=IMG_WIDTH%>" />
						<input type="hidden" name="IMG_HEIGHT" value="<%=IMG_HEIGHT%>" />
						<input type="hidden" name="strArea" value="<%=AREA%>" />

						<input type="hidden" name="intIDX" value="" />
						<input type="hidden" name="OristrImg" value="" />
						<table <%=tableatt%> class="width100 insert">
							<col width="150" />
							<col width="*" />
							<col width="150" />
							<tr>
								<th>이미지 첨부</th>
								<td><input type="file" name="strImg" class="input_file" style="width:450px" /></td>
								<td><span class="tweight red"><%=IMG_ALERT%></span></td>
							</tr>
							<tr>
								<th>보이기 유무</th>
								<td>
									<span class="dchk chk2"><input type="radio" name="isUse" id="isUse_T" value="T" checked="checked"><label for="isUse_T">즉시 보이기</label></span>
									<span class="dchk chk2 chkS"><input type="radio" name="isUse" id="isUse_F" value="F" ><label for="isUse_F">우선 감추기</label></span>
								</td>
								<td></td>
							</tr>
							<tr>
								<th>링크</th>
								<td>
									<select name="isLink">
										<option value="F">링크 사용 안함</option>
										<option value="T">링크 사용 함</option>
									</select>
									<select name="isLinkTarget" >
										<option value="S">같은창으로</option>
										<option value="B">새창으로</option>
									</select>
									<input type="text" name="strLink" class="input_text " style="width:450px;" />
								</td>
								<td>링크가 있을시에만 삽입</td>
							</tr>

							<%If viewTitle = "T" Then%>
								<tr>
									<th>타이틀</th>
									<td>
										<input type="text" name="strTitle" class="input_text fleft" style="width: 80%;" />
										<div class="remainingTXT fleft">&nbsp;(<span class="count">0</span> / <span class="maxCount"><%=strTitleMaxLength2%></span> byte)
									</td>
									<td class="tweight red">최대 <%=strTitleMaxLength2%> byte 까지 작성 가능합니다.</td>
								</tr>
							<%	End If%>

							<%If viewSubTitle = "T" Then%>
								<tr>
									<th>서브 타이틀</th>
									<td>
										<input type="text" name="strSubTitle" class="input_text fleft" style="width: 80%;" />
										<div class="remainingTXT fleft">&nbsp;(<span class="count">0</span> / <span class="maxCount"><%=strContentMaxLength%></span> byte)
									</td>
									<td class="tweight red">최대 <%=strTitleMaxLength%> byte 까지 작성 가능합니다.</td>
								</tr>
							<%End If%>
							<%If viewDesc = "T" Then%>
								<tr>
									<th>짧은 설명</th>
									<td>
										<textarea name="strScontent" class="input_area fleft" cols="50" rows="10" style="width:80%; height:80px;resize:none;"></textarea>
										<div class="remainingTXT fleft">&nbsp;(<span class="count">0</span> / <span class="maxCount"><%=strContentMaxLength2%></span>byte) / <span class="maxRow"><%=strTitleMaxRow%></span>줄</div>
									</td>
									<td class="tweight red">최대 <%=strContentMaxLength2%> byte / <%=strTitleMaxRow%>줄 까지 작성 가능합니다.</td>
								</tr>
							<%End If%>
							<tr>
								<td colspan="3" class="tcenter"><input type="submit" class="input_submit design1" value="등록" /></td>
							</tr>
						</table>
					</form>
				</div>
				<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
<!-- Modal 2 E -->
<script src="/modP/bootstrap/bootstrap.bundle.min.js"></script>

<form name="mfrm" method="post" action="shop_design_banner_handler.asp" enctype="multipart/form-data">
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="value1" value="" />
	<input type="hidden" name="IMG_WIDTH" value="<%=IMG_WIDTH%>" />
	<input type="hidden" name="IMG_HEIGHT" value="<%=IMG_HEIGHT%>" />
	<input type="hidden" name="strArea" value="<%=AREA%>" />
	<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
</form>

<script type="text/javascript">

	//배너별 최대 등록갯수 제한
	$(document).ready(function() {
		<%If REGFORM_VIEW_TF = "F" Then%>
			$("#bannerRegistForm").hide();
		<%Else%>
			$("#bannerRegistForm").show();
		<%End If%>
	});

	//BLINK
	function doBlink() {
		var blink = document.all.tags("BLINK")
		for (var i=0; i < blink.length; i++)
		blink[i].style.visibility = blink[i].style.visibility == "" ? "hidden" : ""
	}
	function startBlink() {
		if (document.all)
		setInterval("doBlink()",2000)
	}
	setInterval (function()	{
		$(".jBlink").fadeOut(1000);
	});
	setInterval (function()	{
		$(".jBlink").fadeIn(2000);
	});

</script>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
