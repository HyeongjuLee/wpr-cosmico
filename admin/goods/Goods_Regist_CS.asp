<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "GOODS"
	INFO_MODE = "GOODS3-2"

	arrParams_FA = Array(Db.makeParam("@strNationCode",adVarChar,adParamInput,6,viewAdminLangCode))
	Set DKRS_FA = Db.execRs("DKSP_SITE_NATION_VIEW",DB_PROC,arrParams_FA,Nothing)
	If Not DKRS_FA.BOF And Not DKRS_FA.EOF Then
		DKRS_FA_strNationName	= DKRS_FA("strNationName")
		DKRS_FA_intSort			= DKRS_FA("intSort")
	Else
		Call ALERTS("설정되지 않은 국가입니다!","BACK","")
	End If

	INFO_TEXT = DKRS_FA_strNationName

	Call FN_NationCurrency(viewAdminLangCode,Chg_CurrencyName,Chg_CurrencyISO)


%>
<link rel="stylesheet" href="Goods.css" />
<%=CONST_SmartEditor_JS%>
<script type="text/javascript" src="Goods_Regist_CS.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript">
<!--
	$(document).ready(function(){
		$('#cate1').change(function(){chg_category('category2');}).change();
		$('#cate2').change(function(){chg_category('category3');});
		//$('#Binded').jPicker();
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
					,"strNationCode"	: '<%=viewAdminLangCode%>'
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
						$(cateID).val(cateVal);
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
	<form name="gform" id="gform" method="post" action="Goods_Regist_CSOk.asp" enctype="multipart/form-data" onsubmit="return chkGFrm(this);">
		<input type="hidden" name="MODE" value="INSERT" />
		<input type="hidden" name="strShopID" value="<%=MAINVENDOR%>" readonly="readonly"/>
		<input type="hidden" name="isImgType" value="S"  readonly="readonly"/>
		<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />

		<div class="titles">CS 관련</div>
		<table <%=tableatt%>>
			<colgroup>
				<col width="200" />
				<col width="800" />
			</colgroup>
			<tbody>
				<tr>
					<th class="req">CS상품여부 <%=starText%></th>
					<!-- <td>
						<label><input type="radio" name="isCSGoods" value="T" <%=isChecked(isCSGoods,"T")%> class="input_check"  disabled="disabled"/><span style="color:#cdcdcd;"> CS상품입니다.</span></label>
						<label><input type="radio" name="isCSGoods" value="F" <%=isChecked(isCSGoods,"F")%> class="input_check check2" checked="checked"/> 일반상품입니다.</label>
					</td> -->
					<td>
						<label><input type="radio" name="isCSGoods" value="T" <%=isChecked(isCSGoods,"T")%> class="input_check" style="display: none;" checked="checked" /> CS상품입니다. <span class="red tweight">(기본 상품 정보는 웹에서 수정 불가)</span></label>
					</td>
				</tr><tr id="isCSGoods_toggle" style="display:none;">
					<th class="req">CS상품코드 <%=starText%></th>
					<td>
						<input type="text" name="CSGoodsCode" class="input_text" style="width:120px; text-align:center;" value="" readonly="readonly"/>
						<a name="modal" id="" href="pop_CSGoodsSearch.asp?nc=<%=viewAdminLangCode%>" title="CS상품검색"><input type="button" class="a_submit design3" value="CS상품검색" /></a>
						<!-- <a href="javascript:openCSGoodsSearch('<%=viewAdminLangCode%>');" class="a_submit design3">CS상품검색</a> -->
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
				</tr>
				<!-- <tr>
					<th class="req">상품 소속 몰 <%=starText%></th>
					<td colspan="3">
						<label><input type="radio" name="GoodsMall" value="E" class="input_check" checked="checked" /> 이벤트몰</label>&nbsp;
						<label><input type="radio" name="GoodsMall" value="1" class="input_check" /> 1몰</label>&nbsp;
						<label><input type="radio" name="GoodsMall" value="2" class="input_check" /> 2몰</label>&nbsp;
						<label><input type="radio" name="GoodsMall" value="3" class="input_check" /> 3몰</label>&nbsp;
						<label><input type="radio" name="GoodsMall" value="4" class="input_check" /> 4몰</label>&nbsp;
					</td>
				</tr> -->
				<tr>
					<th class="req">카테고리 설정 <%=starText%></th>
					<td colspan="3">
						<select id="cate1" name="cate1" class="select2">
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
						<select name="cate2" id="cate2" class="select2" disabled="disabled">
							<option value="">상위 카테고리를 선택해주세요.</option>
						</select>
						<select name="cate3" id="cate3" class="select2" disabled="disabled">
							<option value="">상위 카테고리를 선택해주세요.</option>
						</select>
					</td>
				</tr><tr>
					<th class="req">상품명 <%=starText%></th>
					<td colspan="3"><input type="text" name="GoodsName" class="input_text input_size1" size="100" maxlength="100" value="<%=backword(GoodsName)%>" /> (<span class="GoodsName_cnt">0</span> / 100byte)<br />
					<!-- <span class="" style="line-height:25px;"><strong>상품명 두줄 표기 : '\'기호 사용</strong>&nbsp;&nbsp; 예) 멀티비타민앤미네랄 츄어블 → 멀티비타민앤 \미네랄 츄어블</span> -->
					</td>
				</tr><tr>
					<th>상품설명</th>
					<td colspan="3"><input type="text" name="GoodsComment" class="input_text input_size1" size="100" maxlength="200" value="<%=backword(GoodsTitle)%>" /> (<span class="GoodsComment_cnt">0</span> / 200byte)</td>
				</tr><tr>
					<th>구성</th>
					<td colspan="3">
						<input type="text" name="GoodsNote" class="input_text input_size1" size="60" maxlength="200" value="<%=backword(GoodsNote)%>" />
						<!-- <input type="color" id="colorSelector" name="GoodsNoteColor" value="#000000"class="input_text1 color vmiddle" style="width:70px;" maxlength="6" data-hex="true" /> --><!-- <input type="text" id="Binded" name="GoodsNoteColor" maxlength="6" class="input_text" style="width:50px;" value="000000" /> -->
					</td>
				</tr><tr>
					<th>재질</th>
					<td><input type="text" name="GoodsMaterial" class="input_text input_size1" size="40" value="<%=DKRS_GoodsMaterial%>" /></td>
					<th>색상</th>
					<td><input type="text" name="GoodsColor" class="input_text input_size1" size="40" value="<%=DKRS_GoodsColor%>" /></td>
				</tr><tr>
					<th>카톤</th>
					<td><input type="text" name="GoodsCarton" class="input_text size_s1" value="<%=strGoodsModel%>" /></td>
					<th>사이즈</th>
					<td><input type="text" name="GoodsSize" class="input_text size_s1" value="<%=GoodsSize%>" /></td>
				</tr><tr>
					<th>원산지</th>
					<td><input type="text" name="GoodsMade" class="input_text size_s1" value="<%=backword(GoodsOrigin)%>" /></td>
					<th>브랜드</th>
					<td><input type="text" name="GoodsBrand" class="input_text size_s1" value="<%=strGoodsBrand%>" /></td>
				</tr><tr>
					<th>모델명</th>
					<td><input type="text" name="GoodsModels" class="input_text size_s1" value="<%=strGoodsModel%>" /></td>
					<th>출시일</th>
					<td>
						<input type="text" name="GoodsDate" class="input_text size_s1" onclick="openCalendar(event, gform.GoodsDate, 'YYYY-MM-DD');" value="<%=strGoodsModel%>" readonly="readonly" />
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
					<td ><span class="red" id="viewonly1"></span></td><%'소수점 입력 시onlyKeys삭제%>
					<td><input type="text" name="GoodsCustomer" class="input_text input_number" size="20" maxlength="20" value="" <%=onLyKeysG(viewAdminLangCode)%> /> <!-- <%=Chg_CurrencyName%> --> (<%=Chg_CurrencyISO%>)</td>
					<td></td>
					<!-- <td></td> -->
				</tr><tr>
					<th class="req">공급가 <%=starText%></th>
					<td><span class="red" id="viewonly2"></span></td><%'소수점 입력 시onlyKeys삭제%>
					<td><input type="text" name="GoodsCost" class="input_text input_number" size="20" maxlength="20" value="" <%=onLyKeysG(viewAdminLangCode)%> /> <!-- <%=Chg_CurrencyName%> --> (<%=Chg_CurrencyISO%>)</td>
					<td></td>
					<!-- <td></td> -->
				</tr><tr>
					<th class="req">판매가 <%=starText%></th>
					<!-- <td><label><input type="checkbox" name="isViewMemberNot" value="T" /> 노출</label></td> -->
					<td><label><input type="hidden" name="isViewMemberNot" value="T" /> <span class="red" id="viewonly3"></span></label></td><%'소수점 입력 시onlyKeys삭제%>
					<td><input type="text" name="intPriceNot" class="input_text input_number" size="20" maxlength="20" value="" <%=onLyKeysG(viewAdminLangCode)%> readonly="readonly" /> <!-- <%=Chg_CurrencyName%> --> (<%=Chg_CurrencyISO%>)</td>
					<td><input type="text" name="intMinNot" class="input_text input_number" size="10" maxlength="10" value="" <%=onlyKeys%> /> 개 이상</td>
					<!-- <td><input type="text" name="intPointNot" class="input_text input_number" size="20" maxlength="20" value="" <%=onlyKeys%> /> 원</td> -->
				</tr><!-- <tr>
					<th>인증회원</th>
					<td><label><input type="checkbox" name="isViewMemberAuth" value="T" /> 노출</label></td>
					<td><input type="text" name="intPriceAuth" class="input_text input_number" size="20" maxlength="20" value="" <%=onlyKeys%> /> 원</td>
					<td><input type="text" name="intMinAuth" class="input_text input_number" size="10" maxlength="10" value="" <%=onlyKeys%> />  개 이상</td>
					<td><input type="text" name="intPointAuth" class="input_text input_number" size="20" maxlength="20" value="" <%=onlyKeys%> /> 원</td>
				</tr><tr>
					<th>딜러회원</th>
					<td><label><input type="checkbox" name="isViewMemberDeal" value="T" /> 노출</label></td>
					<td><input type="text" name="intPriceDeal" class="input_text input_number" size="20" maxlength="20" value="" <%=onlyKeys%> /> 원</td>
					<td><input type="text" name="intMinDeal" class="input_text input_number" size="10" maxlength="10" value="" <%=onlyKeys%> />  개 이상</td>
					<td><input type="text" name="intPointDeal" class="input_text input_number" size="20" maxlength="20" value="" <%=onlyKeys%> /> 원</td>
				</tr><tr>
					<th>VIP회원</th>
					<td><label><input type="checkbox" name="isViewMemberVIP" value="T" /> 노출</label></td>
					<td><input type="text" name="intPriceVIP" class="input_text input_number" size="20" maxlength="20" value="" <%=onlyKeys%> /> 원</td>
					<td><input type="text" name="intMinVIP" class="input_text input_number" size="10" maxlength="10" value="" <%=onlyKeys%> />  개 이상</td>
					<td><input type="text" name="intPointVIP" class="input_text input_number" size="20" maxlength="20" value="" <%=onlyKeys%> /> 원</td>
				</tr> -->
				<!-- <tr>
					<th class="req">VIP가 <%=starText%></th>
					<td><span class="red" id="viewonly6">수정불가</span></td>
					<td><input type="text" name="intCSPrice6" class="input_text input_number" size="20" maxlength="20" value="" <%=onlyKeys%> /> <%=Chg_CurrencyName%> (<%=Chg_CurrencyISO%>)</td>
					<td></td>
				</tr><tr>
					<th class="req">GOLD가 <%=starText%></th>
					<td><span class="red" id="viewonly7">수정불가</span></td>
					<td><input type="text" name="intCSPrice7" class="input_text input_number" size="20" maxlength="20" value="" <%=onlyKeys%> /> <%=Chg_CurrencyName%> (<%=Chg_CurrencyISO%>)</td>
					<td></td>
				</tr> -->
				<tr>
					<th>재고설정</th>
					<td colspan="3">
						<label><input type="radio" name="GoodsStockType" class="input_check" value="I" checked="checked" /> 무제한</label>
						<label><input type="radio" name="GoodsStockType" class="input_check check2" value="N" /> 수량</label> <input type="text" name="GoodsStockNum" class="input_text input_number" style="width:40px;" value="0" />개
						<label><input type="radio" name="GoodsStockType" class="input_check check2" value="S" /> 품절</label>
					</td>
				</tr><tr>
					<th>상품보이기</th>
					<td colspan="3">
						<label><input type="radio" name="GoodsViewTF" value="T" <%=isChecked(GoodsViews,"T")%> class="input_check" checked="checked" /> 보임</label>
						<label><input type="radio" name="GoodsViewTF" value="F" <%=isChecked(GoodsViews,"F")%> class="input_check check2" /> 감추기</label>
					</td>
				</tr><tr>
					<th>아이콘 출력</th>
					<td colspan="3">
						<label style="cursor:pointer"><input type="checkbox" name="flagBest" class="input_check" value="T" <%=isChecked(flagBest,"T")%> /> 베스트 상품에 표시</label>
						<label style="cursor:pointer"><input type="checkbox" name="flagNew" class="input_check check2" value="T" <%=isChecked(flagNew,"T")%> /> 새로운 상품에 표시</label>
						<label style="cursor:pointer"><input type="checkbox" name="flagVote" class="input_check check2" value="T" <%=isChecked(flagVote,"T")%> /> 추천 상품에 표시</label>
						<!-- <label style="cursor:pointer"><input type="checkbox" name="flagMain" class="input_check check2" value="T" <%=isChecked(flagMain,"T")%> /> 메인에 표시</label> -->
						<!-- <label style="cursor:pointer"><input type="checkbox" name="flagEvent" class="input_check check2" value="T" <%=isChecked(flagEvent,"T")%> /> 기획전 상품에 표시</label> -->
						<!-- <label style="cursor:pointer"><input type="checkbox" name="flagMaster" class="input_check check2" value="T" <%=isChecked(flagMaster,"T")%> /> 명인관 상품에 표시</label> -->
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
		<%
			upWidth	  = upImgWidths_Default
			upHeight  = upImgHeight_Default
			upWidthL  = upImgWidths_List
			upHeightL = upImgHeight_List
		%>
		<div class="titles">이미지 정보</div>
		<table <%=tableatt%>>
			<colgroup>
				<col width="200" />
				<col width="800" />
			</colgroup>
			<tbody>
				<tr>
					<th colspan="2" style="padding:10px 10px;">
						<span class="red">※ 이미지는 <span style="background:yellow;">배경이 불투명한 png 파일</span>로 등록해 주세요.</span><br />
						<span class="red">※ 이미지2~5, 리스트와 관련상품이미지는 등록하지 않으면 이미지1이 등록됩니다.</span>
					</th>
				</tr><tr>
					<th class="req"><%=starText%> 이미지1</th>
					<td><input type="file" name="Img1Ori" class="input_text" size="80" style="width:450px;" value="" /> <span class="red">(Size : <%=upWidth%> x <%=upHeight%>)</span></td>
				</tr><tr>
					<th>이미지2</th>
					<td><input type="file" name="Img2Ori" class="input_text" size="80" style="width:450px;" value="" /> <span class="red">(Size : <%=upWidth%> x <%=upHeight%>)</span></td>
				</tr><tr>
					<th>이미지3</th>
					<td><input type="file" name="Img3Ori" class="input_text" size="80" style="width:450px;" value="" /> <span class="red">(Size : <%=upWidth%> x <%=upHeight%>)</span></td>
				</tr><tr>
					<th>이미지4</th>
					<td><input type="file" name="Img4Ori" class="input_text" size="80" style="width:450px;" value="" /> <span class="red">(Size : <%=upWidth%> x <%=upHeight%>)</span></td>
				</tr><tr>
					<th>이미지5</th>
					<td><input type="file" name="Img5Ori" class="input_text" size="80" style="width:450px;" value="" /> <span class="red">(Size : <%=upWidth%> x <%=upHeight%>)</span></td>
				</tr><tr>
					<th>리스트 이미지</th>
					<td><input type="file" name="ImgList" class="input_text" size="80" style="width:450px;" value="" /> <span class="red">(Size : <%=upWidthL%> x <%=upHeightL%>)</span></td>
				</tr><!-- <tr>
					<th class="req"><%=starText%> 모바일 메인 이미지</th>
					<td><input type="file" name="imgMobMain" class="input_text" size="80" style="width:450px;" value="" /> <span class="red">(Size : 640 x 340 )</span></td>
				</tr> --><!-- <tr>
					<th>관련상품 이미지</th>
					<td><input type="file" name="ImgRelation" class="input_text" size="80" maxlength="250" value="" /> <span class="red">(Size : 173px * 130px)</span></td>
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
					<td><label><input type="radio" name="bannerB" value="T" checked="checked" />기본 배너를 사용합니다</label> <label style="margin-left:20px;"><input type="radio" name="bannerB" value="T" />새로운 배너 사용 : </label><input type="file" name="ImgBanner" class="input_text2" size="30" maxlength="250" value="" style="" /> <span class="red">(Size : 970px * ∞px)</span></td>
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
						<textarea name="GoodsContent" id="ir1" style="width:100%;height:350px;display:none;" cols="50" rows="10"></textarea>
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
								<td class="tweight"><label><input type="radio" name="GoodsDeliveryType" value="BASIC" class="input_check" checked="checked" /> 기본배송비 적용</label></td>
								<td class="text_small8">기본배송비는 기본설정에서 적용한 금액을 따라갑니다.</td>
							</tr><tr>
								<td class="tweight"><label><input type="radio" name="GoodsDeliveryType" value="SINGLE" class="input_check"  /> 단독배송비 적용</label></td>
								<td class="text_small8">기본배송의 무료배송이나 무료배송금액에 상관없이 단독배송비를 적용합니다.</td>
							</tr><tr id="delivery_toggle" style="display:none;">
								<td class="tweight">단독배송비</td>
								<td class=""><input type="text" name="GoodsDeliveryFee" class="input_text" value="0" /> 원</td>
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
								<col width="*" />
							</colgroup>
							<tr>
								<td class="tweight"><label><input type="radio" name="GoodsDeliPolicyType" value="B" class="input_check" checked="checked" /> 기본 배송/반품 내용 적용</label></td>
								<td class="text_small8">기본으로 설정된 배송/반품 내용을 적용합니다.</td>
							</tr><tr>
								<td class="tweight"><label><input type="radio" name="GoodsDeliPolicyType" value="S" class="input_check" /> 별도 배송/반품 내용 적용</label></td>
								<td class="text_small8">해당상품 단독으로 배송/반품 내용을 설정하여 적용합니다.</td>
							</tr>
						</table>
						<div style="width:99%;">
						<textarea name="GoodsDeliPolicy" id="ir2" style="width:100%;height:200px;display:none; background-color:#fff;" cols="50" rows="10"></textarea>
						<%=FN_Print_SmartEditor("ir2","delivery_content",UCase(viewAdminLangCode),"","","")%>
						</div>
					</td>
				</tr>
			</tbody>
		</table>

		<input type="hidden" id="OptionN" name="OptionVal" class="input_check" value="F"  />

		<!-- <div class="titles">상품 옵션 설정</div> -->
		<table <%=tableatt%>>
			<colgroup>
				<col width="200" />
				<col width="800" />
			</colgroup>
			<tbody>
				<!-- <tr>
					<th class="option">옵션 사용</th>
					<td>
						<label><input type="radio" id="OptionN" name="OptionVal" class="input_check" value="F" onClick="checkOptionKind('F')" checked="checked" />옵션없음</label>
						<label><input type="radio" id="OptionY" name="OptionVal" class="input_check" value="T" onClick="checkOptionKind('T')"  />옵션사용</label>
					</td>
				</tr> --><tr id="optionDispT" style="display:none;">
					<th>옵션설정</th>
					<td><!--#include file = "GoodsOptional.asp"--></td>
				</tr>
			</tbody>
		</table>







		<div class="submit_area"><input type="submit" class="input_submit_b design1" value="상품 저장" /></div>




	</form>
</div>

<%
	'cs상품검색 modal
	MODAL_CONTENT_WIDTH = 920
	MODAL_CSS_TYPE = "BLUE"
%>
<!--#include virtual="/_include/modal_config.asp" -->

<!--#include virtual = "/admin/_inc/copyright.asp"-->
