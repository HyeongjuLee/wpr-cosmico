<!--#include virtual ="/_lib/strFunc.asp" -->
<!--#include virtual ="/_include/document.asp" -->

<%

	target = Trim(gRequestTF("target",False))

	TOTAL_ADDRESS = pRequestTF("TOTAL_ADDRESS",False)
	popWidth = 637
	popHeight = 730


	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	PAGESUM = (PAGESIZE * (PAGE-1))

	NOWPAGE = PAGE

	If TOTAL_ADDRESS = "" Then NOWPAGE = 0

	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGESUM",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@M_name",adVarWChar,adParamInput,100,TOTAL_ADDRESS), _
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("HJP_ZIPCODE_JP_SEARCH",DB_PROC,arrParams,listLen,Nothing)
	ALL_COUNT = arrParams(UBound(arrParams))(4)

	'print All_Count

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int(((All_Count) - 1 ) / CInt(PAGESIZE)) + 1
	IF PAGE = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - (((PAGE)-1)*CInt(PAGESIZE)) '
	End If

	If UCase(Lang) = "KR" Then
		imes = " imes_kr"
	Else
		imes = " imes"
	End If
%>
<link type="text/css" rel="stylesheet" href="/jquerymobile/jquery.mobile-1.3.2.min.css" />
<style>
	html {overflow:hidden}

	#top {position:relative;width:100%; height:56px;}
	#top .top_logo {position:absolute; top:50%; left:50%; margin:0px 0px 0px -49px;}

	#subTitle2 {border-top: 1px solid #d2d2d2; border-bottom: 1px solid #d2d2d2; width: 100%; text-align: center; background-color: #eee; color: #525252; font-size: 16px; padding: 10px 0;}
	table {border-collapse: collapse;}
	.width100 {width:100%;}
	.tron:hover {background:#eee;}

	#pop_search th {background-color:#eee; border:1px solid #ccc;padding:10px 0px; font-size:14px;}
	#pop_search td {border:1px solid #ccc; font-size:14px; text-align:left;line-height:20px;}
	#pop_search .tron td {padding:6px 10px;}

	.popClose {border-radius:4px; font-size:15px; line-height:32px; height:36px; border:1px solid #ccc; width:40%; margin-top:15px;}
	.popInput {border-radius:4px 0px 0px 4px; font-size:15px; line-height:32px; height:32px; border:1px solid #ccc; width:40%;padding-left:10px;outline:none;}
	.popSearchBtn {border-radius:0px 4px 4px 0px; font-size:15px; line-height:32px; height:36px; border:1px solid #ccc; width:20%; border-left:0px none;outline:none;}

	.zip_inDiv {width:630px;height:300px; overflow-y:scroll; overflow-x:hidden;padding-bottom:10px; border-bottom:1px solid #ccc;}

</style>
<script type="text/javascript">
<!--

	function checkZipcode(fvalue,fvalue1)
	{
		<%if target = "" then%>
		try {
			opener.document.cfrm.strZip.value = fvalue;
			opener.document.cfrm.strADDR1.value = fvalue1
			opener.document.cfrm.strADDR2.focus();
		}
		<%elseif target = "strZip" then%>
		try {
			opener.document.getElementById('strZip').value = fvalue;
			opener.document.getElementById('strADDR1').value = fvalue1;
			opener.document.getElementById('strADDR2').focus();
		}
		<%elseif target = "takeZip" then%>
		try {
			opener.document.getElementById('takeZip').value = fvalue;
			opener.document.getElementById('takeADDR1').value = fvalue1;
			opener.document.getElementById('takeADDR2').focus();
		}
		<%end if%>
		catch (e) {}
		self.close();
	}

	function loadings() {
		var loadingBar = $("#loadings");
		loadingBar.toggle();
	}

	function frmChk(f) {
		if(!chkNull(f.TOTAL_ADDRESS, "検索語を入力してください")) return false;
		if (f.TOTAL_ADDRESS.value.length < 2)
		{
			alert("正確な検索語を入力してください");
			return false;
		}
		loadings();
	}

//-->
</script>
<style type="text/css">
	#loading_bg {width:100%;height:100%;top:0px;left:0px;position:fixed;display:block; opacity:0.7;background-color:#fff;z-index:99;text-align:center; }
	#loading-image {position:absolute; top:40%; left:50%; z-index:100;margin-left:-35px;}
</style>
</head>
<body onload="document.pfrm.TOTAL_ADDRESS.focus();">
<div id="loadings" style="width:100%; height:100%;position:absolute;display:none;">
	<div id="loading_bg">
		<img id="loading-image" src="<%=IMG%>/159.gif" width="70"  alt="" />
		<!-- <div style="margin-top:50%;opacity:1;color:red;font-weight:bold;font-size:15px;"><br /><%=LNG_TEXT_PROCESSING_DATA%></div> -->
	</div>
</div>
<div id="top" class="tcenter">
	<img src="/m/images/top_logo.png" width="100" height="" style="margin-top:10px;" />
</div>
<div id="subTitle2" class="width100 tcenter text_noline">アドレス検索</div>
<div id="pop_search" class="width100">
	<form name="pfrm" action="" method="post" onsubmit="return frmChk(this)">
		<div id="searchs" style="margin:15px 5px;" class="tcenter">
			<input type="text" name="TOTAL_ADDRESS" value="<%=TOTAL_ADDRESS%>" class="popInput <%=imes%>"/><input type="submit" value="<%=LNG_TEXT_SEARCH%>" class="popSearchBtn vtop" />
		</div>
	</form>
	<p class="tright">Page : <%=NOWPAGE%> of <%=PAGECOUNT%>&nbsp;&nbsp;</p>
	<table <%=tableatt1%> class="width100" style="width:630px;">
		<colgroup>
			<col width="80" />
			<col width="532" />
			<col width="18" />
		</colgroup>
		<tr>
			<th><%=LNG_TEXT_ZIPCODE%></th>
			<th><%=LNG_TEXT_ADDRESS1%></th>
			<th></th>
		</tr>
	</table>
	<div class="cleft width100 zip_inDiv" style="width:630px;">
		<table <%=tableatt1%> class="width100" style="width:612px;">
			<colgroup>
				<col width="80" />
				<col width="532" />
			</colgroup>
			<%
				If IsArray(arrList) Then
					Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV

					For i = 0 To listLen
						Nums = All_Count - (PAGESIZE*PAGE) + PAGESIZE - i

						arr_ZipCode				= arrList(1,i)
						arr_YuMen_EN			= arrList(2,i)
						arr_BunGi_EN			= arrList(3,i)
						arr_Building_N_EN		= arrList(4,i)
						arr_total_address_EN	= arrList(5,i)
						arr_total_address_JP	= arrList(6,i)

						'Tr_OnclickMsg = "checkZipcode('"&arr_ZipCode&"','"&arr_total_address_EN&"')"			'영문주소 입력
						Tr_OnclickMsg = "checkZipcode('"&arr_ZipCode&"','"&arr_total_address_JP&"')"			'일문주소 입력

			%>
			<tr class="tron cp" onclick="<%=Tr_OnclickMsg%>">
				<td class="tcenter"><%=arr_ZipCode%></td>
				<td>
					<%=arr_total_address_JP%>
					<br />
					<span style="font-size:12px;color: #A6A6A6;"><%=arr_total_address_EN%></span>
				</td>
			</tr>
			<%
					Next
					Set objEncrypter = Nothing												'복호화추가E
				Else
			%>
			<tr>
				<td colspan="2" class="tcenter" style="padding:144px 0px;">
					<%If TOTAL_ADDRESS = "" Then%>
						<span class="tweight blue2" >郵便番号または住所を入力してください。</span><%'우편번호 또는 주소를 입력해주세요. 2018-06-30~%>
						<!-- <span class="tweight lightBlue" >検索するアドレスを入力してください。</span> -->
					<%Else%>
						<span class="tweight red2">検索結果がありません。</span>
					<%End If%>
				</td>
			</tr>
			<%
				End If
			%>
		</table>
	</div>
	<div class="pagingNew"><%Call pageListNew(PAGE,PAGECOUNT)%></div>
	<!-- <div class="pagingArea pagingMob5"><% Call pageListMob5(PAGE,PAGECOUNT)%></div> -->

	<div class="close width100 tcenter" style="margin:5px 0px 30px 0px;">
		<div class="line1"></div>
		<div class="line2"></div>
		<input type="button" value="<%=LNG_TEXT_WINDOW_CLOSE%>" onclick="self.close();" class="popClose" />
	</div>

</div>


<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="TOTAL_ADDRESS" value="<%=TOTAL_ADDRESS%>" />
</form>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
