<!--#include virtual = "/_lib/strFunc.asp"-->
<%
'플래시 사용. 향후 사용금지
Response.End
%>
<%
	PAGE_SETTING = "COMPANY"
	ISLEFT = "T"
	ISSUBTOP = "T"
	ISSUBVISUAL = "T"

	view = 5 'gRequestTF("view",True)
	mNum = 1


	BranchCode = gRequestTF("code",False)

	If BranchCode = "" Then BranchCode = ""
	Dim SEARCHSTR, PAGE, PAGESIZE
		SEARCHSTR = Request.Form("SEARCHSTR")
		PAGE = Request.Form("page")
		PAGESIZE = 10

	If SEARCHSTR = "" Then SEARCHSTR = "" End if
	If PAGE="" Then PAGE = 1 End If


	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _
		Db.makeParam("@cateCode",adVarChar,adParamInput,20,BranchCode), _
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("DKP_BRANCH_LIST",DB_PROC,arrParams,listLen,Nothing)

	All_Count = arrParams(UBound(arrParams))(4)


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

	function ajaxBranchChg(typeValue,goPage,searchs){
		var f = document.rfrm;
		createRequest();

		var url = 'chg_BranchList.asp?code='+typeValue+'&page='+goPage+'&searchs='+searchs;

		request.open("GET",url,true);
		request.onreadystatechange = ChgBranch;   // 함수 뒤에 ()를 빼야합니다!! //onreadystatechange : 서버에서 응답이 도착하면 특정한 자바스크립트 함수를 호출할 수 있는 이벤트
		request.send(null);						  // 요청을 보냄
	 }
	//서버에서 응답을 받은 후 수행하는 함수(콜백함수)
	function ChgBranch() {

		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고		// 4 : COMPLETED (데이터를 전부 받은 상태, 완전한 데이터의 이용가능)
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.(요청성공)
			//alert('성공');
				var newContent = request.responseText;

				document.getElementById("BranchList").innerHTML = newContent; //페이지가 로드할때  서버에서 HTML코드를 가져와서 id가 ""인 <div>엘리먼트의 콘텐츠로 설정한다.

		}

	  }

	}
//-->
</script>
</head>
<body onLoad="ajaxBranchChg('<%=BranchCode%>','<%=PAGE%>','<%=SEARCHSTR%>');">
<!--#include virtual = "/_include/header.asp"-->
<div class="clear">
<!--#include virtual = "/_include/sub_title.asp"-->
<%

	PAGE_NUM = 1
	Select Case PAGE_SETTING
		Case "COMPANY"
			li_class_num1 = "off"
			li_class_num2 = "off"

			Select Case PAGE_NUM
				Case 1 : li_class_num1 = "on"
				Case 2 : li_class_num2 = "on"
			End Select
	End Select

%>

	<!-- <div class="sub_nav cleft">
		<ul>
			<li class="<%=li_class_num1%>"><a href="http://sidshop.co.kr/branch/branch.asp" >지도로 찾기</a></li>
			<li class="<%=li_class_num2%>"><a href="http://sidshop.co.kr/branch/branch_search.asp" >검색어로 찾기</a></li>
		</ul>
	</div> -->
	<div class="clear" style="margin-top:20px;">
		<p style="border-right:1px solid #cdcdcd;"><%=viewFlash("./images/branch_map.swf","xmlURL=branch_map.asp"&FVar,769,300)%></p>
		<p style="padding-top:5px;padding-right:10px;text-align:right"><%=spans("각 시도별 지사는 상기 지도에서 지역을 클릭하면 나타납니다.","red","","")%></p>
	</div>

	<div class="clear" style="">
		<div class="clear" style="margin-top:25px;"><%=viewImg("./images/tit_page4_2_01.gif",170,25,"")%></div>
		<div id="BranchList">
			<table <%=tableatt%> class="userCWidth2">
				<col width="150" />
				<col width="140" />
				<col width="300" />
				<col width="130" />
				<tr>
					<th>지역</th>
					<th>지사명</th>
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
					<td rowspan="2"><%=aImg("javascript:popBranch('"&arrList(1,i)&"')","./images/btn_branchView.jpg",83,40,"")%></td>
				</tr><tr>
					<td><%=arrList(5,i)%>&nbsp;<%=arrList(6,i)%></td>
				</tr>

				<%
						Next
					Else
				%>
				<tr>
					<td colspan="4" class="notData">해당 지역에 등록된 지사가 없습니다</td>
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

