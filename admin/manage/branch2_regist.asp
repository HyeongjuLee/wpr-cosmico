<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE5-5"


%>
<link rel="stylesheet" href="/admin/css/branch.css">
<script type="text/javascript" src="/jscript/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="/jscript/jquery_cate.js"></script>
<script type="text/javascript" src="branch2.js"></script>
<script type="text/javascript">
<!--
$(document).ready(function(){
	$('#cate1')
	  .change(function(){
		var cate1value = $(this).val();
		chgCate1s();
	  })
	.change();




//Jquery 종료
});

  function chgCate1s() {
	var cate1value = $('#cate1').val();
	var dropdownSet = $('#cate2');
	if (cate1value.length == 0) {
	  dropdownSet.attr("disabled",true);
	  dropdownSet.emptySelect();
	}
	else {
	  dropdownSet.attr("disabled",false);
	  $.getJSON(
		'getcate.asp?mode=category2',
		{style:cate1value},
		function(data){
		  dropdownSet.loadSelect(data);
		  $("#cate2 option[value='<%=CATEGORYS2%>']").attr("selected","selected");
		}

	  );

	}
  }
//-->
</script>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="bracn_regist">
	<form name="cfrm" action="branch2Handler.asp" method="post" onsubmit="return chkBranchForm(this);">
		<input type="hidden" name="mode" value="INSERT" />

		<table <%=tableatt%> class="adminFullTable view table2">
			<colgroup>
				<col width="180" />
				<col width="430" />
				<col width="*" />
			</colgroup>
			<tr>
				<td colspan="3" class="title">로드샵 정보</td>
			</tr><tr>
				<th>로드샵 표시</th>
				<td colspan="2">
					<label><input type="radio" name="isUse" value="T" />로드샵 보임</label>
					<label><input type="radio" name="isUse" value="F" />로드샵 숨김</label>
				</td>
			</tr><tr>
				<th>로드샵 위치</th>
				<td colspan="2">
					<select id="cate1" name="cate1">
					<option value="">1차 카테고리</option>
					<%

						SQL = "SELECT [intIDX],[strCateCode], [strCateName], [strCateDepth], [strCateParent], [intCateSort] "
						SQL = SQL & "FROM [DK_BRANCH_CODE] "
						SQL = SQL & " WHERE [strCateParent] = ? ORDER BY [intCateSort] ASC "
						arrParams = Array(_
							Db.makeParam("@PARENTS",adVarchar,adParamInput,20,"000") _
						)
						Set DKRS_CATEGORY = Db.execRs(SQL,DB_TEXT,arrParams,Nothing)

						If DKRS_CATEGORY.BOF Or DKRS_CATEGORY.EOF Then
					%><option value="">카테고리를 우선 저장해주셔야합니다</option><%Else
						Do Until DKRS_CATEGORY.EOF%>
							<option value="<%=DKRS_CATEGORY(1)%>" <%=isSelect(CATEGORYS1,DKRS_CATEGORY(1))%>><%=DKRS_CATEGORY(2)%></option>
					<%	DKRS_CATEGORY.MoveNext
						Loop
						End If
						Call closeRs(DKRS_CATEGORY)
					%>
				</select> <select id="cate2" name="cate2" disabled="disabled"></select>

				</td>
			</tr><tr>
				<th>로드샵 명</th>
				<td colspan="2"><input type="text" name="strBranchName" class="input_text" style="width:300px;" value="" /></td>
			</tr><tr>
				<th>로드샵 대표명</th>
				<td colspan="2"><input type="text" name="strBranchOwner" class="input_text" style="width:300px;" value="" /></td>
			</tr><tr>
				<th>로드샵 전화번호</th>
				<td colspan="2">
					<input type="text" name="strBranchTel1" class="input_text" style="width:40px" value="" /> -
					<input type="text" name="strBranchTel2" class="input_text" style="width:50px" value="" /> -
					<input type="text" name="strBranchTel3" class="input_text" style="width:50px" value="" />
				</td>
			</tr><tr>
				<th>로드샵 팩스번호</th>
				<td colspan="2">
					<input type="text" name="strBranchFax1" class="input_text" style="width:40px" value="" /> -
					<input type="text" name="strBranchFax2" class="input_text" style="width:50px" value="" /> -
					<input type="text" name="strBranchFax3" class="input_text" style="width:50px" value="" />
				</td>
			</tr><tr>
				<th>지사 주소</th>
				<td colspan="2" style="padding:4px 0px 4px 8px;">
					<input type="text" class="input_text" name="strzip" style="width:80px;background-color:#f4f4f4;" readonly="readonly" value="" />
					<img src="<%=IMG_BTN%>/zip_search.gif" width="68" height="20" alt="주소 찾기" class="vmiddle cp" onclick="openzip();" /> <input type="text" name="straddr1" class="input_text" style="width:350px" value=""  />
					<p class="inP"><input type="text" name="straddr2" class="input_text" style="width:520px" value=""  /></p>
				</td>
			</tr><tr>
				<th rowspan="2">지도주소</th>
				<td colspan="2" style="padding-left:10px;padding-bottom:10px;color:#cc6633;line-height:22px;"><span class="tweight">[주소입력 방법 및 유의사항]</span><p>
					&#8226; 다음 약도만들기 페이지로 들어갑니다. <a href="http://dna.daum.net/examples/maps/MissA/step1.php" target="_blank"><span class="tweight">클릭</span></a><p>
					&#8226; 지역이나 동 이름을 입력, 검색후 중심지점을 지정한 후 다음페이지로 넘어갑니다. (예:서현동)<p>
					&#8226; 사이즈는 가로 <span class="red tweight">770px</span>, 세로 <span class="red tweight">400px</span>로 입력해주세요.<p>
					&#8226; 원하시는 줌레벨과 내용을 작성하신후 다음페이지로 넘어갑니다.<p>
					&#8226; 3단계 화면에서 노란색으로 강조된  <span class="red tweight">dna</span> 부터 <span class="red tweight">zoom=4</span> 까지 하단의 입력창에 복사합니다.<strong>("표 제외)</strong><p>
					<img src="branch_sample.png" width="760" height="230">
				</td>
			</tr><tr>
				<td><input type="text" name="strBranchMapCode" class="input_text" style="width:430px" value=""  /></td>
				<td>다음(Daum)지도를 사용합니다</td>
			</tr>
		</table>


		<div class="submit_area">
			<input type="image" src="<%=IMG_BTN%>/btn_rect_confirm.gif" />
			<%=aImg("branch2_list.asp",IMG_BTN&"/btn_rect_list.gif",99,45,"")%>
		</div>
	<form>

</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
