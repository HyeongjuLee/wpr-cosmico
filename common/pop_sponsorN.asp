<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->


<%
	'추천인 하선 후원인 선택 -> 라인입력(2015-05-07)

	SponID1			= pRequestTF("SponID1",False)
	SponID2			= pRequestTF("SponID2",False)
	SponName		= pRequestTF("M_name",False)


	NominID1		= Trim(pRequestTF("NominID1",False))			'추천인의 하선회원중(후원계보) 후원인 선택(2015-05-07)
	NominID2		= Trim(pRequestTF("NominID2",False))
	NominWebID		= Trim(pRequestTF("NominWebID",False))
	voter			= Trim(pRequestTF("voter",False))
	NominChk		= Trim(pRequestTF("NominChk",False))

	Dim popWidth	: popWidth = 420
	Dim popHeight	: popHeight = 390
	Dim PAGESIZE	: PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		: PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	If SponID1 <> "" And SponID2 <> "" And SponName <> "" Then
		arrParams = Array(_
			Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
			Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
			Db.makeParam("@MBID",adVarChar,adParamInput,20,NominID1), _
			Db.makeParam("@MBID2",adInteger,adParamInput,0,NominID2), _
			Db.makeParam("@SponID1",adVarChar,adParamInput,20,SponID1), _
			Db.makeParam("@SponID2",adInteger,adParamInput,0,SponID2), _
			Db.makeParam("@M_name",adVarWChar,adParamInput,100,SponName) ,_
			Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
		)
		arrList = Db.execRsList("[HJP_MEMBER_SEARCH_SPON_FROM_VOTER_BY_MBID_NEW2]",DB_PROC,arrParams,listLen,DB3)
		'arrList = Db.execRsList("[HJP_MEMBER_SEARCH_SPON_FROM_VOTER_BY_MBID_NEW]",DB_PROC,arrParams,listLen,DB3)
		'arrList = Db.execRsList("[HJP_MEMBER_SEARCH_SPON_FROM_VOTER_BY_MBID]",DB_PROC,arrParams,listLen,DB3)
		All_Count = arrParams(UBound(arrParams))(4)

	'	print All_Count

		Dim PAGECOUNT,CNT
		PAGECOUNT = Int(((All_Count) - 1) / CInt(PAGESIZE)) + 1
		IF PAGE = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - (((PAGE)-1)*CInt(PAGESIZE)) '
		End If
	End If
%>
<link rel="stylesheet" href="/css/pop.css" />
<script type="text/javascript">
<!--


// 1라인 선택, 값 넘기기
	function insertThisValue1(fvalue,fvalue1,fvalue2,fvalue3,fvalue4)
	{
		if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" 님을 후원인으로 등록하시겠습니까?")) {		//추가s
			document.frm.SponID1.value = fvalue;
			document.frm.SponID2.value = fvalue1;
			document.frm.SponWebID.value = fvalue2;
			document.frm.sponsor.value = fvalue3;
			document.frm.SponIDChk.value = 'T';														//추가e

			opener.document.cfrm.SponID1.value = fvalue;
			opener.document.cfrm.SponID2.value = fvalue1;
			opener.document.cfrm.SponIDWebID.value = fvalue2;
			opener.document.cfrm.sponsor.value = fvalue3;
			opener.document.cfrm.sponLine.value = fvalue4;
			opener.document.cfrm.SponIDChk.value = 'T';

			opener.document.cfrm.NominID1.value = '<%=NominID1%>';											//추가s
			opener.document.cfrm.NominID2.value = '<%=NominID2%>';
			opener.document.cfrm.NominWebID.value = '<%=NominWebID%>';
			opener.document.cfrm.voter.value = '<%=voter%>';
			opener.document.cfrm.NominChk.value = 'T';												//추가e
			self.close();
		}
	}

	// 2라인 선택, 값 넘기기
	function insertThisValue2(fvalue,fvalue1,fvalue2,fvalue3,fvalue4)
	{
		if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" 님을 후원인으로 등록하시겠습니까?")) {		//추가s
			document.frm.SponID1.value = fvalue;
			document.frm.SponID2.value = fvalue1;
			document.frm.SponWebID.value = fvalue2;
			document.frm.sponsor.value = fvalue3;
			document.frm.SponIDChk.value = 'T';														//추가e

			opener.document.cfrm.SponID1.value = fvalue;
			opener.document.cfrm.SponID2.value = fvalue1;
			opener.document.cfrm.SponIDWebID.value = fvalue2;
			opener.document.cfrm.sponsor.value = fvalue3;
			opener.document.cfrm.sponLine.value = fvalue4;
			opener.document.cfrm.SponIDChk.value = 'T';

			opener.document.cfrm.NominID1.value = '<%=NominID1%>';									//추가s
			opener.document.cfrm.NominID2.value = '<%=NominID2%>';
			opener.document.cfrm.NominWebID.value = '<%=NominWebID%>';
			opener.document.cfrm.voter.value = '<%=voter%>';
			opener.document.cfrm.NominChk.value = 'T';												//추가e

			self.close();
		}
	}

