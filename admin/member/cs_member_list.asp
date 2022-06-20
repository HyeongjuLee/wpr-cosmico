<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MEMBER"
	INFO_MODE = "MEMBER3-1"


	Dim SEARCHTERM	:	SEARCHTERM	 = Request.Form("SEARCHTERM")
	Dim SEARCHSTR	:	SEARCHSTR	 = Request.Form("SEARCHSTR")
	Dim PAGESIZE	:	PAGESIZE	 = Request.Form("PAGESIZE")
	Dim PAGE		:	PAGE		 = Request.Form("PAGE")

	Dim Sell_Mem_TF	:	Sell_Mem_TF	 = Request.Form("Sell_Mem_TF")
	Dim GradeName	:	GradeName	 = Request.Form("GradeName")
	Dim CenterName	:	CenterName	 = Request.Form("CenterName")
	Dim LeaveCheck	:	LeaveCheck	 = Request.Form("LeaveCheck")

	Dim CSMBID1	:	CSMBID1	 = Request.Form("CSMBID1")
	Dim CSMBID2	:	CSMBID2	 = Request.Form("CSMBID2")

	If SEARCHTERM	= "" Then SEARCHTERM = "" End If
	If SEARCHSTR	= "" Then SEARCHSTR = "" End if

	If PAGESIZE		= "" Then PAGESIZE = 15
	If PAGE			= "" Then PAGE = 1
	If Sell_Mem_TF	= "" Then Sell_Mem_TF = 2	'전체 : 판매원/소비자 아닌경우(INTEGER)
	If GradeName	= "" Then GradeName = ""
	If CenterName	= "" Then CenterName = ""
	If LeaveCheck	= "" Then LeaveCheck = 2	'전체 : 활동/탈퇴 아닌경우(INTEGER)

	If CSMBID1	= "" Then CSMBID1 = ""
	If CSMBID2	= "" Then CSMBID2 = ""


	arrParams = Array( _
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE), _
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE), _
		Db.makeParam("@SEARCHSTR",adVarChar,adParamInput,30,convSql(SEARCHSTR)), _
		Db.makeParam("@SEARCHTERM",adVarChar,adParamInput,30,SEARCHTERM), _

		Db.makeParam("@Sell_Mem_TF",adSmallInt,adParamInput,1,Sell_Mem_TF), _
		Db.makeParam("@LeaveCheck",adSmallInt,adParamInput,0,LeaveCheck), _
		Db.makeParam("@GradeName",adVarChar,adParamInput,50,GradeName), _
		Db.makeParam("@CenterName",adVarWChar,adParamInput,50,CenterName), _
		Db.makeParam("@CSMBID1",adVarChar,adParamInput,20,CSMBID1), _
		Db.makeParam("@CSMBID2",adInteger,adParamInput,0,CSMBID2), _
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,0,0) _
	)
	arrList = Db.execRsList("HJPA_CS_MEMBER_LIST",DB_PROC,arrParams,listLen,DB3)

	All_Count = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If


