<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "GOODS"
	INFO_MODE = "GOODS3-5"
%>
<link rel="stylesheet" type="text/css" href="telecom.css" />
<script type="text/javascript" src="banner.js"></script>
<script type="text/javascript">
<!--
	function join_idcheck() {
		var ids = document.regfrm.strShopID;
		if (ids.value == '')
		{
			alert("아이디를 입력하셔야합니다.");
			ids.focus();
			return false;
		}

		if (!checkID(ids.value.trim(), 4, 13)){
			alert("아이디는 영문 혹은 숫자 4자~13자리로 해주세요.");
			ids.focus();
			return false;
		}
		createRequest();

		var url = 'ajax_ShopIdCheck.asp?ids='+ids.value;

		request.open("GET",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					document.getElementById("idCheck").innerHTML = newContent;
				}
			}
		}
		request.send(null);
	}

//등록
function submitInsert() {
	var f = document.regfrm;
/*
	if (f.strShopID.value == '')
	{
		alert('제조사(판매처) ID 를 입력해주세요');
		f.strShopID.focus();
		return false;
	}
*/
	if (f.strShopID.value == "")
	{
		alert("아이디를 입력해주세요");
		f.strShopID.focus();
		return false;
	} else {
		if (!checkID(f.strShopID.value, 4, 13)){
			alert("아이디는 영문 혹은 숫자 4자~13자리로 해주세요.");
			f.strShopID.focus();
			return false;
		}
		if (f.idcheck.value == 'F'){
			alert("아이디 중복확인을 해주세요.");
			f.strShopID.focus();
			return false;
		}
/*
		if (f.strShopID.value != f.chkID.value){
			alert("중복확인한 아이디와 현재 등록된 아이디가 틀립니다. 다시한번 아이디 중복확인을 해주세요.");
			f.strShopID.focus();
			return false;
		}
*/
	}



	if (f.strComName.value == '')
	{
		alert('유통사 이름을 입력해주세요');
		f.strComName.focus();
		return false;
	}
	if (f.FeeType.value==''){
		alert('지불방식을 선택해주세요');
		f.FeeType.focus();
		return false;
	}
	if (f.intFee.value==''){
		alert('배송비를 입력해주세요');
		f.intFee.focus();
		return false;
	}
	if (f.intLimit.value==''){
		alert('배송비한도를 입력해주세요');
		f.intLimit.focus();
		return false;
	}
	if (confirm("등록하시겠습니까?")) {
		f.target = "_self";
		return;
	} else {
		return false;
	}

}

//수정
function submitMod(f) {

	if (confirm("수정하시겠습니까?")){
		return;
	} else {
		return false;
	}

}

function ThisDel(idx,shopID) {
	var f = document.delFrm;
	var msg = "삭제하시겠습니까?";

	if(confirm(msg)){
		f.intIDX.value = idx;
		f.strShopID.value = shopID;
		f.submit();
	}

}
/*
//사용여부 상태변경 /삭제
function submitThisLine(intIDX,mode,values) {
	var f = document.mfrm;
	var msg;

	if (mode == 'USE')	{
		msg = "변경";
	} else if (mode == 'DELETE'){
		msg = "삭제";
	}

	if (confirm(msg+"하시겠습니까?")){
		f.intIDX.value = intIDX;
		f.mode.value = mode;
		f.values.value = values;		// T/F
		f.submit();
	}

}
*/

