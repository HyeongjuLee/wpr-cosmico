<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/m/_include/document.asp" -->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<%

	strM_name		= pRequestTF("M_name",False)
	strMbid1		= pRequestTF("mbid1",False)
	strMbid2		= pRequestTF("mbid2",False)

'	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
'	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
'	If PAGESIZE = "" Then PAGESIZE = 10
'	If PAGE = "" Then PAGE = 1

'	PAGESUM = (PAGESIZE * (PAGE-1))

'	NOWPAGE = PAGE

'	If strID = "" Then NOWPAGE = 0


	arrParams = Array(_
		Db.makeParam("@MBID",adVarChar,adParamInput,20,strMbid1), _
		Db.makeParam("@MBID2",adInteger,adParamInput,0,strMbid2), _
		Db.makeParam("@M_name",adVarWChar,adParamInput,100,strM_name) _
	)
	arrList = Db.execRsList("[DKP_MEMBER_SEARCH_SPON_INFO]",DB_PROC,arrParams,listLen,DB3)	'헬씨특이사항테스트 - 후원인 [번호],[이름],[좌우라인] 검색
	'print All_Count

'	Dim PAGECOUNT,CNT
'	PAGECOUNT = Int(((All_Count) - 1 ) / CInt(PAGESIZE)) + 1
'	IF PAGE = 1 Then
'		CNT = All_Count
'	Else
'		CNT = All_Count - (((PAGE)-1)*CInt(PAGESIZE)) '
'	End If

