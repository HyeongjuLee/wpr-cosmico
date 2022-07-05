<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->

<%'jQuery Modal Dialog방식변경%>
<%
	'Response.Redirect "/common/pop_VoterSFV.asp"		'후원인은 추천인의 후원조직산하에 존재하는 회원 2021-08-17

	If Not (checkRef(houUrl &"/common/pop_sponsor.asp") _
			Or checkRef(houUrl &"/common/joinStep03.asp")) Then
		Call alerts(LNG_ALERT_WRONG_ACCESS,"close_p_modal","")
	End If

	MEMBER_SEARCH_PROC = "DKP_MEMBER_SEARCH"


	strID = pRequestTF("user_id",False)
	If strID <> "" Then
		strID = Replace(Replace(strID,"%",""),"_","")
		If Not checkNameSearch(strID, 2, 20) Then
			'Call ALERTS(LNG_JS_NAME_FORM_CHECK,"back","")
			LNG_TEXT_NO_SEARCHED_MEMBER = LNG_JS_NAME_FORM_CHECK
		End If
	End If

	Dim popWidth : popWidth = 550
	Dim popHeight : popHeight = 600
	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	PAGESUM = (PAGESIZE * (PAGE-1))

	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGESUM",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@M_name",adVarWChar,adParamInput,100,strID), _
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	'arrList = Db.execRsList("DKP_MEMBER_SEARCH",DB_PROC,arrParams,listLen,DB3)
	arrList = Db.execRsList(MEMBER_SEARCH_PROC,DB_PROC,arrParams,listLen,DB3)
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
<link rel="stylesheet" href="/css/popStyle.css?v0" />
<script type="text/javascript">
	/*
	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		opener.document.cfrm.SponID1.value = fvalue;
		opener.document.cfrm.SponID2.value = fvalue1;
		opener.document.cfrm.SponIDWebID.value = fvalue2;
		opener.document.cfrm.sponsor.value = fvalue3;
		opener.document.cfrm.SponIDChk.value = 'T';
		self.close();
	}
	*/
	//modal
	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		parent.document.cfrm.SponID1.value = fvalue;
		parent.document.cfrm.SponID2.value = fvalue1;
		parent.document.cfrm.SponIDWebID.value = fvalue2;
		parent.document.cfrm.sponsor.value = fvalue3;
		parent.document.cfrm.SponIDChk.value = 'T';
		parent.$("#modal_view").dialog("close");
	}

</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<div id="pop_search">
	<!-- <div class="bgtitle">
		<span class="bgFont"><%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%></span>
	</div> -->
	<div class="content" style="width:100%;">
		<form name="pfrm" action="" method="post">
		<p class="tcenter">
			<span class="searchText vmiddle font13px" style="margin-top:12px;"><%=LNG_TEXT_NAME%></span>&nbsp;
			<input type="text" name="user_id" value="<%=strID%>" class="input_text vtop" style="padding:2px 5px;" tabindex="1" />
			<input type="submit" class="txtBtn j_medium" value="<%=LNG_TEXT_SEARCH%>"  />
			<!-- <span class="button medium"><button type="submit" class="tweight"><%=LNG_TEXT_SEARCH%></button></span> -->
		<p class="tright">Page : <%=PAGE%> of <%=PAGECOUNT%></p>
		<table <%=tableatt1%> class="search_table" >
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

							'▣ 승인매출 체크
						'	arrParamsSC = Array(_
						'		Db.makeParam("@mbid",adVarChar,adParamInput,20,arrList_mbid), _
						'		Db.makeParam("@mbid2",adInteger,adParamInput,0,arrList_mbid2) _
						'	)
						'	arrMEMBER_ORDER_CHK = Db.execRsData("HJP_TOTAL_SALES_COUNT_APPROVED",DB_PROC,arrParamsSC,DB3)
						'	If arrMEMBER_ORDER_CHK > 0 Then
	    				'		Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"
						'		arrParams1 = Array(_
						'			Db.makeParam("@MBID",adVarChar,adParamInput,20,arrList(4,i)), _
						'			Db.makeParam("@MBID2",adInteger,adParamInput,0,arrList(5,i)) _
						'		)
						'		ThisDownLeg = Db.execRsData("DKP_DOWNLEG_CHECK",DB_PROC,arrParams1,DB3)
						'		If ThisDownLeg = "T" Then
						'			Tr_OnclickMsg = "insertThisValue('"&arrList_mbid&"','"&arrList_mbid2&"','"&arrList_WebID&"','"&arrList_M_Name&"')"
						'		Else
						'			Tr_OnclickMsg = "alert('"&LNG_POP_SPONSOR_TEXT11&"');"
						'		End If
						'		bgcol = ""
						'	Else
						'		Tr_OnclickMsg = "alert('"&LNG_POP_CANNOT_REGIST_MEM&"');"
						'		bgcol = "background:#999999;"
						'	End If

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
				<td><%=arrList_mbid%> - <%=Fn_MBID2(arrList_mbid2)%></td>
				<!-- <td><%=arrMEMBER_ORDER_CHK%></td> -->
			</tr>
			<%
						Next
					Set objEncrypter = Nothing
				Else
			%>
			<tr>
				<td colspan="4" style="padding:30px 0px;">
					<%If strID = "" Then
						PRINT LNG_TEXT_INPUT_SEARCH_WORD
					Else
						PRINT "<span class=""red2"">"&LNG_TEXT_NO_SEARCHED_MEMBER&"</span>"
					End If%>
				</td>
			</tr>
			<%
				End If
			%>
		</table>
		</form>
		<div class="pagingNew3"><%Call pageListNew(PAGE,PAGECOUNT)%></div>
	</div>
	<!-- <div class="close">
		<span class="button medium tweight" style="margin-top:10px;"><a onclick="self.close();"><%=LNG_TEXT_WINDOW_CLOSE%></a></span>
	</div> -->
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="user_id" value="<%=strID%>" />
</form>


<script type="text/javascript">
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
</script>
</body>
</html>
