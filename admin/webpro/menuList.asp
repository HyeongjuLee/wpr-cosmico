<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-4"


	In_Cate1 = Request("cate1")
	In_Cate2 = Request("cate2")
	In_Cate3 = Request("cate3")
	FCate = Request("cate")

	If FCate <> "" Then PARENTS_CATEGORY = FCate
	If In_Cate1 <> "" Then PARENTS_CATEGORY = In_Cate1
	If In_Cate2 <> "" Then PARENTS_CATEGORY = In_Cate2
	If In_Cate3 <> "" Then PARENTS_CATEGORY = In_Cate3

	If PARENTS_CATEGORY = "" Then
		PARENTS_CATEGORY = "000"
	End If
'	PRINT PARENTS_CATEGORY

	If PARENTS_CATEGORY <> "000" Then
		CATEGORYS1 = Left(PARENTS_CATEGORY,3)
		If Len(PARENTS_CATEGORY) > 3 Then
			CATEGORYS2 = Left(PARENTS_CATEGORY,6)
			If Len(PARENTS_CATEGORY) > 9 Then
			CATEGORYS3 = Left(PARENTS_CATEGORY,9)
			End If
		End If
	End If

	If Len(PARENTS_CATEGORY) = 3 Then C_DEPTH = "2" End If
	If Len(PARENTS_CATEGORY) = 6 Then C_DEPTH = "3" End If
	If PARENTS_CATEGORY = "000" Then C_DEPTH = "1" End If

	Set DKRS = Db.execRs("DKPA_CATEGORY_DEFAULT_COLOR_VIEW",DB_PROC,Nothing,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_OVERCOLOR			= DKRS("OverColor")
		DKRS_OUTCOLOR			= DKRS("OutColor")
		DKRS_SUBOVERCOLOR		= DKRS("subOverColor")
		DKRS_SUBOUTCOLOR		= DKRS("subOutColor")
		DKRS_LEFTOVERCOLOR		= DKRS("leftOverColor")
		DKRS_LEFTOUTCOLOR		= DKRS("leftOutColor")

		DKRS_OVERCOLOR2D		= DKRS("OverColor2d")
		DKRS_OutColor2d			= DKRS("OutColor2d")
		DKRS_subOverColor2d		= DKRS("subOverColor2d")
		DKRS_subOutColor2d		= DKRS("subOutColor2d")
		DKRS_leftOverColor2d	= DKRS("leftOverColor2d")
		DKRS_leftOutColor2d		= DKRS("leftOutColor2d")

		DKRS_OverColor3d		= DKRS("OverColor3d")
		DKRS_OutColor3d			= DKRS("OutColor3d")
		DKRS_subOverColor3d		= DKRS("subOverColor3d")
		DKRS_subOutColor3d		= DKRS("subOutColor3d")
		DKRS_leftOverColor3d	= DKRS("leftOverColor3d")
		DKRS_leftOutColor3d		= DKRS("leftOutColor3d")

	Else
		DKRS_OVERCOLOR			= "000000"
		DKRS_OUTCOLOR			= "000000"
		DKRS_SUBOVERCOLOR		= "000000"
		DKRS_SUBOUTCOLOR		= "000000"
		DKRS_LEFTOVERCOLOR		= "000000"
		DKRS_LEFTOUTCOLOR		= "000000"

		DKRS_OverColor2d		= "000000"
		DKRS_OutColor2d			= "000000"
		DKRS_subOverColor2d		= "000000"
		DKRS_subOutColor2d		= "000000"
		DKRS_leftOverColor2d	= "000000"
		DKRS_leftOutColor2d		= "000000"

		DKRS_OverColor3d		= "000000"
		DKRS_OutColor3d			= "000000"
		DKRS_subOverColor3d		= "000000"
		DKRS_subOutColor3d		= "000000"
		DKRS_leftOverColor3d	= "000000"
		DKRS_leftOutColor3d		= "000000"

	End If

	Select Case C_DEPTH
		Case 1
			DKRS_OVERCOLOR			= DKRS_OVERCOLOR
			DKRS_OUTCOLOR			= DKRS_OUTCOLOR
			DKRS_SUBOVERCOLOR		= DKRS_SUBOVERCOLOR
			DKRS_SUBOUTCOLOR		= DKRS_SUBOUTCOLOR
			DKRS_LEFTOVERCOLOR		= DKRS_LEFTOVERCOLOR
			DKRS_LEFTOUTCOLOR		= DKRS_LEFTOUTCOLOR
		Case 2
			DKRS_OVERCOLOR			= DKRS_OVERCOLOR2D
			DKRS_OUTCOLOR			= DKRS_OUTCOLOR2D
			DKRS_SUBOVERCOLOR		= DKRS_SUBOVERCOLOR2D
			DKRS_SUBOUTCOLOR		= DKRS_SUBOUTCOLOR2D
			DKRS_LEFTOVERCOLOR		= DKRS_LEFTOVERCOLOR2D
			DKRS_LEFTOUTCOLOR		= DKRS_LEFTOUTCOLOR2D
		Case 3
			DKRS_OVERCOLOR			= DKRS_OVERCOLOR3D
			DKRS_OUTCOLOR			= DKRS_OUTCOLOR3D
			DKRS_SUBOVERCOLOR		= DKRS_SUBOVERCOLOR3D
			DKRS_SUBOUTCOLOR		= DKRS_SUBOUTCOLOR3D
			DKRS_LEFTOVERCOLOR		= DKRS_LEFTOVERCOLOR3D
			DKRS_LEFTOUTCOLOR		= DKRS_LEFTOUTCOLOR3D
	End Select


	If C_DEPTH > 1 Then
		SQL = "SELECT [PkPageSetting] FROM [DK_CATEGORY] WHERE [strCateCode] = ?"
		arrParams = Array(_
			Db.makeParam("@strCateCode",adVarChar,adParamInput,20,PARENTS_CATEGORY) _
		)
		PkPageSetting = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
	End If

'	PRINT In_Cate1
'	PRINT In_Cate2
'	PRINT In_Cate3

%>
<link rel="stylesheet" href="webpro.css" />
<script type="text/javascript" src="/jscript/mColorPicker.js"></script>
<script type="text/javascript" src="menu.js"></script>
<script type="text/javascript">
<!--

$(document).ready(function(){
	$('#cate1')
	  .change(function(){
		chg_category();
	  });
});

function chg_category() {
	createRequest();
	var url = 'menuCate.asp';

	var f = document.cateFrm;
	var cate1, cate2
		cate1 = f.cate1.value;
		cate2 = f.cate2.value;

	postParams = "cate1=" + cate1;
	postParams += "&cate2=" + cate2;

	request.open("POST",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				//var newContentSplit = newContent.split("||")
				//alert(newContent);
				document.getElementById("select2nd").innerHTML = newContent;
				$("#cate2 > option[value='<%=IN_CATE2%>']").attr("selected",true);

				//alert(document.getElementById("innerMask").innerHTML);
			} else {
				alert("ajax error");
			}
		  }
		}
	request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
	request.send(postParams);
	return;
}
//-->
</script>
</head>
<body onload="document.frms.strCateNameKor.focus();chg_category();">


