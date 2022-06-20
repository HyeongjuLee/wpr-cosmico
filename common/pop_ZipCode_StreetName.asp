<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	Dim DKSP : Set DKSP = SERVER.CreateObject("ADODB.COMMAND")

	target = Trim(gRequestTF("target",False))


	DORO_NAME = Trim(pRequestTF("DORO_NAME",False))
	popWidth = 430
	popHeight = 280

	viewList = False

	Dim CATEGORYS1	:	CATEGORYS1 = pRequestTF("cate1",False)
	Dim CATEGORYS2	:	CATEGORYS2 = pRequestTF("cate2",False)

%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">
<!--
function checkZipcode(item) {
	var f = document.zz;

	var objOption = item.options[item.selectedIndex];
	var value = objOption.value;
	var addr = objOption.getAttribute('addr');
	var addr2 = objOption.getAttribute('addr2');
	<%if target = "" then%>
	try {
		opener.document.cfrm.strzip.value = value;
		opener.document.cfrm.straddr1.value = addr;
		opener.document.cfrm.straddr2.value = addr2;
		opener.document.cfrm.straddr2.focus();
	}
	<%elseif target = "ori" then%>
	try {
		opener.document.ini.strZip.value = value;
		opener.document.ini.strADDR1.value = addr;
		opener.document.ini.strADDR2.value = addr2;
		opener.document.ini.strADDR2.focus();
	}
	<%elseif target = "take" then%>
	try {
		opener.document.ini.takeZip.value = value;
		opener.document.ini.takeADDR1.value = addr;
		opener.document.ini.takeADDR2.value = addr2;
		opener.document.ini.takeADDR2.focus();
	}

	//shop PG사별 주소선택
	<%elseif target = "inicis" then%>
	try {
		opener.document.ini.strZip.value = value;
		opener.document.ini.strADDR1.value = addr;
		opener.document.ini.strADDR2.value = addr2;
		opener.document.ini.strADDR2.focus();
	}
	<%elseif target = "inicis_take" then%>
	try {
		opener.document.ini.takeZip.value = value;
		opener.document.ini.takeADDR1.value = addr;
		opener.document.ini.takeADDR2.value = addr2;
		opener.document.ini.takeADDR2.focus();
	}
	<%elseif target = "daou" then%>
	try {
		opener.document.frmConfirm.strZip.value = value;
		opener.document.frmConfirm.strADDR1.value = addr;
		opener.document.frmConfirm.strADDR2.value = addr2;
		opener.document.frmConfirm.strADDR2.focus();
	}
	<%elseif target = "daou_take" then%>
	try {
		opener.document.frmConfirm.takeZip.value = value;
		opener.document.frmConfirm.takeADDR1.value = addr;
		opener.document.frmConfirm.takeADDR2.value = addr2;
		opener.document.frmConfirm.takeADDR2.focus();
	}
	<%elseif target = "kiccp" then%>
	try {
		opener.document.frm_pay.strZip.value = value;
		opener.document.frm_pay.strADDR1.value = addr;
		opener.document.frm_pay.strADDR2.value = addr2;
		opener.document.frm_pay.strADDR2.focus();
	}
	<%elseif target = "kiccp_take" then%>
	try {
		opener.document.frm_pay.takeZip.value = value;
		opener.document.frm_pay.takeADDR1.value = addr;
		opener.document.frm_pay.takeADDR2.value = addr2;
		opener.document.frm_pay.takeADDR2.focus();
	}
	<%end if%>
	catch (e) {}
	self.close();
}


$(document).ready(function(){
	$('#cate1')
	  .change(function(){
		chg_category();
	  })
	 .change();
});


