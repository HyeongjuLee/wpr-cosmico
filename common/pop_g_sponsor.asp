<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->

<%
	strID = pRequestTF("user_id",False)

	Dim popWidth : popWidth = 550
	Dim popHeight : popHeight = 530
	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	PAGESUM = (PAGESIZE * (PAGE-1))


	'▣▣▣GNG 후원인선택 (추천인의 후원조직중 선택, 20170512)▣▣▣
	arrParams2 = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams2,DB3)
	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_LineCnt			= DKRS("LineCnt")
		RS_N_LineCnt		= DKRS("N_LineCnt")
		RS_Saveid			= DKRS("Saveid")
		RS_Saveid2			= DKRS("Saveid2")
		RS_Top_Save			= DKRS("Top_Save")
		RS_Nominid			= DKRS("Nominid")
		RS_Nominid2			= DKRS("Nominid2")
		RS_LeaveCheck		= DKRS("LeaveCheck")
	Else
		Call ALERTS(LNG_JS_MEMBERINFO_FAIL,"back","")
	End If
	Call closeRS(DKRS)

	'▣승인된 매출 TOTALPV
	arrParams = Array(_
		Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
	)
	MEMBER_APPROVED_TOTALPV = Db.execRsData("HJP_TOTALPV_APPROVED",DB_PROC,arrParams,DB3)

'	Call ResRW(MEMBER_APPROVED_TOTALPV,"TotalPV")
'	Call ResRW(RS_Nominid,"RS_Nominid")
'	Call ResRW(RS_Nominid2,"RS_Nominid2")

	If RS_Top_Save <> 0 Then Call ALERTS(LNG_POP_SPONSOR_JS03&"!","close","")												'후원인을 등록할 수 없는 회원입니다
	If Sell_Mem_TF <> 0 Then Call ALERTS(LNG_POP_SPONSOR_JS03&".","close","")												'후원인을 등록할 수 없는 회원입니다
	If (RS_Saveid <> "**" And RS_Saveid2 <> 0) Then Call ALERTS(LNG_POP_SPONSOR_JS04,"close","")							'이미 후원인이 등록되었습니다.
	If CDbl(MEMBER_APPROVED_TOTALPV) < CDbl(STANDARD_TOTALPV_4SPONSOR) Then Call ALERTS(LNG_POP_SPONSOR_JS05,"close","")	'후원인을 등록할 수 없습니다. (본인 누적매출 미달)


''	'▣ 본인 상위 후원인 지정 시, 본인 직상위 추천인 및 본인 직상위 추천인의 후원하선회원만 검색 처리
''	arrParams = Array(_
''		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
''		Db.makeParam("@PAGESUM",adInteger,adParamInput,0,PAGE), _
''		Db.makeParam("@mbid",adVarChar,adParamInput,20,RS_Nominid), _
''		Db.makeParam("@mbid2",adInteger,adParamInput,0,RS_Nominid2), _
''		Db.makeParam("@M_name",adVarWChar,adParamInput,100,strID), _
''		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
''	)
''	arrList = Db.execRsList("HJP_MEMBER_SEARCH_SPON_FROM_VOTER",DB_PROC,arrParams,listLen,DB3)
''	'arrList = Db.execRsList("HJP_MEMBER_WEBID_SEARCH_SPON_FROM_VOTER",DB_PROC,arrParams,listLen,DB3)	'webid검색

	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGESUM",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@M_name",adVarWChar,adParamInput,100,strID), _
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKP_MEMBER_SEARCH",DB_PROC,arrParams,listLen,DB3)

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
<link rel="stylesheet" href="/css/popStyle.css" />
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
		//if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" 님을 후원인으로 지정하시겠습니까?")) {
		if (confirm("[<%=LNG_TEXT_SPONSOR_REGIST%>] " +fvalue3+"("+fvalue+"-"+fvalue1+")")) {
			document.nfrm.SponID1.value = fvalue;
			document.nfrm.SponID2.value = fvalue1;
			document.nfrm.SponIDWebID.value = fvalue2;
			document.nfrm.sponsor.value = fvalue3;
			document.nfrm.SponIDChk.value = 'T';
			document.nfrm.action='/common/pop_g_sponsorHandler.asp';
			document.nfrm.submit();
			}else{
			return false;
		}
	}

