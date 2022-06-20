<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "GOODS"
	INFO_MODE = "GOODS1-1"

'	Select Case UCase(strNationCode)
'		CASE "KR" : INFO_MODE = "GOODS1-1-1" : INFO_TEXT = "한국"
'		CASE "US" : INFO_MODE = "GOODS1-1-2" : INFO_TEXT = "미국"
'		CASE "CN" : INFO_MODE = "GOODS1-1-3" : INFO_TEXT = "중국"
'		CASE "ID" : INFO_MODE = "GOODS1-1-4" : INFO_TEXT = "인도네시아"
'		CASE "TH" : INFO_MODE = "GOODS1-1-5" : INFO_TEXT = "태국"
'		CASE "EN" : INFO_MODE = "GOODS1-1-6" : INFO_TEXT = "영문"
'		CASE "JP" : INFO_MODE = "GOODS1-1-7" : INFO_TEXT = "일본"
'	End Select


	In_Cate1 = Request("cate1")
	In_Cate2 = Request("cate2")
	In_Cate3 = Request("cate3")
	FCate = Request("cate")





	'print Fcate
	If FCate <> "" Then PARENTS_CATEGORY = FCate
	If In_Cate1 <> "" Then PARENTS_CATEGORY = In_Cate1
	If In_Cate2 <> "" Then PARENTS_CATEGORY = In_Cate2
	If In_Cate3 <> "" Then PARENTS_CATEGORY = In_Cate3

	If PARENTS_CATEGORY = "" Then
		PARENTS_CATEGORY = "000"
	End If


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



%>
<link rel="stylesheet" href="category.css" />
<script type="text/javascript" src="Category.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		$('#cate1').change(function(){chg_category();}).change();

		$("input[type=button][name=submit]").click(function() {

			var upDom = $(this).closest("tr");
			var strCateCode			= upDom.find("input[name=strCateCode]");
			var isView				= upDom.find("select[name=isView]");
			var strCateName			= upDom.find("input[name=strCateName]");
			var OriStrImg			= upDom.find("input[name=OriStrImg]");

			var modFrm = $("form[name=modFrm]");
			$(modFrm).find("input[name=strCateCode]").val(strCateCode.val());
			$(modFrm).find("input[name=OriStrImg]").val(OriStrImg.val());
			$(modFrm).find("input[name=strCateName]").val(strCateName.val());
			$(modFrm).find("input[name=isView]").val(isView.val());

			modFrm.submit();

		});


	});

	function chg_category() {

		mode = "category2";
		cate = $('#cate1').val();
		if (cate.length == 0)
		{
			$("#cate2").attr("disabled",true);
			$("#cate2").html("<option value=''>상위 카테고리를 선택해주세요.</option>");
		} else {
			$.ajax({
				type: "POST"
				,url: "Category_d2.asp"
				,data: {
					 "mode"				: mode
					,"cate"				: cate
					,"strNationCode"	: '<%=viewAdminLangCode%>'

				}
				,success: function(data) {
					var FormErrorChk = data.split(",");
					if (FormErrorChk[0] == "FORMERROR")
					{
						alert("필수값:"+FormErrorChk[1]+"가 넘어오지 않았습니다.\n다시 시도해주세요");
						loadings();
					} else {
						$("#cate2").attr("disabled",false);
						$("#cate2").html(data);
						$("#cate2").val("<%=CATEGORYS2%>");
					}
				}
				,error:function(data) {
					loadings();
					alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				}
			});

		}
	}
