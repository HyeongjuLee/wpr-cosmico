<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "GOODS"
	'INFO_MODE = "GOODS6-1"

	strNationCode = Request("nc")


	arrParams_FA = Array(Db.makeParam("@strNationCode",adVarChar,adParamInput,6,strNationCode))
	Set DKRS_FA = Db.execRs("DKSP_SITE_NATION_VIEW",DB_PROC,arrParams_FA,Nothing)
	If Not DKRS_FA.BOF And Not DKRS_FA.EOF Then
		DKRS_FA_strNationName	= DKRS_FA("strNationName")
		DKRS_FA_intSort			= DKRS_FA("intSort")
	Else
		Call ALERTS("설정되지 않은 국가입니다!","BACK","")
	End If

	INFO_MODE = "GOODS6-1-"&DKRS_FA_intSort&""
	INFO_TEXT = DKRS_FA_strNationName


	CATEGORY_NAME01 = "메인카테고리"
    
%>
<style type="text/css">
	.input_text {border:1px solid #ccc; height:16px; padding-top:2px;}

	#category th {border:1px solid #ccc; padding:5px 0px; background-color:#eee;}
	#category td {border:1px solid #ccc; padding:5px 5px;}

</style>
<script type="text/javascript" src="banner.js"></script>
<script type="text/javascript">
<!--

	//등록
	function submitInsert() {
		var f = document.regfrm;

		if (f.strCateName.value==''){
			alert('이름을 입력해주세요');
			f.strCateName.focus();
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
	function submitMod(ThisValues,uidx) {
		var f = document.modfrm;

		if (confirm("수정하시겠습니까?")){
			f.MODE.value = "MODIFY";
			f.values.value = ThisValues;	//strCateName0,strCateName1,strCateName2...
			f.intIDX.value = uidx;
			f.submit();
		}

	}

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

	// 삭제
	function DelThisLine(intIDX,mode,values) {
		var f = document.mfrm;
		var msg;

		//if (confirm("등록된 단말기, 가입유형, 구매유형 ~ 유심비 내역까지 모두 삭제되고 복구할 수 없습니다. \n\n 삭제하시겠습니까? ")){
		if (confirm("선택한 내역를 삭제하시겠습니까?\n\n\※ 삭제 후 복구할 수 없습니다.")) {
			f.intIDX.value = intIDX;
			f.mode.value = mode;
			f.values.value = values;		// T/F
			f.submit();
		}

	}

//-->
</script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="category" class="">
	<div class="cleft">
		<p class="titles"><%=CATEGORY_NAME01%> 등록</p>
		<form name="regfrm" method="post" action="Category01_Handler.asp"onSubmit="return submitInsert(this);">
			<input type="hidden" name="mode" value="REGIST" />
			<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />
			<table <%=tableatt%> style="width:720px;">
				<col width="120" />
				<col width="380" />
				<col width="*" />
				<tr>
					<th><%=CATEGORY_NAME01%> 이름</th>
					<td><input type="text" name="strCateName" class="input_text vmiddle" style="width:300px" /></td>
					<td colspan="3" class="tcenter"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
				</tr>
			</table>
		</form>
	</div>

	<div class="cleft">
		<p class="titles"><%=CATEGORY_NAME01%> 리스트</p>
		<form name="modfrm" method="post" action="Category01_Handler.asp">
			<input type="hidden" name="MODE" value="" readonly="readonly" />
			<input type="hidden" name="intIDX" value="" readonly="readonly" />
			<input type="hidden" name="values" value="" readonly="readonly" />
			<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />
			<table <%=tableatt%> style="width:720px;">
				<col width="60" />
				<col width="60" />
				<col width="*" />
				<col width="220" />
				<tr>
					<th>사용여부</th>
					<th>코드</th>
					<th><%=CATEGORY_NAME01%> 이름</th>
					<th>기능</th>
				</tr>
				<%
					SQL = " SELECT * FROM [HW_SHOP_CATEGORY01] WHERE [isDel] = 'F' ORDER BY [strCateCode] ASC"
					arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,Nothing)

					If IsArray(arrList) Then
						For i = 0 To listLen
							arrList_intIDX        	= arrList(0,i)
							arrList_strNationCode 	= arrList(1,i)
							arrList_strCateCode   	= arrList(2,i)
							arrList_strCateName   	= arrList(3,i)
							arrList_isUse         	= arrList(4,i)
							arrList_isDel         	= arrList(5,i)
							arrList_intCateSort   	= arrList(6,i)
				%>
				<tr>
					<td class="tcenter"><%=TFVIEWER(arrList_isUse,"USE")%></td><!-- strText.asp -->
					<td class="tcenter"><%=arrList_strCateCode%></td>
					<td class=""><input type="text" name="strCateName<%=i%>" class="input_text vmiddle" style="width:300px" value="<%=arrList_strCateName%>" /></td>

					<td class="tcenter">
						<%=aImgOPT("javascript:submitThisLine('"&arrList_intIDX&"','USE','T')","S",IMG_BTN&"/btn_isUseT.gif",45,22,"","")%>
						<%=aImgOPT("javascript:submitThisLine('"&arrList_intIDX&"','USE','F')","S",IMG_BTN&"/btn_isUseF.gif",45,22,"","")%>&nbsp;&nbsp;

						<%=aImgOPT("javascript:submitMod(document.modfrm.strCateName"&i&".value,'"&arrList_intIDX&"');","S",IMG_BTN&"/btn_gray_update.gif",45,22,"","")%>&nbsp;
						<!-- <%=aImgOPT("javascript:submitThisLine('"&arrList_intIDX&"','DELETE','T')","S",IMG_BTN&"/btn_gray_delete.gif",45,22,"","")%> -->
						<!-- <%=aImgOPT("javascript:DelThisLine('"&arrList_intIDX&"','DELETE','T')","S",IMG_BTN&"/btn_gray_delete.gif",45,22,"","")%> -->
					</td>
				</tr>
				<%
						Next
					Else
				%>
				<tr>
					<td colspan="6" class="notData"></td>
				</tr>
				<%
					End If
				%>
			</table>
		</form>
	</div>



<form name="mfrm" method="post" action="Category01_Handler.asp">
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="intIDX" value="" />
	<input type="hidden" name="values" value="" />
	<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />
</form>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
