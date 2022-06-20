<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/m/_include/document.asp" -->
<!--#include virtual = "/m/_include/jqueryload.asp"-->
<%
	strID = pRequestTF("user_id",False)
	SponID1			= pRequestTF("SponID1",False)
	SponID2			= pRequestTF("SponID2",False)
	SponName		= pRequestTF("M_name",False)


	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	PAGESUM = (PAGESIZE * (PAGE-1))

	NOWPAGE = PAGE

	If strID = "" Then NOWPAGE = 0

'	arrParams = Array(_
'		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
'		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
'		Db.makeParam("@M_name",adVarChar,adParamInput,50,strID), _
'		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
'	)
'	arrList = Db.execRsList("DKP_MEMBER_SEARCH",DB_PROC,arrParams,listLen,DB3)
'	All_Count = arrParams(3)(4)

	'print All_Count

	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@MBID",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
		Db.makeParam("@MBID2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
		Db.makeParam("@SponID1",adVarChar,adParamInput,20,SponID1), _
		Db.makeParam("@SponID2",adInteger,adParamInput,0,SponID2), _
		Db.makeParam("@M_name",adVarWChar,adParamInput,50,SponName) ,_
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("[HJP_MEMBER_SEARCH_UNDER_SPON_MEMBER]",DB_PROC,arrParams,listLen,DB3)
	'arrList = Db.execRsList("[HJP_MEMBER_SEARCH_SPON_FROM_VOTER_BY_MBID]",DB_PROC,arrParams,listLen,DB3)
	All_Count = arrParams(UBound(arrParams))(4)

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
		opener.document.dateFrm.SponID1.value = fvalue;
		opener.document.dateFrm.SponID2.value = fvalue1;
		opener.document.dateFrm.sponsor.value = fvalue3;
		self.close();
	}

//-->
</script>
</head>
<body onload="document.pfrm.m_name.focus();">
<div id="top" style="height:65px;" class="tcenter">
	<!-- <img src="<%=M_IMG%>/top_logo.png" width="120" alt="" style="margin-top:0px;" /> -->
	<img src="<%=IMG_SHARE%>/top_logo.png" width="82" height="52" />
</div>
<div id="subTitle" class="width100 tcenter text_noline " style="border-top:1px solid #ccc;margin-top:0px;"><%=CS_SPON%>&nbsp;<%=LNG_TEXT_SEARCH%></div>

<div id="pop_search" class="width100">
	<form name="pfrm" action="" method="post" data-ajax="false">
		<div id="searchs" style="margin:15px 5px;" class="tcenter">
			<input type="text" name="m_name" value="<%=SponName%>" class="popInput" /><input type="submit" value="<%=LNG_TEXT_SEARCH%>" class="popSearchBtn" />
		</div>
	</form>
	<div class="cleft width100">
		<p class="tright">Page : <%=NOWPAGE%> of <%=PAGECOUNT%></p>
		<table <%=tableatt1%> class="width100">
			<colgroup>
				<col width="16%" />
				<col width="28%" />
				<col width="28%" />
				<col width="28%" />
			</colgroup>
			<tr>
				<th>No</th>
				<th>회원명</th>
				<th>회원아이디</th>
				<!-- <th>생년월</th> -->
				<th>사업자 번호</th>
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
						Birth = Left(BirthDay,2) & "년 " & Mid(BirthDay,3,2)&"월"
						'Birth = arrList(7,i)&arrList(8,i)

						Tr_OnclickMsg = "insertThisValue('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&"')"

			%>
			<tr class="tron cp" onclick="<%=Tr_OnclickMsg%>">
				<td><%=Nums%></td>
				<td><%=arrList(1,i)%></td>
				<td><%=WebID%></td>
				<!-- <td><%=Birth%></td> -->
				<td><%=arrList(4,i)%> - <%=Fn_MBID2(arrList(5,i))%></td>
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

	<div class="close width100 tcenter" style="margin:5px 0px 30px 0px;">
		<div class="line1"></div>
		<div class="line2"></div>
		<input type="button" value="<%=LNG_TEXT_WINDOW_CLOSE%>" onclick="self.close();" class="popClose" />
	</div>

</div>


<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="user_id" value="<%=strID%>" />
</form>

</body>
</html>
