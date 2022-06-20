<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "GOODS"
	INFO_MODE = "GOODS3-3"


	intIDX = gRequestTF("Gidx",True)
	strNationCode = Request("nc")

	If isCSGOODUSE <> "T" Then Call ALERTS("잘못된 접근입니다.","Back","/admin/goods/Goods_modify.asp?Gidx="&intIDX&"")

	'print isMACCO
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs("DKSP_GOODS_VIEW_A",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		DKRS_intIDX						= DKRS("intIDX")
		DKRS_Category					= DKRS("Category")
		DKRS_DelTF						= DKRS("DelTF")
		DKRS_GoodsType					= DKRS("GoodsType")
		DKRS_GoodsName					= DKRS("GoodsName")
		DKRS_GoodsComment				= DKRS("GoodsComment")
		DKRS_GoodsSearch				= DKRS("GoodsSearch")
		DKRS_GoodsPrice					= DKRS("GoodsPrice")
		DKRS_GoodsCustomer				= DKRS("GoodsCustomer")
		DKRS_GoodsCost					= DKRS("GoodsCost")
		DKRS_GoodsStockType				= DKRS("GoodsStockType")
		DKRS_GoodsStockNum				= DKRS("GoodsStockNum")
		DKRS_GoodsPoint					= DKRS("GoodsPoint")
		DKRS_GoodsMade					= DKRS("GoodsMade")
		DKRS_GoodsProduct				= DKRS("GoodsProduct")
		DKRS_GoodsBrand					= DKRS("GoodsBrand")
		DKRS_GoodsModels				= DKRS("GoodsModels")
		DKRS_GoodsDate					= DKRS("GoodsDate")
		DKRS_GoodsViewTF				= DKRS("GoodsViewTF")
		DKRS_flagBest					= DKRS("flagBest")
		DKRS_flagNew					= DKRS("flagNew")
		DKRS_FlagVote					= DKRS("FlagVote")
		DKRS_GoodsContent				= DKRS("GoodsContent")
		DKRS_GoodsDeliveryType			= DKRS("GoodsDeliveryType")
		DKRS_GoodsDeliveryFee			= DKRS("GoodsDeliveryFee")
		DKRS_GoodsDeliveryLimit			= DKRS("GoodsDeliveryLimit")
		DKRS_GoodsDeliPolicyType		= DKRS("GoodsDeliPolicyType")
		DKRS_GoodsDeliPolicy			= DKRS("GoodsDeliPolicy")
		DKRS_ClickCnt					= DKRS("ClickCnt")
		DKRS_RegID						= DKRS("RegID")
		DKRS_RegDate					= DKRS("RegDate")
		DKRS_RegHost					= DKRS("RegHost")
		DKRS_OptionVal					= DKRS("OptionVal")
		DKRS_GoodsBanner				= DKRS("GoodsBanner")
		DKRS_GoodsNote					= DKRS("GoodsNote")
		DKRS_GoodsNoteColor				= DKRS("GoodsNoteColor")
		DKRS_isCSGoods					= DKRS("isCSGoods")
		DKRS_CSGoodsCode				= DKRS("CSGoodsCode")
		DKRS_intSort					= DKRS("intSort")
		DKRS_flagMain					= DKRS("flagMain")
		DKRS_GoodsMaterial				= DKRS("GoodsMaterial")
		DKRS_GoodsCarton				= DKRS("GoodsCarton")
		DKRS_GoodsSize					= DKRS("GoodsSize")
		DKRS_GoodsColor					= DKRS("GoodsColor")
		DKRS_isShopType					= DKRS("isShopType")
		DKRS_strShopID					= DKRS("strShopID")
		DKRS_isAccept					= DKRS("isAccept")
		DKRS_Img1Ori					= DKRS("Img1Ori")
		DKRS_Img2Ori					= DKRS("Img2Ori")
		DKRS_Img3Ori					= DKRS("Img3Ori")
		DKRS_Img4Ori					= DKRS("Img4Ori")
		DKRS_Img5Ori					= DKRS("Img5Ori")
		DKRS_ImgList					= DKRS("ImgList")
		DKRS_ImgThum					= DKRS("ImgThum")
		DKRS_ImgRelation				= DKRS("ImgRelation")
		DKRS_ImgBanner					= DKRS("ImgBanner")
		DKRS_isViewMemberNot			= DKRS("isViewMemberNot")
		DKRS_isViewMemberAuth			= DKRS("isViewMemberAuth")
		DKRS_isViewMemberDeal			= DKRS("isViewMemberDeal")
		DKRS_isViewMemberVIP			= DKRS("isViewMemberVIP")
		DKRS_intPriceNot				= DKRS("intPriceNot")
		DKRS_intPriceAuth				= DKRS("intPriceAuth")
		DKRS_intPriceDeal				= DKRS("intPriceDeal")
		DKRS_intPriceVIP				= DKRS("intPriceVIP")
		DKRS_intMinNot					= DKRS("intMinNot")
		DKRS_intMinAuth					= DKRS("intMinAuth")
		DKRS_intMinDeal					= DKRS("intMinDeal")
		DKRS_intMinVIP					= DKRS("intMinVIP")
		DKRS_intPointNot				= DKRS("intPointNot")
		DKRS_intPointAuth				= DKRS("intPointAuth")
		DKRS_intPointDeal				= DKRS("intPointDeal")
		DKRS_intPointVIP				= DKRS("intPointVIP")
		DKRS_isImgType					= DKRS("isImgType")
		DKRS_imgMobMain					= DKRS("imgMobMain")
		DKRS_strNationCode				= DKRS("strNationCode")
		DKRS_intCSPrice4				= DKRS("intCSPrice4")
		DKRS_intCSPrice5				= DKRS("intCSPrice5")
		DKRS_intCSPrice6				= DKRS("intCSPrice6")
		DKRS_intCSPrice7				= DKRS("intCSPrice7")
		'DKRS_flagEvent					= DKRS("flagEvent")


	Else
		Call ALERTS("존재하지 않는 상품입니다.","BACK","")

	End If
	Call FN_NationCurrency(DKRS_strNationCode,Chg_CurrencyName,Chg_CurrencyISO)


	CATEGORYS1 = Left(DKRS_Category,3)
	If Len(DKRS_Category) > 3 Then CATEGORYS2 = Left(DKRS_Category,6) Else CATEGORY2 = ""
	If Len(DKRS_Category) > 6 Then CATEGORYS3 = Left(DKRS_Category,9) Else CATEGORY3 = ""

'	PRINT CATEGORYS1
'	PRINT CATEGORYS2
'	PRINT CATEGORYS3

%>
<link rel="stylesheet" href="goods.css" />
<%=CONST_SmartEditor_JS%>
<script type="text/javascript" src="Goods_modify_CS.js?v1"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript">
<!--
	$(document).ready(function(){
		$('#cate1').change(function(){chg_category('category2');}).change();
		$('#cate2').change(function(){chg_category('category3');});

	});

	function chg_category(mode) {

		//mode = "category2";
		var cate
		var cateVal
		var cateID
		if (mode == 'category2')
		{
			cate = $('#cate1').val();
			cateVal = '<%=CATEGORYS2%>'
			cateID = '#cate2'
		} else if (mode == 'category3')
		{
			cate = $('#cate2').val();
			cateVal = '<%=CATEGORYS3%>'
			cateID = '#cate3'
		}

		if (cate.length == 0)
		{
			$(cateID).attr("disabled",true);
			$(cateID).html("<option value=''>상위 카테고리를 선택해주세요.</option>");
		} else {
			$.ajax({
				type: "POST"
				,url: "Category_d2.asp"
				,data: {
					 "mode"				: mode
					,"cate"				: cate
					,"strNationCode"	: '<%=DKRS_strNationCode%>'

				}
				,success: function(data) {
					var FormErrorChk = data.split(",");
					if (FormErrorChk[0] == "FORMERROR")
					{
						alert("필수값:"+FormErrorChk[1]+"가 넘어오지 않았습니다.\n다시 시도해주세요");
						loadings();
					} else {
						$(cateID).attr("disabled",false);
						$(cateID).html(data);
						if (cateVal != ''){$(cateID).val(cateVal);};
						$(cateID).change();
					}
				}
				,error:function(data) {
					loadings();
					alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				}
			});

		}
	}
//-->
</script>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="goods">
	<form name="gform" id="gform" method="post" action="Goods_ModifyOk.asp" enctype="multipart/form-data" onsubmit="return chkGFrm(this);">
		<input type="hidden" name="intIDX" value="<%=intIDX%>" />
		<input type="hidden" name="Ori_Img1Ori" value="<%=DKRS_Img1Ori%>" />
		<input type="hidden" name="Ori_Img2Ori" value="<%=DKRS_Img2Ori%>" />
		<input type="hidden" name="Ori_Img3Ori" value="<%=DKRS_Img3Ori%>" />
		<input type="hidden" name="Ori_Img4Ori" value="<%=DKRS_Img4Ori%>" />
		<input type="hidden" name="Ori_Img5Ori" value="<%=DKRS_Img5Ori%>" />
		<input type="hidden" name="Ori_ImgList" value="<%=DKRS_ImgList%>" />
		<input type="hidden" name="Ori_ImgThum" value="<%=DKRS_ImgThum%>" />
		<input type="hidden" name="Ori_ImgRelation" value="<%=DKRS_ImgRelation%>" />
		<input type="hidden" name="Ori_ImgBanner" value="<%=DKRS_ImgBanner%>" />
		<input type="hidden" name="Ori_imgMobMain" value="<%=DKRS_imgMobMain%>" />
		<input type="hidden" name="strShopID" value="<%=DKRS_strShopID%>" readonly="readonly" />
		<input type="hidden" name="strNationCode" value="<%=DKRS_strNationCode%>" readonly="readonly" />

		<div class="titles">CS 관련</div>
		<table <%=tableatt%>>
			<colgroup>
				<col width="200" />
				<col width="800" />
			</colgroup>
			<tbody>
				<tr>
					<th class="req">CS상품여부 <%=starText%></th>
					<td>
						<label><input type="radio" name="isCSGoods" value="T" <%=isChecked(isCSGoods,"T")%> class="input_check" checked="checked" /> CS상품입니다. <span class="red tweight">(기본 상품 정보는 웹에서 수정 불가)</span></label>
					</td>
				</tr>
				<!-- <tr>
					<th class="req">CS상품여부</th>
					<%If DKRS_isCSGoods = "F" Then%>
					<td>
						<label><input type="radio" name="isCSGoods" value="T" <%=isChecked(DKRS_isCSGoods,"T")%> class="input_check" disabled="disabled" /><span style="color:#cdcdcd;"> CS상품입니다.</span></label>
						<label><input type="radio" name="isCSGoods" value="F" <%=isChecked(DKRS_isCSGoods,"F")%> class="input_check check2" /> 일반상품입니다.</label>
					</td>
					<%Else%>
					<td>
						<label><input type="radio" name="isCSGoods" value="T" <%=isChecked(DKRS_isCSGoods,"T")%> class="input_check" checked="checked" /> CS상품입니다.</label>
						<label><input type="radio" name="isCSGoods" value="F" <%=isChecked(DKRS_isCSGoods,"F")%> class="input_check check2" /> 일반상품입니다.</label>
					</td>
					<%End If%>
				</tr> -->
				<tr id="isCSGoods_toggle" style="di splay:none;">
					<th class="req">CS상품코드 <%=starText%></th>
					<td>
						<input type="text" name="CSGoodsCode" class="input_text" style="width:120px; text-align:center;" value="<%=DKRS_CSGoodsCode%>" readonly="readonly"/>
						<a name="modal" id="" href="pop_CSGoodsModify.asp?ncode=<%=DKRS_CSGoodsCode%>&nc=<%=viewAdminLangCode%>" title="CS상품수정"><input type="button" class="a_submit design3" value="CS상품수정" /></a>
						<!-- <a href="javascript:openCSGoodsModify('<%=DKRS_CSGoodsCode%>','<%=DKRS_strNationCode%>');" class="a_submit design3">CS상품수정</a> -->
						<span id="csGoodsName"></span>
					</td>
				</tr>
			</tbody>
		</table>
		<div class="titles">상품기본정보</div>
		<table <%=tableatt%>>
			<colgroup>
				<col width="200" />
				<col width="300" />
				<col width="200" />
				<col width="300" />
			</colgroup>
			<tbody>
				<tr>
					<th class="req">상품노출 여부 <%=starText%></th>
					<td colspan="3">
						<label><input type="radio" name="GoodsType" value="A" <%=isChecked(DKRS_GoodsType,"A")%> class="input_check" checked="checked" /> 전체노출</label>
						<!-- <label><input type="radio" name="GoodsType" value="H" <%=isChecked(DKRS_GoodsType,"H")%> class="input_check check2" /> 일반샵에서만</label>
						<label><input type="radio" name="GoodsType" value="M" <%=isChecked(DKRS_GoodsType,"M")%> class="input_check check2" /> 모바일샵에서만</label> -->
					</td>
				</tr><tr>
					<th class="req">카테고리 설정 <%=starText%></th>
					<td colspan="3">
						<select id="cate1" name="cate1" class="select2">
							<option value="">상위 메뉴를 선택해주세요.</option>
							<%
								arrParams = Array(_
									Db.makeParam("@strNationCode",adVarChar,adParamInput,6,DKRS_strNationCode), _
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
						<select name="cate2" id="cate2" class="select2" disabled="disabled">
							<option value="">상위 카테고리를 선택해주세요.</option>
						</select>
						<select name="cate3" id="cate3" class="select2" disabled="disabled">
							<option value="">상위 카테고리를 선택해주세요.</option>
						</select>
					</td>
				</tr><tr>
					<th class="req">상품명 <%=starText%></th>
					<td colspan="3"><input type="text" name="GoodsName" class="input_text input_size1" size="100" maxlength="100" value="<%=backword(DKRS_GoodsName)%>" /> (<span class="GoodsName_cnt">0</span> / 100byte)<br />
				</tr>
				<!-- <tr>
					<th class="req">유통사 <%=starText%> </th>
					<td>
						<select name="GoodsProduct" onchange="insertThisValue(this);">
						<%
							SQL = "SELECT * FROM [DK_DELIVERY_FEE_BY_COMPANY] WHERE [isDel] = 'F' ORDER BY [intIDX] ASC"
							arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,Nothing)
							If IsArray(arrList) Then
									PRINT TABS(6)&"	<option value="""" thisattr="""">제조사 선택</option>" &VbCrlf
								For i = 0 To listLen
									PRINT TABS(6)&"<option value="""&arrList(2,i)&""" thisattr="""&arrList(1,i)&""" "&isSelect(DKRS_GoodsProduct,arrList(2,i))&">"&arrList(2,i)&"</option>"&VbCrlf
								Next
							Else
								PRINT TABS(6)&"	<option value=""notBanner"">제조사 등록이 필요합니다.</option>" &VbCrlf
							End If
						%>
						</select>
						<th>유통사ID</th>
						<td><input type="text" name="strShopID" class="input_text size_s1" value="<%=DKRS_strShopID%>" readonly="readonly" /></td>
					</td>
				</tr> -->
				<tr>
					<th>상품설명</th>
					<td colspan="3"><input type="text" name="GoodsComment" class="input_text input_size1" size="100" maxlength="200" value="<%=backword(DKRS_GoodsComment)%>" /> (<span class="GoodsComment_cnt">0</span> / 200byte)</td>
				</tr><tr>
					<th>구성</th>
					<td colspan="3">
						<input type="text" name="GoodsNote" class="input_text input_size1" size="60" maxlength="200" value="<%=backword(DKRS_GoodsNote)%>" />
						<input type="color" id="GoodsNoteColor" name="GoodsNoteColor" value="#<%=DKRS_GoodsNoteColor%>" class="input_text1 color vmiddle" style="width:70px;" maxlength="6" data-hex="true" />
					</td>
				</tr><tr>
					<th>재질</th>
					<td><input type="text" name="GoodsMaterial" class="input_text input_size1" size="40" value="<%=DKRS_GoodsMaterial%>" /></td>
					<th>색상</th>
					<td><input type="text" name="GoodsColor" class="input_text input_size1" size="40" value="<%=DKRS_GoodsColor%>" /></td>
				</tr><tr>
					<th>카톤</th>
					<td><input type="text" name="GoodsCarton" class="input_text size_s1" value="<%=DKRS_GoodsCarton%>" /></td>
					<th>사이즈</th>
					<td><input type="text" name="GoodsSize" class="input_text size_s1" value="<%=DKRS_GoodsSize%>" /></td>
				</tr><tr>
					<th>원산지</th>
					<td><input type="text" name="GoodsMade" class="input_text size_s1" value="<%=backword(DKRS_GoodsMade)%>" /></td>
					<th>브랜드</th>
					<td><input type="text" name="GoodsBrand" class="input_text size_s1" value="<%=DKRS_GoodsBrand%>" /></td>
				</tr><tr>
					<th>모델명</th>
					<td><input type="text" name="GoodsModels" class="input_text size_s1" value="<%=DKRS_GoodsModels%>" /></td>
					<th>출시일</th>
					<td>
						<input type="text" name="GoodsDate" class="input_text size_s1" onclick="openCalendar(event, gform.GoodsDate, 'YYYY-MM-DD');" value="<%=DKRS_GoodsDate%>" readonly="readonly" />
						<a onclick="openCalendar(event, gform.GoodsDate, 'YYYY-MM-DD');" class="cp" ><%=viewImgSt(IMG_ICON&"/icon_date_add.gif",16,16,"","","vmiddle")%></a>
					</td>
				</tr>
			</tbody>
		</table>













		<div class="titles">가격/노출 정보</div>
		<table <%=tableatt%> class="width100 priceTable">
			<colgroup>
				<col width="200" />
				<col width="70" />
				<col width="240" />
				<col width="*" />
				<!-- <col width="230" /> -->
			</colgroup>
			<thead>
				<tr>
					<th>구분</th>
					<th><!-- 노출 --></th>
					<th>가격</th>
					<th>최소구매수량</th>
					<!-- <th>적립금</th> -->
				</tr>
			</thead>
			<tbody>
				<tr>
					<th class="req">소비자가 <%=starText%></th>
					<td ><span class="red" id="viewonly1"><!-- 수정불가 --></span></td><%'소수점 입력 시onlyKeys삭제%>
					<td><input type="text" name="GoodsCustomer" class="input_text input_number" size="20" maxlength="20" value="<%=num2curAdmin(DKRS_GoodsCustomer,strNationCode)%>"  readonly="readonly" />  <!-- <%=Chg_CurrencyName%> --> (<%=Chg_CurrencyISO%>)</td>
					<td></td>
					<!-- <td></td> -->
				</tr><tr>
					<th class="req">공급가 <%=starText%></th>
					<td ><span class="red" id="viewonly2"><!-- 수정불가 --></span></td><%'소수점 입력 시onlyKeys삭제%>
					<td><input type="text" name="GoodsCost" class="input_text input_number" size="20" maxlength="20" value="<%=num2curAdmin(DKRS_GoodsCost,strNationCode)%>"  readonly="readonly"  />  <!-- <%=Chg_CurrencyName%> --> (<%=Chg_CurrencyISO%>)</td>
					<td></td>
					<!-- <td></td> -->
				</tr><tr>
					<th class="req">판매가 <%=starText%></th><%'소수점 입력 시onlyKeys삭제%>
					<!-- <td><label><input type="checkbox" name="isViewMemberNot" value="T" <%=isChecked(DKRS_isViewMemberNot,"T")%> /> 노출</label></td> -->
					<td><label><input type="hidden" name="isViewMemberNot" value="T" <%=isChecked(DKRS_isViewMemberNot,"T")%> /> <span class="red" id="viewonly3"><!-- 수정불가 --></span></label></td>
					<td><input type="text" name="intPriceNot" class="input_text input_number" size="20" maxlength="20" value="<%=num2curAdmin(DKRS_intPriceNot,strNationCode)%>"  readonly="readonly"  />  <!-- <%=Chg_CurrencyName%> --> (<%=Chg_CurrencyISO%>)</td>
					<td><input type="text" name="intMinNot" class="input_text input_number" size="10" maxlength="10" value="<%=DKRS_intMinNot%>" <%=onlyKeys%> /> 개 이상</td>
					<!-- <td><input type="text" name="intPointNot" class="input_text input_number" size="20" maxlength="20" value="<%=DKRS_intPointNot%>" <%=onlyKeys%> /> 원</td> -->
				</tr><!-- <tr>
					<th>인증회원</th>
					<td><label><input type="checkbox" name="isViewMemberAuth" value="T" <%=isChecked(DKRS_isViewMemberAuth,"T")%> /> 노출</label></td>
					<td><input type="text" name="intPriceAuth" class="input_text input_number" size="20" maxlength="20" value="<%=DKRS_intPriceAuth%>" <%=onlyKeys%> /> 원</td>
					<td><input type="text" name="intMinAuth" class="input_text input_number" size="10" maxlength="10" value="<%=DKRS_intMinAuth%>" <%=onlyKeys%> />  개 이상</td>
					<td><input type="text" name="intPointAuth" class="input_text input_number" size="20" maxlength="20" value="<%=DKRS_intPointAuth%>" <%=onlyKeys%> /> 원</td>
				</tr><tr>
					<th>딜러회원</th>
					<td><label><input type="checkbox" name="isViewMemberDeal" value="T" <%=isChecked(DKRS_isViewMemberDeal,"T")%> /> 노출</label></td>
					<td><input type="text" name="intPriceDeal" class="input_text input_number" size="20" maxlength="20" value="<%=DKRS_intPriceDeal%>" <%=onlyKeys%> /> 원</td>
					<td><input type="text" name="intMinDeal" class="input_text input_number" size="10" maxlength="10" value="<%=DKRS_intMinDeal%>" <%=onlyKeys%> />  개 이상</td>
					<td><input type="text" name="intPointDeal" class="input_text input_number" size="20" maxlength="20" value="<%=DKRS_intPointDeal%>" <%=onlyKeys%> /> 원</td>
				</tr><tr>
					<th>VIP회원</th>
					<td><label><input type="checkbox" name="isViewMemberVIP" value="T" <%=isChecked(DKRS_isViewMemberVIP,"T")%> /> 노출</label></td>
					<td><input type="text" name="intPriceVIP" class="input_text input_number" size="20" maxlength="20" value="<%=DKRS_intPriceVIP%>" <%=onlyKeys%> /> 원</td>
					<td><input type="text" name="intMinVIP" class="input_text input_number" size="10" maxlength="10" value="<%=DKRS_intMinVIP%>" <%=onlyKeys%> />  개 이상</td>
					<td><input type="text" name="intPointVIP" class="input_text input_number" size="20" maxlength="20" value="<%=DKRS_intPointVIP%>" <%=onlyKeys%> /> 원</td>
				</tr> -->
				<!-- <tr>
					<th class="req">VIP가 <%=starText%></th>
					<td><span class="red" id="viewonly6">수정불가</span></td>
					<td><input type="text" name="intCSPrice6" class="input_text input_number" size="20" maxlength="20" value="<%=DKRS_intCSPrice6%>" <%=onlyKeys%> />  <%=Chg_CurrencyName%> (<%=Chg_CurrencyISO%>)</td>
					<td></td>
				</tr><tr>
					<th class="req">GOLD가 <%=starText%></th>
					<td><span class="red" id="viewonly7">수정불가</span></td>
					<td><input type="text" name="intCSPrice7" class="input_text input_number" size="20" maxlength="20" value="<%=DKRS_intCSPrice7%>" <%=onlyKeys%> />  <%=Chg_CurrencyName%> (<%=Chg_CurrencyISO%>)</td>
					<td></td>
				</tr> -->
				<tr>
					<th>재고설정</th>
					<td colspan="3">
						<label><input type="radio" name="GoodsStockType" class="input_check" value="I"  <%=isChecked(DKRS_GoodsStockType,"I")%> /> 무제한</label>
						<label><input type="radio" name="GoodsStockType" class="input_check check2" value="N" <%=isChecked(DKRS_GoodsStockType,"N")%> /> 수량</label> <input type="text" name="GoodsStockNum" class="input_text input_number" style="width:40px;" value="<%=DKRS_GoodsStockNum%>" />개
						<label><input type="radio" name="GoodsStockType" class="input_check check2" value="S" <%=isChecked(DKRS_GoodsStockType,"S")%> /> 품절</label>
					</td>
				</tr><tr>
					<th>상품보이기</th>
					<td colspan="3">
						<label><input type="radio" name="GoodsViewTF" value="T" <%=isChecked(DKRS_GoodsViewTF,"T")%> class="input_check" checked="checked" /> 보임</label>
						<label><input type="radio" name="GoodsViewTF" value="F" <%=isChecked(DKRS_GoodsViewTF,"F")%> class="input_check check2" /> 감추기</label>
					</td>
				</tr><tr>
					<th>아이콘 출력</th>
					<td colspan="3">
						<label><input type="checkbox" name="flagBest" class="input_check" value="T" <%=isChecked(DKRS_flagBest,"T")%> /> 베스트 상품에 표시</label>
						<label><input type="checkbox" name="flagNew" class="input_check check2" value="T" <%=isChecked(DKRS_flagNew,"T")%> /> 새로운 상품에 표시</label>
						<label><input type="checkbox" name="flagVote" class="input_check check2" value="T" <%=isChecked(DKRS_flagVote,"T")%> /> 추천 상품에 표시</label>
						<!-- <label><input type="checkbox" name="flagMain" class="input_check check2" value="T" <%=isChecked(DKRS_flagMain,"T")%> /> 메인에 표시</label> -->
						<!-- <label style="cursor:pointer"><input type="checkbox" name="flagEvent" class="input_check check2" value="T" <%=isChecked(flagEvent,"T")%> /> 기획전 상품에 표시</label> -->
					</td>
				</tr><tr>
					<th>비고</th>
					<td colspan="3">
						<ul>
							<li>- 소비자가격은 비회원 구매 불가. 일반 회원부터 구입이 가능합니다.</li>
							<li>- 최소수량 0으로 설정 시 1개부터 구입가능</li>
							<li>- 아이콘 출력 선택 시 메인화면에도 랜덤하게 노출됩니다.</li>
						</ul>
					</td>
				</tr>
			</tbody>
		</table>

		<div class="titles">이미지 정보</div>
		<table <%=tableatt%>>
			<colgroup>
				<col width="200" />
				<col width="800" />
			</colgroup>
			<%
				Function viewPicTF2(ByVal values,ByVal paths)

					Select Case paths
						Case "img1" : thisImg = DKRS_Img1Ori
						Case "img2" : thisImg = DKRS_Img2Ori
						Case "img3" : thisImg = DKRS_Img3Ori
						Case "img4" : thisImg = DKRS_Img4Ori
						Case "img5" : thisImg = DKRS_Img5Ori
						Case "list" : thisImg = DKRS_ImgList
						Case "thum" : thisImg = DKRS_ImgThum
						Case "mobMain" : thisImg = DKRS_imgMobMain
					End Select

					Select Case thisImg
						Case ""
							viewPicTF2 = viewImgSt(IMG_ICON&"/icon_picF.gif",16,16,"","","vmiddle") &"이미지없음"
						Case Else
							viewPicTF2 = "<a href=""javascript:goodsImgView('"&values&"','"&paths&"')"" />"&viewImgSt(IMG_ICON&"/icon_picT.gif",16,16,"","","vmiddle") &"이미지보기</a>"
					End Select

				End Function
			%>
			<!-- <tr>
				<th>이미지 타입</th>
				<td>
					<label><input type="radio" name="isImgType" class="input_check" value="S" <%=isChecked(DKRS_isImgType,"S")%> /> 자체등록</label>
					<label><input type="radio" name="isImgType" class="input_check check2" value="V" <%=isChecked(DKRS_isImgType,"V")%> /> 주소등록</label>
				</td>
			</tr> -->
			<tr><label><input type="hidden" name="isImgType" class="input_check" value="S" <%=isChecked(DKRS_isImgType,"S")%> /></label></tr>
			<tbody>
				<th colspan="2" style="padding:10px 10px;">
					<span class="red">※ 이미지는 <span style="background:yellow;">배경이 불투명한 png 파일</span>로 등록해 주세요.</span><br />
					<span class="red">※ 이미지를 변경하실 때만 삽입하시면 됩니다</span>
				</th>
				<tr>
					<th class="req"><%=starText%> 이미지1</th>
					<td>
						<%=viewPicTF2(DKRS_intIDX,"img1")%> | <input type="file" name="Img1Ori" class="input_text" style="width:450px;" value="" />
						<span class="red">(Size : <%=upImgWidths_Default%> x <%=upImgHeight_Default%>)</span>
					</td>
				</tr><tr>
					<th>이미지2</th>
					<td>
						<%=viewPicTF2(DKRS_intIDX,"img2")%> | <input type="file" name="Img2Ori" class="input_text" style="width:450px;" value="" />
						<span class="red">(Size : <%=upImgWidths_Default%> x <%=upImgHeight_Default%>)</span>
						<%If DKRS_Img2Ori <> "" Then%><span class="fright"><label><input type="checkbox" name="strData2Del" class="input_check" value="T" />삭제&nbsp;</label></span><%End If%>
					</td>
				</tr><tr>
					<th>이미지3</th>
					<td>
						<%=viewPicTF2(DKRS_intIDX,"img3")%> | <input type="file" name="Img3Ori" class="input_text" style="width:450px;" value="" />
						<span class="red">(Size : <%=upImgWidths_Default%> x <%=upImgHeight_Default%>)</span>
						<%If DKRS_Img3Ori <> "" Then%><span class="fright"><label><input type="checkbox" name="strData3Del" class="input_check" value="T" />삭제&nbsp;</label></span><%End If%>
					</td>
				</tr><tr>
					<th>이미지4</th>
					<td>
						<%=viewPicTF2(DKRS_intIDX,"img4")%> | <input type="file" name="Img4Ori" class="input_text" style="width:450px;" value="" />
						<span class="red">(Size : <%=upImgWidths_Default%> x <%=upImgHeight_Default%>)</span>
						<%If DKRS_Img4Ori <> "" Then%><span class="fright"><label><input type="checkbox" name="strData4Del" class="input_check" value="T" />삭제&nbsp;</label></span><%End If%>
					</td>
				</tr><tr>
					<th>이미지5</th>
					<td>
						<%=viewPicTF2(DKRS_intIDX,"img5")%> | <input type="file" name="Img5Ori" class="input_text" style="width:450px;" value="" />
						<span class="red">(Size : <%=upImgWidths_Default%> x <%=upImgHeight_Default%>)</span>
						<%If DKRS_Img5Ori <> "" Then%><span class="fright"><label><input type="checkbox" name="strData5Del" class="input_check" value="T" />삭제&nbsp;</label></span><%End If%>
					</td>
				</tr><tr>
					<th>리스트 이미지</th>
					<td>
						<%=viewPicTF2(DKRS_intIDX,"list")%> | <input type="file" name="ImgList" class="input_text" style="width:450px;" value="" />
						<span class="red">(Size : <%=upImgWidths_List%> x <%=upImgHeight_List%>)</span>
					</td>
				</tr><!-- <tr>
					<th>모바일 메인 이미지</th>
					<td>
						<%=viewPicTF2(DKRS_intIDX,"mobMain")%> | <input type="file" name="imgMobMain" class="input_text" style="width:450px;" value="" />
						<span class="red">(Size : 640 x 340)</span>
					</td>
				</tr> -->
			</tbody>
		</table>

		<!-- <div class="titles">기타정보</div>
		<table <%=tableatt%>>
			<colgroup>
				<col width="200" />
				<col width="800" />
			</colgroup>
			<tbody>
				<tr>
					<th>배너</th>
					<td><label><input type="radio" name="bannerB" value="T" checked="checked" />기본 배너를 사용합니다</label> <label style="margin-left:20px;"><input type="radio" name="bannerB" value="T" />새로운 배너 사용 : </label><input type="file" name="ImgBanner" class="input_text" size="30" maxlength="250" value="" style="" /> <span class="red">(Size : 970px * ∞px)</span></td>
				</tr><tr>
					<th>관련상품</th>
					<td></td>
				</tr>
			</tbody>
		</table> -->


		<div class="titles">상품상세 정보</div>
		<table <%=tableatt%>>
			<colgroup>
				<col width="1000" />
			</colgroup>
			<tbody>
				<tr>
					<td style="padding:0px;">
						<textarea name="GoodsContent" id="ir1" style="width:100%;height:350px;display:none;" cols="50" rows="10"><%=backword(DKRS_GoodsContent)%></textarea>
						<%=FN_Print_SmartEditor("ir1","goods_content",UCase(viewAdminLangCode),"","","")%>
					</td>
				</tr>
			</tbody>
		</table>


		<div class="titles">배송/반품 정보</div>
		<table <%=tableatt%>>
			<colgroup>
				<col width="200" />
				<col width="800" />
			</colgroup>
			<tbody>

				<tr>
					<th>배송비 설정</th>
					<td>
						<table <%=tableatt%> class="notBorTable innerTable">
							<colgroup>
								<col width="180" />
								<col width="590" />
							</colgroup>
							<tr>
								<td class="tweight"><label><input type="radio" name="GoodsDeliveryType" value="BASIC" class="input_check" <%=isChecked("BASIC",DKRS_GoodsDeliveryType)%> /> 기본배송비 적용</label></td>
								<td class="text_small8">기본배송비는 기본설정에서 적용한 금액을 따라갑니다.</td>
							</tr><tr>
								<td class="tweight"><label><input type="radio" name="GoodsDeliveryType" value="SINGLE" class="input_check" <%=isChecked("SINGLE",DKRS_GoodsDeliveryType)%>  /> 단독배송비 적용</label></td>
								<td class="text_small8">기본배송의 무료배송이나 무료배송금액에 상관없이 단독배송비를 적용합니다.</td>
							</tr><tr id="delivery_toggle">
								<td class="tweight">단독배송비</td>
								<td class=""><input type="text" name="GoodsDeliveryFee" class="input_text" value="<%=DKRS_GoodsDeliveryFee%>" /> 원</td>
							</tr>
						</table>
					</td>
				</tr>

				<tr>
					<th rowspan="2">배송/반품안내</th>
					<td>
						<table <%=tableatt%> class="notBorTable innerTable">
							<colgroup>
								<col width="220" />
								<col width="550" />
							</colgroup>
							<tr>
								<td class="tweight"><label><input type="radio" name="GoodsDeliPolicyType" value="B" class="input_check" <%=isChecked("B",DKRS_GoodsDeliPolicyType)%> /> 기본 배송/반품 내용 적용</label></td>
								<td class="text_small8">기본으로 설정된 배송/반품 내용을 적용합니다.</td>
							</tr><tr>
								<td class="tweight"><label><input type="radio" name="GoodsDeliPolicyType" value="S" class="input_check" <%=isChecked("S",DKRS_GoodsDeliPolicyType)%>  /> 별도 배송/반품 내용 적용</label></td>
								<td class="text_small8">해당상품 단독으로 배송/반품 내용을 설정하여 적용합니다.</td>
							</tr>
						</table>
						<div style="width:99%;">
						<textarea name="GoodsDeliPolicy" id="ir2" style="width:100%;height:200px;display:none; background-color:#fff;" cols="50" rows="10"><%=backword(DKRS_GoodsDeliPolicy)%></textarea>
						<%=FN_Print_SmartEditor("ir2","delivery_content",UCase(viewAdminLangCode),"","","")%>
						</div>
					</td>
				</tr>
			</tbody>
		</table>

		<!-- <div class="titles">상품 옵션 설정</div> -->
		<script type="text/javascript">
		<!--
			function fncINPUTADD(form,key)	{
				var form = document.gform;
				if(key == 1) {
					if (form.rowss.value >= 7){
						alert("옵션값은 7개까지 추가 가능합니다.");
						return false;
					}
					var oRow = idUTILCOST.insertRow(-1);
					oRow.onmouseover=function(){idUTILCOST.clickedRowIndex=this.rowIndex};
					var oCell1 = oRow.insertCell(0);
					var oCell2 = oRow.insertCell(1);
					oCell1.innerHTML = "<input type=\"hidden\" name=\"thisRowNum\" value=\""+(parseInt(form.rowss.value)+1)+"\" /><input type = \"text\" name = \"optiontitle\" class=\"input_text\" size=\"24\" maxlength = \"200\" />";
					oCell2.innerHTML = "<input type = \"text\" name = \"optionValues\" class=\"input_text\" style=\"width:555px\" size=\"80\" />";
					form.rowss.value = parseInt(form.rowss.value)+1;
				}else{
					if (form.rowss.value <= 1) {
						alert("옵션값을 없애시려면 상단의 옵션없음을 눌러주세요.");
						return false;
					}
					var oRow = idUTILCOST.deleteRow(-1);
					form.rowss.value = parseInt(form.rowss.value)-1;
				}
			}
			//-->
		</script>

		<input type="hidden" id="OptionN" name="OptionVal" class="input_check" value="F"  /><%'옵션사용시 주석/삭제!! %>
		<%
			If DKRS_OptionVal = "T" Then
				SQL = "SELECT * FROM [DK_GOODS_OPTION] WHERE [GoodsIDX] = ? AND [isUse] = 'T'"
				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
				)
				arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)
		%>
			<table <%=tableatt%>>
				<colgroup>
					<col width="200" />
					<col width="800" />
				</colgroup>
				<tbody>
					<!-- <tr>
						<th class="option">옵션 사용</th>
						<td>
							<label><input type="radio" id="OptionN" name="OptionVal" value="F" onClick="checkOptionKind('F')" />옵션없음</label>
							<label><input type="radio" id="OptionY" name="OptionVal" value="T" onClick="checkOptionKind('T')" checked="checked" />옵션사용</label>
						</td>
					</tr> --><tr id="optionDispT">
						<th>옵션설정</th>
						<td>

							<input type="hidden" id="rowss" name="rowss" value="<%=listLen+1%>" />
							<input type="hidden" name="having" value="T" />
							<table <%=tableatt%> style="width:780px;">
								<tr>
									<td style="text-align:right;">
										<img src="<%=img_icon%>/color_add_i.gif" width="37" height="17" onclick="fncINPUTADD(document.frmUNITCOST,1)" style="cursor:pointer;" />
										<img src="<%=img_icon%>/color_del_i.gif" width="37" height="17" onclick="fncINPUTADD(document.frmUNITCOST,0)" style="cursor:pointer;" />
									</td>
								</tr><tr>
									<td>
										<table border="1" bordercolor="#D9D9D9" cellspacing="0" cellpadding="0" frame="hsides" id="idUTILCOST" style="width:760px;">
											<thead>
												<tr>
													<th style="height:30px; text-align:center;">옵션명</th>
													<th style="height:30px; text-align:center;">옵션값</th>
												</tr>
											</thead>
											<tbody>
											<%
												If IsArray(arrList) Then
													For i = 0 To listLen
											%>
												<tr>
													<td width="170"><input type="hidden" name="thisRowNum" value="<%=arrList(4,i)%>" /><input type="text" name="optiontitle" value ="<%=arrList(2,i)%>" class="input_text" size="24" maxlength="200"></td>
													<td width="*"><input type="text" name="optionValues" class="input_text" size="80" style="width:555px" value ="<%=arrList(3,i)%>"></td>
												</tr>

											<%		Next
												End If
											%>
											</tbody>
										</table>
									</td>
								</tr><tr>
									<td>
										<ul>
											<li>- 상품 옵션을 선택할 수 있습니다.</li>
											<li>- 상품 옵션은 <strong>옵션값:가격\옵션값:가격</strong> 형태로 적어주시면 됩니다. <strong>예) 빨강:3500\파랑:4500 형식</strong></li>
											<li>- 상품 가격이 없을 경우에는 0 으로 기입해주시면 됩니다.</li>
											<li>- 옵션의 모든 값이 0일 경우에는 가격 추가 표시는 뜨지 않습니다.</li>
										</ul>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
		<%Else%>
			<table <%=tableatt%>>
				<colgroup>
					<col width="200" />
					<col width="800" />
				</colgroup>
				<tbody>
					<!-- <tr>
						<th class="option">옵션 사용</th>
						<td>
							<label><input type="radio" id="OptionN" name="OptionVal" value="F" onClick="checkOptionKind('F')" checked="checked" />옵션없음</label>
							<label><input type="radio" id="OptionY" name="OptionVal" value="T" onClick="checkOptionKind('T')"  />옵션사용</label>
						</td>
					</tr> --><tr id="optionDispT" style="display:none;">
						<th>옵션설정</th>
						<td>

							<input type="hidden" id="rowss" name="rowss" value="1" />
							<input type="hidden" name="having" value="F" />
							<table <%=tableatt%> style="width:780px;">
								<tr>
									<td style="text-align:right;">
										<img src="<%=img_icon%>/color_add_i.gif" width="37" height="17" onclick="fncINPUTADD(document.frmUNITCOST,1)" style="cursor:pointer;" />
										<img src="<%=img_icon%>/color_del_i.gif" width="37" height="17" onclick="fncINPUTADD(document.frmUNITCOST,0)" style="cursor:pointer;" />
									</td>
								</tr><tr>
									<td>
										<table border="1" bordercolor="#D9D9D9" cellspacing="0" cellpadding="0" frame="hsides" id="idUTILCOST" style="width:760px;">
											<thead>
											<tr>
												<th style="height:30px; text-align:center;">옵션명</th>
												<th style="height:30px; text-align:center;">옵션값</th>
											</tr>
											</thead>
											<tbody>
											<tr>
												<td width="170"><input type="text" name="optiontitle" value ="사이즈" class="input_text" size="24" maxlength="200"></td>
												<td width="*"><input type="text" name="optionValues" class="input_text" size="80" style="width:555px" value =""></td>
											</tr>
											</tbody>
										</table>
									</td>
								</tr><tr>
									<td>
										<ul>
											<li>- 상품 옵션을 선택할 수 있습니다.</li>
											<li>- 상품 옵션은 <strong class="red">옵션값:판매가격:공급가\옵션값:판매가격:공급가</strong> 형태로 적어주시면 됩니다. <br />&nbsp;&nbsp;<strong style="color:#3366ff;">예) 빨강:3500:2500\파랑:4500:3500 형식</strong></li>
											<li>- 상품 가격이 없을 경우에는 0 으로 기입해주시면 됩니다.</li>
											<li>- 옵션의 모든 값이 0일 경우에는 가격 추가 표시는 뜨지 않습니다.</li>
										</ul>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
		<%End If%>







		<div class="submit_area"><input type="submit" class="input_submit_b design1" value="상품 저장" /></div>



	</form>
</div>

<%
	'cs상품수정 modal
	MODAL_CONTENT_WIDTH = 870
	MODAL_CONTENT_HEIGHT = 450
	MODAL_CSS_TYPE = "BLUE"
%>
<!--#include virtual="/_include/modal_config.asp" -->

<!--#include virtual = "/admin/_inc/copyright.asp"-->
