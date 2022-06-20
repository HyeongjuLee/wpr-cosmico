<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "GOODS"
	INFO_MODE = "GOODS5-5"



	intIDX = gRequestTF("Gidx",True)



	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs("DKPA_GOODS_VIEW",DB_PROC,arrParams,Nothing)

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

	Else
		Call ALERTS("존재하지 않는 상품입니다.","BACK","")

	End If


	If DKRS_isAccept <> "A" Then Call ALERTS("상품의 상태가 변경되었습니다. 승인 혹은 거절등의 메뉴에서 찾아주세요","BACK","")
	If DKRS_isShopType <> "S" Then Call ALERTS("셀러가 등록한 상품이 아닙니다. 자체상품에서 처리해주세요.","BACK","")

	CATEGORYS1 = Left(DKRS_Category,3)
	CATEGORYS2 = Left(DKRS_Category,6)
	CATEGORYS3 = Left(DKRS_Category,9)

'	PRINT CATEGORYS1
'	PRINT CATEGORYS2

%>
<link rel="stylesheet" href="goods.css" />
<%=CONST_SmartEditor_JS%>
<script type="text/javascript" src="Vendor_Goods_modify.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
<!-- <link rel="stylesheet" href="/jscript/jpicker/jPicker-1.1.6.css" />
<script type="text/javascript" src="/jscript/jpicker/jpicker-1.1.6.js"></script> -->
<script type="text/javascript">
	<!--
		$(document).ready(function(){
			$('#cate1').change(function(){chg_category2();}).change();
			$('#cate2').change(function(){chg_category3();});
			//$('#Binded').jPicker();

		});

		function chg_category2() {
			createRequest();
			var url = 'Category_d2.asp';

			mode = "category2";
			cate = $('#cate1').val();

			postParams = "mode=" + mode;
			postParams += "&cate=" + cate;

			if (cate.length == 0)
			{
				$("#cate2").attr("disabled",true);
				$("#cate2").html("<option value=''>상위 카테고리를 선택해주세요.</option>");
			} else {
				request.open("POST",url,true);
				request.onreadystatechange = function ChgContent() {
					if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
						if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
							var newContent = request.responseText;
							//var newContentSplit = newContent.split("||")
							//alert(newContent);
							//document.getElementById("select2nd").innerHTML = newContent;
							//$("#cate2 > option[value='<%=IN_CATE2%>']").attr("selected",true);
							$("#cate2").attr("disabled",false);
							$("#cate2").html(newContent);
							$("#cate2").val("<%=CATEGORYS2%>");
							$("#cate2").change();


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
		}
		function chg_category3() {
			createRequest();
			var url = 'Category_d2.asp';

			mode = "category3";
			cate = $('#cate2').val();

			postParams = "mode=" + mode;
			postParams += "&cate=" + cate;

			if (cate.length == 0)
			{
				$("#cate3").attr("disabled",true);
				$("#cate3").html("<option value=''>상위 카테고리를 선택해주세요.</option>");
			} else {
				request.open("POST",url,true);
				request.onreadystatechange = function ChgContent() {
					if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
						if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
							var newContent = request.responseText;
							//var newContentSplit = newContent.split("||")
							//alert(newContent);
							//document.getElementById("select2nd").innerHTML = newContent;
							//$("#cate2 > option[value='<%=IN_CATE2%>']").attr("selected",true);
							$("#cate3").attr("disabled",false);
							$("#cate3").html(newContent);
							$("#cate3").val("<%=CATEGORYS3%>");
							$("#cate3").change();


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
		}
	//-->
</script>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="goods">
	<form name="gform" id="gform" method="post" action="Vendor_Goods_Modify_A_Ok.asp" enctype="multipart/form-data" onsubmit="return chkGFrm(this);">
		<input type="hidden" name="chgMode" value="" />
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

		<div class="titles">셀러(벤더) 정보</div>
		<%
			arrParams2 = Array(_
				Db.makeParam("@strShopID",adVarChar,adParamInput,20,DKRS_strShopID) _
			)
			Set DKRS2 = Db.execRs("DKPA_VENDOR_VIEW",DB_PROC,arrParams2,Nothing)
			If Not DKRS2.BOF And Not DKRS.EOF Then
				DKRS2_intIDX		= DKRS2("intIDX")
				DKRS2_strShopID		= DKRS2("strShopID")
				DKRS2_strPass		= DKRS2("strPass")
				DKRS2_strComName	= DKRS2("strComName")
				DKRS2_sellerState	= DKRS2("sellerState")
				DKRS2_regDate		= DKRS2("regDate")
				DKRS2_AcceptDate	= DKRS2("AcceptDate")
				DKRS2_RefuseDate	= DKRS2("RefuseDate")
				DKRS2_StopDate		= DKRS2("StopDate")
				DKRS2_FeeType		= DKRS2("FeeType")
				DKRS2_intFee		= DKRS2("intFee")
				DKRS2_intLimit		= DKRS2("intLimit")
			End If

		%>
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="200" />
				<col width="300" />
				<col width="200" />
				<col width="300" />
			</colgroup>
			<tbody>
				<tr>
					<th>유통사 아이디</th>
					<td><%=DKRS2_strShopID%></td>
					<th>유통사명</th>
					<td><%=DKRS2_strComName%></td>
				</tr><tr>
					<th>유통사 기본 배송비</th>
					<td><%
						If DKRS2_FeeType = "FREE" Then
							PRINT printDeli(DKRS2_FeeType)
						Else
							PRINT printDeli(DKRS2_FeeType) & " - "&num2cur(DKRS2_intFee)& " 원"
						End If
					%></td>
					<th>유통사 기본 배송정책</th>
					<td><%
						If DKRS2_FeeType = "FREE" Then
							PRINT printDeli(DKRS2_FeeType)
						Else
							PRINT num2cur(DKRS2_intLimit)& " 원 이상 무료배송"
						End If
					%></td>
				</tr>
			</tbody>
		</table>


		<div class="titles">CS 관련</div>
		<table <%=tableatt%>>
			<colgroup>
				<col width="200" />
				<col width="800" />
			</colgroup>
			<tbody>
				<!-- <tr>
					<th class="req">CS상품여부 <%=starText%></th>
					<td>
						<label><input type="radio" name="isCSGoods" value="T" <%=isChecked(isCSGoods,"T")%> class="input_check" checked="checked" /> CS상품입니다. <span class="red tweight">(기본 상품 정보는 웹에서 수정 불가)</span></label>
					</td>
				</tr> -->
				<tr>
					<th class="req">CS상품여부</th>
					<td>
						<label><input type="radio" name="isCSGoods" value="T" <%=isChecked(DKRS_isCSGoods,"T")%> class="input_check" checked="checked" /> CS상품입니다.</label>
						<label><input type="radio" name="isCSGoods" value="F" <%=isChecked(DKRS_isCSGoods,"F")%> class="input_check check2" /> 일반상품입니다.</label>
					</td>
				</tr>
				<tr id="isCSGoods_toggle">
					<th class="req">CS상품코드 <%=starText%></th>
					<td><input type="text" name="CSGoodsCode" class="input_text" style="width:120px; text-align:center;" value="<%=DKRS_CSGoodsCode%>" readonly="readonly"/> <%=aImgOpt("javascript:openCSGoodsSearch_vendor();","",IMG_BTN&"/btn_csGoodsModify.gif",70,22,"","class=""vmiddle""")%> <span id="csGoodsName"></span></td>
				</tr>
			</tbody>
		</table>


		<div class="titles">상품기본정보</div>
		<table <%=tableatt%> class="width100">
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
						<label><input type="radio" name="GoodsType" value="A" <%=isChecked(DKRS_GoodsType,"A")%> class="input_check" /> 전체노출</label>
						<label><input type="radio" name="GoodsType" value="H" <%=isChecked(DKRS_GoodsType,"H")%> class="input_check check2" /> 일반샵에서만</label>
						<label><input type="radio" name="GoodsType" value="M" <%=isChecked(DKRS_GoodsType,"M")%> class="input_check check2" /> 모바일샵에서만</label>
					</td>
				</tr><tr>
					<th class="req">카테고리 설정 <%=starText%></th>
					<td colspan="3">
						<select id="cate1" name="cate1" class="select2">
							<option value="">상위 메뉴를 선택해주세요.</option>
							<%
								arrParams = Array(_
									Db.makeParam("@strCatrParent",adVarChar,adParamInput,20,"000") _
								)
								arrList = Db.execRsList("DKPA_SHOP_CATEGORY_LIST",DB_PROC,arrParams,listLen,Nothing)
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
					<th class="req">상품명 <%=starText%> </th>
					<td colspan="3"><input type="text" name="GoodsName" class="input_text input_size1" size="100" maxlength="100" value="<%=backword(DKRS_GoodsName)%>" /> (<span class="GoodsName_cnt">0</span> / 100byte)</td>
				</tr><tr>
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
				<col width="400" />
				<col width="*" />
			</colgroup>
			<thead>
				<tr>
					<th>구분</th>
					<th>노출</th>
					<th>가격</th>
					<th>최소구매수량</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<th>소비자가</th>
					<td><span class="red">수정불가</span></td>
					<td class="tweight"><%=num2cur(DKRS_GoodsCustomer)%> 원</td>
					<td rowspan="2">정산관련 내용과 맞물려 있는 항목. CS에서 동일하게 맞춰주세요.</td>
				</tr><tr>
					<th>공급가</th>
					<td><span class="red">수정불가</span></td>
					<td class="tweight red"><%=num2cur(DKRS_GoodsCost)%> 원</td>
				</tr><tr>
					<th class="req">판매가 <%=starText%></th>
					<td><label><input type="hidden" name="isViewMemberNot" value="T" <%=isChecked(DKRS_isViewMemberNot,"T")%> /></label><span class="red">수정불가</span></td>
					<td><input type="text" name="intPriceNot" class="input_text input_number" size="20" maxlength="20" value="<%=DKRS_intPriceNot%>" <%=onlyKeys%> /> 원 <span id="viewKorWon1" class="wonSpan"> 원</span></td>
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
				</tr> --><tr>
					<th>재고설정</th>
					<td colspan="3">
						<label><input type="radio" name="GoodsStockType" class="input_check" value="I"  <%=isChecked(DKRS_GoodsStockType,"I")%> /> 무제한</label>
						<label><input type="radio" name="GoodsStockType" class="input_check check2" value="N" <%=isChecked(DKRS_GoodsStockType,"N")%> /> 수량</label> <input type="text" name="GoodsStockNum" class="input_text input_number" style="width:40px;" value="<%=DKRS_GoodsStockNum%>" />개
						<label><input type="radio" name="GoodsStockType" class="input_check check2" value="S" <%=isChecked(DKRS_GoodsStockType,"S")%> /> 품절</label>
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
						<label><input type="checkbox" name="flagBest" class="input_check" value="T" <%=isChecked(DKRS_flagBest,"T")%> /> 베스트 상품에 표시</label>
						<label><input type="checkbox" name="flagNew" class="input_check check2" value="T" <%=isChecked(DKRS_flagNew,"T")%> /> 새로운 상품에 표시</label>
						<label><input type="checkbox" name="flagVote" class="input_check check2" value="T" <%=isChecked(DKRS_flagVote,"T")%> /> 추천 상품에 표시</label>
						<label><input type="checkbox" name="flagMain" class="input_check check2" value="T" <%=isChecked(DKRS_flagMain,"T")%> /> 메인에 표시</label>
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
		<table <%=tableatt%> class="width100">
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
			<tr>
				<th>이미지 타입</th>
				<td>
					<label><input type="radio" name="isImgType" class="input_check" value="S" <%=isChecked(DKRS_isImgType,"S")%> /> 자체등록</label>
					<label><input type="radio" name="isImgType" class="input_check check2" value="V" <%=isChecked(DKRS_isImgType,"V")%> /> 주소등록</label>
				</td>
			</tr>
			<tbody id="isImgType_S">
				<tr>
					<th class="req"><%=starText%> 이미지1</th>
					<td><%=viewPicTF2(DKRS_intIDX,"img1")%> | <input type="file" name="Img1Ori" class="input_text2" size="80" maxlength="250" value="" /> <span class="red">(Size : <%=upImgWidths_Default%>px x <%=upImgHeight_Default%>px)</span></td>
				</tr><tr>
					<th>이미지2</th>
					<td><%=viewPicTF2(DKRS_intIDX,"img2")%> | <input type="file" name="Img2Ori" class="input_text2" size="80" maxlength="250" value="" /> <span class="red">(Size : <%=upImgWidths_Default%>px x <%=upImgHeight_Default%>px)</span></td>
				</tr><tr>
					<th>이미지3</th>
					<td><%=viewPicTF2(DKRS_intIDX,"img3")%> | <input type="file" name="Img3Ori" class="input_text2" size="80" maxlength="250" value="" /> <span class="red">(Size : <%=upImgWidths_Default%>px x <%=upImgHeight_Default%>px)</span></td>
				</tr><tr>
					<th>이미지4</th>
					<td><%=viewPicTF2(DKRS_intIDX,"img4")%> | <input type="file" name="Img4Ori" class="input_text2" size="80" maxlength="250" value="" /> <span class="red">(Size : <%=upImgWidths_Default%>px x <%=upImgHeight_Default%>px)</span></td>
				</tr><tr>
					<th>이미지5</th>
					<td><%=viewPicTF2(DKRS_intIDX,"img5")%> | <input type="file" name="Img5Ori" class="input_text2" size="80" maxlength="250" value="" /> <span class="red">(Size : <%=upImgWidths_Default%>px x <%=upImgHeight_Default%>px)</span></td>
				</tr><tr>
					<th>리스트 이미지</th>
					<td><%=viewPicTF2(DKRS_intIDX,"list")%> | <input type="file" name="ImgList" class="input_text2" size="80" maxlength="250" value="" /> <span class="red">(Size : <%=upImgWidths_List%>px x <%=upImgHeight_List%>px)</span></td>
				</tr><!-- <tr>
					<th>모바일 메인 이미지</th>
					<td><%=viewPicTF2(DKRS_intIDX,"mobMain")%> | <input type="file" name="imgMobMain" class="input_text2" style="width:450px;" value="" /> <span class="red">(Size : 640 x 340)</span></td>
				</tr> -->
			</tbody>
			<tbody id="isImgType_V" style="display:none;">
				<tr>
					<th class="req"><%=starText%> 이미지1</th>
					<td><%=viewPicTF2(DKRS_intIDX,"img1")%> | <input type="text" name="Img1Ori_V" class="input_text" size="75" maxlength="250" value="<%=DKRS_Img1Ori%>" /> <span class="red">(Size : <%=upImgWidths_Default%>px x <%=upImgHeight_Default%>px)</span></td>
				</tr><tr>
					<th>이미지2</th>
					<td><%=viewPicTF2(DKRS_intIDX,"img2")%> | <input type="text" name="Img2Ori_V" class="input_text" size="75" maxlength="250" value="<%=DKRS_Img2Ori%>" /> <span class="red">(Size : <%=upImgWidths_Default%>px x <%=upImgHeight_Default%>px)</span></td>
				</tr><tr>
					<th>이미지3</th>
					<td><%=viewPicTF2(DKRS_intIDX,"img3")%> | <input type="text" name="Img3Ori_V" class="input_text" size="75" maxlength="250" value="<%=DKRS_Img3Ori%>" /> <span class="red">(Size : <%=upImgWidths_Default%>px x <%=upImgHeight_Default%>px)</span></td>
				</tr><tr>
					<th>이미지4</th>
					<td><%=viewPicTF2(DKRS_intIDX,"img4")%> | <input type="text" name="Img4Ori_V" class="input_text" size="75" maxlength="250" value="<%=DKRS_Img4Ori%>" /> <span class="red">(Size : <%=upImgWidths_Default%>px x <%=upImgHeight_Default%>px)</span></td>
				</tr><tr>
					<th>이미지5</th>
					<td><%=viewPicTF2(DKRS_intIDX,"img5")%> | <input type="text" name="Img5Ori_V" class="input_text" size="75" maxlength="250" value="<%=DKRS_Img5Ori%>" /> <span class="red">(Size : <%=upImgWidths_Default%>px x <%=upImgHeight_Default%>px)</span></td>
				</tr><tr>
					<th>썸네일 이미지</th>
					<td><%=viewPicTF2(DKRS_intIDX,"thum")%> | <input type="text" name="ImgThum_V" class="input_text" size="75" maxlength="250" value="<%=DKRS_ImgThum%>" /> <span class="red">(Size : <%=upImgWidths_Thum%>px x <%=upImgHeight_Thum%>px) 미입력시 이미지1로 저장됩니다</span></td>
				</tr><tr>
					<th>리스트 이미지</th>
					<td><%=viewPicTF2(DKRS_intIDX,"list")%> | <input type="text" name="ImgList_V" class="input_text" size="75" maxlength="250" value="<%=DKRS_ImgList%>" /> <span class="red">(Size : <%=upImgWidths_List%>px x <%=upImgHeight_List%>px)</span></td>
				</tr><!-- <tr>
					<th>모바일 메인 이미지</th>
					<td><%=viewPicTF2(DKRS_intIDX,"mobMain")%> | <input type="text" name="imgMobMain" class="input_text" size="75" maxlength="250" value="<%=DKRS_imgMobMain%>" /> <span class="red">(Size : <%=upImgWidths_List%>px x <%=upImgHeight_List%>px)</span></td>
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
		<table <%=tableatt%> class="width100">
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
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="200" />
				<col width="800" />
			</colgroup>
			<tbody>
				<tr>
					<th>배송비 설정</th>
					<td><%
						Select Case DKRS_GoodsDeliveryType
							Case "SINGLE"
								PRINT "단독배송비 적용 상품입니다."

							Case "BASIC"
								PRINT "업체의 기본배송비 정책("&printDeli(DKRS2_FeeType)&")으로 배송됩니다.<br />업체 배송정책 : "
								If DKRS2_FeeType = "FREE" Then
									PRINT printDeli(DKRS2_FeeType)
								Else
									PRINT "배송료 "&num2cur(DKRS2_intFee) & "원 - "&num2cur(DKRS2_intLimit)& " 원 이상 무료배송"
								End If
						End Select
					%></td>
				</tr><tr>
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

		<!-- <div class="titles">상품 옵션 설정</div>
		<%
			If DKRS_OptionVal = "T" Then
				SQL = "SELECT * FROM [DK_GOODS_OPTION] WHERE [GoodsIDX] = ? AND [isUse] = 'T'"
				arrParams = Array(_
					Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
				)
				arrList = Db.execRsList(SQL,DB_TEXT,arrParams,listLen,Nothing)
		%>
			<table <%=tableatt%> class="width100">
				<colgroup>
					<col width="200" />
					<col width="800" />
				</colgroup>
				<tbody>
					<tr>
						<th class="option">옵션 사용</th>
						<td>옵션이 있는 상품입니다.</td>
					</tr><tr id="optionDispT">
						<th>옵션 내용</th>
						<td>
							<table <%=tableatt%> style="width:780px;">

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
										<td width="170"><%=arrList(2,i)%></td>
										<td width="*"><%=Replace(arrList(3,i),"\",",")%></td>
									</tr>

								<%		Next
									End If
								%>
								</tbody>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
		<%Else%>
			<table <%=tableatt%> class="width100">
				<colgroup>
					<col width="200" />
					<col width="800" />
				</colgroup>
				<tbody>
					<tr>
						<th class="option">옵션 사용</th>
						<td>해당 상품에는 옵션이 없습니다</td>
					</tr>
				</tbody>
			</table>
		<%End If%> -->

		<div class="titles">반려사유</div>
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="150" />
				<col width="*" />
			</colgroup>
			<tbody>
				<tr>
					<th>반려일자</th>
					<th>반려사유</th>
				</tr>
				<%
					arrParams = Array(_
						Db.makeParam("@FK_IDX",adInteger,adParamInput,4,DKRS_intIDX) _
					)
					arrList = Db.execRsList("DKPA_GOODS_RETURN_CAUSE_LIST",DB_PROC,arrParams,listLen,Nothing)
					If IsArray(arrList) Then
						For i = 0 To listLen

				%>
				<tr>
					<td><%=arrList(3,i)%></td>
					<td><%=BACKWORD(arrList(2,i))%></td>
				</tr>
				<%
						Next
					Else
				%>
				<tr>
					<td colspan="2" class="notData">등록된 반려사유가 없습니다.</td>
				</tr>
				<%
					End If
				%>

			</tbody>
		</table>

		<div class="titles">반려사유 (재반려시에만 입력)</div>

		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="1000" />
			</colgroup>
			<tbody>
				<tr>
					<td><textarea name="strReturnCause" id="strReturnCause" class="input_area" cols="50" rows="10" style="width:98%; height:180px;"></textarea></td>
				</tr>
			</tbody>
		</table>

	</form>

	<div class="cleft submit_area width100">
		<div class="fleft">
			<a href="Vendor_Goods_List_F.asp"><img src="<%=IMG_BTN%>/vendor_go_list.gif" alt="" /></a>
			<a href="javascript:ReturnFrm(document.gform);"><img src="<%=IMG_BTN%>/vendor_go_r.gif" alt="" /></a>
		</div>
		<div class="fright">
			<a href="javascript:chkGFrm(document.gform);"><img src="<%=IMG_BTN%>/vendor_submit.gif" alt="" /></a>
			<a href="javascript:AcceptFrm(document.gform);"><img src="<%=IMG_BTN%>/vendor_go_t.gif" alt="" /></a>
		</div>
	</div>




</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
