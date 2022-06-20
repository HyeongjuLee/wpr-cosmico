<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/m/_include/document.asp" -->
<!--#include virtual = "/m/_include/jqueryload.asp"-->

<%
	PAGE_SETTING = "JOIN"

'	strID = pRequestTF("user_id",False)
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
	arrList = Db.execRsList("[DKP_MEMBER_SEARCH02]",DB_PROC,arrParams,listLen,DB3)
	'print All_Count

'	Dim PAGECOUNT,CNT
'	PAGECOUNT = Int(((All_Count) - 1 ) / CInt(PAGESIZE)) + 1
'	IF PAGE = 1 Then
'		CNT = All_Count
'	Else
'		CNT = All_Count - (((PAGE)-1)*CInt(PAGESIZE)) '
'	End If

%>
<style>
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
/*
	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		opener.document.cfrm.NominID1.value = fvalue;
		opener.document.cfrm.NominID2.value = fvalue1;
		opener.document.cfrm.NominWebID.value = fvalue2;
		opener.document.cfrm.voter.value = fvalue3;
		opener.document.cfrm.NominChk.value = 'T';
		opener.document.cfrm.voter.focus();
		self.close();
	}
*/
	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		if (confirm(fvalue3+"("+fvalue+"-"+fvalue1+")"+" 님을 추천인으로 등록하시겠습니까?")) {
			document.nfrm.NominID1.value = fvalue;
			document.nfrm.NominID2.value = fvalue1;
			document.nfrm.NominWebID.value = fvalue2;
			document.nfrm.voter.value = fvalue3;
			document.nfrm.NominChk.value = 'T';
			document.nfrm.action='/m/common/pop_sponsorN.asp';
			document.nfrm.submit();
			}else{
			return false;
		}
	}
//-->
</script>
</head>
<body >
<!-- <div id="top" class="cleft"><div class="top_logo"><img src="<%=IMG%>/voter_top.png" width="134" /></div></div> -->
<div id="top" style="height:50px;" class="tcenter">
	<img src="<%=M_IMG%>/top_logo.png" width="120" alt="" style="margin-top:10px;" />
</div>
<div id="subTitle" class="width100 tcenter text_noline" style="border-top:1px solid #ccc;">추천인 선택</div>



<div id="pop_search" class="width100">
	<form name="pfrm" action="" method="post" data-ajax="false">
		<table <%=tableatt%> class="width100">
			<col width="70" />
			<col width="*" />
			<tr>
				<th>회원번호</th>
				<td style="text-align:left; padding-left:7px;"><input type="text" name="mbid1" value="<%=strMbid1%>" maxlength="2" class="input_text imes" style="width:40%" /> - <input data-theme="w" type="tel" name="mbid2" value="<%=strMbid2%>" class="input_text" style="width:40%" /></td>
			</tr><tr>
				<th>회원명</th>
				<td style="text-align:left; padding-left:7px;"><input type="text" name="m_name" value="<%=strM_name%>" class="input_text" style="width:90%"  /></td>
			</tr>
		</table>
		<div class="width100">
			<input type="submit" value="추천인 검색" class="joinBtn jBtn3" />
		</div>
		<!-- <div class="joinBtn jBtn3" style=""><a href="javascript:ajax_accountChk();">본인인증</a></div> -->
		<table <%=tableatt1%> class="width100" style="margin-top:20px;" >
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
'						Birth = Left(arrList(3,i),2) & "년 " & Mid(arrList(3,i),3,2)&"월"
						WebID = arrList(2,i)
						If arrList(2,i) = "" Or IsNull(arrList(2,i)) Then WebID = "미기입회원"
			%>
				<tr class="tron cp" onclick="insertThisValue('<%=arrList(4,i)%>','<%=arrList(5,i)%>','<%=WebID%>','<%=arrList(1,i)%>')">
				<td><%=arrList(4,i)%>-<%=Fn_MBID2(arrList(5,i))%></td>
				<td><%=arrList(1,i)%></td>
			</tr>
			<%
					Next
				Else
			%>
			<tr>
				<td colspan="5" style="padding:30px 0px;">
					<%If strID = "" Then%>
						<span class="tweight lightBlue" >추천인의 회원번호와 이름을 입력해주세요.</span>
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

	<!-- pop_sponsorN.asp 스폰서 선택창 띄우며, 추천인 데이타 넘기기 -->
	<form name="nfrm" method="post" action="pop_sponsor2.asp" />
		<input type="hidden" name="NominID1" value="" readonly="readonly" />
		<input type="hidden" name="NominID2" value="" readonly="readonly" />
		<input type="hidden" name="NominWebID" value="" readonly="readonly" />
		<input type="hidden" name="voter" value="" readonly="readonly" />
		<input type="hidden" name="NominChk" value="" readonly="readonly" />
	</form>
</div>
<div class="cleft close width100" style="margin-top:30px;">
	<div class="line1"></div>
	<div class="line2"></div>
	<div class="joinBtn jBtn2" style=""><a href="javascript:self.close();" style="color:#fff;">창 닫기</a></div>
	<!-- <input type="button" value="창 닫기" onclick="self.close();"/> --></div>

	<form name="frm" method="post" action="">
		<!-- <input type="hidden" name="PAGE" value="<%=PAGE%>" /> -->
		<input type="hidden" name="M_name" value="<%=strM_name%>" />
		<input type="hidden" name="strMbid1" value="<%=strMbid1%>" />
		<input type="hidden" name="strMbid2" value="<%=strMbid2%>" />
	</form>

</body>
</html>
