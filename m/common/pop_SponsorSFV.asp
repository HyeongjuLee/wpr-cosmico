<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/m/_include/document.asp" -->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<%
	'jQuery Modal Dialog방식변경
	If Not (checkRef(houUrl &"/m/common/pop_SponsorSFV.asp") _
			Or checkRef(houUrl &"/m/common/pop_VoterSFV.asp")) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If

	'후원인은 추천인의 후원조직산하에 존재하는 회원으로만 등록 가능 하도록 처리
	NominID1    = Trim(pRequestTF("NominID1",True))
	NominID2    = Trim(pRequestTF("NominID2",True))
	NominWebID    = Trim(pRequestTF("NominWebID",False))
	voter   = Trim(pRequestTF("voter",True))

	strID = pRequestTF("user_id",False)

	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	PAGESUM = (PAGESIZE * (PAGE-1))

	NOWPAGE = PAGE

	If strID = "" Then NOWPAGE = 0

	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@MBID1",adVarChar,adParamInput,20,NominID1), _
		Db.makeParam("@MBID2",adInteger,adParamInput,0,NominID2), _
		Db.makeParam("@M_name",adVarWChar,adParamInput,100,strID), _
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("HJP_MEMBER_SEARCH_SPON_FROM_VOTER",DB_PROC,arrParams,listLen,DB3)
	ALL_COUNT = arrParams(UBound(arrParams))(4)


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

  //modal
	parent.$(".ui-dialog-title").text('<%=CS_SPON%><%=vbTab%><%=LNG_TEXT_SEARCH%>');
	parent.$(".ui-widget-header").css({"color":"#82702e"});

	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" 님을 <%=CS_SPON%> (으)로 등록하시겠습니까?")) {
			parent.document.cfrm.SponID1.value = fvalue;
			parent.document.cfrm.SponID2.value = fvalue1;
			parent.document.cfrm.SponIDWebID.value = fvalue2;
			parent.document.cfrm.sponsor.value = fvalue3;
			parent.document.cfrm.SponIDChk.value = 'T';
			parent.document.cfrm.NominID1.value = '<%=NominID1%>';
			parent.document.cfrm.NominID2.value = '<%=NominID2%>';
			parent.document.cfrm.NominWebID.value = '<%=NominWebID%>';
			parent.document.cfrm.voter.value = '<%=voter%>';
			parent.document.cfrm.NominChk.value = 'T';
			parent.document.cfrm.NominCom.value = 'F';
			parent.$("#modal_view").dialog("close");

			self.close();
		}
	}

</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<!-- <div id="top" style="" class="tcenter">
	<img src="/images/share/top_logo.png" height="40" height="" style="margin-top:15px;" />
</div> -->
<!-- <div id="subTitle" class="width100 tcenter text_noline " style="border-top:1px solid #ccc;margin-top:0px;"><%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%></div> -->

