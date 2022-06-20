<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE4-3"


	intIDX = gRequestTF("idx",True)

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs("DKPA_BRANCH_VIEW",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_intIDX          		= DKRS("intIDX")
		RS_BranchCode      		= DKRS("BranchCode")
		RS_strBranchName   		= DKRS("strBranchName")
		RS_strZip          		= DKRS("strZip")
		RS_strADDR1        		= DKRS("strADDR1")
		RS_strADDR2        		= DKRS("strADDR2")
		RS_strBranchOwner  		= DKRS("strBranchOwner")
		RS_strBranchTel    		= DKRS("strBranchTel")
		RS_strBranchFax    		= DKRS("strBranchFax")
		RS_strBranchMapCode		= DKRS("strBranchMapCode")
		RS_isUse				= DKRS("isUse")

		RS_strBankCode1			= DKRS("strBankCode1")
		RS_strBankNumber1		= DKRS("strBankNumber1")
		RS_strBankOwner1		= DKRS("strBankOwner1")

		RS_strBankCode2			= DKRS("strBankCode2")
		RS_strBankNumber2		= DKRS("strBankNumber2")
		RS_strBankOwner2		= DKRS("strBankOwner2")

		RS_strBankCode3			= DKRS("strBankCode3")
		RS_strBankNumber3		= DKRS("strBankNumber3")
		RS_strBankOwner3		= DKRS("strBankOwner3")

		RS_strBankCode4			= DKRS("strBankCode4")
		RS_strBankNumber4		= DKRS("strBankNumber4")
		RS_strBankOwner4		= DKRS("strBankOwner4")

		RS_strBranchKey			= DKRS("strBranchKey")



		If RS_strBranchTel		= "" Or IsNull(RS_strBranchTel) Then RS_strBranchTel = "--"
		If RS_strBranchFax		= "" Or IsNull(RS_strBranchFax) Then RS_strBranchFax = "--"

		arrRSTel		= Split(RS_strBranchTel,"-")
		arrRSMobile		= Split(RS_strBranchFax,"-")


		If RS_strBranchPic = "" Or IsNull(RS_strBranchPic) Then
			viewPics = viewImgSt(IMG_SHARE&"/notImg.gif",150,150,"","","vmiddle")
		Else
			viewPics = aImgSt2(VIR_PATH("branch")&"/"&RS_strPic,IMG_ICON&"/icon_picT.gif",16,16,"","","vmiddle")
		End If

	Else
		Call ALERTS("데이터가 없습니다. 이미 처리되었을 수 있습니다.","back","")
	End If

	CATEGORYS1 = Left(RS_BranchCode,3)
	CATEGORYS2 = Left(RS_BranchCode,6)
'	If CATEGORYS2 <> "" Then CATEGORYS = RS_BranchCode
'	If CATEGORYS3 <> "" Then CATEGORYS = RS_BranchCode
'	If CATEGORYS1 = "" Then	CATEGORYS = ""

%>
<link rel="stylesheet" href="/admin/css/branch.css">
<script type="text/javascript" src="/jscript/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="/jscript/jquery_cate.js"></script>
<script type="text/javascript" src="branch.js"></script>
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
/*
function delok(uidx){
	var f = document.delFrm;

	if (confirm("해당 스케쥴을 삭제하시겠습니까?\n\n\※ 삭제 후 복구할 수 없습니다.※")) {
		f.intIDX.value = uidx;
		f.submit();
	}
}
*/

//-->
</script>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="bracn_regist">
	<form name="cfrm" action="branchHandler_daum.asp" method="post" onsubmit="return chkBranchForm(this);">
		<input type="hidden" name="intIDX" value="<%=intIDX%>" />
		<input type="hidden" name="mode" value="MODIFY" />

		<table <%=tableatt%> class="adminFullTable view table2">
			<colgroup>
				<col width="220" />
				<col width="250" />
				<col width="*" />
			</colgroup>
			<tr>
				<td colspan="3" class="title">지사정보</td>
			</tr><tr>
				<th>지사 표시</th>
				<td colspan="2">
					<label><input type="radio" name="isUse" value="T" <%=isChecked(RS_isUse,"T")%> />지사보임</label>
					<label><input type="radio" name="isUse" value="F" <%=isChecked(RS_isUse,"F")%> />지사숨김</label>
				</td>
			</tr><tr>
				<th>지사 위치</th>
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
				<th>지사 명</th>
				<td colspan="2"><input type="text" name="strBranchName" class="input_text" style="width:300px;" value="<%=RS_strBranchName%>" /></td>
			</tr><tr>
				<th>지사 대표명</th>
				<td colspan="2"><input type="text" name="strBranchOwner" class="input_text" style="width:300px;" value="<%=RS_strBranchOwner%>" /></td>
			</tr><tr>
				<th>지사 전화번호</th>
				<td colspan="2">
					<input type="text" name="strBranchTel1" class="input_text" style="width:40px" value="<%=arrRSTel(0)%>" /> -
					<input type="text" name="strBranchTel2" class="input_text" style="width:50px" value="<%=arrRSTel(1)%>" /> -
					<input type="text" name="strBranchTel3" class="input_text" style="width:50px" value="<%=arrRSTel(2)%>" />
				</td>
			</tr><tr>
				<th>지사 팩스번호</th>
				<td colspan="2">
					<input type="text" name="strBranchFax1" class="input_text" style="width:40px" value="<%=arrRSMobile(0)%>" /> -
					<input type="text" name="strBranchFax2" class="input_text" style="width:50px" value="<%=arrRSMobile(1)%>" /> -
					<input type="text" name="strBranchFax3" class="input_text" style="width:50px" value="<%=arrRSMobile(2)%>" />
				</td>
			</tr><tr>
				<th>지사 주소</th>
				<td colspan="2" style="padding:4px 0px 4px 8px;">
					<input type="text" class="input_text" name="strzip" style="width:80px;background-color:#f4f4f4;" readonly="readonly" value="<%=RS_strZip%>" />
					<img src="<%=IMG_BTN%>/zip_search.gif" width="68" height="20" alt="주소 찾기" class="vmiddle cp" onclick="openzip();" /> <input type="text" name="straddr1" class="input_text" style="width:350px" value="<%=RS_strADDR1%>"  />
					<p class="inP"><input type="text" name="straddr2" class="input_text" style="width:520px" value="<%=RS_strADDR2%>"  /></p>
				</td>
			</tr><tr>
				<th rowspan="">지도만들기</th>
				<td colspan="2"style="padding-left:10px;padding-bottom:10px;color:#cc6633;line-height:22px;">
					<p><span class="tweight">[주소입력 방법 및 유의사항]</span></p>
					<p><strong>※</strong> 'Daum지도' 약도만들기 상세설명<a href="http://blog.daum.net/daummaps/482" target="_blank"><span class="tweight"> [클릭]</span></a></p>
					<br />
					<p>&#8226; 1) 'Daum지도'에서 약도를 만들 장소를 검색 한다.<a href="http://map.daum.net/" target="_blank"><span class="tweight"> [클릭]</span></a></p>
					<p>&#8226; 2) 해당 장소의 상세보기를 클릭하여 장소상세 페이지를 띄운다.</p>
					<p>&nbsp;&nbsp; ※ [상세보기]미등록시 [지도공유]-[지도퍼가기]-[소스생성하기] 클릭 → 4)번</p>
					<p>&#8226; 3) 오른쪽 위에 있는 약도만들기 버튼 을 클릭 한다.</p>
					<p>&#8226; 4) 약도만들기 레이어에서 소스생성하기를 클릭 한 후 편집기(ex:메모장,한글,워드)에 소스를 붙인다.</p>
					<p>&#8226; 소스중 timestamp(숫자형식) 값과 [<span style="color:blue;">"timestamp" : <strong>"1446100455923"</strong></span>]</p>
					<p>&nbsp;&nbsp;&nbsp;key(숫자+ 영문형식) 값을 [<span style="color:blue;">"key" : <strong>"6dzw"</strong>]</span></p>
					<p>&nbsp;&nbsp;&nbsp;각각 하단 입력창에 복사합니다.</p>
				</td>
			</tr><tr>
				<th><!-- 지도주소 -->timestamp</th>
				<td><input type="text" name="strBranchMapCode" class="input_text" style="width:150px" value="<%=RS_strBranchMapCode%>"  /></td>
				<td> timestamp의 숫자값만 입력합니다.(쎄미콜론 "" 제외)</td>
			</tr><tr>
				<th>Key</th>
				<td><input type="text" name="strBranchKey" class="input_text" style="width:100px" value="<%=RS_strBranchKey%>"  /></td>
				<td> key의 값만 입력합니다.(쎄미콜론 "" 제외)</td>
			</tr>
		</table>
		<div class="submit_area">
			<input type="image" src="<%=IMG_BTN%>/btn_rect_confirm.gif" />&nbsp;<%=aImg("branch_list.asp",IMG_BTN&"/btn_rect_list.gif",99,45,"")%>
		</div>
	<form>
</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
