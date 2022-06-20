<!--#include virtual ="/_lib/strFunc.asp" -->
<!--#include virtual ="/m/_include/document.asp" -->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<%
	'jQuery Modal Dialog방식변경
	If Not (checkRef(houUrl &"/m/common/pop_VoterSFV.asp") _
			Or checkRef(houUrl &"/m/common/joinStep_n03_g.asp") _
			Or checkRef(houUrl &"/m/common/joinStep04.asp") _
			Or checkRef(houUrl &"/m/common/joinStep_n03_m.asp")) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If

	'바이럴 추천인 자동호출
	DKRSVI_MBID1	= ""
	DKRSVI_MBID2	= ""
	DKRSVI_MNAME	= ""
	DKRSVI_CHECK	= "F"
	DKRSVI_WEBID	= ""
	If VIRAL_USE_TF = "T" Then
		If DK_MEMBER_VOTER_ID <> "" Then
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV

				SQLVI = "SELECT [MBID],[MBID2],[M_NAME],[WebID] FROM [tbl_MemberInfo] WHERE [webID] = ? "
				arrParamsVI = Array(_
					Db.makeParam("@WebID",adVarWChar,adParamInput,100,DK_MEMBER_VOTER_ID) _
				)
				Set DKRSVI = Db.execRs(SQLVI,DB_TEXT,arrParamsVI,DB3)
				If Not DKRSVI.BOF And Not DKRSVI.EOF Then
					DKRSVI_MBID1		= DKRSVI("MBID")
					DKRSVI_MBID2		= DKRSVI("MBID2")
					DKRSVI_MNAME		= DKRSVI("M_NAME")
					DKRSVI_CHECK		= "T"
					DKRSVI_WEBID		= DKRSVI("WebID")
					'DKRSVI_WEBID		= objEncrypter.DEcrypt(DKRSVI_WEBID)
				Else
					DKRSVI_MBID1		= ""
					DKRSVI_MBID2		= ""
					DKRSVI_MNAME		= ""
					DKRSVI_CHECK		= "F"
					DKRSVI_WEBID		= ""
				End If

			Set objEncrypter = Nothing
		End If
	End If
%>
<%

	MEMBER_SEARCH_PROC = "DKP_MEMBER_SEARCH"


	strID = pRequestTF("user_id",False)

	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	PAGESUM = (PAGESIZE * (PAGE-1))

	NOWPAGE = PAGE

	If strID = "" Then NOWPAGE = 0

	'바이럴 추천인 자동호출
	If DKRSVI_MNAME <> "" AND strID = "" Then
		arrParams = Array(_
			Db.makeParam("@MBID",adVarChar,adParamInput,20,DKRSVI_MBID1), _
			Db.makeParam("@MBID2",adInteger,adParamInput,0,DKRSVI_MBID2) _
		)
		arrList = Db.execRsList("HJP_MEMBER_SEARCH_MBID12",DB_PROC,arrParams,listLen,DB3)
	Else
		arrParams = Array(_
			Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
			Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
			Db.makeParam("@M_name",adVarWChar,adParamInput,100,strID), _
			Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
		)
		arrList = Db.execRsList(MEMBER_SEARCH_PROC,DB_PROC,arrParams,listLen,DB3)
		ALL_COUNT = arrParams(UBound(arrParams))(4)
	End If
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

	//modal
	parent.$(".ui-dialog-title").text('<%=CS_NOMIN%><%=vbTab%><%=LNG_TEXT_SEARCH%>');
	parent.$(".ui-widget-header").css({"color":"#003858"});

	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		alert( fvalue3+"("+fvalue+"-"+fvalue1+") 님을 <%=CS_NOMIN%> (으)로 등록합니다.");

		document.nfrm.NominID1.value = fvalue;
		document.nfrm.NominID2.value = fvalue1;
		document.nfrm.NominWebID.value = fvalue2;
		document.nfrm.voter.value = fvalue3;
		//document.nfrm.NominChk.value = 'T';
		//document.nfrm.NominCom.value = 'F';
		document.nfrm.action='/m/common/pop_SponsorSFV.asp';
		document.nfrm.submit();
	}

</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<!-- <div id="top" style="" class="tcenter">
	<img src="/images/share/top_logo.png" height="40" height="" style="margin-top:15px;" />
</div> -->
<!-- <div id="subTitle" class="width100 tcenter text_noline " style="border-top:1px solid #ccc;margin-top:0px;"><%=CS_NOMIN%>&nbsp;<%=LNG_TEXT_SEARCH%></div> -->

<div id="pop_search" class="width100">
	<form name="pfrm" action="" method="post">
		<div id="searchs" style="margin:15px 5px;" class="tcenter">
			<input type="text" name="user_id" value="<%=strID%>" class="popInput <%=imes%>"/><input type="submit" value="<%=LNG_TEXT_SEARCH%>" class="popSearchBtn" />
		</div>
	</form>
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
								bgcol = ""
							Else
								Tr_OnclickMsg = "alert('"&LNG_POP_CANNOT_REGIST_MEM&"');"
								bgcol = "background:#999999;"
							End If
						End If

						'추천인 매출 여부 상관없이 검색 요청
						Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"
						bgcol = ""

			%>
			<tr class="tron cp" onclick="<%=Tr_OnclickMsg%>" style="<%=bgcol%>">
				<td><%=Nums%></td>
				<td>
					<%If DKRSVI_MNAME <> "" And DKRSVI_MBID1 = arrList_mbid And DKRSVI_MBID2 = arrList_mbid2 Then%>
						<span class="tweight red">※ <%=LNG_VIRAL_VOTER%></span><br />
						<span class="tweight blue"><%=arrList_M_Name%></span>
					<%Else%>
						<%=arrList_M_Name%>
					<%End If%>
				</td>
				<td><%=arrList_WebID%></td>
				<!-- <td><%=Birth%></td> -->
				<td><%=arrList_mbid%> - <%=Right("00000000"&arrList_mbid2,MBID2_LEN)%></td>
				<!-- <td><%=arrMEMBER_ORDER_CHK%></td> -->
			</tr>
			<%
					Next
					Set objEncrypter = Nothing												'복호화추가E
				Else
			%>
			<tr>
				<td colspan="5" style="padding:30px 0px;">
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
	<div class="pagingArea pagingMob5"><% Call pageListMob5(PAGE,PAGECOUNT)%></div>

	<!-- <div class="close width100 tcenter" style="margin:5px 0px 30px 0px;">
		<input type="button" value="<%=LNG_TEXT_WINDOW_CLOSE%>" onclick="self.close();" class="popClose" />
	</div> -->

</div>
<form name="frm" method="post" action="">
  <input type="hidden" name="PAGE" value="<%=PAGE%>" />
  <input type="hidden" name="user_id" value="<%=strID%>" />
</form>

<%'추천인 데이타 넘기기 %>
<form name="nfrm" method="post" action="pop_SponsorSFV.asp" />
	<input type="hidden" name="NominID1" value="" readonly="readonly" />
	<input type="hidden" name="NominID2" value="" readonly="readonly" />
	<input type="hidden" name="NominWebID" value="" readonly="readonly" />
	<input type="hidden" name="voter" value="" readonly="readonly" />
</form>

</body>
</html>
