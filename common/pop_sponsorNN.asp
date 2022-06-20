<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->

<%
'	If Not checkRef(houUrl &"/common/pop_voter2.asp") Then Call alerts("잘못된 접근입니다.","go","/common/pop_voter2.asp")

	strID			= pRequestTF("user_id",False)
	NominID1		= Trim(pRequestTF("NominID1",False))			'2013-03-29 추천인의 하선회원중(후원계보) 후원인 선택
	NominID2		= Trim(pRequestTF("NominID2",False))
	NominWebID		= Trim(pRequestTF("NominWebID",False))
	voter			= Trim(pRequestTF("voter",False))
	NominChk		= Trim(pRequestTF("NominChk",False))

	SponID1			= pRequestTF("SponID1",False)
	SponID2			= pRequestTF("SponID2",False)

'print NominID1 & ":<Br/>"
'print NominID2 & ":<Br/>"
'print SponID1 & ":<Br/>"
'print SponID2 & ":<Br/>"


	Dim popWidth	:	popWidth = 550
	Dim popHeight	:	popHeight = 540
	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	'	Db.makeParam("@M_name",adVarWchar,adParamInput,50,strID), _
	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@MBID",adVarChar,adParamInput,20,NominID1), _
		Db.makeParam("@MBID2",adInteger,adParamInput,0,NominID2), _
		Db.makeParam("@SponID1",adVarChar,adParamInput,20,SponID1), _
		Db.makeParam("@SponID2",adInteger,adParamInput,0,SponID2), _
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("[HJP_MEMBER_SEARCH_SPON_FROM_VOTER_BY_MBID]",DB_PROC,arrParams,listLen,DB3)
'	arrList = Db.execRsList("[HJP_MEMBER_SEARCH_SPON_FROM_VOTER_BK]",DB_PROC,arrParams,listLen,DB3)

	All_Count = arrParams(UBound(arrParams))(4)
'	All_Count = arrParams(4)(4)

'	print All_Count

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int(((All_Count) - 1) / CInt(PAGESIZE)) + 1
	IF PAGE = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - (((PAGE)-1)*CInt(PAGESIZE)) '
	End If

%>
<link rel="stylesheet" href="/css/pop.css" />
<script type="text/javascript">
<!--
//후원인,추천인 데이타 부모창으로 넘기기
	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3,fvalue4,fvalue5,fvalue6,fvalue7)
	{
		if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" 님을 후원인으로 등록하시겠습니까?")) {		//추가s

			document.frm.SponID1.value = fvalue;
			document.frm.SponID2.value = fvalue1;
			document.frm.SponWebID.value = fvalue2;
			document.frm.sponsor.value = fvalue3;
			document.frm.SponIDChk.value = 'T';
			opener.document.cfrm.SponID1.value = fvalue;
			opener.document.cfrm.SponID2.value = fvalue1;
			opener.document.cfrm.SponIDWebID.value = fvalue2;
			//opener.document.cfrm.sponsor.value = fvalue3;
			opener.document.cfrm.sponsor.value = fvalue+"-"+fvalue1;
			opener.document.cfrm.SponIDChk.value = 'T';

			opener.document.cfrm.NominID1.value = fvalue4;
			opener.document.cfrm.NominID2.value = fvalue5;
			opener.document.cfrm.NominWebID.value = fvalue6;
			//opener.document.cfrm.voter.value = fvalue7;
			opener.document.cfrm.voter.value = fvalue4+"-"+fvalue5;
			opener.document.cfrm.NominChk.value = 'T';
		//	self.close();
			}else{
			return false;
		}
	}