<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="selectCate">
	<form name="cateFrm" action="menuList.asp" method="post">
		<table <%=tableatt%>>
			<colgroup>
				<col width="190" />
			</colgroup>
			<thead>
				<tr>
					<th>카테고리 선택 </th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><select id="cate1" name="cate1" class="select20" onchange="chg_category();">
						<option value="">메뉴를 선택해주세요.</option>
						<%
							arrParams = Array(_
								Db.makeParam("@strCatrParent",adVarChar,adParamInput,20,"000") _
							)
							arrList = Db.execRsList("DKPA_CATEGORY_WEBPRO_LIST",DB_PROC,arrParams,listLen,Nothing)
							If Not IsArray(arrList) Then
								PRINT "<option value="""">메뉴가 없습니다.</option>"
							Else
								For i = 0 To listLen
									PRINT "<option value="""&arrList(2,i)&""""& isSelect(CATEGORYS1,arrList(2,i))&">"&arrList(4,i)&"</option>"
								Next
							End If
						%>
						</select>
						<p id="select2nd" style="margin-top:10px;">
							<select id="cate2" name="cate2" disabled="disabled">
								<option value="">상위 메뉴 선택</option>
							</select>
						</p>
						<br />
						<input type="submit" value="메뉴 이동" class="submit" />
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>
<div id="inCate">
	<form name="frms" method="post" action="menuHandler.asp" enctype="multipart/form-data" onsubmit="return menuIn(this)">
	<input type="hidden" name="mode" value="INSERT" />
	<input type="hidden" name="intCateDepth" value="<%=C_DEPTH%>" />
	<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
	<table <%=tableatt%> style="width:800px;">
		<colgroup>
			<col width="20%" />
			<col width="30%" />
			<col width="20%" />
			<col width="30%" />
		</colgroup>
		<thead>
			<tr>
				<th colspan="4">메뉴 추가</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td class="tds1">메뉴명</td>
				<td class="tds2" colspan="3"><input type="text" name="strCateNameKor" class="input_text" style="width:200px;" /> ※ 메인 메뉴에 맞춰서 설정해주세요.</td>
			</tr><tr>
				<td class="tds1">메뉴명(영어)</td>
				<td class="tds2" colspan="3"><input type="text" name="strCateNameEng" class="input_text" style="width:200px;" /> ※ 메인 메뉴에 맞춰서 설정해주세요.</td>
			</tr><tr>
				<td class="tds1">고유값(영어)</td>
				<td class="tds2" colspan="3"><input type="text" name="PkPageSetting" class="input_text" value="<%=PkPageSetting%>" style="width:200px;" /> ※ 메인메뉴의 경우 중복되면 안됩니다.</td>
			</tr><tr>
				<td class="tds1">메인 위치 조정</td>
				<td class="tds2"><input type="text" name="intMainAxisX" class="input_text tright" style="width:120px;" <%=onlyKeys%>  /> PX</td>
				<td class="tds1">서브 위치 조정</td>
				<td class="tds2"><input type="text" name="intSubAxisX" class="input_text tright" style="width:120px;" <%=onlyKeys%>  /> PX</td>
			</tr><tr>
				<td class="tds1">메뉴 보임</td>
				<td class="tds2">
					<label><input type="radio" name="isView" value="T" class="vmiddle" checked="checked" /> 메뉴 보임</label>
					<label><input type="radio" name="isView" value="F" class="vmiddle" /> 메뉴 숨김</label>
				</td>
				<td class="tds1">서브 메뉴 보임</td>
				<td class="tds2">
					<label><input type="radio" name="isSubView" value="T" class="vmiddle" checked="checked" /> 서브메뉴 보임</label>
					<label><input type="radio" name="isSubView" value="F" class="vmiddle"  /> 서브메뉴 숨김</label>
				</td>
			</tr><tr>
				<td class="tds1">링크 처리</td>
				<td class="tds2" colspan="3">
					<select name="isShop" class="vmiddle">
						<option value="T">쇼핑몰</option>
						<option value="F" selected="selected">일반링크</option>
					</select>
					<select name="isTargetType" class="vmiddle">
						<option value="S" selected="selected">같은창에서</option>
						<option value="B">새창으로</option>
					</select>
					http://<input type="text" name="strLinkURL" class="input_text vmiddle" style="width:400px;"  value="포럼은 도메인을 제외한 주소를 넣어야합니다." onFocus="this.value=''" />
				</td>
			</tr><tr>
				<td class="tds1">메인 컬러조정</td>
				<td class="tds2" colspan="3">
					마우스 오버시 : <input type="color" id="overColor" name="overColor" value="<%=DKRS_OVERCOLOR%>" class="input_text2 color vmiddle" style="width:70px;" maxlength="6" data-hex="true" />
					마우스 아웃시 : <input type="color" id="outColor" name="outColor" value="<%=DKRS_OUTCOLOR%>" class="input_text2 color vmiddle" style="width:70px;" maxlength="6" data-hex="true" /> (16진수 WebColor 로 입력하셔야합니다.)
				</td>
			</tr><tr>
				<td class="tds1">서브 컬러조정</td>
				<td class="tds2" colspan="3">
					마우스 오버시 : <input type="color" id="subOverColor" name="subOverColor" value="<%=DKRS_SUBOVERCOLOR%>" class="input_text2 color vmiddle" style="width:70px;" maxlength="6" data-hex="true" />
					마우스 아웃시 : <input type="color" id="subOutColor" name="subOutColor" value="<%=DKRS_SUBOUTCOLOR%>" class="input_text2 color vmiddle" style="width:70px;" maxlength="6" data-hex="true" /> (16진수 WebColor 로 입력하셔야합니다.)
				</td>
			</tr><tr>
				<td class="tds1">레프트 컬러조정</td>
				<td class="tds2" colspan="3">
					마우스 오버시 : <input type="color" id="leftOverColor" name="leftOverColor" value="<%=DKRS_LEFTOVERCOLOR%>" class="input_text2 color vmiddle" style="width:70px;" maxlength="6" data-hex="true" />
					마우스 아웃시 : <input type="color" id="leftOutColor" name="leftOutColor" value="<%=DKRS_LEFTOUTCOLOR%>" class="input_text2 color vmiddle" style="width:70px;" maxlength="6" data-hex="true" /> (16진수 WebColor 로 입력하셔야합니다.)
				</td>
			</tr><tr>
				<td colspan="4" align="center" style="padding:3px 0px;"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
			</tr>
		</tbody>
	</table>
	</form>
</div>
<div id="divList">
	<%
		col_width01 = 40
		col_width02 = 45
		col_width03 = 70
		col_width04 = 100

		col_width05 = 140


		col_width06 = 120
		col_width07 = 170
		col_width08 = 115
		col_width09 = 115
		col_width10 = 70

		col_width11 = 110
		col_width12 = 50
	%>
	<table <%=tableatt%> style="width:1000px;">
		<colgroup>
			<col width="<%=col_width01%>" />
			<col width="<%=col_width02%>" />
			<col width="<%=col_width03%>" />
			<col width="<%=col_width04%>" />

			<col width="<%=col_width05%>" />
			<col width="<%=col_width06%>" />

			<col width="<%=col_width07%>" />

			<col width="<%=col_width08%>" />
			<col width="<%=col_width09%>" />

			<col width="*" />
		</colgroup>
			<tr>
				<th>번호</th>
				<th>순서</th>
				<th>코드</th>
				<th>노출</th>

				<th>메뉴명</th>
				<th>좌표</th>

				<th>링크처리</th>

				<th>오버컬러</th>
				<th>아웃컬러</th>

				<th>비고</th>
			</tr>
	</table>
	<%
		arrParams = Array(_
			Db.makeParam("@strCatrParent",adVarChar,adParamInput,20,PARENTS_CATEGORY) _
		)
		arrList = Db.execRsList("DKPA_CATEGORY_WEBPRO_LIST",DB_PROC,arrParams,listLen,Nothing)

		styleWidth = 60
		If IsArray(arrList) Then
			For i = 0 To listLen
				arr_intIDX					= arrList(1,i)
				arr_strCateCode				= arrList(2,i)
				arr_PkPageSetting			= arrList(3,i)
				arr_strCateNameKor			= arrList(4,i)
				arr_strCateNameEng			= arrList(5,i)
				arr_strCateParent			= arrList(6,i)
				arr_intCateDepth			= arrList(7,i)
				arr_intCateSort				= arrList(8,i)
				arr_isShop					= arrList(9,i)
				arr_isView					= arrList(10,i)
				arr_isSubView				= arrList(11,i)
				arr_isTargetType			= arrList(12,i)
				arr_strLinkURL				= arrList(13,i)
				arr_intMainAxisX			= arrList(14,i)
				arr_intSubAxisX				= arrList(15,i)
				arr_intLetterSpacing		= arrList(16,i)
				arr_OverColor				= arrList(17,i)
				arr_OutColor				= arrList(18,i)
				arr_subOverColor			= arrList(19,i)
				arr_subOutColor				= arrList(20,i)
				arr_leftOverColor			= arrList(21,i)
				arr_leftOutColor			= arrList(22,i)
				arr_isTopImgMenu			= arrList(23,i)
				arr_TopImgOn				= arrList(24,i)
				arr_TopImgOff				= arrList(25,i)
				arr_LeftImgTop				= arrList(26,i)
				arr_LeftImgBottom			= arrList(27,i)
				arr_isLeftImgMenu			= arrList(28,i)
				arr_leftImgOn				= arrList(29,i)
				arr_leftImgOff				= arrList(30,i)


				PRINT "	<form name=""frmc"" method=""post"" action=""menuHandler.asp"" enctype=""multipart/form-data"" onsubmit=""return menuMode(this)"">" & VbCrlf
				PRINT "	<input type=""hidden"" name=""mode"" value=""UPDATE"" />" & VbCrlf
				PRINT "	<input type=""hidden"" name=""strCateCode"" value="""&arr_strCateCode&""" />" & VbCrlf
				PRINT "	<input type=""hidden"" name=""strCateParent"" value="""&arr_strCateParent&""" />" & VbCrlf
				'PRINT "	<input type=""hidden"" name=""OriStrImg"" value="""&arrList(18,i)&""" />" & VbCrlf
				PRINT "	<table "&tableatt&" style=""width:1000px;"">" & VbCrlf
				PRINT "		<colgroup>" & VbCrlf
				PRINT "			<col width="""&col_width01&""" />"
				PRINT "			<col width="""&col_width02&""" />"
				PRINT "			<col width="""&col_width03&""" />"
				PRINT "			<col width="""&col_width04&""" />"
				PRINT "			<col width="""&col_width05&""" />"
				PRINT "			<col width="""&col_width06&""" />"
				PRINT "			<col width="""&col_width07&""" />"
				PRINT "			<col width="""&col_width08&""" />"
				PRINT "			<col width="""&col_width09&""" />"
				PRINT "			<col width=""*"" />"
				PRINT "		</colgroup>"
				PRINT "		<tr>"
				PRINT "			<td>"&arr_intCateSort&"</td>"
				PRINT "			<td>"
									RESPONSE.WRITE "<p>"&viewImgStJS(IMG_BTN&"/cate_up.gif",16,16,"","","bor1 vmiddle cp","onclick=""sortUp('"&arr_strCateCode&"')""")&"</p>"
									RESPONSE.WRITE "<p>"&viewImgStJS(IMG_BTN&"/cate_down.gif",16,16,"","margin-top:2px;","bor1 vmiddle cp","onclick=""sortDown('"&arr_strCateCode&"')""")&"</p>"
				PRINT "			</td>"
				PRINT "			<td>"&arrList(2,i)&"</td>"
				PRINT "			<td>"
									RESPONSE.WRITE "<p style=""margin-left:4px;"">메인 : <select name=""isView"">"
									RESPONSE.WRITE "	<option value=""T"" "&isSelect("T",arr_isView)&">보임</option>"
									RESPONSE.WRITE "	<option value=""F"" "&isSelect("F",arr_isView)&">숨김</option>"
									RESPONSE.WRITE "</select></p>"
									RESPONSE.WRITE "<p style=""margin-left:4px;"">서브 : <select name=""isSubView"">"
									RESPONSE.WRITE "	<option value=""T"" "&isSelect("T",arr_isSubView)&">보임</option>"
									RESPONSE.WRITE "	<option value=""F"" "&isSelect("F",arr_isSubView)&">숨김</option>"
									RESPONSE.WRITE "</select></p>"
				PRINT "			</td>"
				PRINT "			<td class=""tweight"">"
									RESPONSE.WRITE "<p>한 : <input type=""text"" name=""strCateNameKor"" value="""&arr_strCateNameKor&""" class=""input_text"" style=""width:90px;"" /></p>"
									RESPONSE.WRITE "<p>영 : <input type=""text"" name=""strCateEName"" value="""&arr_strCateNameEng&""" class=""input_text"" style=""width:90px;"" /></p>"
									RESPONSE.WRITE "<p>값 : <input type=""text"" name=""PkPageSetting"" value="""&arr_PkPageSetting&""" class=""input_text"" style=""width:90px;"" /></p>"
				PRINT "			</td>"
				PRINT "			<td>"
									RESPONSE.WRITE "<p>메인위치 : <input type=""text"" name=""intMainAxisX"" value="""&arr_intMainAxisX&""" class=""input_text"" style=""width:30px;"" "
									RESPONSE.WRITE onlyKeys
									RESPONSE.WRITE " /></p>"
									RESPONSE.WRITE "<p>서브위치 : <input type=""text"" name=""intSubAxisX"" value="""&arr_intSubAxisX&""" class=""input_text"" style=""width:30px;"" "
									RESPONSE.WRITE onlyKeys
									RESPONSE.WRITE " /></p>"
									RESPONSE.WRITE "<p>글자간격 : <input type=""text"" name=""intLetterSpacing"" value="""&arr_intLetterSpacing&""" class=""input_text"" style=""width:30px;"" /></p>"
									RESPONSE.WRITE ""
				PRINT "			</td>"
				PRINT "			<td class=""tleft"">"
									RESPONSE.WRITE "<p style=""margin-left:4px;"">타입 : <select name=""isShop"">"
									RESPONSE.WRITE "	<option value=""T"" "&isSelect("T",arr_isShop)&">쇼핑몰</option>"
									RESPONSE.WRITE "	<option value=""F"" "&isSelect("F",arr_isShop)&">일반</option>"
									RESPONSE.WRITE "</select></p>"
									RESPONSE.WRITE "<p style=""margin-left:4px;"">타겟 : <select name=""isTargetType"">"
									RESPONSE.WRITE "	<option value=""S"" "&isSelect("S",arr_isTargetType)&">같은창</option>"
									RESPONSE.WRITE "	<option value=""B"" "&isSelect("B",arr_isTargetType)&">새창</option>"
									RESPONSE.WRITE "</select></p>"
									RESPONSE.WRITE "<p style=""margin-left:4px;"">주소 : <input type=""text"" name=""strLinkURL"" value="""&arr_strLinkURL&""" class=""input_text"" style=""width:110px;"" /></p>"
				PRINT "			</td>"

				PRINT "			<td class=""tweight"">"
									RESPONSE.WRITE "메 : <input type=""color"" id=""overColor"&i&""" name=""OverColor"" value="""&arr_OverColor&"""class=""input_text2 color vmiddle"" style=""width:55px;"" maxlength=""6"" data-hex=""true"" /><br />"
									RESPONSE.WRITE "서 : <input type=""color"" id=""toverColor"&i&""" name=""subOverColor"" value="""&arr_subOverColor&"""class=""input_text2 color vmiddle"" style=""width:55px;"" maxlength=""6"" data-hex=""true"" /><br />"
									RESPONSE.WRITE "좌 : <input type=""color"" id=""loverColor"&i&""" name=""leftOverColor"" value="""&arr_leftOverColor&"""class=""input_text2 color vmiddle"" style=""width:55px;"" maxlength=""6"" data-hex=""true"" /></td>"
				PRINT "			<td class=""tweight"">"
									RESPONSE.WRITE "메 : <input type=""color"" id=""outColors"&i&""" name=""outColor"" value="""&arr_OutColor&""" class=""input_text2 color vmiddle"" style=""width:55px;"" maxlength=""6"" data-hex=""true"" /><br />"
									RESPONSE.WRITE "서 : <input type=""color"" id=""toutColors"&i&""" name=""subOutColor"" value="""&arr_subOutColor&""" class=""input_text2 color vmiddle"" style=""width:55px;"" maxlength=""6"" data-hex=""true"" /><br />"
									RESPONSE.WRITE "좌 : <input type=""color"" id=""loutColors"&i&""" name=""leftOutColor"" value="""&arr_leftOutColor&""" class=""input_text2 color vmiddle"" style=""width:55px;"" maxlength=""6"" data-hex=""true"" /></td>"
				PRINT "			<td><p><input type=""image"" src="""&IMG_BTN&"/btn_modify.gif"" class=""vmiddle"" /></p><p style=""margin-top:3px;""><img src="""&IMG_BTN&"/btn_del.gif"" width=""34"" height=""17"" alt=""현재행삭제"" class=""cp vmiddle"" onclick=""delok('"&arrList(2,i)&"')"" /></p></td>"
				PRINT "		</tr>"
				PRINT "	</table>"
				PRINT "	</form>"

			Next
		Else
				PRINT "	<table "&tableatt&" style=""width:1000px;"">" & VbCrlf
				PRINT "		<colgroup>" & VbCrlf
				PRINT "			<col width="""&col_width01&""" />"
				PRINT "			<col width="""&col_width02&""" />"
				PRINT "			<col width="""&col_width03&""" />"
				PRINT "			<col width="""&col_width04&""" />"
				PRINT "			<col width="""&col_width05&""" />"
				PRINT "			<col width="""&col_width06&""" />"
				PRINT "			<col width="""&col_width07&""" />"
				PRINT "			<col width="""&col_width08&""" />"
				PRINT "			<col width="""&col_width09&""" />"
				PRINT "			<col width=""*"" />"
				PRINT "		</colgroup>"
				PRINT "		<tr>"
				PRINT "			<td colspan=""11"" height=""80""> 등록된 카테고리가 없습니다.</td>"
				PRINT "		</tr>"
				PRINT "	</table>"
				PRINT "	</form>"
		End If


	%>



</div>

<form name="delFrm" action="menuHandler.asp" method="post" enctype="multipart/form-data" >
<input type="hidden" name="mode" value="DELETE" />
<input type="hidden" name="strCateCode" value="" />
<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
</form>
<form name="sortFrm" action="menuHandler.asp" method="post" enctype="multipart/form-data" >
<input type="hidden" name="strCateCode" value="" />
<input type="hidden" name="mode" value="" />
<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
</form>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
