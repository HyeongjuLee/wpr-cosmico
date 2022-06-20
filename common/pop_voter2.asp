<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->


<%
	Response.Redirect "/common/pop_voterN.asp"		'추천인 -> 추천인의 후원하선 -> 라인선택으로 변경 (2015-05-07)

	strM_name		= pRequestTF("M_name",False)
	strMbid1		= pRequestTF("mbid1",False)
	strMbid2		= pRequestTF("mbid2",False)
	Dim popWidth	: popWidth = 420
	Dim popHeight	: popHeight = 330
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
		Db.makeParam("@M_name",adVarWChar,adParamInput,50,strM_name) _
	)
	arrList = Db.execRsList("[DKP_MEMBER_SEARCH02]",DB_PROC,arrParams,listLen,db3)
'	All_Count = arrParams(Ubound(arrParams))(4)

	'print All_Count

'	Dim PAGECOUNT,CNT
'	PAGECOUNT = Int(((All_Count) - 1 ) / CInt(PAGESIZE)) + 1
'	IF PAGE = 1 Then
'		CNT = All_Count
'	Else
'		CNT = All_Count - (((PAGE)-1)*CInt(PAGESIZE)) '
'	End If

%>
<link rel="stylesheet" href="/css/pop.css" />
<script type="text/javascript">
<!--


	function insertThisValue(fvalue,fvalue1,fvalue2,fvalue3)
	{
		opener.document.cfrm.NominID1.value = fvalue;
		opener.document.cfrm.NominID2.value = fvalue1;
		opener.document.cfrm.NominWebID.value = fvalue2;
		opener.document.cfrm.voter.value = fvalue3;
		opener.document.cfrm.NominChk.value = 'T';
		self.close();
	}
//-->
</script>
</head>
<body onload="document.pfrm.mbid1.focus();">
<div id="pop_search">
	<div id="pop_title"><img src="<%=IMG_JOIN%>/pop_title_voterSearch.gif" width="250" height="40" alt="User Id Check" /></div>
	<div class="content3">
		<form name="pfrm" action="" method="post">
		<p class="tcenter"><span class="searchText">회원번호 </span><td class="input_td"><input type="text" name="mbid1" class="input_text" style="width:30px;ime-mode:disabled;" maxlength="2" onkeyup="goNextFocusChk(this,2, this.form.mbid2)" /> - <input type="text" name="mbid2" class="input_text" style="width:80px;" maxlength="" onkeyup="numberOnly(this)" onblur="numberOnly(this)"/><span class="searchText">&nbsp;&nbsp;&nbsp;&nbsp;이 름 </span> <input type="text" name="m_name" class="input_text" style="width:80px;ime-mode:active;" />&nbsp;&nbsp&nbsp;<input type="submit" value="검색" class="vmiddle" /></p><br />

		<!-- <p class="tright">Page : <%=PAGE%> of <%=PAGECOUNT%></p> -->
		<table <%=tableatt1%> class="search_table" style="width:420px;">
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
				<td colspan="2" style="padding:30px 0px;">
					<%If strM_name = ""  Then%>
						<span style="line-height:70px" class="tweight lightBlue">추천인의 회원번호와 이름을 입력해주세요.</span>
					<%Else%>
						<span style="line-height:70px" class="tweight red2">요청하신 검색어로 검색된 회원이 없습니다.</span>
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
		<img src="<%=IMG_BTN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:10px; cursor:pointer;" onclick="self.close();"/>
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