//-->
</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<div id="pop_search">
	<!-- <div id="pop_title"><img src="<%=IMG_POP%>/tit_sponsor.gif" width="250" height="40" alt="User Id Check" /></div> -->
	<div class="bgtitle tweight">
		<span class="bgFont"><%=CS_SPON%>&nbsp;<%=LNG_TEXT_SPONSOR_REGIST%></span>
	</div>
	<div class="content">
		<form name="pfrm" action="" method="post">
		<p class="tcenter">
			<span class="searchText"><%=LNG_TEXT_NAME%><!-- <%=LNG_LEFT_MEM_INFO_WEBID%> --></span>
			<input type="text" name="user_id" value="<%=strID%>" class="input_text vtop" style="padding:2px 5px;" tabindex="1" />
			<span class="button medium"><button type="submit" class="tweight"><%=LNG_TEXT_SEARCH%></button></span>
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

							WebID	 = arrList(2,i)
							BirthDay = arrList(3,i)
							mbid	 = arrList(4,i)
							mbid2	 = arrList(5,i)

							If arrList(2,i) = "" Or IsNull(arrList(2,i)) Then WebID = ""
							On Error Resume Next
								'If WebID	<> "" Then WebID	= objEncrypter.Decrypt(WebID)
								If BirthDay	<> "" Then BirthDay	= objEncrypter.Decrypt(BirthDay)
							On Error Goto 0
							'Birth = Left(BirthDay,2) & "년 " & Mid(BirthDay,3,2)&"월"
							Birth = arrList(6,i)&arrList(7,i)

							arrParams1 = Array(_
								Db.makeParam("@MBID",adVarChar,adParamInput,20,mbid), _
								Db.makeParam("@MBID2",adInteger,adParamInput,0,mbid2) _
							)
							ThisDownLeg = Db.execRsData("DKP_DOWNLEG_CHECK",DB_PROC,arrParams1,DB3)

							If (DK_MEMBER_ID1 = mbid And Cdbl(DK_MEMBER_ID2) = CDbl(mbid2)) Then
								'Tr_OnclickMsg = "ALERT('본인을 후원인으로 등록할 수 없습니다.');"
								Tr_OnclickMsg = "ALERT('"&LNG_POP_SPONSOR_JS06&"');"
							Else
								If ThisDownLeg = "T" Then
									Tr_OnclickMsg = "insertThisValue('"&mbid&"','"&mbid2&"','"&WebID&"','"&arrList(1,i)&"')"
								Else
									'Tr_OnclickMsg = "alert('더이상 "&CS_SPON&"을 등록할 수 없는 회원입니다.');"
									Tr_OnclickMsg = "alert('"&LNG_POP_SPONSOR_TEXT11&"');"
								End If
							End If

			%>
			<tr class="tron cp" onclick="<%=Tr_OnclickMsg%>">
				<td><%=Nums%></td>
				<td><%=arrList(1,i)%></td>
				<td><%=WebID%></td>
				<td><%=Birth%></td>
				<td><%=mbid%> - <%=Fn_MBID2(mbid2)%></td>
			</tr>
			<%
						Next
					Set objEncrypter = Nothing
				Else
			%>
			<tr>
				<td colspan="5" style="padding:30px 0px;line-height:30px;font-size:17px;font-family:맑은 고딕",malgun gothic,verdana,gulim,;>
					<%
						If strID = "" Then
							'PRINT "<span class=""blue2 tweight"">※후원인을 입력해 주세요.</span><p />"
							'PRINT "<span class=""red2 tweight"">※입력처리중 오류발생시 본사로 문의해 주십시오.</span>"
							PRINT "<span class=""blue2 tweight"">※"&LNG_JS_SPONSOR&"</span><p />"
							'PRINT "<span class=""red2 tweight"">※입력처리중 오류발생시 본사로 문의해 주십시오.</span>"
						Else
							'PRINT "<span class=""red2"">요청하신 검색어로 검색된 회원이 없습니다.</span>"
							PRINT "<span class=""red2"">"&LNG_TEXT_NO_SEARCHED_MEMBER&"</span>"
						End If
					%>
				</td>
			</tr>
			<%
				End If
			%>
		</table>
		</form>
		<div class="pagingNew"><%Call pageListNew(PAGE,PAGECOUNT)%></div>
	</div>
	<div class="close">
		<div class="line1"></div>
		<div class="line2"></div>
		<span class="button medium tweight" style="margin-top:10px;"><a onclick="self.close();"><%=LNG_TEXT_WINDOW_CLOSE%></a></span>
	</div>
</div>
<form name="nfrm" method="post" action="" />
	<input type="hidden" name="SponID1" value="" readonly="readonly" />
	<input type="hidden" name="SponID2" value="" readonly="readonly" />
	<input type="hidden" name="SponIDWebID" value="" readonly="readonly" />
	<input type="hidden" name="sponsor" value="" readonly="readonly" />
	<input type="hidden" name="SponIDChk" value="T" readonly="readonly" />
</form>


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
