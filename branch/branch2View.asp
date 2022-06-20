<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'플래시 사용. 향후 사용금지
Response.End
%><%

	code = gRequestTF("code",True)

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,code) _
	)
	Set DKRS = Db.execRs("DKP_BRANCH2_VIEW",DB_PROC,arrParams,Nothing)


	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_BranchCode				= DKRS("BranchCode")
		RS_strBranchName			= DKRS("strBranchName")
		RS_strZip					= DKRS("strZip")
		RS_strADDR1					= DKRS("strADDR1")
		RS_strADDR2					= DKRS("strADDR2")
		RS_strBranchOwner			= DKRS("strBranchOwner")
		RS_strBranchTel				= DKRS("strBranchTel")
		RS_strBranchFax				= DKRS("strBranchFax")
		RS_strBranchMapCode			= DKRS("strBranchMapCode")
		RS_strCateName				= DKRS("strCateName")
	Else
		Call ALERTS("해당 코드에 맞는 로드샵이 없습니다.","CLOSE","")
	End If



%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="branch.css" />
</head>
<body>
	<div id="branchView" style="width:780px; margin:0px auto;">
		<div class="area">
			<p><%=viewImg(IMG_CONTENT&"/news_04_tit.jpg",780,140,"")%></p>
			<table <%=tableatt%> style="width:780px; margin-top:15px;">
				<colgroup>
					<col width="200" />
					<col width="580" />
				</colgroup>
				<tr>
					<th colspan="2" class="title"><%=RS_strBranchName%></th>
				</tr><tr>
					<th>로드샵 위치</th>
					<td><%=RS_strCateName%></td>
				</tr><tr>
					<th>로드샵명</th>
					<td><%=RS_strBranchName%></td>
				</tr><tr>
					<th>로드샵 대표</th>
					<td><%=RS_strBranchOwner%></td>
				</tr><tr>
					<th>전화번호</th>
					<td><%=RS_strBranchTel%></td>
				</tr><tr>
					<th>팩스번호</th>
					<td><%=RS_strBranchFax%></td>
				</tr><tr>
					<th>주소</th>
					<td>(우 <%=RS_strZip%>) <%=RS_strADDR1%>&nbsp;<%=RS_strADDR2%></td>
				</tr><tr>
					<th colspan="2">약도</th>
				</tr><tr>
					<td colspan="2" style="padding:0px;">
					<% If RS_strBranchMapCode <> "" Then%>
					<div style="width:770px;border:5px solid #ccc;"><iframe src="http://<%=RS_strBranchMapCode%>" width="770" height="400" scrolling="no" frameborder="0"></iframe></div>
					<%Else%>
					<div style="width:770px;border:5px solid #ccc;line-height:200px;" class = "tcenter">약도가 입력되지 않았습니다.</div>
					<% End If%>
					</td>
				</tr>
			</table>
			<div class="cl_left tcenter" style="padding:30px 0px;"><img src="<%=IMG_JOIN%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:4px;cursor:pointer;" onclick="self.close();" /></div>
		</div>
	</div>
</body>
</html>