//-->
</script>
<style>
	.input_text {border:1px solid #ccc; height:16px; padding-top:2px;}

	#deliveryFee th {border:1px solid #ccc; padding:5px 0px; background-color:#eee;}
	#deliveryFee td {border:1px solid #ccc; padding:5px 5px;}
</style>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="deliveryFee" class="">

	<div class="cleft">
		<p class="titles">택배비정보</p>
		<%
			col_width01 = "20%"
			col_width02 = "20%"
			col_width03 = "15%"
			col_width04 = "15%"
			col_width05 = "15%"
			col_width07 = "15%"
		%>
		<table <%=tableatt%> style="width:1000px;">
			<colgroup>
				<col width="<%=col_width01%>" />
				<col width="<%=col_width02%>" />
				<col width="<%=col_width03%>" />
				<col width="<%=col_width04%>" />
				<col width="<%=col_width05%>" />
				<col width="<%=col_width07%>" />
			</colgroup>
			<tr>
				<th>유통사 이름</th>
				<th>유통사ID<span class="red">(수정불가)</span></th>
				<th>지불방식</th>
				<th>배송비</th>
				<th>무료배송금액</th>
				<th>수정 / 삭제</th>
			</tr>
		</table>
		<%
'			SQL = "[intIDX],[strShopID],[strComName],[FeeType],[intFee],[intLimit],[regDate],[regID],[hostIP]"
'			arrList = Db.execRsList("HJ_DELIVERY_INFO_LIST",DB_PROC,Nothing,listLen,Nothing)
		'	arrList = Db.execRsList("DKPA_DELIVERY_FEE_GABOGO",DB_PROC,Nothing,listLen,Nothing)


		'		Db.makeParam("@comShopID",adVarChar,adParamInput,30,"company") _
			arrParams = Array(_
				Db.makeParam("@comShopID",adVarChar,adParamInput,30,MAINVENDOR) _
			)
			arrList = Db.execRsList("DKPA_DELIVERY_FEE_COMPANY",DB_PROC,arrParams,listLen,Nothing)

			If IsArray(arrList) Then
				For i = 0 To listLen
					arrList_intIDX			= arrList(0,i)
					arrList_strShopID		= arrList(1,i)
					arrList_strComName		= arrList(3,i)
					arrList_FeeType			= arrList(9,i)
					arrList_intFee			= arrList(10,i)
					arrList_intLimit		= arrList(11,i)


			'FOR NEXT 문 안에 FORM INPUT 테이블 넣기 - > 리스트 각개별로 전송
		%>
			<form name="modfrm" method="post" action="deliveryFee_Handler.asp" onsubmit="return submitMod(this)">
			<input type="hidden" name="MODE" value="MODIFY" readonly="readonly" />
			<input type="hidden" name="intIDX" value="<%=arrList_intIDX%>" readonly="readonly" />
				<table <%=tableatt%> style="width:1000px;">
					<colgroup>
						<col width="<%=col_width01%>" />
						<col width="<%=col_width02%>" />
						<col width="<%=col_width03%>" />
						<col width="<%=col_width04%>" />
						<col width="<%=col_width05%>" />
						<col width="<%=col_width07%>" />
					</colgroup>
					<tr>
						<!-- <td class="tcenter"><%=TFVIEWER(arrList_isUse,"USE")%></td> -->
						<td class="tcenter"><%=arrList_strComName%></td>
						<td class="tcenter"><%=arrList_strShopID%></td>
						<td class="tcenter">
							<select name="FeeType" class="selectbox">
								<!-- <option value="">지불방식선택</option> -->
								<option value="prev" <%=isSelect("prev",arrList_FeeType)%>>선불</option>
								<option value="next" <%=isSelect("next",arrList_FeeType)%>>착불</option>
								<option value="free" <%=isSelect("free",arrList_FeeType)%> >무료</option>
							<select>
						</td>
						<td class="tcenter"><input type="text" name="intFee" class="input_text vmiddle" style="width:45px;text-align:right;" value="<%=arrList_intFee%>" <%=onLyKeys%> /> 원</td>
						<td class="tcenter"><input type="text" name="intLimit" class="input_text vmiddle" style="width:45px;text-align:right;" value="<%=arrList_intLimit%>" <%=onLyKeys%> /> 원</td>
						<td class="tcenter">
							<input type="image" src="<%=IMG_BTN%>/btn_gray_update.gif" class="" />

						</td>
					</tr>
				<%'FOR NEXT 문 안에 FORM INPUT 테이블 넣기 - > 리스트 각개별로 전송%>
				</table>
			</form>
		<%
				Next
			Else
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
					</colgroup>
					<tr>
						<td colspan="7" class="notData">등록된 택배비정보가 없습니다.</td>
					</tr>
				</table>
			</form>
		<%
			End If
		%>
	</div>

<form name="mfrm" method="post" action="deliveryFee_Handler.asp">
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="values" value="" />
</form>
<form name="delFrm" action="deliveryFee_Handler.asp" method="post">
	<input type="hidden" name="mode" value="DELETE" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="isDel" value="T" />
	<input type="hidden" name="strShopID" value="" />
</form>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
