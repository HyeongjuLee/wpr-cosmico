<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "GOODS"
	INFO_MODE = "GOODS2-1"
	PAGE_SETTING = "ESHOP"

'	On Error Resume Next


	arrParams_FA = Array(Db.makeParam("@strNationCode",adVarChar,adParamInput,6,viewAdminLangCode))
	Set DKRS_FA = Db.execRs("DKSP_SITE_NATION_VIEW",DB_PROC,arrParams_FA,Nothing)
	If Not DKRS_FA.BOF And Not DKRS_FA.EOF Then
		DKRS_FA_strNationName	= DKRS_FA("strNationName")
		DKRS_FA_intSort			= DKRS_FA("intSort")
	Else
		Call ALERTS("설정되지 않은 국가입니다!","BACK","")
	End If

	Call FN_NationCurrency(viewAdminLangCode,Chg_CurrencyName,Chg_CurrencyISO)

' ===================================================================
' 리스트 변수 받아오기(설정)
' ===================================================================
	Dim SEARCHTERM		:	SEARCHTERM = pRequestTF("SEARCHTERM",False)
	Dim SEARCHSTR		:	SEARCHSTR = pRequestTF("SEARCHSTR",False)
	Dim PAGESIZE		:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE				:	PAGE = pRequestTF("PAGE",False)
	Dim ORDERS			:	ORDERS = pRequestTF("ORDERS",False)

	Dim CATEGORYS1		:	CATEGORYS1 = pRequestTF("cate1",False)
	Dim CATEGORYS2		:	CATEGORYS2 = pRequestTF("cate2",False)
	Dim CATEGORYS3		:	CATEGORYS3 = pRequestTF("cate3",False)


	Dim isVIEWYN		:	isVIEWYN = pRequestTF("isVIEWYN",False) 'pRequestTF("isVIEWYN")
	Dim isSOLDOUT		:	isSOLDOUT = pRequestTF("isSOLDOUT",False) ' pRequestTF("isSOLDOUT")
	Dim minPrice		:	minPrice = pRequestTF("minPrice",False)
	Dim maxPrice		:	maxPrice = pRequestTF("maxPrice",False)
	If PAGESIZE = "" Then PAGESIZE = 5
	If PAGE = "" Then PAGE = 1
	If SEARCHTERM = "" Or SEARCHSTR = "" Then
		SEARCHTERM = ""
		SEARCHSTR = ""
	End If
	If isVIEWYN = "" Then isVIEWYN = ""
	If isSOLDOUT = "" Then  isSOLDOUT = ""
	If minPrice = "" Then minPrice = ""
	If maxPrice = "" Then maxPrice = ""

	Dim CATEGORYS
	If CATEGORYS1 <> "" Then CATEGORYS = CATEGORYS1
	If CATEGORYS2 <> "" Then CATEGORYS = CATEGORYS2
	If CATEGORYS3 <> "" Then CATEGORYS = CATEGORYS3
	If CATEGORYS1 = "" Then	CATEGORYS = ""

	If ORDERS = "" Then ORDERS = "IDXDESC"
' ===================================================================
' ===================================================================
' 데이터 가져오기
' ===================================================================
	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,SEARCHSTR), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _
		Db.makeParam("@strNationCode",adVarChar,adParamInput,6,viewAdminLangCode), _
		Db.makeParam("@ORDERS",adVarChar,adParamInput,50,ORDERS), _

		Db.makeParam("@Category",adVarChar,adParamInput,50,CATEGORYS), _
		Db.makeParam("@GoodsStockType",adChar,adParamInput,1,isSOLDOUT), _
		Db.makeParam("@GoodsViewTF",adVarChar,adParamInput,50,isVIEWYN), _
		Db.makeParam("@GoodsPrice1",adInteger,adParamInput,50,minPrice), _
		Db.makeParam("@GoodsPrice2",adInteger,adParamInput,50,maxPrice), _

		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

	)
	arrList = Db.execRsList("DKSP_GOODS_LIST_Sort",DB_PROC,arrParams,listLen,Nothing)

	All_Count = arrParams(Ubound(arrParams))(4)
