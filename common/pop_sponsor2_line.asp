<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->


<%
	strM_name	= pRequestTF("M_name",False)
	strMbid1	= pRequestTF("mbid1",False)
	strMbid2	= pRequestTF("mbid2",False)
	Dim popWidth	: popWidth = 420
	Dim popHeight	: popHeight = 390
'	Dim PAGESIZE	: PAGESIZE = pRequestTF("PAGESIZE",False)
'	Dim PAGE		: PAGE = pRequestTF("PAGE",False)
'	If PAGESIZE = "" Then PAGESIZE = 10
'	If PAGE = "" Then PAGE = 1


'		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
'		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
'		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	arrParams = Array(_
		Db.makeParam("@MBID",adVarChar,adParamInput,20,strMbid1), _
		Db.makeParam("@MBID2",adInteger,adParamInput,0,strMbid2), _
		Db.makeParam("@M_name",adVarWChar,adParamInput,100,strM_name) _
	)
	arrList = Db.execRsList("[DKP_MEMBER_SEARCH_SPON_INFO]",DB_PROC,arrParams,listLen,db3)	'헬씨특이사항테스트 - 후원인 [번호],[이름],[좌우라인] 검색

'	All_Count = arrParams(3)(4)

	'print All_Count

'	Dim PAGECOUNT,CNT
'	PAGECOUNT = Int(((All_Count) - 1 ) / CInt(PAGESIZE)) + 1								'런타임 오류 오류 '800a000d' 형식이 일치하지 않습니다.: '[string: ""]'
'	IF PAGE = 1 Then
'		CNT = All_Count
'	Else
'		CNT = All_Count - (((PAGE)-1)*CInt(PAGESIZE)) '
'	End If
%>
<%
	'	arrParams1 = Array(_
	'		Db.makeParam("@mbid",adVarChar,adParamInput,20,strMbid1), _
	'		Db.makeParam("@mbid2",adInteger,adParamInput,0,strMbid2) _
	'	)
	'	LEFT_LINE = Db.execRsData("HJP_DOWN_SPON_INFO_TEST",DB_PROC,arrParams1,Nothing)			'후원한 회원 정보 불러오기
	'	arrParams1 = Array(_
	'		Db.makeParam("@mbid",adVarChar,adParamInput,20,strMbid1), _
	'		Db.makeParam("@mbid2",adInteger,adParamInput,0,strMbid2) _
	'	)
	'	RIGHT_LINE = Db.execRsData("HJP_DOWN_SPON_INFO_TEST02",DB_PROC,arrParams1,Nothing)

%>
<link rel="stylesheet" href="/css/pop.css" />
<script type="text/javascript">
<!--
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
// 1라인 선택, 값 넘기기
	function insertThisValue1(fvalue,fvalue1,fvalue2,fvalue3,fvalue4)
	{
		opener.document.cfrm.SponID1.value = fvalue;
		opener.document.cfrm.SponID2.value = fvalue1;
		opener.document.cfrm.SponIDWebID.value = fvalue2;
		opener.document.cfrm.sponsor.value = fvalue3;
		opener.document.cfrm.sponLine.value = fvalue4;
		opener.document.cfrm.SponIDChk.value = 'T';
		self.close();
	}
// 2라인 선택, 값 넘기기
	function insertThisValue2(fvalue,fvalue1,fvalue2,fvalue3,fvalue4)
	{
		opener.document.cfrm.SponID1.value = fvalue;
		opener.document.cfrm.SponID2.value = fvalue1;
		opener.document.cfrm.SponIDWebID.value = fvalue2;
		opener.document.cfrm.sponsor.value = fvalue3;
		opener.document.cfrm.sponLine.value = fvalue4;
		opener.document.cfrm.SponIDChk.value = 'T';
		self.close();
	}
//-->
</script>
</head>
<body onload="document.pfrm.mbid1.focus();">
<div id="pop_search">
	<div id="pop_title"><img src="<%=IMG_JOIN%>/pop_title_sponsorSearch.gif" width="250" height="40" alt="User Id Check" /></div>
	<div class="content4">
		<form name="pfrm" action="" method="post">
		<p class="tcenter"><span class="searchText">회원번호 </span><td class="input_td"><input type="text" name="mbid1" value="" class="input_text" style="width:30px;ime-mode:disabled;" maxlength="2" onkeyup="goNextFocusChk(this,2, this.form.mbid2)" /> - <input type="text" name="mbid2" class="input_text" style="width:70px;" maxlength="" onkeyup="numberOnly(this)" onblur="numberOnly(this)"/><span class="searchText">&nbsp;&nbsp;&nbsp;&nbsp;이 름 </span> <input type="text" name="m_name" class="input_text" style="width:70px;ime-mode:active;" />&nbsp;&nbsp&nbsp;<input type="submit" value="검색" class="vmiddle" /></p><br />

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
				<td><%=arrList(1,i)%></td><!-- <td><%=arrList(6,i)%></td><td><%=arrList(7,i)%></td> -->
			</tr><tr>
				<td colspan="2" style="padding-bottom:30px;">
				<%If arrList(6,i) = 0 And arrList(7,i) = 0 Then %>											<!-- HL-7397 / 이소영 -->
					<div class="lheight35">후원라인을 선택해 주세요.</div>
					<div class="tweight lightBlue">등록을 원하시는 라인의 이미지를 클릭해주세요.</div><br />
					<span class="padR30"><input type="image" src="<%=IMG_JOIN%>/satOn.gif" class="vmiddle"<%=Jas_Line1%>/></span>
					<span class="padL30"><input type="image" src="<%=IMG_JOIN%>/satOn.gif" class="vmiddle"<%=Jas_Line2%>/></span></p><br />
					<span class="tweight padR40">1라인</span><span class="tweight padL40">2라인</span>
				<%ElseIf arrList(6,i) = 0 And arrList(7,i) = 2 Then %>										<!-- H1-14 김석 -->
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
					<%If strM_name = "" Then%>
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
	<!-- <input type="hidden" name="PAGE" value="<%=PAGE%>" /> -->
	<input type="hidden" name="M_name" value="<%=strM_name%>" />
</form>


<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
