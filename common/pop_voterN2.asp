<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->
<%
	'바이럴 추천인 자동호출
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
%>
<%

	'XXX 후원인은 추천인의 후원조직산하에 존재하는 회원으로만 등록 가능 하도록 처리 (~ 2019-12-31)

	'▣facite 변경 : 추천인만 등록 (2019-12-31 ~)

	strID = pRequestTF("user_id",False)

	Dim popWidth : popWidth = 550
	Dim popHeight : popHeight = 530
	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

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
		arrList = Db.execRsList("DKP_MEMBER_SEARCH",DB_PROC,arrParams,listLen,DB3)
		ALL_COUNT = arrParams(UBound(arrParams))(4)
	End IF
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
		padding:10px 10px;margin:0px auto;
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
	/* ~2019-12-31
	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" 님을 추천인으로 등록하시겠습니까?")) {
			document.nfrm.NominID1.value = fvalue;
			document.nfrm.NominID2.value = fvalue1;
			document.nfrm.NominWebID.value = fvalue2;
			document.nfrm.voter.value = fvalue3;
			document.nfrm.NominChk.value = 'T';
			//document.nfrm.action='/common/pop_sponsorN2_LINE.asp';        //라인선택
			document.nfrm.action='/common/pop_sponsorN2.asp';
			document.nfrm.submit();
			}else{
			return false;
		}
	}
	*/

	//2019-12-31~
	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" 님을 추천인으로 등록하시겠습니까?")) {
			opener.document.cfrm.NominID1.value = fvalue;
			opener.document.cfrm.NominID2.value = fvalue1;
			opener.document.cfrm.NominWebID.value = fvalue2;
			opener.document.cfrm.voter.value = fvalue3;
			opener.document.cfrm.NominChk.value = 'T';
			self.close();
		}
	}


</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<div id="pop_search">
	<!-- <div id="pop_title"><img src="<%=IMG_POP%>/tit_voter.gif" width="250" height="40" alt="User Id Check" /></div> -->
	<div class="bgtitle tweight">
		<span class="bgFont"><%=CS_NOMIN%>&nbsp;<%=LNG_TEXT_SEARCH%></span>
	</div>
	<div class="content">
		<form name="pfrm" action="" method="post">
		<p class="tcenter">
			<span class="searchText"><%=LNG_TEXT_NAME%> (<%=LNG_TEXT_WEBID%>)</span>
			<input type="text" name="user_id" value="<%=strID%>" class="input_text vtop" style="width:180px; padding:2px 5px;" tabindex="1" />
			<span class="button medium"><button type="submit" class="tweight"><%=LNG_TEXT_SEARCH%></button></span>
		<p class="">Page : <%=PAGE%> of <%=PAGECOUNT%></p>
		<table <%=tableatt1%> class="search_table">
			<colgroup>
				<col width="12%" />
				<col width="44%" />
				<col width="44%" />
				<!-- <col width="16%" /> -->
				<!-- <col width="30%" /> -->
			</colgroup>
			<tr>
				<th><%=LNG_TEXT_NUMBER%></th>
				<th><%=LNG_TEXT_NAME%></th>
				<th><%=LNG_TEXT_ID%></th>
				<!-- <th><%=LNG_TEXT_BIRTH%></th> -->
				<!-- <th><%=LNG_TEXT_MEMID%></th> -->
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


						'▣ 승인매출 체크
'						arrParamsSC = Array(_
'							Db.makeParam("@mbid",adVarChar,adParamInput,20,arrList_mbid), _
'							Db.makeParam("@mbid2",adInteger,adParamInput,0,arrList_mbid2) _
'						)
'						arrMEMBER_ORDER_CHK = Db.execRsData("HJP_TOTAL_SALES_COUNT_APPROVED",DB_PROC,arrParamsSC,DB3)
'
'						If arrMEMBER_ORDER_CHK > 0 Then
'    						Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"
'							bgcol = ""
'						Else
'							Tr_OnclickMsg = "alert('"&LNG_POP_CANNOT_REGIST_MEM&"');"
'							bgcol = "background:#999999;"
'						End If

						''Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"

						'2020-01-06 추천인 매출 여부 상관없이 검색 요청
						Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"
						bgcol = ""

			%>
			<tr class="tron cp" onclick="<%=Tr_OnclickMsg%>" style="<%=bgcol%>">
				<td><%=Nums%></td>
				<td>
					<%If DKRSVI_MNAME <> "" And DKRSVI_MBID1 = arrList_mbid And DKRSVI_MBID2 = arrList_mbid2 Then%>
						<span class="tweight red2">※ <%=LNG_VIRAL_VOTER%></span><br />
						<span class="tweight blue2"><%=arrList_M_Name%></span>
					<%Else%>
						<%=arrList_M_Name%>
					<%End If%>
				</td>
				<td><%=arrList_WebID%></td>
				<!-- <td><%=Birth%></td> -->
				<!-- <td><%=arrList_mbid%> - <%=Fn_MBID2(arrList_mbid2)%></td> -->
			</tr>
			<%
					Next
					Set objEncrypter = Nothing
				Else
			%>
			<tr>
				<td colspan="3" style="padding:30px 0px;">
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

<!-- pop_sponsorN.asp 스폰서 선택창 띄우며, 추천인 데이타 넘기기 -->
<form name="nfrm" method="post" action="pop_sponsorN2.asp" />
	<input type="hidden" name="NominID1" value="" readonly="readonly" />
	<input type="hidden" name="NominID2" value="" readonly="readonly" />
	<input type="hidden" name="NominWebID" value="" readonly="readonly" />
	<input type="hidden" name="voter" value="" readonly="readonly" />
	<input type="hidden" name="NominChk" value="" readonly="readonly" />
</form>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
