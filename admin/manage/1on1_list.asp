<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	W1200 = "T"
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE8-2"


	sc_isReply	= Request("sc_isReply")			: If sc_isReply	= "" Then sc_isReply	= ""
	sc_cate1	= Request("sc_cate1")			: If sc_cate1	= "" Then sc_cate1		= ""
	sc_cate2	= Request("sc_cate2")			: If sc_cate2	= "" Then sc_cate2		= ""
	sc_Name		= Request("sc_Name")			: If sc_Name	= "" Then sc_Name		= ""
	sc_ReplyID	= Request("sc_ReplyID")			: If sc_ReplyID	= "" Then sc_ReplyID	= ""
	sc_WebID	= Request("sc_WebID")			: If sc_WebID	= "" Then sc_WebID	= ""

	PAGE = Request("page")						: If PAGE="" Then PAGE = 1 End If
	PAGESIZE = 20


	SC_QUERY = "PAGE="&page
	SC_QUERY = SC_QUERY & "&sc_cate1="&sc_cate1
	SC_QUERY = SC_QUERY & "&sc_cate2="&sc_cate2
	SC_QUERY = SC_QUERY & "&sc_Name="&server.urlencode(sc_Name)
	SC_QUERY = SC_QUERY & "&sc_ReplyID="&server.urlencode(sc_ReplyID)
	SC_QUERY = SC_QUERY & "&sc_WebID="&server.urlencode(sc_WebID)
	SC_QUERY = SC_QUERY & "&sc_isReply="&sc_isReply

	strCate = ""
	If sc_cate1 <> "" Then strCate = sc_cate1
	If sc_cate2 <> "" Then strCate = sc_cate2


	arrParams = Array(_
		Db.makeParam("@PAGE",adInteger,adParamInput,0,PAGE),_
		Db.makeParam("@PAGESIZE",adInteger,adParamInput,0,PAGESIZE),_
		Db.makeParam("@strCate",adVarChar,adParamInput,40,strCate),_
		Db.makeParam("@strName",adVarWChar,adParamInput,200,sc_Name),_
		Db.makeParam("@strReplyID",adVarWChar,adParamInput,200,sc_ReplyID),_
		Db.makeParam("@strWebID",adVarChar,adParamInput,100,sc_WebID),_

		Db.makeParam("@isReply",adChar,adParamInput,1,sc_isReply),_

		Db.makeParam("@strNation",adVarChar,adParamInput,10,UCase(viewAdminLangCode)), _
		Db.makeParam("@ALL_COUNT",adInteger,adParamOutput,4,0) _
	)
	arrList = Db.execRsList("DKSP_COUNSEL_1ON1_LIST_ADMIN",DB_PROC,arrParams,listLen,Nothing)
	All_Count = arrParams(UBound(arrParams))(4)

	Dim PAGECOUNT,CNT
	PAGECOUNT = Int((CCur(All_Count) - 1 ) / CInt(PAGESIZE) ) + 1
	IF CCur(PAGE) = 1 Then
		CNT = All_Count
	Else
		CNT = All_Count - ((CCur(PAGE)-1)*CInt(PAGESIZE)) '
	End If

