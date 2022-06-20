<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->

<%
	'후원조직도에서 후원인 검색 (GNG, 2019-03-04)

	strID = pRequestTF("user_id",False)
	Dim popWidth : popWidth = 550
	Dim popHeight : popHeight = 550
	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	PAGESUM = (PAGESIZE * (PAGE-1))

	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGESUM",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
		Db.makeParam("@M_name",adVarWChar,adParamInput,100,strID), _
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("HJP_MEMBER_SEARCH_FROM_SPONTREE",DB_PROC,arrParams,listLen,DB3)
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
<link rel="stylesheet" href="/css/popStyle.css?v1" />
<style type="text/css">
	html {overflow:hidden}	/*크롬 스크롤바 생성 방지*/
	.bgtitle {
		width:530px;padding:10px 10px;margin:0px auto;
		background: #2070aa;
		background: -moz-linear-gradient(#5080af 20%, #2070aa 80%);
		background: -webkit-gradient(linear, left top, left bottom, color-stop(20%, #5080af), color-stop(80%, #2070aa));
		background: -webkit-linear-gradient(#5080af 20%, #2070aa 80%);
		background: linear-gradient(#5080af 20%, #2070aa 80%);
	}
	.bgtitle .bgFont{
		font-size:20px;color:#eee;font-family:malgun gothic;Arial,verdana;
	}
</style>
<script type="text/javascript">
<!--


	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		opener.document.cfrm.SponID1.value = fvalue;
		opener.document.cfrm.SponID2.value = fvalue1;
		opener.document.cfrm.SponIDWebID.value = fvalue2;
		opener.document.cfrm.sponsor.value = fvalue3;
		opener.document.cfrm.SponIDChk.value = 'T';
		self.close();
	}
//-->
</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<div id="pop_search" style="wi dth:540px;">
	<!-- <div id="pop_title"><img src="<%=IMG_POP%>/tit_sponsor.gif" width="250" height="40" alt="User Id Check" /></div> -->
	<div class="bgtitle tweight">
		<span class="bgFont"><%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%></span>
	</div>
	<div class="content">
		<form name="pfrm" action="" method="post">
		<p class="tcenter">
			<span class="searchText"><%=LNG_TEXT_NAME%></span>
			<input type="text" name="user_id" value="<%=strID%>" class="input_text vtop" style="padding:2px 5px;" tabindex="1" />
			<span class="button medium"><button type="submit" class="tweight"><%=LNG_TEXT_SEARCH%></button></span>
			<!-- <input type="image" src="<%=IMG_POP%>/btn_search.gif" class="vtop" tabindex="2" /></p> -->
		<p class="tright">Page : <%=PAGE%> of <%=PAGECOUNT%></p>
		<table <%=tableatt1%> class="search_table">
			<colgroup>
				<col width="12%" />
				<col width="24%" />
				<col width="24%" />
				<col width="16%" />
				<col width="24%" />
			</colgroup>
			<tr>
				<th><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_TEXT_NAME%></th>
				<th><%=LNG_TEXT_ID%></th>
				<th><%=LNG_TEXT_BIRTH%></th>
				<th><%=LNG_TEXT_MEMID%></th>
			</tr>
			<%
				If IsArray(arrList) Then
					Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV

						For i = 0 To listLen
							Nums = All_Count - (PAGESIZE*PAGE) + PAGESIZE - i

							WebID = arrList(2,i)
							BirthDay = arrList(3,i)
							If arrList(2,i) = "" Or IsNull(arrList(2,i)) Then WebID = ""
							On Error Resume Next
								'If WebID	<> "" Then WebID	= objEncrypter.Decrypt(WebID)
								If BirthDay	<> "" Then BirthDay	= objEncrypter.Decrypt(BirthDay)
							On Error Goto 0
							'Birth = Left(BirthDay,2) & "년 " & Mid(BirthDay,3,2)&"월"
							Birth = arrList(7,i)&arrList(8,i)

							arrParams1 = Array(_
								Db.makeParam("@MBID",adVarChar,adParamInput,20,arrList(4,i)), _
								Db.makeParam("@MBID2",adInteger,adParamInput,0,arrList(5,i)) _
							)
							ThisDownLeg = Db.execRsData("DKP_DOWNLEG_CHECK",DB_PROC,arrParams1,DB3)
							If ThisDownLeg = "T" Then
								Tr_OnclickMsg = "insertThisValue('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&"')"
							Else
								'Tr_OnclickMsg = "alert('더이상 "&CS_SPON&"을 등록할 수 없는 회원입니다.');"
								Tr_OnclickMsg = "alert('"&LNG_POP_SPONSOR_TEXT11&"');"
							End If

			%>
			<tr class="tron cp" onclick="<%=Tr_OnclickMsg%>">
				<td><%=Nums%></td>
				<td><%=arrList(1,i)%></td>
				<td><%=WebID%></td>
				<td><%=Birth%></td>
				<td><%=arrList(4,i)%> - <%=Fn_MBID2(arrList(5,i))%></td>
			</tr>
			<%
						Next
					Set objEncrypter = Nothing												'복호화추가E
				Else
			%>
			<tr>
				<td colspan="5" style="padding:30px 0px;">
					<%If strID = "" Then
						PRINT LNG_TEXT_INPUT_SEARCH_WORD
					Else
						PRINT LNG_TEXT_NO_SEARCHED_MEMBER
					End If%>
				</td>
			</tr>
			<%
				End If
			%>
		</table>
		</form>
		<!-- <div class="pagings"><%Call pageList(PAGE,PAGECOUNT)%></div> -->
		<div class="pagingNew"><%Call pageListNew(PAGE,PAGECOUNT)%></div>
	</div>
	<div class="close">
		<div class="line1"></div>
		<div class="line2"></div>
		<span class="button medium tweight" style="margin-top:10px;"><a onclick="self.close();"><%=LNG_TEXT_WINDOW_CLOSE%></a></span>
		<!-- <img src="<%=IMG_POP%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:10px; cursor:pointer;" onclick="self.close();"/> -->
	</div>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="user_id" value="<%=strID%>" />
</form>


<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