//-->
</script>
</head>
<body onload="document.pfrm.SponID1.focus();">
<div id="pop_search">
	<!-- <div id="pop_title"><img src="<%=IMG_JOIN%>/pop_title_sponsorSearch.gif" width="250" height="40" alt="User Id Check" /></div> -->
	<div class="cleft tweight" style="background-color:#0c6bba;width:100%;padding:10px 10px;margin:0px auto;">
		<span style="font-size:20px;color:#eee;font-family:Arial,verdana;">후원인 검색</span>
	</div>
	<div class="content4">
		<form name="pfrm" action="" method="post">
		<!-- 추가 -->
		<input type="hidden" name="NominID1" value="<%=NominID1%>" />
		<input type="hidden" name="NominID2" value="<%=NominID2%>" />
		<input type="hidden" name="NominWebID" value="<%=NominWebID%>" />
		<input type="hidden" name="voter" value="<%=voter%>" />
		<!-- 추가 -->

		<p class="tcenter"><span class="searchText">후원인 </span>
			<input type="text" name="SponID1" class="input_text" style="width:30px;ime-mode:disabled;" maxlength="2" onkeyup="goNextFocusChk(this,2, this.form.SponID2)" value="<%=SponID1%>"/>	-
			<input type="text" name="SponID2" class="input_text" style="width:80px;" maxlength="" onkeyup="numberOnly(this)" onblur="numberOnly(this)"  value="<%=SponID2%>"/>
			<span class="searchText">&nbsp;&nbsp;&nbsp;&nbsp;이 름 </span>
			<input type="text" name="m_name" class="input_text" style="width:80px;ime-mode:active;" value="<%=SponName%>"/>
			&nbsp;&nbsp&nbsp;<input type="submit" value="검색" class="vmiddle" />
		</p><br />

		<!-- <p class="tright">Page : <%=PAGE%> of <%=PAGECOUNT%></p> -->
		<table <%=tableatt1%> class="search_table">
			<colgroup>
				<col width="50%" />
				<col width="50%" />
			</colgroup>
			<tr>
				<th>회원번호</th>
				<th>이&nbsp;&nbsp;름</th>
			</tr>
			<%
				If IsArray(arrList) Then
					For i = 0 To listLen
						Birth = Left(arrList(3,i),2) & "년 " & Mid(arrList(3,i),3,2)&"월"
						WebID = arrList(2,i)
						If arrList(2,i) = "" Or IsNull(arrList(2,i)) Then WebID = "미기입회원"

						SQL = "SELECT  Down_Reg_Cnt From tbl_Config"
						DRC = Int(Db.execRsData(SQL,DB_TEXT,Nothing,db3))

						SQL = "Select Count([Mbid]) From [tbl_Memberinfo] Where [Saveid] = ? And [Saveid2] = ? And LineCnt > 0"
						arrParams = Array(_
							Db.makeParam("@Saveid",adVarChar,adParamInput,20,arrList(4,i)),_
							Db.makeParam("@Saveid2",adInteger,adParamInput,0,arrList(5,i))_
						)
						DMC = Int(Db.execRsData(SQL,DB_TEXT,arrParams,db3))

					'	If DMC >= DRC Then
					'		Jas = "onclick=""alert('후원라인이 모두 등록된 회원입니다.');"" "
					'	Else
					'		Jas  = "onclick=""insertThisValue ('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&"'   )"" "

						Jas_Line1  = "onclick=""insertThisValue1 ('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&" - 1라인', '1')"" "
						Jas_Line2  = "onclick=""insertThisValue2 ('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&" - 2라인', '2')"" "

					'	End if
			%>
			<!-- <tr class="tron cp" <%=Jas%>> -->
			<tr>
				<td><%=arrList(4,i)%>-<%=Fn_MBID2(arrList(5,i))%></td>
				<td><%=arrList(1,i)%></td>
			</tr>
			<tr>
				<td colspan="2" style="padding-bottom:30px;">
				<%If arrList(6,i) = 0 And arrList(7,i) = 0 Then %>
					<div class="lheight35">후원라인을 선택해 주세요.</div>
					<div class="tweight lightBlue">등록을 원하시는 라인의 이미지를 클릭해주세요.</div><br />
					<span class="padR30"><input type="image" src="<%=IMG_JOIN%>/satOn.gif" class="vmiddle"<%=Jas_Line1%>/></span>
					<span class="padL30"><input type="image" src="<%=IMG_JOIN%>/satOn.gif" class="vmiddle"<%=Jas_Line2%>/></span></p><br />
					<span class="tweight padR40">1라인</span><span class="tweight padL40">2라인</span>
				<%ElseIf arrList(6,i) = 0 And arrList(7,i) = 2 Then %>
					<div class="lheight35">2라인에 기등록된 회원이 존재합니다.</div>
					<div class="tweight lightBlue">1라인에 등록을 원하시면 이미지를 클릭해주세요.</div><br />
					<span class="padR30"><input type="image" src="<%=IMG_JOIN%>/satOn.gif" class="vmiddle"<%=Jas_Line1%>/></span>
					<span class="padL30"><img src="<%=IMG_JOIN%>/satOff.gif" class="vmiddle"/></span></p><br />
					<span class="tweight lightBlue padR40">1라인</span><span class="tweight padL40">2라인</span>
				<%ElseIf arrList(6,i) = 1 And arrList(7,i) = 0 Then %>
					<div class="lheight35">1라인에 기등록된 회원이 존재합니다.</div>
					<div class="tweight lightBlue">2라인에 등록을 원하시면 이미지를 클릭해주세요.</div><br />
					<span class="padR30"><img src="<%=IMG_JOIN%>/satOff.gif" class="vmiddle"/></span>
					<span class="padL30"><input type="image" src="<%=IMG_JOIN%>/satOn.gif"  class="vmiddle"<%=Jas_Line2%>/></span></p><br />
					<span class="tweight padR40">1라인</span><span class="tweight lightBlue padL40">2라인</span>
				<%Else %>
					<span class="tweight red2 lheight135">후원라인이 모두 등록된 회원입니다.</span>
				<%End If%>
				</td>
			</tr>
			<%
					Next
				Else
			%>
			<tr>
				<td colspan="5" style="padding:30px 0px;">
					<%If SponName = "" Then%>
						<span class="tweight lightBlue lheight110" >후원인의 회원번호와 이름을 입력해주세요.</span>
					<%Else%>
						<span class="tweight red2 lheight110">요청하신 검색어로 검색된 회원이 없습니다.</span>
					<%End If%>
				</td>
			</tr>
			<%
				End If
			%>
		</table>
		</form>
		<!-- <div class="pagings"><%Call pageList(PAGE,PAGECOUNT)%></div> -->
	</div>
	<div class="close">
		<div class="line1"></div>
		<div class="line2"></div>
		<img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:10px; cursor:pointer;" onclick="self.close();"/>
	</div>
</div>
<form name="frm" method="post" action="">
	<input type="hidden" name="PAGE" value="<%=PAGE%>" />
	<input type="hidden" name="NominID1" value="<%=NominID1%>" />
	<input type="hidden" name="NominID2" value="<%=NominID2%>" />
	<input type="hidden" name="NominWebID" value="<%=NominWebID%>" />
	<input type="hidden" name="voter" value="<%=voter%>" />

	<input type="hidden" name="M_name" value="<%=SponName%>" />
	<input type="hidden" name="SponID1" value="" readonly="readonly" />
	<input type="hidden" name="SponID2" value="" readonly="readonly" />
	<input type="hidden" name="SponWebID" value="" readonly="readonly" />
	<input type="hidden" name="sponsor" value="" readonly="readonly" />
	<input type="hidden" name="SponIDChk" value="" readonly="readonly" />
</form>


<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