%>
<link rel="stylesheet" href="1on1.css" />
<script>
	$(document).ready(function(){
		$('#cate1')
		  .change(function(){chg_category();}).change();
	});


	function chg_category() {

		mode = "category2";
		cate = $('#cate1').val();
		if (cate.length == 0)
		{
			$("#cate2").attr("disabled",true);
			$("#cate2").html("<option value=''>?????? ??????????????? ??????????????????.</option>");
		} else {
			$.ajax({
				type: "POST"
				,url: "1on1_Category_d2.asp"
				,data: {
					 "mode"				: mode
					,"cate"				: cate
					,"strNationCode"	: '<%=viewAdminLangCode%>'

				}
				,success: function(data) {
					var FormErrorChk = data.split(",");
					if (FormErrorChk[0] == "FORMERROR")
					{
						alert("?????????:"+FormErrorChk[1]+"??? ???????????? ???????????????.\n?????? ??????????????????");
						loadings();
					} else {
						$("#cate2").attr("disabled",false);
						$("#cate2").html(data);
						$("#cate2").val("<%=sc_cate2%>");
					}
				}
				,error:function(data) {
					loadings();
					alert("ajax ?????? ??? ????????? ?????????????????????.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				}
			});

		}
	}
</script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="counseling" class="list">
	<div class="search">
		<p class="titles">??????</p>
		<form name="sfrm" action="1on1_list.asp" method="get">
			<table <%=tableatt%> class="width100">
				<colgroup>
					<col width="140" />
					<col width="*" />
				</colgroup>
				<tr>
					<th>????????????</th>
					<td>
						<select id="cate1" name="sc_cate1" class="">
							<option value="">?????? ????????? ??????????????????.</option>
							<%
								arrParams3 = Array(_
									Db.makeParam("@strNationCode",adVarChar,adParamInput,6,viewAdminLangCode), _
									Db.makeParam("@strCatrParent",adVarChar,adParamInput,20,"000") _
								)
								arrList3 = Db.execRsList("DKSP_COUNSEL_1ON1_CATEGORY_LIST_ADMIN",DB_PROC,arrParams3,listLen3,Nothing)
								If Not IsArray(arrList3) Then
									PRINT "<option value="""">????????? ????????????.</option>"
								Else
									For j = 0 To listLen3
										arrList3_intIDX				= arrList3(1,j)
										arrList3_strCateCode		= arrList3(3,j)
										arrList3_strCateName		= arrList3(4,j)
										arrList3_strCateParent		= arrList3(5,j)
										arrList3_intCateDepth		= arrList3(6,j)
										arrList3_intCateSort		= arrList3(7,j)
										arrList3_isView				= arrList3(8,j)
										PRINT "<option value="""&arrList3_strCateCode&""""& isSelect(sc_cate1,arrList3_strCateCode)&">"&arrList3_strCateName&"</option>"
									Next
								End If
							%>
						</select>
						<select name="sc_cate2" id="cate2" class="select2">
							<option value="">?????? ??????????????? ??????????????????.</option>
						</select>
					</td>
				</tr><tr>
					<th>?????????</th>
					<td>
						<input type="radio" name="sc_isReply" id="replyTF1" class="input_radio" <%=isChecked(sc_isReply,"")%> value="" /><label for="replyTF1"> ????????????</label>
						<input type="radio" name="sc_isReply" id="replyTF2" class="input_radio" <%=isChecked(sc_isReply,"T")%> value="T" /><label for="replyTF2"> ????????? ????????? ??????</label>
						<input type="radio" name="sc_isReply" id="replyTF3" class="input_radio" <%=isChecked(sc_isReply,"F")%> value="F" /><label for="replyTF3"> ???????????? ????????? ??????</label>
						<input type="radio" name="sc_isReply" id="replyTF4" class="input_radio" <%=isChecked(sc_isReply,"I")%> value="I" /><label for="replyTF4"> ???????????? ????????? ??????</label>
					</td>
				</tr><tr>
					<th>????????? ??????</th>
					<td><input type="text" name="sc_Name" class="input_text" style="width:230px;" value="<%=sc_Name%>" /> (????????? ?????? ????????? ???????????? ??????)</td>
				</tr><tr>
					<th>????????? ????????????</th>
					<td><input type="text" name="sc_WebID" class="input_text" style="width:230px;" value="<%=sc_WebID%>" /> (????????? ???????????? ????????? ???????????? ?????????)</td>
				</tr><tr>
					<th>?????????ID</th>
					<td>
						<input type="text" name="sc_ReplyID" class="input_text" style="width:230px;" value="<%=sc_ReplyID%>" placeholder="???????????? ??????????????????" />
						<input type="submit" src="<%=IMG_BTN%>/btn_search.gif" class="input_submit design1" value="??????" />
						<a href="<%=Request.ServerVariables("SCRIPT_NAME")%>" class="a_submit design3">???????????????</a>

					</td>
				</tr>
			</table>
		</form>

	</div>






	<p class="titles">????????? (<%=num2cur(All_Count)%> ???)</p>
	<div class="tbl_list">
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="70" />
				<col width="130" />
				<col width="140" />
				<col width="180" />
				<col width="*" />
				<col width="60" />
				<col width="60" />
				<col width="90" />
				<col width="95" />
			</colgroup>
			<thead>
				<tr>
					<th>??????</th>
					<th>????????????</th>
					<th>????????????</th>
					<th>???????????? / ?????????</th>
					<th>??????</th>
					<th>??????</th>
					<th>??????</th>
					<th>?????????</th>
					<th>??????</th>
				</tr>
			</thead>
			<tbody>
			<%


				Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV



				If IsArray(arrList) Then
					For i = 0 To listLen
						arrList_ROWNUM			= arrList(0,i)
						arrList_intIDX			= arrList(1,i)
						arrList_isDel			= arrList(2,i)
						arrList_strCate			= arrList(3,i)
						arrList_strUserID		= arrList(4,i)
						arrList_strName			= arrList(5,i)
						arrList_strEmail		= arrList(6,i)
						arrList_strMobile		= arrList(7,i)
						arrList_strSubject		= arrList(8,i)
						arrList_strContent		= arrList(9,i)
						arrList_regDate			= arrList(10,i)
						arrList_regIP			= arrList(11,i)
						arrList_isSmsSend		= arrList(12,i)
						arrList_isMailSend		= arrList(13,i)
						arrList_isReply			= arrList(14,i)
						arrList_repDate			= arrList(15,i)
						arrList_strReply		= arrList(16,i)
						arrList_strReplyID		= arrList(17,i)
						arrList_strNation		= arrList(18,i)
						arrList_strData1		= arrList(19,i)
						arrList_strData2		= arrList(20,i)
						arrList_strData3		= arrList(21,i)
						arrList_strWebID		= arrList(22,i)
						arrList_memoCnt			= arrList(23,i)

						NUMS = CDbl(All_Count) - CDbl(arrList_ROWNUM) + 1
						'If arrList_strName		<> "" Then arrList_strName		= objEncrypter.Decrypt(arrList_strName)
						If arrList_strEmail		<> "" Then arrList_strEmail		= objEncrypter.Decrypt(arrList_strEmail)
						If arrList_strMobile	<> "" Then arrList_strMobile	= objEncrypter.Decrypt(arrList_strMobile)

						SQL = "SELECT [strCateName] FROM [DKT_COUNSEL_1ON1_CATEGORY] WHERE [strCateCode] = ?"
						arrParams5 = Array(Db.makeParam("@strCateCode",adVarChar,adParamInput,40,Left(arrList_strCate,3)))
						arrParams6 = Array(Db.makeParam("@strCateCode",adVarChar,adParamInput,40,Left(arrList_strCate,6)))
						CateName1 = Db.execRsData(SQL,DB_TEXT,arrParams5,Nothing)
						CateName2 = Db.execRsData(SQL,DB_TEXT,arrParams6,Nothing)


			%>

				<tr>
					<td><%=NUMS%></td>
					<td>
						<a href="?sc_cate1=<%=Left(arrList_strCate,3)%>"><%=CateName1%></a><br />
						<a href="?sc_cate2=<%=Left(arrList_strCate,6)%>"><strong><%=CateName2%></strong></a>
					</td>
					<td class="contents">
						<a href="?sc_name=<%=server.urlencode(arrList_strName)%>"><%=arrList_strName%></a><br />
						<a href="?sc_WebID=<%=server.urlencode(arrList_strWebID)%>"><%=arrList_strWebID%></a>
					</td>
					<td class="contents"><%=arrList_strMobile%><br /><%=arrList_strEmail%></td>
					<td class="tleft"><%=backword(arrList_strSubject)%></td>
					<td>
						<%=TFVIEWER(arrList_isReply,"REPLY")%><br />
						<%If arrList_strReplyID <> "" Then%>
						<a href="?sc_replyID=<%=arrList_strReplyID%>"><%=arrList_strReplyID%></a>
						<%End If%>
					</td>
					<td><%=num2cur(arrList_memoCnt)%> ???</td>
					<td><%=DateValue(arrList_regDate)%><br /><%=TimeValue(arrList_regDate)%></td>
					<td><a href="1on1_view.asp?idx=<%=arrList_intIDX%>&<%=SC_QUERY%>" class="a_submit design1">????????????</a></td>
				</tr>
			<%
					Next
				Else
			%>
				<tr>
					<td colspan="9" class="notData">????????? ????????? ????????????.</td>
				</tr>
			<%
				End If
				Set objEncrypter = Nothing

			%>



			</tbody>

		</table>
	</div>
	<div class="cleft  width100" style="margin-top:15px;text-align:center; padding-bottom:40px;">
		<!-- <div class="pageArea2"><%Call pageList(PAGE,PAGECOUNT)%></div> -->
		<div class="pagingArea pagingNew4"><% Call pageListNew3(PAGE,PAGECOUNT)%></div>
	</div>

	<form name="frm" method="get" action="">
		<input type="hidden" name="sc_isReply" value="<%=sc_isReply%>" />
		<input type="hidden" name="PAGE" value="<%=PAGE%>" />
		<input type="hidden" name="sc_cate1" value="<%=sc_cate1%>" />
		<input type="hidden" name="sc_cate2" value="<%=sc_cate2%>" />
		<input type="hidden" name="sc_Name" value="<%=sc_Name%>" />
		<input type="hidden" name="sc_ReplyID" value="<%=sc_ReplyID%>" />
		<input type="hidden" name="sc_WebID" value="<%=sc_WebID%>" />
		<input type="hidden" name="nc" value="<%=viewAdminLangCode%>" />
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
