<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE1-2"


	intIDX = gRequestTF("idx",True)

	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS = Db.execRs("DKPA_BRANCH_VIEW2",DB_PROC,arrParams,Nothing)

	If Not DKRS.BOF And Not DKRS.EOF Then
		RS_intIDX          		= DKRS("intIDX")
		RS_BranchCode      		= DKRS("BranchCode")
		RS_strBranchName   		= DKRS("strBranchName")
		RS_strZip          		= DKRS("strZip")
		RS_strADDR1        		= DKRS("strADDR1")
		RS_strADDR2        		= DKRS("strADDR2")
		RS_strBranchOwner  		= DKRS("strBranchOwner")
		RS_strBranchTel    		= DKRS("strBranchTel")
		RS_strBranchFax    		= DKRS("strBranchFax")
		RS_strBranchMapCode		= DKRS("strBranchMapCode")
		RS_isUse				= DKRS("isUse")

		RS_strBankCode1			= DKRS("strBankCode1")
		RS_strBankNumber1		= DKRS("strBankNumber1")
		RS_strBankOwner1		= DKRS("strBankOwner1")

		RS_strBankCode2			= DKRS("strBankCode2")
		RS_strBankNumber2		= DKRS("strBankNumber2")
		RS_strBankOwner2		= DKRS("strBankOwner2")

		RS_strBankCode3			= DKRS("strBankCode3")
		RS_strBankNumber3		= DKRS("strBankNumber3")
		RS_strBankOwner3		= DKRS("strBankOwner3")

		RS_strBankCode4			= DKRS("strBankCode4")
		RS_strBankNumber4		= DKRS("strBankNumber4")
		RS_strBankOwner4		= DKRS("strBankOwner4")

		RS_strCateName			= DKRS("strCateName")
		RS_strBranchKey			= DKRS("strBranchKey")


		If RS_strBranchTel		= "" Or IsNull(RS_strBranchTel) Then RS_strBranchTel = "--"
		If RS_strBranchFax		= "" Or IsNull(RS_strBranchFax) Then RS_strBranchFax = "--"

		arrRSTel		= Split(RS_strBranchTel,"-")
		arrRSMobile		= Split(RS_strBranchFax,"-")


		If RS_strBranchPic = "" Or IsNull(RS_strBranchPic) Then
			viewPics = viewImgSt(IMG_SHARE&"/notImg.gif",150,150,"","","vmiddle")
		Else
			viewPics = aImgSt2(VIR_PATH("branch")&"/"&RS_strPic,IMG_ICON&"/icon_picT.gif",16,16,"","","vmiddle")
		End If


		If RS_isUse = "T" Then
			RS_isUse_TF = "지사보임"
		Else
			RS_isUse_TF = "지사숨김"
		End If

	Else
		Call ALERTS("데이터가 없습니다. 이미 처리되었을 수 있습니다.","back","")
	End If

%>
<link rel="stylesheet" href="/admin/css/branch.css">
<script type="text/javascript" src="/jscript/jquery-1.3.2.min.js"></script>
<script type="text/javascript" src="/jscript/jquery_cate.js"></script>
<script type="text/javascript" src="branch.js"></script>
<script type="text/javascript">
<!--

function delok(uidx){
	var f = document.delFrm;

	if (confirm("해당 지사를 삭제하시겠습니까?\n\n\※ 삭제 후 복구할 수 없습니다.※")) {
		f.intIDX.value = uidx;
		f.submit();
	}
}

//-->
</script>

</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="bracn_regist">
	<table <%=tableatt%> class="adminFullTable view table2">
		<colgroup>
			<col width="220" />
			<col width="*" />
		</colgroup>
		<tr>
			<td colspan="2" class="title">지사정보</td>
		</tr><tr>
			<th>지사 표시</th>
			<td><%=RS_isUse_TF%></td>
		</tr><tr>
			<th>지사 위치</th>
			<td><%=RS_strCateName%></td>
		</tr><tr>
			<th>지사 명</th>
			<td><%=RS_strBranchName%></td>
		</tr><tr>
			<th>지사 대표명</th>
			<td><%=RS_strBranchOwner%></td>
		</tr><tr>
			<th>지사 전화번호</th>
			<td><%=RS_strBranchTel%></td>
		</tr><tr>
			<th>지사 팩스번호</th>
			<td><%=RS_strBranchFax%></td>
		</tr><tr>
			<th>지사 주소</th>
			<td>(우 <%=RS_strZip%>) <%=RS_strADDR1%>&nbsp;<%=RS_strADDR2%></td>
		</tr><tr>
			<th>timestamp</th>
			<td><%=RS_strBranchMapCode%></td>
		</tr><tr>
			<th>key</th>
			<td><%=RS_strBranchKey%></td>
		</tr>
	</table>
	<div class="submit_area">
		<%=aImg("branch_list.asp?bname="&strBoardName,IMG_BTN&"/btn_rect_list.gif",99,45,"")%>			<%=aImgOpt("branch_modify.asp?idx="&intIDX&"","S",IMG_BTN&"/btn_rect_change.gif",99,45,"","style=""margin-left:7px;""")%>
		<%=aImgOpt("javascript:delok('"&intIDX&"')","S",IMG_BTN&"/btn_rect_del.gif",99,45,"","style=""margin-left:7px;""")%>
	</div>
</div>

<form name="delFrm" action="branchHandler.asp" method="post">
	<input type="hidden" name="mode" value="DELETE" />
	<input type="hidden" name="intIDX" value="<%=intIDX%>" />
</form>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