<div id="pop_search" class="width100">
	<form name="pfrm" action="" method="post" data-ajax="false">
		<input type="hidden" name="NominID1" value="<%=NominID1%>" readonly="readonly" />
		<input type="hidden" name="NominID2" value="<%=NominID2%>" readonly="readonly" />
		<input type="hidden" name="NominWebID" value="<%=NominWebID%>" readonly="readonly" />
		<input type="hidden" name="voter" value="<%=voter%>" readonly="readonly" />
		<div id="searchs" style="margin:15px 5px;" class="tcenter">
			<input type="text" name="user_id" value="<%=strID%>" class="popInput" /><input type="submit" value="<%=LNG_TEXT_SEARCH%>" class="popSearchBtn" />
		</div>

		<div class="cleft width100">
			<p class="tright">Page : <%=NOWPAGE%> of <%=PAGECOUNT%></p>
			<table <%=tableatt1%> class="width100">
				<colgroup>
					<col width="12%" />
					<col width="34%" />
					<col width="30%" />
					<col width="24%" />
				</colgroup>
				<tr>
					<th><%=LNG_TEXT_NUMBER%></th>
					<th><%=LNG_TEXT_NAME%></th>
					<th><%=LNG_TEXT_ID%></th>
					<!-- <th><%=LNG_TEXT_BIRTH%></th> -->
					<th><%=LNG_TEXT_MEMID%></th>
				</tr>
				<%
					If IsArray(arrList) Then
						Set objEncrypter = Server.CreateObject("Hyeongryeol.StringEncrypter")
							objEncrypter.Key = con_EncryptKey
							objEncrypter.InitialVector = con_EncryptKeyIV

							For i = 0 To listLen
								Nums = All_Count - (PAGESIZE*PAGE) + PAGESIZE - i

								arrList_RowNum			= arrList(0,i)
								arrList_M_Name			= arrList(1,i)
								arrList_WebID			= arrList(2,i)
								arrList_cpno			= arrList(3,i)
								arrList_mbid			= arrList(4,i)
								arrList_mbid2			= arrList(5,i)

								arrList_Sell_Mem_Type	= arrList(6,i)

								arrList_BirthDay		= arrList(7,i)
								arrList_BirthDay_M		= arrList(8,i)
								arrList_BirthDay_D		= arrList(9,i)

								Birth = arrList_BirthDay&arrList_BirthDay_M

								If 1=2 Then
									'▣ 승인매출 체크
									arrParamsSC = Array(_
										Db.makeParam("@mbid",adVarChar,adParamInput,20,arrList_mbid), _
										Db.makeParam("@mbid2",adInteger,adParamInput,0,arrList_mbid2) _
									)
									arrMEMBER_ORDER_CHK = Db.execRsData("HJP_TOTAL_SALES_COUNT_APPROVED",DB_PROC,arrParamsSC,DB3)
									If arrMEMBER_ORDER_CHK > 0 Then
										Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"
										arrParams1 = Array(_
											Db.makeParam("@MBID",adVarChar,adParamInput,20,arrList(4,i)), _
											Db.makeParam("@MBID2",adInteger,adParamInput,0,arrList(5,i)) _
										)
										ThisDownLeg = Db.execRsData("DKP_DOWNLEG_CHECK",DB_PROC,arrParams1,DB3)
										If ThisDownLeg = "T" Then
											Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"
										Else
											Tr_OnclickMsg = "alert('"&LNG_POP_SPONSOR_TEXT11&"');"
										End If
										bgcol = ""
									Else
										Tr_OnclickMsg = "alert('"&LNG_POP_CANNOT_REGIST_MEM&"');"
										bgcol = "background:#999999;"
									End If
								End If

								arrParams1 = Array(_
									Db.makeParam("@MBID",adVarChar,adParamInput,20,arrList_mbid), _
									Db.makeParam("@MBID2",adInteger,adParamInput,0,arrList_mbid2) _
								)
								ThisDownLeg = Db.execRsData("DKP_DOWNLEG_CHECK",DB_PROC,arrParams1,DB3)
								If ThisDownLeg = "T" Then
									Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"
								Else
									Tr_OnclickMsg = "alert('"&LNG_POP_SPONSOR_TEXT11&"');"
								End If

				%>
				<tr class="tron cp" onclick="<%=Tr_OnclickMsg%>" style="<%=bgcol%>">
					<td><%=Nums%></td>
					<td><%=arrList_M_Name%></td>
					<td><%=arrList_WebID%></td>
					<!-- <td><%=Birth%></td> -->
					<td><%=arrList_mbid%> - <%=Right("00000000"&arrList_mbid2,MBID2_LEN)%></td>
					<!-- <td><%=arrMEMBER_ORDER_CHK%></td> -->
				</tr>
				<%
						Next
						Set objEncrypter = Nothing
					Else
				%>
				<tr>
					<td colspan="4" style="padding:30px 0px;">
						<%If strID = "" Then%>
							<span class="tweight lightBlue" ><%=LNG_TEXT_INPUT_SEARCH_WORD%></span>
						<%Else%>
							<span class="tweight red2"><%=LNG_TEXT_NO_SEARCHED_MEMBER%></span>
						<%End If%>
					</td>
				</tr>
				<%
					End If
				%>
			</table>
		</div>
	</form>
	<div class="pagingArea pagingMob5"><% Call pageListMob5(PAGE,PAGECOUNT)%></div>

	<!-- <div class="close width100 tcenter" style="margin:5px 0px 30px 0px;">
		<input type="button" value="<%=LNG_TEXT_WINDOW_CLOSE%>" onclick="self.close();" class="popClose" />
	</div> -->

</div>


<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="user_id" value="<%=strID%>" />
	<input type="hidden" name="NominID1" value="<%=NominID1%>" />
	<input type="hidden" name="NominID2" value="<%=NominID2%>" />
	<input type="hidden" name="NominWebID" value="<%=NominWebID%>" />
	<input type="hidden" name="voter" value="<%=voter%>" />
</form>

</body>
</html>