//-->
</script>
</head>
<body>
<div id="pop_search">
	<!-- <div id="pop_title"><img src="<%=IMG_POP%>/tit_sponsor_blue.gif" width="250" height="40" alt="User Id Check" /></div> -->
	<!-- <div><img src="<%=IMG_JOIN%>/sponsor_step02.png" width="550" height="60" alt="User Id Check" /></div> -->
	<div class="cleft tweight" style="background-color:#333;width:100%;padding:10px 10px;margin:0px auto;">
		<span style="font-size:20px;color:#eee;font-family:宋體,simsun,Arial,verdana; ">후원인 검색</span>
	</div>
	<div class="content2">
		<form name="pfrm" action="" method="post">
		<input type="hidden" name="NominID1" value="<%=NominID1%>" />
		<input type="hidden" name="NominID2" value="<%=NominID2%>" />
		<input type="hidden" name="NominWebID" value="<%=NominWebID%>" />
		<input type="hidden" name="voter" value="<%=voter%>" />

		<!-- <p class="tcenter"><span class="searchText vmiddle"><%=starText%> RECOMMENDER : <span class="lightBlue"><%=voter%> (<%=NominID1%>-<%=NominID2%>) </span>'s lower rank sponsor list <%=starText%></span></p> -->
		<!-- <p class="tcenter"><span class="searchText vmiddle"><%=starText%> 추천인 : <span class="lightBlue">(<%=NominID1%>-<%=NominID2%>) </span>의 후원하선 <%=starText%></span></p> -->
		<p class="tcenter" style="padding-top:20px;">
			<span class="searchText vmiddle"><img src="<%=IMG_POP%>/info_plus.jpg" width="11" height="11" style="margin-top:3px;">联络人 <!-- 후원인 --> : </span>
			<!-- <input type="text" name="user_id" value="<%=strID%>" class="input_text vtop" style="width:130px;" tabindex="1" /> -->
			<input type="text" name="SponID1" value="<%=SponID1%>" class="input_text vtop tcenter" maxlength="2" style="width:60px;" tabindex="1" /> -
			<input type="text" name="SponID2" value="<%=SponID2%>" class="input_text vtop tcenter" style="width:180px;" <%=onlyKeys%> tabindex="2" />
			<!-- <input type="image" src="<%=IMG_JOIN%>/btn_search_e.gif" class="vtop" tabindex="2"/></p> -->
			<span class="button medium"><button type="submit" class="tweight">搜索</button></span>
		<p class="tright" style="padding-top:10px;">Page : <%=PAGE%> of <%=PAGECOUNT%></p>
		<table <%=tableatt1%> class="search_table" >
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="30%" />
				<col width="10%" />
				<col width="10%" />
			</colgroup>
			<tr>
				<th>번호</th>
				<th>회원번호</th>
				<th>이름</th>
				<th>1</th>
				<th>2</th>
			</tr>
			<%
				If IsArray(arrList) Then

					For i = 0 To listLen
						BirthDay = arrList(3,i)
						WebID	 = arrList(2,i)

						Nums = All_Count - (PAGESIZE*PAGE) + PAGESIZE - i
						Birth = Left(BirthDay,2) & "-" & Mid(BirthDay,3,2)&""

						If arrList(2,i) = "" Or IsNull(arrList(2,i)) Then WebID = "미기입회원"
						SQL = "SELECT  Down_Reg_Cnt From tbl_Config"							'후원라인 수 비교/선택 (2013-02-28, 2대까지)
						DRC = Int(Db.execRsData(SQL,DB_TEXT,Nothing,DB3))

						SQL = "Select Count([Mbid]) From [tbl_Memberinfo] Where [Saveid] = ? And [Saveid2] = ? And LineCnt > 0"
						arrParams = Array(_
							Db.makeParam("@Saveid",adVarChar,adParamInput,20,arrList(4,i)),_
							Db.makeParam("@Saveid2",adInteger,adParamInput,0,arrList(5,i))_
						)
						DMC = Int(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))

						If DMC >= DRC Then
							Jas = "onclick=""alert('후원라인이 모두 등록된 회원입니다.');"" "
							SponFull = "×"
						Else
							Jas = "onclick=""insertThisValue('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&"','"&NominID1&"','"&NominID2&"','"&NominWebID&"','"&voter&"')"" "
							SponFull = "○"

			Jas_Line1  = "onclick=""insertThisValue1 ('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&" - 1라인', '1')"" "
			Jas_Line2  = "onclick=""insertThisValue2 ('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&" - 2라인', '2')"" "
						End If

			'			If arrList(7,i) = 1 Then
			'				iconON = "off"
			'			ElseIf arrList(8,i) = 1 Then
			'				iconON = "off"
			'			Else
			'				iconON = "on"
			'			End If

			%>
			<!-- <tr class="tron cp" <%=Jas%>> -->
			<tr>
				<td><%=arrList(0,i)%></td>
				<td><%=arrList(4,i)%>-<%=arrList(5,i)%></td>
				<td><%=arrList(1,i)%></td>
				<%If arrList(7,i) = 1 Then%>
					<td><%=arrList(7,i)%><img src="<%=IMG_JOIN%>/satOff.gif" class="vmiddle" width="20"/></td>
				<%Else%>
					<td><%=arrList(7,i)%><input type="image" src="<%=IMG_JOIN%>/saton.gif" class="vmiddle"<%=Jas_Line1%> width="20"/></td>
				<%End If%>
				<%If arrList(8,i) = 1 Then%>
					<td><%=arrList(8,i)%><img src="<%=IMG_JOIN%>/satOff.gif" class="vmiddle" width="20"/></td>
				<%Else%>
					<td><%=arrList(8,i)%><input type="image" src="<%=IMG_JOIN%>/saton.gif" class="vmiddle"<%=Jas_Line2%> width="20"/></td>
				<%End If%>
				<!-- <td><%=arrList(6,i)%></td>
				<td><%=SponFull%></td>
				<td><%=WebID%></td>
				<td><%=Birth%></td> -->
			</tr>
			<%
					Next
				Else
			%>
			<tr>
				<td colspan="7" style="padding:30px 0px;">
					<%'If strID = "" Then%>
					<%If SponID1 = "" Or SponID2 = "" Then %>
						<span class="tweight lightBlue" >请键入赞助商的名字<!-- Please type in the sponsor name. --></span>
					<%Else%>
						<span class="tweight red2">没有成员从搜索词搜索<!-- There is no member searched from the search word. --></span>
					<%End If%>
				</td>
			</tr>
			<%
				End If
			%>
		</table>
		</form>
		<div class="pagings"><%Call pageList(PAGE,PAGECOUNT)%></div>
	</div>
	<div class="close">
		<div class="line1"></div>
		<div class="line2"></div>
		<span class="button medium" style="margin-top:10px;"><a href="javascript:void(0);" onclick="self.close();">关闭窗口</a></span>
		<!-- <img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:10px; cursor:pointer;" onclick="self.close();"/> -->
	</div>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="PAGESIZE" value="<%=PAGESIZE%>" />

	<input type="hidden" name="NominID1" value="<%=NominID1%>" />
	<input type="hidden" name="NominID2" value="<%=NominID2%>" />
	<input type="hidden" name="NominWebID" value="<%=NominWebID%>" />
	<input type="hidden" name="voter" value="<%=voter%>" />

	<input type="hidden" name="SponID1" value="" readonly="readonly" />
	<input type="hidden" name="SponID2" value="" readonly="readonly" />
	<input type="hidden" name="SponWebID" value="" readonly="readonly" />
	<input type="hidden" name="sponsor" value="" readonly="readonly" />
	<input type="hidden" name="SponIDChk" value="" readonly="readonly" />
	<input type="hidden" name="user_id" value="<%=strID%>" />
</form>
<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