'print CATEGORYS
' ===================================================================
		Dim PAGECOUNT,CNT
		PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If


	'▣상품밀기 실제 ALL_COUNT계산▣
	ALL_COUNT_REAL = 0
	SQL_AC = "SELECT COUNT([intIDX]) FROM [DK_GOODS] WHERE [DelTF] = 'F' AND [isShopType] = 'E' AND [strNationCode] = '"&viewAdminLangCode&"'"
	ALL_COUNT_REAL = Db.execRsData(SQL_AC,DB_TEXT,nothing,nothing)


%>
<script type="text/javascript" src="goods_list.js"></script>
<link rel="stylesheet" href="goods.css" />
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

	function delOk(idx) {
		if (confirm("삭제하시겠습니까? 삭제 후 복구할 수 없습니다.")) {
			location.href = 'goodsDel.asp?Gidx='+idx;
		}
	}

	//-->
</script>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<iframe src="/hiddens.asp" name="hiddenFrame" frameborder="0" width="0" height="0" style="display:none;"></iframe>
<div id="goods_search">
	<form name="searchform" action="goods_list_sort.asp" method="post">
		<table <%=tableatt%> class="goodSearch">
			<colgroup>
				<col width="190" />
				<col width="*" />
			</colgroup>
			<tbody>
			<tr>
				<th>분류검색</th>
				<td>
					<select id="cate1" name="cate1" class="select2">
						<option value="">상위 메뉴를 선택해주세요.</option>
						<%
							arrParams1 = Array(_
								Db.makeParam("@strNationCode",adVarChar,adParamInput,6,viewAdminLangCode), _
								Db.makeParam("@strCatrParent",adVarChar,adParamInput,20,"000") _
							)
							arrList1 = Db.execRsList("DKSP_SHOP_CATEGORY_LIST",DB_PROC,arrParams1,listLen1,Nothing)
							If Not IsArray(arrList1) Then
								PRINT "<option value="""">메뉴가 없습니다.</option>"
							Else
								For j = 0 To listLen1
									arrList1_intIDX				= arrList1(1,j)
									arrList1_strCateCode		= arrList1(2,j)
									arrList1_strCateName		= arrList1(3,j)
									arrList1_strCateParent		= arrList1(4,j)
									arrList1_intCateDepth		= arrList1(5,j)
									arrList1_intCateSort		= arrList1(6,j)
									arrList1_isView				= arrList1(7,j)
									arrList1_isBest				= arrList1(8,j)
									arrList1_isVote				= arrList1(9,j)
									arrList1_isTopImgView		= arrList1(10,j)
									arrList1_strTopImg			= arrList1(11,j)
									PRINT "<option value="""&arrList1_strCateCode&""""& isSelect(CATEGORYS1,arrList1_strCateCode)&">"&arrList1_strCateName&"</option>"
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
				<th>진열상태</th>
				<td>
					<label><input type="radio" name="isVIEWYN" value="" <%=isChecked(isVIEWYN,"")%> /> 전체상품</label>
					<label><input type="radio" name="isVIEWYN" value="T" <%=isChecked(isVIEWYN,"T")%> /> 진열중인 상품만</label>
					<label><input type="radio" name="isVIEWYN" value="F" <%=isChecked(isVIEWYN,"F")%> /> 진열되지 않은 상품만</label>
				</td>
			</tr><tr>
				<th>품절상태</th>
				<td>
					<label><input type="radio" name="isSOLDOUT" value="" <%=isChecked(isSOLDOUT,"")%> /> 전체상품</label>
					<label><input type="radio" name="isSOLDOUT" value="S" <%=isChecked(isSOLDOUT,"S")%> /> 품절된 상품만</label>
					<label><input type="radio" name="isSOLDOUT" value="N" <%=isChecked(isSOLDOUT,"N")%> /> 재고가 있는 상품</label>
					<label><input type="radio" name="isSOLDOUT" value="I" <%=isChecked(isSOLDOUT,"I")%> /> 재고 무제한 상품</label>
				</td>
			</tr><tr>
				<th>상품가격</th>
				<td><input type="text" name="minPrice" class="input_text input_number" value="<%=minPrice%>" <%=onLyKeys%> /> 부터 <input type="text" name="maxPrice" class="input_text input_number" value="<%=maxPrice%>"  <%=onLyKeys%> /> 까지</td>
			</tr><tr>
				<th>상품명</th>
				<td>
					<select name="SEARCHTERM">
						<option value="GoodsName" <%=isSelect(SEARCHTERM,"GoodsName")%>>상품명으로 검색</option>
						<option value="intIDX" <%=isSelect(SEARCHTERM,"intIDX")%>>상품번호로 검색</option>
					</select>
					<input type="text" name="SEARCHSTR" value="<%=searchstr%>" class="input_text" />
				</td>
			</tr><tr>
				<th>정렬순서</th>
				<td class="">
					<select name="pagesize">
						<option value="10" <%=isSelect(pagesize,"10")%>>10개씩 보기</option>
						<option value="20" <%=isSelect(pagesize,"20")%>>20개씩 보기</option>
						<option value="30" <%=isSelect(pagesize,"30")%>>30개씩 보기</option>
						<option value="40" <%=isSelect(pagesize,"40")%>>40개씩 보기</option>
						<option value="50" <%=isSelect(pagesize,"50")%>>50개씩 보기</option>
					</select>
					<select name="orders" style="">
						<option value="IDXDESC" <%=isSelect(ORDERS,"IDXDESC")%>>등록순서 내림차순</option>
						<option value="IDXASC" <%=isSelect(ORDERS,"IDXASC")%>>등록순서 오름차순</option>
						<option value="SORTDESC" <%=isSelect(ORDERS,"SORTDESC")%>>노출순서 내림차순</option>
						<option value="SORTASC" <%=isSelect(ORDERS,"SORTASC")%>>노출순서 오름차순</option>
					</select>
					<input type="submit" class="a_submit design1" value="검색"/>
					<a href="<%=Request.ServerVariables("SCRIPT_NAME")%>" class="a_submit design3">초기화</a>
				</td>
			</tr><!-- <tr>
				<td colspan="2" class="orders">
					<select name="pagesize">
						<option value="10" <%=isSelect(pagesize,"10")%>>10개씩 보기</option>
						<option value="20" <%=isSelect(pagesize,"20")%>>20개씩 보기</option>
						<option value="30" <%=isSelect(pagesize,"30")%>>30개씩 보기</option>
						<option value="40" <%=isSelect(pagesize,"40")%>>40개씩 보기</option>
						<option value="50" <%=isSelect(pagesize,"50")%>>50개씩 보기</option>
					</select>
					<select name="orders">
						<option value="basic" <%=isSelect(ORDERS,"basic")%>>기본정렬</option>
						<option value="name" <%=isSelect(ORDERS,"name")%>>상품이름순</option>
						<option value="pricehigh" <%=isSelect(ORDERS,"pricehigh")%>>가격높은 순서</option>
						<option value="pricelow" <%=isSelect(ORDERS,"pricelow")%>>가격낮은 순서</option>
					</select>
				</td>
			</tr> -->
			</tbody>
		</table>
	</form>
</div>
<%If UCase(DK_MEMBER_ID) = "WEBPRO" Then%>
<script>
<!--
	function openGoodsEmpty() {
		openPopup("Goods_Empty_Number.asp", "Goods_Empty_Number", 100, 100, "left=200, top=200, scrollbars=yes");
	}
// -->
</script>
<a href="javascript:openGoodsEmpty();"><span class="red">[Webpro_openGoodsEmpty]</span></a>
<%End If%>
<div id="goods_list">
	<!-- <input type="hidden" name="max_number" id="max_number" value="<%=ALL_COUNT%>" /> -->
	<input type="hidden" name="max_number" id="max_number" value="<%=ALL_COUNT_REAL%>" />
	<table <%=tableatt%> class="goodList">
		<colgroup>
			<col width="110" />
			<col width="80" />
			<col width="140" />
			<col width="*" />
			<col width="250" />
			<col width="110" />
		</colgroup>
		<thead>
			<tr>
				<th>순번</th>
				<th>상품번호<br /> 상품상태<br /><span class="cs_ncode">CS상품코드</span></th>
				<th colspan="2">상품정보</th>
				<th>가격정보</th>
				<th>기능</th>
			</tr>
		</thead>
		<tbody>
		<%
				'IsArray(arrList)
				'Response.End
				'print listLen
				'Response.End

				If IsArray(arrList) Then
					For i = 0 To listLen
						arrList_intIDX				= arrList(1,i)		'상품고유번호
						arrList_GoodsViewTF			= arrList(2,i)		'상품노출설정
						arrList_GoodsStockType		= arrList(3,i)		'I:무제한, N:수량, S:품절
						arrList_ImgThum				= arrList(4,i)
						arrList_Category			= arrList(5,i)
						arrList_GoodsName			= arrList(6,i)
						arrList_GoodsComment		= arrList(7,i)
						arrList_flagBest			= arrList(8,i)		'베스트상품노출
						arrList_flagNew				= arrList(9,i)		'NEW 상품노출
						arrList_FlagVote			= arrList(10,i)		'추천상품노출
						arrList_GoodsPrice			= arrList(11,i)		'판매가
						arrList_GoodsCustomer		= arrList(12,i)		'소비자가
						arrList_GoodsCost			= arrList(13,i)		'상품원가
						arrList_GoodsPoint			= arrList(14,i)		'적립금
						arrList_GoodsStockNum		= arrList(15,i)		'재고량
						arrList_flagMain			= arrList(16,i)
						arrList_isCSGoods			= arrList(17,i)
						arrList_isViewMemberNot		= arrList(18,i)
						arrList_isViewMemberAuth	= arrList(19,i)
						arrList_isViewMemberDeal	= arrList(20,i)
						arrList_isViewMemberVIP		= arrList(21,i)
						arrList_intPriceNot			= arrList(22,i)
						arrList_intPriceAuth		= arrList(23,i)
						arrList_intPriceDeal		= arrList(24,i)
						arrList_intPriceVIP			= arrList(25,i)
						arrList_intMinNot			= arrList(26,i)
						arrList_intMinAuth			= arrList(27,i)
						arrList_intMinDeal			= arrList(28,i)
						arrList_intMinVIP			= arrList(29,i)
						arrList_intPointNot			= arrList(30,i)
						arrList_intPointAuth		= arrList(31,i)
						arrList_intPointDeal		= arrList(32,i)
						arrList_intPointVIP			= arrList(33,i)
						arrList_isImgType			= arrList(34,i)
						arrList_intCSPrice4			= arrList(35,i)		'CS PV
						arrList_intCSPrice5			= arrList(36,i)
						arrList_intCSPrice6			= arrList(37,i)		'VIP 가 (엘라이프)
						arrList_intCSPrice7			= arrList(38,i)		'GOLD가 (엘라이프)
						arrList_intSort				= arrList(39,i)

						arrList_CSGoodsCode			= arrList(40,i)

						If arrList_CSGoodsCode <> "" Then
						'▣CS상품정보
							arrParams = Array(_
								Db.makeParam("@Na_Code",adVarChar,adParamInput,50,UCase(viewAdminLangCode)), _
								Db.makeParam("@ncode",adVarChar,adParamInput,20,arrList_CSGoodsCode) _
							)
							Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO_GLOBAL",DB_PROC,arrParams,DB3)
							'Set DKRS = Db.execRs("HJP_CSGOODS_PRICE_INFO",DB_PROC,arrParams,DB3)
							If Not DKRS.BOF And Not DKRS.EOF Then
								RS_ncode		= DKRS("ncode")
								RS_price2		= DKRS("price2")
								RS_price4		= DKRS("price4")
								RS_price5		= DKRS("price5")
								RS_price6		= DKRS("price6")
								RS_SellCode		= DKRS("SellCode")
								RS_SellTypeName	= DKRS("SellTypeName")
							Else
								RS_ncode = "--"
							End If
							Call closeRs(DKRS)

						End If

		%>
			<tr>
				<!-- <td class="tcenter"><input type="checkbox" value="<%=arrList_intIDX%>" /></td> -->
				<td class="tcenter">
					<p><%=num2curINT(arrList_intSort)%></p>
					<p style="margin-top:4px;"><input type="text" name="sortNum<%=i%>" id="sortNum<%=i%>" <%=onlykeys%> class="input_text tcenter" style="width:58px;" value="" maxlength="3" /></p>
					<p style="margin-top:4px;"><span class="button medium icon"><span class="refresh"></span><button type="button" onclick="chgThisAsc('sortNum<%=i%>','<%=arrList_intIDX%>');">변경</button></span></p>
				</td>
				<td class="tcenter lh160">
					<strong><%=(arrList(1,i))%></strong><br />
					<a href="goods_changeOne.asp?idx=<%=arrList_intIDX%>&amp;types=GoodsViewTF" target="hiddenFrame"><img src="<%=IMG_ICON%>/i_view<%=arrList_GoodsViewTF%>.gif" alt="진열상태" style="padding-bottom:5px;" /></a><br />
					<a href="goods_changeOne.asp?idx=<%=arrList_intIDX%>&amp;types=GoodsStockType" target="hiddenFrame"><img src="<%=IMG_ICON%>/i_sold<%=arrList_GoodsStockType%>.gif" alt="재고상태" style="padding-bottom:5px;" /></a><br />
					<span class="cs_ncode"><%=RS_ncode%></span><br />
				</td>
				<td class="tcenter no_right"><a href="/shop/detailView.asp?gIDX=<%=arrList_intIDX%>" target="_blank">
					<%If arrList_isImgType = "S" Then%>
						<img src="<%=VIR_PATH("goods/thum")%>/<%=backword(arrList_ImgThum)%>" alt="" /></a>
					<%Else%>
						<img src="<%=backword(arrList_ImgThum)%>" width="<%=upImgWidths_Thum%>" height="<%=upImgHeight_Thum%>" alt="" /></a>
					<%End If%>
				</td>
				<td class="no_left lh160">
					<span class="category"><%=PrintCate_E1(Left(arrList_Category,3),Left(arrList_Category,6),Left(arrList_Category,9),"",viewAdminLangCode)%></span><br />
					<span class="goodsname"><%=backword(arrList_GoodsName)%></span><br />
					<span class="comment"><%=backword(arrList_GoodsComment)%></span><br />
					<a href="goods_changeOne.asp?idx=<%=arrList_intIDX%>&amp;types=flagBest" target="hiddenFrame"><img src="<%=IMG_ICON%>/i_best<%=arrList_flagBest%>.gif" alt="BEST" style="padding-bottom:5px;" /></a>
					<a href="goods_changeOne.asp?idx=<%=arrList_intIDX%>&amp;types=flagNew" target="hiddenFrame"><img src="<%=IMG_ICON%>/i_new<%=arrList_flagNew%>.gif" alt="New" style="padding-bottom:5px;" /></a>
					<a href="goods_changeOne.asp?idx=<%=arrList_intIDX%>&amp;types=FlagVote" target="hiddenFrame"><img src="<%=IMG_ICON%>/i_vote<%=arrList_FlagVote%>.gif" alt="추천상품" style="padding-bottom:5px;" /></a>
					<!-- <a href="goods_changeOne.asp?idx=<%=arrList_intIDX%>&amp;types=flagMain" target="hiddenFrame"><img src="<%=IMG_ICON%>/i_index<%=arrList_flagMain%>.gif" alt="인덱스" style="padding-bottom:5px;" /></a> -->
					<img src="<%=IMG_ICON%>/i_csgoods<%=arrList_isCSGoods%>.gif" alt="인덱스" style="padding-bottom:5px;" title="CS상품은 상품수정에서 처리할 수 있습니다." alt="CS상품은 상품수정에서 처리할 수 있습니다." />
				</td>
				<td class="tcenter">
					<table <%=tableatt%> class="intable width90">
						<colgroup>
							<col width="70" />
							<!-- <col width="40" /> -->
							<col width="40" />
							<col width="*" />
							<col width="40" />
						</colgroup>

						<tr>
							<th>구분</th>
							<!-- <th>표시</th> -->
							<th>수량</th>
							<th colspan="2">금액</th>
						</tr><tr>
							<td class="tds1">소비자가</td>
							<!-- <td class="tds2"></td> -->
							<td class="tds2"></td>
							<td class="tds2 b-r"><%=num2curAdmin(arrList_GoodsCustomer,viewAdminLangCode)%></td>
							<td class="tds3 b-l"><%=Chg_CurrencyISO%></td>
						</tr><tr>
							<td class="tds1">판매가</td>
							<!-- <td class="tcenter"><%=TFVIEWER(arrList_isViewMemberNot,"VIEW")%></td> -->
							<td class="tcenter"><%=num2curINT(arrList_intMinNot)%></td>
							<td class="tds2 b-r"><%=num2curAdmin(arrList_intPriceNot,viewAdminLangCode)%></td>
							<td class="tds3 b-l"><%=Chg_CurrencyISO%></td>
						</tr><!-- <tr>
							<td class="tds1">멤버쉽가</td>
							<td class="tcenter"><%=TFVIEWER(arrList_isViewMemberAuth,"VIEW")%></td>
							<td class="tcenter"><%=num2cur(arrList_intMinAuth)%></td>
							<td class="tds2 b-r"><%=num2cur(arrList_intPriceAuth)%></td>
							<td class="tds3 b-l"><%=Chg_CurrencyISO%></td>
						</tr><tr>
							<td class="tds1">딜러회원가</td>
							<td class="tcenter"><%=TFVIEWER(arrList_isViewMemberDeal,"VIEW")%></td>
							<td class="tcenter"><%=num2cur(arrList_intMinDeal)%></td>
							<td class="tds2 b-r"><%=num2cur(arrList_intPriceDeal)%></td>
							<td class="tds3 b-l">개</td>
						</tr><tr>
							<td class="tds1">VIP회원가</td>
							<td class="tcenter"><%=TFVIEWER(arrList_isViewMemberVIP,"VIEW")%></td>
							<td class="tcenter"><%=num2cur(arrList_intMinVIP)%></td>
							<td class="tds2 b-r"><%=num2cur(arrList_intPriceVIP)%></td>
							<td class="tds3 b-l">개</td>
						</tr> -->
						<!-- <tr>
							<td class="tds1">VIP가</td>
							<td class="tds2"></td>
							<td class="tds2"></td>
							<td class="tds2 b-r"><%=num2cur(arrList_intCSPrice6)%></td>
							<td class="tds3 b-l"><%=Chg_CurrencyISO%></td>
						</tr><tr>
							<td class="tds1">GOLD가</td>
							<td class="tds2"></td>
							<td class="tds2"></td>
							<td class="tds2 b-r"><%=num2cur(arrList_intCSPrice7)%></td>
							<td class="tds3 b-l"><%=Chg_CurrencyISO%></td>
						</tr> -->
					</table>
					<%
						Select Case arrList_GoodsStockType
							Case "N" '수량'
								If CDbl(arrList_GoodsStockNum) < 10 Then
									PRINT "<span class=""red tweight"">재고가 10개 이하인 상품입니다.</span> "
								End If
							Case "I" '무제한'
							Case "S" '품절'
								PRINT  "<span class=""red tweight"">품절된 상품입니다.</span>"
							Case Else '이상제품
								PRINT "<span class=""red tweight"">상품재고에 문제가 있습니다. 개발사에게 문의해주세요.</span>"
						End Select
					%>
				</td>
				<td class="tcenter">
					<%If isCSGOODUSE = "T" Then %><%'▣CS상품수정시▣%>
						<div class="btnArea"><a href="goods_modify_CS.asp?Gidx=<%=arrList_intIDX%>"><input type="button" class="a_submit design1" value="상품수정" /></a></div>
					<%Else%>
						<div class="btnArea"><a href="goods_modify.asp?Gidx=<%=arrList_intIDX%>"><input type="button" class="a_submit design1" value="상품수정" /></a></div>
					<%End If%>
					<div class="btnArea"><input type="button" class="a_submit design2" value="상품삭제" onclick="delOk('<%=arrList_intIDX%>')" /></div>
				</td>
			</tr>
		<%			Next%>
		<%		Else%>
		<tr>
			<td colspan="7" class="notData">등록된 상품이 없습니다.</td>
		</tr>
		<%		End If%>
		</tbody>

	</table>
	<div class="pagingNew3"><%Call pageListNew(PAGE,PAGECOUNT)%></div>

</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="intSort" value="" />
	<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />

	<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
	<input type="hidden" name="SEARCHSTR" value="<%=SEARCHSTR%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="ORDERS" value="<%=ORDERS%>" />

	<input type="hidden" name="cate1" value="<%=CATEGORYS1%>" />
	<input type="hidden" name="cate2" value="<%=CATEGORYS2%>" />
	<input type="hidden" name="cate3" value="<%=CATEGORYS3%>" />

	<input type="hidden" name="isVIEWYN" value="<%=isVIEWYN%>" />
	<input type="hidden" name="isSOLDOUT" value="<%=isSOLDOUT%>" />
	<input type="hidden" name="minPrice" value="<%=minPrice%>" />
	<input type="hidden" name="maxPrice" value="<%=maxPrice%>" />
</form>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