%>
<link rel="stylesheet" href="/admin/css/member.css" />
<script type="text/javascript" src="/admin/jscript/cs_member.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="member_list">
	<form name="sfrm" action="cs_member_list.asp" method="post">
		<p class="titles">검색<p>
		<table <%=tableatt%> class="adminFullTable search">
			<colgroup>
				<col width="200" />
				<col width="800" />
			</colgroup>
			<tr>
				<th>회원구분 선택</th>
				<td>
					<label><input type="radio" name="Sell_Mem_TF" value="2" class="input_chk" <%=isChecked(Sell_Mem_TF,"2")%> />전체</label>
					<label><input type="radio" name="Sell_Mem_TF" value="0" class="input_chk input_chk_s" <%=isChecked(Sell_Mem_TF,"0")%> />사업자</label>
					<label><input type="radio" name="Sell_Mem_TF" value="1" class="input_chk input_chk_s" <%=isChecked(Sell_Mem_TF,"1")%> />소비자</label>
				</td>
			</tr><tr>
				<th>활동여부 선택</th>
				<td>
					<label><input type="radio" name="LeaveCheck" value="2" class="input_chk" <%=isChecked(LeaveCheck,"2")%> />전체</label>
					<label><input type="radio" name="LeaveCheck" value="1" class="input_chk input_chk_s" <%=isChecked(LeaveCheck,"1")%> />활동</label>
					<label><input type="radio" name="LeaveCheck" value="0" class="input_chk input_chk_s" <%=isChecked(LeaveCheck,"0")%> />탈퇴</label>
				</td>
			</tr><!-- <tr>
				<th>현직급 / 센타명</th>
				<td>
					<select name="GradeName">
						<option value="" >==현직급 선택==</option>
						<%
							SQL = "SELECT [Grade_Name] FROM [tbl_Class]"

							arrListG = DB.execRsList(SQL,DB_TEXT,Nothing,listLenG,DB3)
							If IsArray(arrListG) Then
								For i = 0 To listLenG
						%>
								 <option value="<%=arrListG(0,i)%>" <%=isSelect(GradeName,""&arrListG(0,i)&"")%>><%=arrListG(0,i)%></option>
						<%
								Next
							End If
						%>
					</select>&nbsp;&nbsp;&nbsp;
					<select name="CenterName">
						<option value="" >==센타선택==</option>
						<%
							SQL2 = "SELECT [name] FROM [tbl_Business]"

							arrListC = DB.execRsList(SQL2,DB_TEXT,Nothing,listLenC,DB3)
							If IsArray(arrListC) Then
								For i = 0 To listLenC
						%>
								 <option value="<%=arrListC(0,i)%>" <%=isSelect(CenterName,""&arrListC(0,i)&"")%>><%=arrListC(0,i)%></option>
						<%
								Next
							End If
						%>
					</select>
				</td>
			</tr> --><tr>
				<th>조건 검색</th>
				<td>
					<select name="SEARCHTERM">
						<option value="" <%=isSelect(SEARCHTERM,"")%>>==조건 선택==</option>
						<option value="WebID" <%=isSelect(SEARCHTERM,"WebID")%>>신청자 아이디로 검색</option>
						<option value="M_Name" <%=isSelect(SEARCHTERM,"M_Name")%>>이름으로 검색</option>
					</select>
					<input type="text" name="SEARCHSTR" class="input_text" style="width:180px;" value="<%=SEARCHSTR%>" />
				</td>
			</tr><tr>
				<th>회원번호 검색</th>
				<td>
					<input type="text" name="CSMBID1" class="input_text imes" style="width:50px;" maxlength="2" value="<%=CSMBID1%>" /> -
					<input type="text" name="CSMBID2" class="input_text" style="width:100px;" maxlength="8" value="<%=CSMBID2%>" <%=onlyKeys%>/>&nbsp;&nbsp;
					<input type="image" src="<%=IMG_BTN%>/btn_search.gif" class="vtop"/>
					<%=aImg(Request.ServerVariables("SCRIPT_NAME"),IMG_BTN&"/search_reset.gif",80,23,"")%>
				</td>
			</tr>
		</table>
	</form>


	<p class="titles">CS등록회원 리스트<p>
	<table <%=tableatt%> class="adminFullTable">
		<colgroup>
			<col width="60" />
			<col width="90" />
			<col width="130" />
			<col width="130" />
			<col width="90" />
			<col width="90" />
			<col width="100" />
			<col width="60" />
			<col width="60" />
			<col width="90" />
			<col width="*" />
		</colgroup>
		<thead>
			<tr>
				<th>Num</th>
				<th>등록일</th>
				<th>회원번호</th>
				<th>성명</th>
				<!-- <th>성별</th> -->
				<!-- <th>메일</th> -->
				<th>현직급</th>
				<th>센타명</th>
				<th>웹아이디</th>
				<th>주소</th>
				<th>연락처</th>
				<th>회원구분</th>
				<th>비고</th>
			</tr>
		</tr>
	<%
		If IsArray(arrList) Then
			For i = 0 To listLen
				arrList_mbid			= arrList(1,i)
				arrList_mbid2			= arrList(2,i)
				arrList_M_Name			= arrList(3,i)
				arrList_E_name			= arrList(4,i)
				arrList_Email			= arrList(5,i)
				arrList_cpno			= arrList(6,i)
				arrList_Addcode1		= arrList(7,i)
				arrList_Address1		= arrList(8,i)
				arrList_Address2		= arrList(9,i)
				arrList_Address3		= arrList(10,i)
				arrList_reqtel			= arrList(11,i)
				arrList_officetel		= arrList(12,i)
				arrList_hometel			= arrList(13,i)
				arrList_hptel			= arrList(14,i)
				arrList_LineCnt			= arrList(15,i)
				arrList_N_LineCnt		= arrList(16,i)
				arrList_Recordid		= arrList(17,i)
				arrList_Recordtime		= arrList(18,i)
				arrList_businesscode	= arrList(19,i)
				arrList_bankcode		= arrList(20,i)
				arrList_banklocal		= arrList(21,i)
				arrList_bankaccnt		= arrList(22,i)
				arrList_bankowner		= arrList(23,i)
				arrList_Regtime			= arrList(24,i)
				arrList_Saveid			= arrList(25,i)
				arrList_Saveid2			= arrList(26,i)
				arrList_Nominid			= arrList(27,i)
				arrList_Nominid2		= arrList(28,i)
				arrList_RegDocument		= arrList(29,i)
				arrList_CpnoDocument	= arrList(30,i)
				arrList_BankDocument	= arrList(31,i)
				arrList_Remarks			= arrList(32,i)
				arrList_LeaveCheck		= arrList(33,i)
				arrList_LineUserCheck	= arrList(34,i)
				arrList_LeaveDate		= arrList(35,i)
				arrList_LineUserDate	= arrList(36,i)
				arrList_LeaveReason		= arrList(37,i)
				arrList_LineDelReason	= arrList(38,i)
				arrList_WebID			= arrList(39,i)
				arrList_WebPassWord		= arrList(40,i)
				arrList_BirthDay		= arrList(41,i)
				arrList_BirthDayTF		= arrList(42,i)
				arrList_Ed_Date			= arrList(43,i)
				arrList_Ed_TF			= arrList(44,i)
				arrList_PayStop_Date	= arrList(45,i)
				arrList_PayStop_TF		= arrList(46,i)
				arrList_For_Kind_TF		= arrList(47,i)
				arrList_Sell_Mem_TF		= arrList(48,i)
				arrList_CurGrade		= arrList(49,i)
				arrList_Max_CurGrade	= arrList(50,i)

				arrList_Grade_Cnt		= arrList(51,i)
				arrList_Grade_Name		= arrList(52,i)

				arrList_center_name		= arrList(53,i)

				Select Case Left(arrList_cpno,1)
					Case "1","3" : listNum4 = viewImg(IMG_ICON&"/icon_male.gif",16,16,"")
					Case "2","4": listNum4 = viewImg(IMG_ICON&"/icon_female.gif",16,16,"")
					Case Else : listNum4 = "--"
				End Select

				Select Case arrList_Sell_Mem_TF
					Case "0" : SellMem_TF = "판매원"
					Case "1" : SellMem_TF = "소비자"
					Case Else : SellMem_TF = "--"
				End Select

				If arrList_LeaveCheck = 0 Then
					trc = " style=""background-color:#efede2;"""
					LEAVE_TEXT = "<span class=""red""> (탈퇴)</span>"
				Else
					trc = " "
					LEAVE_TEXT = ""
				End If

				If DKCONF_SITE_ENC = "T" Then
					Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV
						If arrList_Address1	<> "" Then arrList_Address1		= objEncrypter.Decrypt(arrList_Address1)
						If arrList_Address2	<> "" Then arrList_Address2		= objEncrypter.Decrypt(arrList_Address2)
						If arrList_hometel	<> "" Then arrList_hometel		= objEncrypter.Decrypt(arrList_hometel)
						If arrList_hptel	<> "" Then arrList_hptel		= objEncrypter.Decrypt(arrList_hptel)
					Set objEncrypter = Nothing
				End If


				AllZip = "["&arrList_Addcode1&"] " & arrList_Address1 & " " &arrList_Address2
				ThisNum = ALL_COUNT - CInt(arrList(0,i)) + 1
				PRINT "<tr "&trc&">" & VbCrlf
				PRINT "	<td class=""tcenter"">" & ThisNum &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & date8to10(arrList_Regtime) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList_mbid &"-"& Fn_MBID2(arrList_mbid2) &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList_M_Name &LEAVE_TEXT&"</td>" &VbCrlf
				'PRINT "	<td class=""tcenter"">" & listNum4 &"</td>" &VbCrlf											'copyTxt : admin/jscript/member.js
				'PRINT "	<td class=""tcenter"">" & viewImgStJS(IMG_ICON&"/icon_email.gif",16,16,"","","cp","onclick=""copyTxt('"&arrList_Email&"','Email')""") & viewImgSt(IMG_ICON&"/icon_email_write.gif",16,16,"","margin-left:2px;","") &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList_Grade_Name &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList_center_name &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & arrList_WebID &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & viewImgStJS(IMG_ICON&"/icon_homeT.gif",16,16,"","","cp","onclick=""copyTxt('"&AllZip&"','주소')""") &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & viewImgStJS(IMG_ICON&"/icon_TelT.gif",16,16,"","","cp","onclick=""copyTxt('"&arrList_hometel&"','전화번호')""") &" " & viewImgStJS(IMG_ICON&"/icon_mobileT.gif",16,16,"","","cp","onclick=""copyTxt('"&arrList_hptel&"','핸드폰번호')""") &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">" & SellMem_TF &"</td>" &VbCrlf
				PRINT "	<td class=""tcenter"">"&aImg("javascript:goMemberInfo('"&arrList_mbid&"','"&arrList_mbid2&"')",IMG_BTN&"/btn_gray_update.gif",45,22,"")&"</td>" &VbCrlf
				PRINT "</tr>" & VbCrlf
			Next
		Else
			PRINT "<tr>"
			PRINT "	<td colspan=""11"" class=""notData"">등록된 회원이 없습니다</td>"
			PRINT "</tr>"
		End If

	%>
	</table>
	<div class="paging_area pagingNew">
		<%Call pageListNew(PAGE,PAGECOUNT)%>
		<form name="frm" method="post" action="">
			<input type="hidden" name="PAGE" value="<%=PAGE%>" />
			<input type="hidden" name="SEARCHTERM" value="<%=SEARCHTERM%>" />
			<input type="hidden" name="SEARCHSTR" value="<%=convSql(SEARCHSTR)%>" />
			<input type="hidden" name="Sell_Mem_TF" value="<%=Sell_Mem_TF%>" />
			<input type="hidden" name="GradeName" value="<%=GradeName%>" />
			<input type="hidden" name="CenterName" value="<%=CenterName%>" />
			<input type="hidden" name="LeaveCheck" value="<%=LeaveCheck%>" />
			<input type="hidden" name="CSMBID1" value="<%=CSMBID1%>" />
			<input type="hidden" name="CSMBID2" value="<%=CSMBID2%>" />
			<input type="hidden" name="mid" value="" />
			<input type="hidden" name="mid2" value="" />
		</form>
	</div>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