function chg_category() {
	createRequest();
	var url = 'getGugun.asp';

	mode = "category2";
	cate = $('#cate1').val();

	postParams = "mode=" + mode;
	postParams += "&cate=" + cate;

	if (cate.length == 0)
	{
		$("#cate2").attr("disabled",true);
		$("#cate2").html("<option value=''>시/도 를 선택해주세요.</option>");
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


function submitChk(f) {
 	if (chkEmpty(f.cate1)) {
		alert("시/도를 선택해주세요.");
		f.cate1.focus();
		return false;
	}
 	if (chkEmpty(f.cate2)) {
		alert("구/군을 선택해주세요.");
		f.cate2.focus();
		return false;
	}
	if (f.DORO_NAME.value.stripspace() == "") {
		alert("도로명을 입력해 주세요.");
		f.DORO_NAME.focus();
		return false;
	}
	if (f.DORO_NAME.value.stripspace().length < 2) {
		alert("정확한 도로명을 입력해 주세요.");
		f.DORO_NAME.focus();
		return false;
	}

	document.getElementById("loadings").style.visibility="visible";
}

function pageGoto(page){
	var target = '<%=target%>'
	if(page == 1){
  		location.href = "pop_ZipCode.asp?target="+target
	}else if(page == 2){
		location.href = "pop_ZipCode_StreetName.asp?target="+target
	}
}

function loaded()
{
  document.all.loading.style.display = 'none';
  document.all.body.style.display = 'block';
}

//-->
</script>
<style type="text/css">
	html{overflow:hidden;}
	div#zip_top {clear:both; float:left;width:430px; height:40px; border-bottom:1px solid #777777;  overflow:hidden;}
	div#searchs {width:430px; height:60px; overflow:hidden; text-align:center;}
	div#titles {clear:both;padding-top:10px;padding-top:15px; text-align:center;color:#000;}
	div#close {height:30px;text-align:center;margin-top:13px;}
	div#zipcheck {text-align:center; margin-bottom:10px;}
	.input_text {height:16px; padding-top:2px;border:1px solid #ddd; width:140px;}
	.line1 {height:1px; background-color:#dedede;}
	.line2 {height:2px; background-color:#f4f4f4;}

	#loading_bg {width:100%;height:100%;top:0px;left:0px;position:fixed;display:block; opacity:0.7;backgr ound-color:#fff;z-index:99;text-align:center; }
	#loading-image {position:absolute; top:35%; left:40%; z-index:100;}

</style>
</head>
<body onload="document.zz.DORO_NAME.focus();" onload="loaded();">
<form name="zz" method="post" onsubmit="return submitChk(this)">
	<div id="loadings" style="width:100%; height:100%;position:absolute;background:url(/images/join/loading_bg70.png) 0 0 repeat; z-index:9999;visibility:hidden;">
		<div id="loading_bg"><img id="loading-image" src="/images/159.gif" width="80"  alt="" /></div>
		<p class="tcenter tweight blue2" style="margin-top:190px;font-size:18px;">검색중입니다. 잠시만 기다려주세요.</p>
	</div>
	<%
		'시/도의 영어이름 → 각 시도 테이블호출
		SQL2 = "SELECT [SiDo_Name_2] FROM [tbl_SiDo_Code] WHERE [SiDo_Name] = ?"

		arrParams = Array(_
			Db.makeParam("@SIDO_NAME_KR",adVarchar,adParamInput,20,CATEGORYS1) _
		)
		Set HJRS = Db.execRs(SQL2,DB_TEXT,arrParams,DB2)
		If Not HJRS.BOF And Not HJRS.EOF Then
			SIDO_NAME = HJRS(0)
		End If

		Select Case SIDO_NAME
			Case "Gangwon"			: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Gangwon"
			Case "Gyeonggi"			: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Gyeonggi"
			Case "Gyeongsangnamdo"	: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Gyeongsangnamdo"
			Case "Gyeongsangbukdo"	: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Gyeongsangbukdo"
			Case "Gwangju"			: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Gwangju"
			Case "Daegu"			: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Daegu"
			Case "Daejeon"			: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Daejeon"
			Case "Busan"			: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Busan"
			Case "Seoul"			: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Seoul"
			Case "Ulsan"			: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Ulsan"
			Case "Incheon"			: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Incheon"
			Case "Jeollanamdo"		: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Jeollanamdo"
			Case "Jeollabukdo"		: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Jeollabukdo"
			Case "Jeju"				: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Jeju"
			Case "Chungcheongnamdo"	: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Chungcheongnamdo"
			Case "Chungcheongbukdo"	: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Chungcheongbukdo"
			Case "Sejong"			: FN_PROCEDURE_NAME = "HJP_ZIPCODE_STREET_SEARCH_Sejong"
		End Select

		'도로명 주소검색
		If DORO_NAME <> "" Then
			viewList = True

			'SQL = "SELECT [ZipCode],[sido],[gugun],[doromyung],[buildingNum],[buildingNumSub],[buildingName],[rawDong] "
			'SQL = SQL& "FROM "&SIDO_NAME&" WHERE [gugun] = ? AND [doromyung] LIKE ? ORDER BY [buildingNum] DESC"
			'Db.makeParam("@DORO_NAME",adVarWChar,adParamInput,255,"%"&DORO_NAME&"%") _
			arrParams = Array( _
				Db.makeParam("@gugun",adVarWChar,adParamInput,255,CATEGORYS2) ,_
				Db.makeParam("@DORO_NAME",adVarWChar,adParamInput,255,DORO_NAME) _
			)
			arrList = Db.execRsList(FN_PROCEDURE_NAME,DB_PROC,arrParams,listLen,DB2)

		End If
	%>
	<div id="zip_top"><img src="<%=IMG_POP%>/tit_addr.gif" width="250" height="40" alt="우편번호 검색 이미지" /></div>
	<div style="margin-left:5px;">
		<label><input type="radio" name="memberType" value="member" onClick="pageGoto(1);">구 지번주소</label>
		<label><input type="radio" name="memberType" value="nonmember" onClick="pageGoto(2);" checked="checked">신 도로명주소</label>
	</div>
	<%If viewList = False Then%>
		<div id="titles">
			<div>검색할 주소의 <font color="#0e95d4"><strong>시/도, 구/군을 선택후 도로명을</strong></font> 입력해 주세요.</div>
			<div height="2"style="margin-bottom:11px;">(예 : 마포대로)</div>
		</div>
	<%Else%>
		<%If Not IsArray(arrList) Then%>
			<%popHeight = 280%>
			<div id="titles">
				<div><font color="#0e95d4">입력하신 도로명은 없습니다.</font></div>
				<div style="margin-bottom:20px;"><font color="#0e95d4">확인후 다시 입력해주세요.</font></div>
			</div>
		<%Else%>
			<div id="titles">
				<div style="margin-bottom:20px;">검색결과 중 해당주소를 <font color="#0e95d4"><strong>선택</strong></font>해 주세요.</div>
			</div>
		<div id="zipcheck">
		<%popHeight = 380%>
		<select size="10" name="zipcode" onChange="checkZipcode(this)" style="width:350px;">
			<%For i = 0 To listLen
				RS_ZipCode			= arrList(0,i)
				RS_sido				= arrList(1,i)
				RS_gugun			= arrList(2,i)
				RS_doromyung		= arrList(3,i)
				RS_buildingNum		= arrList(4,i)
				RS_buildingNumSub	= arrList(5,i)
				RS_buildingName		= arrList(6,i)
				RS_rawDong			= arrList(7,i)

				If RS_buildingNumSub = "0" Then
					RS_buildingNum = RS_buildingNum
				Else
					RS_buildingNum = RS_buildingNum &"-"& RS_buildingNumSub
				End If

				If RS_buildingName <> "" And Not IsNull(RS_buildingName) Then
					If RS_rawDong <> "" And Not IsNull(RS_rawDong) Then
						strADDR2 = "("&RS_rawDong&","&RS_buildingName&")"
					Else
						strADDR2 = "("&RS_buildingName&")"
					End If
				Else
					If RS_rawDong <> "" And Not IsNull(RS_rawDong) Then
						strADDR2 = "("&RS_rawDong&")"
					Else
						strADDR2 = ""
					End If
				End If

				RS_ZipCode = Left(RS_ZipCode,3)&"-"&Right(RS_ZipCode,3)

				addr_view = RS_sido &" "& RS_gugun &" "& RS_doromyung &" "& RS_buildingNum &" "& strADDR2
				strADDR1  = RS_sido &" "& RS_gugun &" "& RS_doromyung &" "& RS_buildingNum
			%>
			<option value="<%=RS_ZipCode%>" addr="<%=strADDR1%>" addr2="<%=strADDR2%>"/><%=addr_view%></option>
			<%
				addr_view = ""
				strADDR1 = ""
				strADDR2 = ""
				Next%>
		</select>
		<%End If%>
		</div>
	<%End If%>

	<div id="searchs">
		<div>
			<select id="cate1" name="cate1">
				<option value="">시/도 선택</option>
				<%
					SQL = "SELECT * FROM [tbl_SiDo_Code]"
					Set DKRS_CATEGORY = Db.execRs(SQL,DB_TEXT,Nothing,DB2)
				%>
				<%If DKRS_CATEGORY.BOF Or DKRS_CATEGORY.EOF Then%>
					<option value="">카테고리를 우선 저장해주셔야합니다</option>
				<%Else%>
				<%	Do Until DKRS_CATEGORY.EOF %>
					<option value="<%=DKRS_CATEGORY(1)%>" <%=isSelect(CATEGORYS1,DKRS_CATEGORY(1))%>><%=DKRS_CATEGORY(1)%></option>
				<%	DKRS_CATEGORY.MoveNext %>
				<%	Loop
				  End If
				  Call closeRs(DKRS_CATEGORY)
				%>
			</select>
			<select id="cate2" name="cate2" disabled="disabled"><option value=""></option></select><br/>
		</div>
		<div style="margin-top:15px;">
			<input type="text" name="DORO_NAME" class="input_text" style="vertical-align:top; width:120px;ime-mode:active;" />
			<input type="image" src="<%=IMG_BTN%>/btn_search.gif" class="vbottom" />
			<!-- <%=aImgSt(Request.ServerVariables("SCRIPT_NAME"),IMG_BTN&"/search_reset.gif",80,23,"","","vbottom")%> -->
		</div>
	</div>
</form>
<div id="close">
<div class="line1"></div>
<div class="line2"></div>
<img src="<%=IMG_POP%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:4px;cursor:pointer;" onclick="self.close();" />
</div>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>

<form name="frm" method="post" action="">
	<input type="hidden" name="cate1" value="<%=cate1%>" />
	<input type="hidden" name="cate2" value="<%=cate2%>" />
</form>

</body>
</html>
