<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/_include/document.asp" -->

<%
	strID = pRequestTF("user_id",False)
	Dim popWidth : popWidth = 550
	Dim popHeight : popHeight = 500
	Dim PAGESIZE	:	PAGESIZE = pRequestTF("PAGESIZE",False)
	Dim PAGE		:	PAGE = pRequestTF("PAGE",False)
	If PAGESIZE = "" Then PAGESIZE = 10
	If PAGE = "" Then PAGE = 1

	PAGESUM = (PAGESIZE * (PAGE-1))

	arrParams = Array(_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@PAGESUM",adInteger,adParamInput,0,PAGESUM), _
		Db.makeParam("@M_name",adInteger,adParamInput,0,strID), _
		Db.makeParam("@All_Count",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKP_MEMBER_SEARCH",DB_PROC,arrParams,listLen,Nothing)
	All_Count = arrParams(3)(4)

	'print All_Count

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int(((All_Count) - 1 ) / CInt(PAGESIZE)) + 1
	IF PAGE = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - (((PAGE)-1)*CInt(PAGESIZE)) '
	End If

%>
<link rel="stylesheet" href="/css/pop.css" />
<script type="text/javascript">
<!--


	function insertThisValue(fvalue,fvalue1,fvalue2)
	{
		opener.document.cfrm.sponsor_mbid2.value = fvalue1;
		opener.document.cfrm.sponsor_check.value = fvalue2;
		opener.document.cfrm.sponsor.value = fvalue1;
		self.close();
	}
//-->
</script>
</head>
<body onload="document.pfrm.user_id.focus();">
<div id="pop_search">
	<div id="pop_title"><img src="<%=IMG_POP%>/pop_title_sponsorSearch.gif" width="250" height="40" alt="User Id Check" /></div>
	<div class="content">
		<form name="pfrm" action="" method="post">
		<p class="tcenter">
			<span class="searchText"><%=POP_JOIN_VOTE_TXT01%></span>
			<input type="text" name="user_id" value="<%=strID%>" class="input_text vtop" style="width:180px;" <%=onlyKeys%> tabindex="1" />
			<input type="image" src="<%=IMG_POP%>/btn_search.gif" class="vtop" tabindex="2" /></p>
		<p class="tright">Page : <%=PAGE%> of <%=PAGECOUNT%></p>
		<table <%=tableatt1%> class="search_table">
			<colgroup>
				<col width="12%" />
				<col width="24%" />
				<col width="24%" />
				<col width="24%" />
				<col width="16%" />
			</colgroup>
			<tr>
				<th><%=POP_JOIN_VOTE_TXT02%></th>
				<th><%=POP_JOIN_VOTE_TXT03%></th>
				<th><%=POP_JOIN_VOTE_TXT04%></th>
				<th><%=POP_JOIN_VOTE_TXT05%></th>
				<th><%=POP_JOIN_VOTE_TXT06%></th>
			</tr>
			<%
				If IsArray(arrList) Then
					For i = 0 To listLen
						Nums = All_Count - (PAGESIZE*PAGE) + PAGESIZE - i
						Birth = Left(arrList(2,i),2) & "-" & Mid(arrList(2,i),3,2)&""
						WebID = arrList(1,i)
						If arrList(1,i) = "" Or IsNull(arrList(1,i)) Then WebID = POP_JOIN_VOTE_TXT07
			%>
			<tr class="tron cp" onclick="insertThisValue('<%=arrList(3,i)%>','<%=arrList(4,i)%>','<%=WebID%>')">
				<td><%=Nums%></td>
				<td><%=arrList(0,i)%></td>
				<td><%=WebID%></td>
				<td><%=Birth%></td>
				<td><%=arrList(4,i)%></td>
			</tr>
			<%
					Next
				Else
			%>
			<tr>
				<td colspan="5" style="padding:30px 0px;">
					<%If strID = "" Then
						PRINT POP_JOIN_VOTE_TXT08
					Else
						PRINT POP_JOIN_VOTE_TXT09
					End If%>
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
		<img src="<%=IMG_POP%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:10px; cursor:pointer;" onclick="self.close();"/>
	</div>
</div>
				<form name="frm" method="post" action="">
					<input type="hidden" name="PAGE" value="<%=PAGE%>" />
					<input type="hidden" name="user_id" value="<%=strID%>" />
				</form>


<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
