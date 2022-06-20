<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/m/_include/document.asp"-->
<!--#include virtual="/m/_include/jqueryload.asp"-->

<%

	Dim DKSP : Set DKSP = SERVER.CreateObject("ADODB.COMMAND")

	target = Trim(gRequestTF("target",False))

	DORO_NAME = Trim(pRequestTF("DORO_NAME",False))
	popWidth = 430
	popHeight = 280

	viewList = False

	Dim CATEGORYS1	:	CATEGORYS1 = pRequestTF("cate1",False)
	Dim CATEGORYS2	:	CATEGORYS2 = pRequestTF("cate2",False)

'	WITH DKSP
'		.ActiveConnection = db2
'		.CommandType = adCmdStoredProc
'		.CommandText = "DK_ZIPSEARCH"
'
'		.Parameters.Append .CreateParameter("@dong",adVarChar,adParamInput,52,DONG)
'
'		Set DKRS = .EXECUTE
'	End WITH
'	LIST = False
'	If Not DKRS.BOF Or Not DKRS.EOF Then
'		LIST = True
'		RESULT = DKRS.GETROWS()
'		COUNT = UBound(RESULT,2)
'	End If
'End If

%>

<script type="text/javascript">
<!--
function checkZipcode(item) {
	var f = document.zz;

	if (item.value != "")
	{

		var objOption = item.options[item.selectedIndex];
		var value = objOption.value;
		var addr = objOption.getAttribute('addr');
		try {
			opener.document.frmConfirm.takeZip.value = value;
			opener.document.frmConfirm.takeADDR1.value = addr;
			opener.document.frmConfirm.takeADDR2.focus();
		}
		catch (e) {}
		self.close();
	}
}


$(document).ready(function(){
	$('#cate1')
	  .change(function(){
		chg_category();
	  })
	 .change();
});


