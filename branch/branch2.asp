<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'플래시 사용. 향후 사용금지
Response.End
%><%
	PAGE_SETTING = "COMPANY"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	view = 8 'gRequestTF("view",True)
	mNum = 1


	BranchCode = gRequestTF("code",False)


	If BranchCode = "" Then BranchCode = ""
	Dim SEARCHSTR, PAGE, PAGESIZE
		SEARCHSTR = Request.Form("SEARCHSTR")
		PAGE = Request.Form("page")
		PAGESIZE = 10

	If SEARCHTERM = "" Then SEARCHTERM = "" End If
	If SEARCHSTR = "" Then SEARCHSTR = "" End if
	If PAGE="" Then PAGE = 1 End If
' ===================================================================



' ===================================================================
' 데이터 가져오기
' ===================================================================
	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _

		Db.makeParam("@cateCode",adVarChar,adParamInput,20,BranchCode), _

		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _

	)
	arrList = Db.execRsList("DKP_BRANCH2_LIST",DB_PROC,arrParams,listLen,Nothing)

	All_Count = arrParams(UBound(arrParams))(4)

' ===================================================================
		Dim PAGECOUNT,CNT
		PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
		IF CCur(PAGE) = 1 Then
			CNT = All_Count
		Else
			CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
		End If

	If BranchCode <> "" Then
		BranchCodeLen = Len(BranchCode)
		If BranchCodeLen > 2 Then
			SQL = "SELECT [strCode] FROM [DK_BRANCH_CODE] WHERE [strCateCode] = ?"
			arrParams = Array(_
				Db.makeParam("@strCode",adVarChar,adParamInput,3,Left(BranchCode,3)) _
			)
			stageNum = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
		End If
		If BranchCodeLen > 5 Then
			SQL = "SELECT [strCode] FROM [DK_BRANCH_CODE] WHERE [strCateCode] = ?"
			arrParams = Array(_
				Db.makeParam("@strCode",adVarChar,adParamInput,6,Left(BranchCode,6)) _
			)
			cityNum = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)
		End If

	End If

	If stageNum <> "" Then
		FVar ="&stateNum="&stageNum&"&cityNum="&cityNum
	End If



%>
<!--#include virtual = "/_include/document.asp"-->
<link rel="stylesheet" href="branch.css" />

<script type="text/javascript">
<!--

	function ajaxBranchChg(typeValue,goPage,searchs){
		var f = document.rfrm;
		createRequest();

		var url = 'chg_BranchList2.asp?code='+typeValue+'&page='+goPage+'&searchs='+searchs;

		request.open("GET",url,true);
		request.onreadystatechange = ChgBranch;    // 함수 뒤에 ()를 빼야합니다!!
		request.send(null);
	 }
/*
	function ajaxBranchChg(typeValue){
		var f = document.rfrm;
		createRequest();

		var url = 'chg_BranchList.asp?code='+typeValue;

		request.open("GET",url,true);
		request.onreadystatechange = ChgBranch;    // 함수 뒤에 ()를 빼야합니다!!
		request.send(null);
	 }
*/
	function ChgBranch() {

		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.

				var newContent = request.responseText;

				document.getElementById("BranchList").innerHTML = newContent;

		}

	  }

	}
//-->
</script>
</head>
<body onLoad="ajaxBranchChg('<%=BranchCode%>','<%=PAGE%>','<%=SEARCHSTR%>');">
<!--#include virtual = "/_include/header.asp"-->
<div class="clear">
<p><%=viewImg(IMG_CONTENT&"/company_09_tit.jpg",780,40,"")%></p>

	<div class="clear" style="margin-top:20px;">
		<p><%=viewFlash("./images/branch_map.swf","xmlURL=branch_map.asp"&FVar,780,300)%></p>
		<p style="padding-top:5px;padding-right:10px;text-align:right"><%=spans("각 시도별 로드샵은 상기 지도에서 지역을 클릭하면 나타납니다.","red","","")%></p>
	</div>

	<div class="clear" style="">
		<div class="clear" style="margin-top:25px;"><%=viewImg("./images/tit_page4_3_01.gif",170,25,"")%></div>
		<div id="BranchList">
			<table <%=tableatt%> class="userCWidth2">
				<col width="150" />
				<col width="140" />
				<col width="300" />
				<col width="130" />
				<tr>
					<th>지역</th>
					<th>로드샵명</th>
					<th>연락처/주소</th>
					<th>보기</th>
				</tr>
				<%
					If IsArray(arrList) Then
						For i = 0 To listLen

				%>
				<tr>
					<td rowspan="2"><%=arrList(2,i)%></td>
					<td rowspan="2"><%=arrList(3,i)%></td>
					<td><%=arrList(8,i)%></td>
					<td rowspan="2"><%=aImg("javascript:pop_Branch2('"&arrList(1,i)&"')","./images/btn_branchView.jpg",83,40,"")%></td><!-- common.js -->
				</tr><tr>
					<td><%=arrList(5,i)%>&nbsp;<%=arrList(6,i)%></td>
				</tr>

				<%
						Next
					Else
				%>
				<tr>
					<td colspan="4" class="notData">해당 지역에 등록된 로드샵이 없습니다</td>
				</tr>
				<%
					End If
				%>
			</table>
			<div class="pageArea2"><%Call pageList3(page,PAGECOUNT,BranchCode,"","")%></div>
		</div>
	</div>



</div>
<!--#include virtual = "/_include/copyright.asp"-->


