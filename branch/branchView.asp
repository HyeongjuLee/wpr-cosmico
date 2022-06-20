<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'플래시 사용. 향후 사용금지
Response.End
%><%

	code = gRequestTF("code",True)

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,code) _
	)
	Set DKRS = Db.execRs("DKP_BRANCH_VIEW",DB_PROC,arrParams,Nothing)


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
		RS_strBranchKey				= DKRS("strBranchKey")			'다음지도 키추가(2015-10-29)

		RS_strBranchMapCode = BACKWORD(Replace(RS_strBranchMapCode," ",""))
		RS_strBranchKey		= BACKWORD(Replace(RS_strBranchKey," ",""))

	Else
		Call ALERTS("해당 코드에 맞는 지사가 없습니다.","CLOSE","")
	End If



%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="branch.css" />
</head>
<body>
	<div id="branchView" style="width:780px; margin:0px auto;">
		<div class="area">
			<!-- <p><%=viewImg(IMG_CONTENT&"/news_03_tit.jpg",780,140,"")%></p> -->
			<div class="tcenter" style="margin:20px 0px;"><img src="<%=IMG_SHARE%>/top_logo.png"></div>
			<table <%=tableatt%> style="width:780px; margin-top:15px;">
				<colgroup>
					<col width="200" />
					<col width="580" />
				</colgroup>
				<tr>
					<th colspan="2" class="title"><%=RS_strBranchName%></th>
				</tr><tr>
					<th>지사 위치</th>
					<td><%=RS_strCateName%></td>
				</tr><tr>
					<th>지사명</th>
					<td><%=RS_strBranchName%></td>
				</tr><tr>
					<th>지사대표</th>
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
					<div style="width:770px;border:5px solid #ccc;">
						<!-- 1. 약도 노드 -->
						<div id="daumRoughmapContainer<%=RS_strBranchMapCode%>" class="root_daum_roughmap root_daum_roughmap_landing"></div>

						<!-- 2. 설치 스크립트 - SSL = "https" -->
						<script charset="UTF-8" class="daum_roughmap_loader_script" src="https://spi.maps.daum.net/imap/map_js_init/roughmapLoader.js"></script>
						<!-- <script charset="UTF-8" class="daum_roughmap_loader_script" src="http://dmaps.daum.net/map_js_init/roughmapLoader.js"></script> -->

						<!-- 3. 실행 스크립트 -->
						<script charset="UTF-8">
							new daum.roughmap.Lander({
								"timestamp" : "<%=RS_strBranchMapCode%>",
								"key" : "<%=RS_strBranchKey%>",
								"mapWidth" : "770",
								"mapHeight" : "400"
							}).render();
						</script>
						<!-- <iframe src="http://<%=BACKWORD(RS_strBranchMapCode)%>" width="770" height="400" scrolling="no" frameborder="0"></iframe> -->
					</div>
					<!-- <div style="width:770px;border:5px solid #ccc;"><iframe src="http://<%=BACKWORD(RS_strBranchMapCode)%>" width="770" height="400" scrolling="no" frameborder="0"></iframe></div> -->
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