function chg_category() {



		$.ajax({
			type: "POST"
			,url: "getGugun.asp"
			,data: {
				  "mode"		: "category2"
				 ,"cate"		: $('#cate1').val()
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
					$("#cate2").attr("disabled",false);
					$("#cate2").html(data);
					$("#cate2").val("<%=CATEGORYS2%>");
			}
			,error:function(data) {
				alert("ajax error");
			}
		});


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






function pageGoto(){
	page = $("input[name=afType]:checked").val();
	if(page == 1){
		location.href = "pop_ZipCode.asp";
	}else if(page == 2){
		location.href = "pop_ZipCode_StreetName.asp";
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
	div#titles {clear:both;padding-top:10px;padding-top:15px; text-align:center;color:#000;}
	div#close {height:30px;text-align:center;margin-top:13px;}
	div#zipcheck {text-align:center; margin-bottom:10px;}
	.input_text {height:16px; padding-top:2px;border:1px solid #ddd; width:140px;}
	.line1 {height:1px; background-color:#dedede;}
	.line2 {height:2px; background-color:#f4f4f4;}

	.zipbtn .ui-btn-inner {padding:6px 0px !important;}
	.zipbtn .ui-btn-inner span {padding:0px 0px !important;}
	#zip {position:relative;width:100%; height:66px; background:url(/m/images/header_bg2.png) 0px 0px no-repeat; background-size:100% 66px;}
	#zip .top_logo {position:absolute; top:50%; left:50%; margin:-10px 0px 0px -72px;}


	#loading_bg {width:100%;height:100%;top:0px;left:0px;position:fixed;display:block; opacity:0.7;backgr ound-color:#fff;z-index:99;text-align:center; }
	#loading-image {position:absolute; top:35%; left:40%; z-index:100;}

</style>
<script src="/m/js/check.js"></script>
<link rel="stylesheet" href="/m/js/icheck/skin/line/_all.css" />
<script src="/m/js/icheck/icheck.min.js"></script>
</head>
<body>
<div id="loadings" style="width:100%; height:100%;position:absolute;background:url(/images/join/loading_bg70.png) 0 0 repeat; z-index:9999;visibility:hidden;">
	<div id="loading_bg"><img id="loading-image" src="/images/159.gif" width="80"  alt="" /></div>
	<p class="tcenter tweight blue2" style="margin-top:190px;font-size:18px;">검색중입니다. 잠시만 기다려주세요.</p>
</div>

<div id="zip" class=""><div class="top_logo"><img src="<%=M_IMG%>/zip_top.png" width="140" /></div></div>
<div style="margin:10px 5px 0px 5px;">
	<div style="">
		<div class="fleft" style="width:49%;"><div class="skin-grey2"><input type="radio" name="afType" value="1"  /><label>구 지번주소</label></div></div>
		<div class="fright" style="width:49%;"><div class="skin-grey2"><input type="radio" name="afType" value="2" checked="checked" /><label>신 도로명주소</label></div></div>
		<script>
			$(document).ready(function(){
				$('.skin-grey2 input').each(function(){
					var self = $(this),
					label = self.next(),
					label_text = label.text();

					label.remove();
					self.iCheck({
						checkboxClass: 'icheckbox_line-grey',
						radioClass: 'iradio_line-grey',
						insert: '<div class="icheck_line-icon"></div>' + label_text
					}).on('ifChecked',function(event){
					pageGoto();
				});
			});

			});
		</script>
	</div>

</div>

<form name="zz" method="post" onsubmit="return submitChk(this)" data-ajax="false">
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

		If viewList = False Then
	%>
		<div id="titles" style="font-size:16px; font-weight:bold;">
			<div>검색할 주소의 <font color="#0e95d4"><strong>시/도, 구/군을 선택후 도로명을</strong></font> 입력해 주세요.</div>
			<div height="2"style="margin-bottom:11px;">(예 : 마포대로)</div>
		</div>
	<%Else%>
		<%If Not IsArray(arrList) Then%>
			<%popHeight = 280%>
			<div id="titles" style="font-size:16px; font-weight:bold;">
				<div><font color="#0e95d4">입력하신 도로명은 없습니다.</font></div>
				<div style="margin-bottom:20px;"><font color="#0e95d4">확인후 다시 입력해주세요.</font></div>
			</div>
		<%Else%>
			<div id="titles" style="font-size:16px; font-weight:bold;">
				<div style="margin-bottom:20px;">검색결과 중 해당주소를 <font color="#0e95d4"><strong>선택</strong></font>해 주세요.</div>
			</div>
			<div id="zipcheck" style="margin:0px 5px;">
				<select name="zipcode" onChange="checkZipcode(this)" style="width:100%;height:25px; font-size:15px; line-height:25px;">
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
			<div class="close width100 tcenter" style=" margin:20px 0px;">
				<div class="line1"></div>
				<div class="line2"></div>

			</div>
		<%End If%>
		</div>
	<%End If%>

	<div id="searchs" class="" style="margin:0px 5px; " class="tcenter">
		<div style="padding:0px 0px;">
			<select id="cate1" name="cate1" style="width:49%; float:left; height:25px; font-size:15px; line-height:25px;">
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
			<select id="cate2" name="cate2" disabled="disabled" style="width:49%; float:right; height:25px; font-size:15px; line-height:25px;"><option value=""></option></select><br/>
		</div>

		<div class="tcenter" style="padding-top:25px;">
		<input type="text" name="DORO_NAME" value="<%=DORO_NAME%>" style="border-radius:4px 0px 0px 4px; font-size:15px; line-height:32px; height:32px; border:1px solid #ccc; width:70%;"  /><input type="submit" value="검색" style="border-radius:0px 4px 4px 0px; font-size:15px; line-height:32px; height:36px; border:1px solid #ccc; width:20%; border-left:0px none;" />
		</div>

	</div>
</form>
<div class="close width100 tcenter" style=" margin-top:20px;">
	<div class="line1"></div>
	<div class="line2"></div>
	<input type="button" value="창 닫기" onclick="self.close();" style="border-radius:4px; font-size:15px; line-height:32px; height:36px; border:1px solid #ccc; width:40%; margin-top:15px;" />
</div>

<form name="frm" method="post" action="">
	<input type="hidden" name="cate1" value="<%=cate1%>" />
	<input type="hidden" name="cate2" value="<%=cate2%>" />
</form>

</body>
</html>