%>
<link type="text/css" rel="stylesheet" href="/jquerymobile/jquery.mobile-1.3.2.min.css" />
<style>
	#pop_search .content4 {clear:both;color:#555;padding-top:20px; width:400px;height:215px;overflow:hidden;}

	.lheight35 {line-height:35px;}
	.lheight110 {line-height:110px;}
	.lheight135 {line-height:135px;}
	.padR30 {padding-right:30px}
	.padL30 {padding-left:30px}
	.padR40 {padding-right:40px}
	.padL40 {padding-left:40px}

	td {height:40px;}

	 .joinBtn {display: block;  margin:0px auto; padding: 8px ;font-size: 13px;line-height: 30px;color: #fff;background: #000;border: none;-webkit-border-radius: 3px;-moz-border-radius: 3px;border-radius: 3px; text-align:center;cursor: pointer;}
	 .jBtn1 {background-color:#ad0d0d; margin-top:15px;}
	 .jBtn2 {background-color:#777; margin-top:15px; padding:2px 6px;}
	 .jBtn3 {background-color:#4581e5; margin-top:15px; padding:2px 8px;width:45%;}
	 a {display:block;color:#fff;}

	th {border:1px solid #ccc; background-color:#eee;}
	td {}



</style>
<script type="text/javascript">
<!--

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
<body>
<div id="top" style="height:50px;" class="tcenter">
	<img src="<%=M_IMG%>/top_logo.png" width="120" alt="" style="margin-top:10px;" />
</div>

<div id="subTitle" class="width100 tcenter text_noline" style="border-top:1px solid #ccc;">후원인 선택</div>

<div id="pop_search" class="width100">
	<form name="pfrm" action="" method="post" data-ajax="false">
<table <%=tableatt%> class="width100">
			<col width="70" />
			<col width="*" />
			<tr>
				<th>회원번호</th>
				<td style="text-align:left; padding-left:7px;"><input type="text" name="mbid1" value="<%=strMbid1%>" class="input_text" style="width:40%" /> - <input data-theme="w" type="tel" name="mbid2" value="<%=strMbid2%>" class="input_text" style="width:40%" /></td>
			</tr><tr>
				<th>회원명</th>
				<td style="text-align:left; padding-left:7px;"><input type="text" name="m_name" value="<%=strM_name%>" class="input_text" style="width:90%"  /></td>
			</tr>
		</table>
		<div class="width100">
			<input type="submit" value="후원인 검색" class="joinBtn jBtn3" />
		</div>


		<table <%=tableatt1%> class="width100" style="margin-top:20px;">
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
						DRC = Int(Db.execRsData(SQL,DB_TEXT,Nothing,DB3))

						SQL = "Select Count([Mbid]) From [tbl_Memberinfo] Where [Saveid] = ? And [Saveid2] = ? And LineCnt > 0"
						arrParams = Array(_
							Db.makeParam("@Saveid",adVarChar,adParamInput,20,arrList(4,i)),_
							Db.makeParam("@Saveid2",adInteger,adParamInput,0,arrList(5,i))_
						)
						DMC = Int(Db.execRsData(SQL,DB_TEXT,arrParams,DB3))

					'	If DMC >= DRC Then
					'		Jas = "onclick=""alert('후원라인이 모두 등록된 회원입니다.');"" "
					'	Else
					'		Jas  = "onclick=""insertThisValue ('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&"'   )"" "
							Jas_Line1  = "onclick=""insertThisValue1 ('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&" - 1라인', '1')"" "
							Jas_Line2  = "onclick=""insertThisValue2 ('"&arrList(4,i)&"','"&arrList(5,i)&"','"&WebID&"','"&arrList(1,i)&" - 2라인', '2')"" "
					'	End if
			%>
				<tr>
				<td><%=arrList(4,i)%>-<%=Fn_MBID2(arrList(5,i))%></td>
				<td><%=arrList(1,i)%></td>
			</tr><tr>
				<td colspan="2" style="padding-bottom:30px;">
				<%If arrList(6,i) = 0 And arrList(7,i) = 0 Then %>											<!-- HL-7397 / 이소영 -->
					<div class="lheight35">후원라인을 선택해 주세요.</div>
					<div class="tweight lightBlue">등록을 원하시는 라인의 이미지를 클릭해주세요.</div><br />
					<span class="padR30"><input type="image" src="<%=M_IMG%>/satOn.gif" class="vmiddle"<%=Jas_Line1%>/></span>
					<span class="padL30"><input type="image" src="<%=M_IMG%>/satOn.gif" class="vmiddle"<%=Jas_Line2%>/></span></p><br />
					<span class="tweight padR40">1라인</span><span class="tweight padL40">2라인</span>
				<%ElseIf arrList(6,i) = 0 And arrList(7,i) = 2 Then %>										<!-- H1-14 김석 -->
					<div class="lheight35">2라인에 기등록된 회원이 존재합니다.</div>
					<div class="tweight lightBlue">1라인에 등록을 원하시면 이미지를 클릭해주세요.</div><br />
					<span class="padR30"><input type="image" src="<%=M_IMG%>/satOn.gif" class="vmiddle"<%=Jas_Line1%>/></span>
					<span class="padL30"><img src="<%=M_IMG%>/satOff.gif" class="vmiddle"/></span></p><br />
					<span class="tweight lightBlue padR40">1라인</span><span class="tweight padL40">2라인</span>
				<%ElseIf arrList(6,i) = 1 And arrList(7,i) = 0 Then %>
					<div class="lheight35">1라인에 기등록된 회원이 존재합니다.</div>
					<div class="tweight lightBlue">2라인에 등록을 원하시면 이미지를 클릭해주세요.</div><br />
					<span class="padR30"><img src="<%=M_IMG%>/satOff.gif" class="vmiddle"/></span>
					<span class="padL30"><input type="image" src="<%=M_IMG%>/satOn.gif"  class="vmiddle"<%=Jas_Line2%>/></span></p><br />
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
					<%If strID = "" Then%>
						<span class="tweight lightBlue" >후원인의 회원번호와 이름을 입력해주세요.</span>
					<%Else%>
						<span class="tweight red2">요청하신 검색어로 검색된 회원이 없습니다.</span>
					<%End If%>
				</td>
			</tr>
			<%
				End If
			%>
		</table>
	</form>


		<!-- <div class="cleft paging_area_m"><%Call pageList(PAGE,PAGECOUNT)%> -->
</div>
<div class="cleft close width100" style="margin-top:30px;">
	<div class="line1"></div>
	<div class="line2"></div>
	<div class="joinBtn jBtn2" style=""><a href="javascript:self.close();" style="color:#fff;">창 닫기</a></div>
</div>

	<form name="frm" method="post" action="">
		<!-- <input type="hidden" name="PAGE" value="<%=PAGE%>" /> -->
		<input type="hidden" name="M_name" value="<%=strM_name%>" />
	</form>

</body>
</html>
