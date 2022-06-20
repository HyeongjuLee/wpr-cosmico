<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/m/_include/document.asp" -->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<%
	strID = pRequestTF("user_id",False)

	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	PAGESUM = (PAGESIZE * (PAGE-1))

	NOWPAGE = PAGE

	If strID = "" Then NOWPAGE = 0

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
<link type="text/css" rel="stylesheet" href="/jquerymobile/jquery.mobile-1.3.2.min.css" />
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
			document.nfrm.action='/m/common/pop_g_sponsorHandler.asp';
			document.nfrm.submit();
			}else{
			return false;
		}
	}

//-->
</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<div id="top" style="height:65px;" class="tcenter">
	<!-- <img src="<%=M_IMG%>/top_logo.png" width="120" alt="" style="margin-top:0px;" /> -->
	<!-- <img src="/images/share/top_logo.png" width="137" height="" style="margin-top:26px;" /> -->
	<div class="top_logo"><a><img src="/images/share/top_logo.png" /></a></div></h3>
</div>
<div id="subTitle" class="width100 tcenter text_noline " style="border-top:1px solid #ccc;margin-top:0px;"><%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%></div>

<div id="pop_search" class="width100">
	<form name="pfrm" action="" method="post" data-ajax="false">
		<div id="searchs" style="margin:15px 5px;" class="tcenter">
			<input type="text" name="user_id" value="<%=strID%>" class="popInput" /><input type="submit" value="<%=LNG_TEXT_SEARCH%>" class="popSearchBtn" />
		</div>
	</form>
	<div class="cleft width100">
		<p class="tright">Page : <%=NOWPAGE%> of <%=PAGECOUNT%></p>
		<table <%=tableatt1%> class="width100">
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
						mbid	 = arrList(4,i)
						mbid2	 = arrList(5,i)

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

						If (DK_MEMBER_ID1 = mbid And Cdbl(DK_MEMBER_ID2) = CDbl(mbid2)) Then
							'Tr_OnclickMsg = "alert('본인을 후원인으로 등록할 수 없습니다.');"
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
				<td><%=arrList(4,i)%> - <%=Fn_MBID2(arrList(5,i))%></td>
			</tr>
			<%
					Next
					Set objEncrypter = Nothing
				Else
			%>
			<tr>
				<td colspan="5" style="padding:30px 0px;">
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
	</div>
	<div class="pagingArea pagingMob5"><% Call pageListMob5(PAGE,PAGECOUNT)%></div>

	<div class="close width100 tcenter" style="margin:5px 0px 30px 0px;">
		<div class="line1"></div>
		<div class="line2"></div>
		<input type="button" value="<%=LNG_TEXT_WINDOW_CLOSE%>" onclick="self.close();" class="popClose" />
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

</body>
</html>