</script>
</head>
<body onload="document.frms.strCateName.focus();">
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="selectCate">
	<form name="cateFrm" action="category.asp" method="post">
		<table <%=tableatt%> class="width100">

			<thead>
				<tr>
					<th>카테고리 선택 </th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="tcenter">
						<p>
							<select id="cate1" name="cate1">
								<option value="">상위 메뉴를 선택해주세요.</option>
								<%
									arrParams = Array(_
										Db.makeParam("@strNationCode",adVarChar,adParamInput,6,viewAdminLangCode), _
										Db.makeParam("@strCatrParent",adVarChar,adParamInput,20,"000") _
									)
									arrList = Db.execRsList("DKSP_SHOP_CATEGORY_LIST",DB_PROC,arrParams,listLen,Nothing)
									If Not IsArray(arrList) Then
										PRINT "<option value="""">메뉴가 없습니다.</option>"
									Else
										For i = 0 To listLen
											arrList_intIDX				= arrList(1,i)
											arrList_strCateCode			= arrList(2,i)
											arrList_strCateName			= arrList(3,i)
											arrList_strCateParent		= arrList(4,i)
											arrList_intCateDepth		= arrList(5,i)
											arrList_intCateSort			= arrList(6,i)
											arrList_isView				= arrList(7,i)
											arrList_isBest				= arrList(8,i)
											arrList_isVote				= arrList(9,i)
											arrList_isTopImgView		= arrList(10,i)
											arrList_strTopImg			= arrList(11,i)
											PRINT "<option value="""&arrList_strCateCode&""""& isSelect(CATEGORYS1,arrList_strCateCode)&">"&arrList_strCateName&"</option>"
										Next
									End If
								%>
							</select>
						</p>
						<p>
							<select name="cate2" id="cate2">
								<option value="">상위 카테고리를 선택해주세요.</option>
							</select>
						</p>
						<br />
						<input type="submit" value="하위메뉴로 이동" class="input_submit design3" />
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>


<div id="inCate">
	<form name="frms" method="post" action="Category_Handler.asp" onsubmit="return menuIn(this)" enctype="multipart/form-data">
		<input type="hidden" name="mode" value="INSERT" />
		<input type="hidden" name="intCateDepth" value="<%=C_DEPTH%>" />
		<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
		<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="180" />
				<col width="*" />
			</colgroup>
			<thead>
				<tr>
					<th colspan="4">메뉴 추가</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>메뉴명</td>
					<td ><input type="text" name="strCateName" class="input_text" style="width:300px;" /></td>
				</tr><tr>
					<th>메뉴 보임</td>
					<td class="tds2">
						<label><input type="radio" name="isView" value="T" class="vmiddle" checked="checked" /> 메뉴 보임</label>
						<label><input type="radio" name="isView" value="F" class="vmiddle" /> 메뉴 숨김</label>
					</td>
				</tr><!-- <tr>
					<th>메뉴 타입</th>
					<td class="tds2">
						<label><input type="radio" name="isCateType" value="S" class="vmiddle" checked="checked" onclick="chgCateType(this.value);" /> 쇼핑몰타입</label>
						<label><input type="radio" name="isCateType" value="L" class="vmiddle" onclick="chgCateType(this.value);"  /> 링크 타입</label>
					</td>
				</tr> -->
			</tbody>
			<!-- <tbody id="cate_shop">
				<tr>
					<th>베스트상품 노출</td>
					<td class="tds2">
						<label><input type="radio" name="isBest" value="T" class="vmiddle" /> 상단에 베스트상품 노출</label>
						<label><input type="radio" name="isBest" value="F" class="vmiddle" checked="checked" /> 베스트 상품 노출 숨김</label>
					</td>
				</tr><tr>
					<th>추천상품 노출</td>
					<td class="tds2">
						<label><input type="radio" name="isVote" value="T" class="vmiddle" />상단에 추천상품 노출</label>
						<label><input type="radio" name="isVote" value="F" class="vmiddle" checked="checked" /> 추천상품 노출 숨김</label>
					</td>
				</tr><tr>
					<th>신상품 노출</td>
					<td class="tds2">
						<label><input type="radio" name="isNew" value="T" class="vmiddle" />상단에 신상품 노출</label>
						<label><input type="radio" name="isNew" value="F" class="vmiddle" checked="checked" /> 신상품 노출 숨김</label>
					</td>
				</tr><tr>
					<th>카테고리 상단 이미지</td>
					<td>
						<label><input type="radio" name="isTopImgView" value="T" class="vmiddle" /> 해당 카테고리 이미지 사용</label>
						<label><input type="radio" name="isTopImgView" value="F" class="vmiddle" checked="checked" /> 상위레벨 이미지 보임</label>
					</td>
				</tr><tr>
					<th>카테고리 상단 이미지</td>
					<td class="tds2"><input type="file" name="strTopImg" class="input_file" style="width:380px;" /></td>
				</tr>
			</tbody> -->
			<tbody id="cate_link" style="display:none;">
				<tr>
					<th>링크 타입</td>
					<td class="tds2">
						<label><input type="radio" name="isLinkType" value="S" class="vmiddle" checked="checked" /> 같은창에서 이동</label>
						<label><input type="radio" name="isLinkType" value="B" class="vmiddle" /> 새창으로 이동</label>
					</td>
				</tr><tr>
					<th>링크 주소</td>
					<td class="tds2"><input type="text" name="strLink" class="input_text" style="width:300px;" /></td>
				</tr>
			</tbody>
			<tr>
				<td colspan="2" align="center" style="padding:3px 0px;"><input type="submit" value="카테고리 등록" class="input_submit design1" /></td>
			</tr>
		</table>
	</form>

</div>
<div id="divList">
	<%
	%>

	<table <%=tableatt%> class="width100">
		<colgroup>
			<col width="40" />
			<col width="80" />
			<col width="140" />
			<col width="500" />

			<col width="80" />

			<col width="*" />
		</colgroup>
		<tr>
			<th>번호</th>
			<th>순서</th>
			<th>코드</th>
			<th>메뉴명</th>

			<th>노출</th>
			<!-- <th>베스트</th>
			<th>추천</th>
			<th>신상품</th> -->
			<!-- <th>메뉴명</th> -->

			<th>비고</th>
		</tr>

		<%

			arrParams = Array(_
				Db.makeParam("@strNationCode",adVarChar,adParamInput,6,viewAdminLangCode), _
				Db.makeParam("@strCatrParent",adVarChar,adParamInput,20,PARENTS_CATEGORY) _
			)
			arrList = Db.execRsList("DKSP_SHOP_CATEGORY_LIST",DB_PROC,arrParams,listLen,Nothing)

			styleWidth = 60
			If IsArray(arrList) Then
				For i = 0 To listLen
					arrList_intIDX				= arrList(1,i)
					arrList_strCateCode			= arrList(2,i)
					arrList_strCateName			= arrList(3,i)
					arrList_strCateParent		= arrList(4,i)
					arrList_intCateDepth		= arrList(5,i)
					arrList_intCateSort			= arrList(6,i)
					arrList_isView				= arrList(7,i)
					arrList_isBest				= arrList(8,i)
					arrList_isVote				= arrList(9,i)
					arrList_isNew				= arrList(10,i)
					arrList_isTopImgView		= arrList(11,i)
					arrList_strTopImg			= arrList(12,i)
					arrList_isCateType			= arrList(13,i)
					arrList_isLinkType			= arrList(14,i)
					arrList_strLink				= arrList(15,i)
					arrList_strNationCode		= arrList(16,i)




					If arrList_strTopImg = "" Then
						arrList_isTopImgView_ICON = "<img src="""&IMG_ICON&"/icon_picF.gif"" class=""vmiddle"" alt="""" />"
					Else
						arrList_isTopImgView_ICON = "<a href=""javascript:openImgPop('category','"&arrList_intIDX&"')"" target=""_blank""><img src="""&IMG_ICON&"/icon_picT.gif"" class=""vmiddle"" alt="""" /></a>"
					End If



		%>

			<tr>
				<td><%=arrList_intCateSort%></td>
				<td>
					<a href="javascript:sortUp('<%=arrList_strCateCode%>')" style="font-size:19px;"><i class="fas fa-arrow-circle-up"></i></a>
					<a href="javascript:sortDown('<%=arrList_strCateCode%>')" style="font-size:19px;"><i class="fas fa-arrow-circle-down"></i></i></a>
				</td>
				<td><%=arrList_strCateCode%></td>
				<td><input type="text" name="strCateName" value="<%=arrList_strCateName%>" class="input_text" style="width:90%;" /></td>
				<td>
					<select name="isView" class="select2">
						<option value="T" <%=isSelect(arrList_isView,"T")%>>보임</option>
						<option value="F" <%=isSelect(arrList_isView,"F")%>>숨김</option>
					</select>
				</td>
				<!-- <td>
					<select name="isBest" class="select2">
						<option value="T" <%=isSelect(arrList_isBest,"T")%>>보임</option>
						<option value="F" <%=isSelect(arrList_isBest,"F")%>>숨김</option>
					</select>
				</td>
				<td>
					<select name="isVote" class="select2">
						<option value="T" <%=isSelect(arrList_isVote,"T")%>>보임</option>
						<option value="F" <%=isSelect(arrList_isVote,"F")%>>숨김</option>
					</select>
				</td>
				<td>
					<select name="isNew" class="select2">
						<option value="T" <%=isSelect(arrList_isNew,"T")%>>보임</option>
						<option value="F" <%=isSelect(arrList_isNew,"F")%>>숨김</option>
					</select>
				</td> -->
				<!-- <td>
					<%If arrList_isCateType = "S" Then%>
						<select name="isTopImgView" class="select2">
							<option value="T" <%=isSelect(arrList_isTopImgView,"T")%>>개별</option>
							<option value="F" <%=isSelect(arrList_isTopImgView,"F")%>>상위</option>
						</select>
						<%=arrList_isTopImgView_ICON%>
						<input type="file" name="strTopImg" value="<%=arrList_strCateName%>" class="input_text" style="width:70%;" />
					<%Else%>
						<select name="isLinkType" class="select2">
							<option value="S" <%=isSelect(arrList_isLinkType,"S")%>>같은창</option>
							<option value="B" <%=isSelect(arrList_isLinkType,"B")%>>새 창</option>
						</select>
						<input type="text" name="strLink" value="<%=arrList_strLink%>" class="input_text" style="width:70%;" />
					<%End If%>
				</td> -->

				<td>
					<input type="hidden" name="strCateCode" value="<%=arrList_strCateCode%>" />
					<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
					<input type="hidden" name="OriStrImg" value="<%=arrList_strTopImg%>" />
					<input type="hidden" name="strNationCode" value="<%=arrList_strNationCode%>" />

					<input type="button" name="submit" class="input_submit design1" value="수정" />
					<a href="javascript:delok('<%=arrList_strCateCode%>');" class="a_submit design4">삭제</a>
				</td>
			</tr>

		<%
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

	</table>

</div>

<form name="delFrm" action="Category_Handler.asp" method="post"  enctype="multipart/form-data">
	<input type="hidden" name="mode" value="DELETE" />
	<input type="hidden" name="strCateCode" value="" />
	<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
	<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
</form>
<form name="sortFrm" action="Category_Handler.asp" method="post"  enctype="multipart/form-data">
	<input type="hidden" name="strCateCode" value="" />
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
	<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
</form>


<form name="modFrm" action="Category_Handler.asp" method="post" enctype="multipart/form-data">
	<input type="hidden" name="mode" value="UPDATE" />
	<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
	<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />

	<input type="hidden" value="" name="strCateCode"  />
	<input type="hidden" value="" name="OriStrImg" />
	<input type="hidden" value="" name="strCateName" /></td>
	<input type="hidden" value="" name="isView" /></td>



</form>


<!--#include virtual = "/admin/_inc/copyright.asp"-->
