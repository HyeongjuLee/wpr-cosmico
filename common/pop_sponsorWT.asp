<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->

<%

	Response.Redirect "/common/pop_sponsorWT_ID.asp"	'더화이트 라인선택(2016-05-26) WebID검색(화이트, 2016-06-14)


	strID = pRequestTF("user_id",False)
	Dim popWidth	:	popWidth = 550
	Dim popHeight	:	popHeight = 590
	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
		Db.makeParam("@M_name",adVarWChar,adParamInput,100,strID), _
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("[HJP_MEMBER_SEARCH_SPON_FROM_VOTER]",DB_PROC,arrParams,listLen,DB3)
	All_Count = arrParams(UBound(arrParams))(4)

'	print All_Count

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int(((All_Count) - 1) / CInt(PAGESIZE)) + 1
	IF PAGE = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - (((PAGE)-1)*CInt(PAGESIZE)) '
	End If

%>
<link rel="stylesheet" href="/css/popStyle.css" />
<style type="text/css">
	html {overflow:hidden}	/*크롬 스크롤바 생성 방지*/
	.bgtitle {
		width:100%;padding:10px 10px;margin:0px auto;
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

	// 1라인 선택, 값 넘기기
	function insertThisValue1(fvalue,fvalue1,fvalue2,fvalue3,fvalue4)
	{
		//if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" 님을 후원인으로 등록하시겠습니까?")) {
		if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" \n\n<%=LNG_POP_SPONSOR_JS01%>")) {
			opener.document.cfrm.SponID1.value = fvalue;
			opener.document.cfrm.SponID2.value = fvalue1;
			opener.document.cfrm.SponIDWebID.value = fvalue2;
			opener.document.cfrm.sponsor.value = fvalue3;
			opener.document.cfrm.sponLine.value = fvalue4;
			opener.document.cfrm.SponIDChk.value = 'T';
			self.close();
		}
	}
	// 2라인 선택, 값 넘기기
	function insertThisValue2(fvalue,fvalue1,fvalue2,fvalue3,fvalue4)
	{
		//if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" 님을 후원인으로 등록하시겠습니까?")) {
		if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" \n\n<%=LNG_POP_SPONSOR_JS01%>")) {
			opener.document.cfrm.SponID1.value = fvalue;
			opener.document.cfrm.SponID2.value = fvalue1;
			opener.document.cfrm.SponIDWebID.value = fvalue2;
			opener.document.cfrm.sponsor.value = fvalue3;
			opener.document.cfrm.sponLine.value = fvalue4;
			opener.document.cfrm.SponIDChk.value = 'T';
			self.close();
		}
	}

//-->
</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<div id="pop_search">
	<!-- <div id="pop_title"><img src="<%=IMG_POP%>/tit_sponsor.gif" width="250" height="40" alt="User Id Check" /></div> -->
	<div class="bgtitle tweight">
		<span class="bgFont"><%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%></span>
	</div>
	<div class="content" style="height:410px;">
		<form name="pfrm" action="" method="post">
		<p class="tcenter">
			<span class="searchText"><%=LNG_TEXT_NAME%></span>
			<input type="text" name="user_id" value="<%=strID%>" class="input_text vtop" style="padding:2px 5px;" tabindex="1" />
			<span class="button medium"><button type="submit" class="tweight"><%=LNG_TEXT_SEARCH%></button></span>
			<!-- <input type="image" src="<%=IMG_POP%>/btn_search.gif" class="vtop" tabindex="2" /></p> -->
		<p class="tright">Page : <%=PAGE%> of <%=PAGECOUNT%></p>
		<table <%=tableatt1%> class="search_table">
			<colgroup>
				<col width="10%" />
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
				<col width="10%" />
				<col width="10%" />
				<col width="10%" />
			</colgroup>
			<tr>
				<th><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_TEXT_NAME%></th>
				<th><%=LNG_TEXT_ID%></th>
				<th><%=LNG_TEXT_MEMID%></th>
				<th><%=LNG_TEXT_LEVEL%></th>
				<th>A</th>
				<th>B</th>
			</tr>
			<%
				If IsArray(arrList) Then
					Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV
						For i = 0 To listLen
							Nums = All_Count - (PAGESIZE*PAGE) + PAGESIZE - i

							WebID	 = arrList(2,i)
							BirthDay = arrList(3,i)
							LVL		 = arrList(6,i)
							L_LINE	 = arrList(10,i)
							R_LINE	 = arrList(11,i)

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
								Jas_Line1  = "onclick=""insertThisValue1 ('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&" - A', '1')"" "
								Jas_Line2  = "onclick=""insertThisValue2 ('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&" - B', '2')"" "
							Else
								'Tr_OnclickMsg = "alert('더이상 "&CS_SPON&"을 등록할 수 없는 회원입니다.');"
								Tr_OnclickMsg = "alert('"&LNG_POP_SPONSOR_TEXT11&"');"
							End If

			%>
			<!-- <tr class="tron cp" <%=Tr_OnclickMsg%>> -->
			<tr>
				<td><%=Nums%></td>
				<td><%=arrList(1,i)%></td>
				<td><%=WebID%></td>
				<td><%=arrList(4,i)%> - <%=Fn_MBID2(arrList(5,i))%></td>
				<td><%=LVL%></td>
				<%If L_LINE = 0 And R_LINE = 0 Then %>
					<td><input type="image" src="<%=IMG_ICON_KR%>/saton.png" class="vmiddle"<%=Jas_Line1%> /></td>
					<td><input type="image" src="<%=IMG_ICON_KR%>/saton.png" class="vmiddle"<%=Jas_Line2%> /></td>
				<%ElseIf L_LINE = 0 And R_LINE = 2 Then %>
					<td><input type="image" src="<%=IMG_ICON_KR%>/saton.png" class="vmiddle"<%=Jas_Line1%> /></td>
					<td><img src="<%=IMG_ICON_KR%>/satOff.png" class="vmiddle" /></td>
				<%ElseIf L_LINE = 1 And R_LINE = 0 Then %>
					<td><img src="<%=IMG_ICON_KR%>/satOff.png" class="vmiddle" /></td>
					<td><input type="image" src="<%=IMG_ICON_KR%>/saton.png" class="vmiddle"<%=Jas_Line2%> /></td>
				<%Else %>
					<td><img src="<%=IMG_ICON_KR%>/satOff.png" class="vmiddle" /></td>
					<td><img src="<%=IMG_ICON_KR%>/satOff.png" class="vmiddle" /></td>
				<%End If%>
			</tr>
			<%
						Next
					Set objEncrypter = Nothing
				Else
			%>
			<tr>
				<td colspan="7" style="padding:30px 0px;">
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