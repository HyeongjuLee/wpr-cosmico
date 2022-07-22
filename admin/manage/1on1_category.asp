<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	'INFO_MODE = "MANAGE8-1"


	INFO_MODE = "MANAGE8-1"
	INFO_TEXT = viewAdminLangName

	In_Cate1 = Request("cate1")
	In_Cate2 = Request("cate2")
	In_Cate3 = Request("cate3")
	FCate = Request("cate")





	'print Fcate
	If FCate <> "" Then PARENTS_CATEGORY = FCate
	If In_Cate1 <> "" Then PARENTS_CATEGORY = In_Cate1
	If In_Cate2 <> "" Then PARENTS_CATEGORY = In_Cate2
	If In_Cate3 <> "" Then PARENTS_CATEGORY = In_Cate3

	If PARENTS_CATEGORY = "" Then
		PARENTS_CATEGORY = "000"
	End If


	If PARENTS_CATEGORY <> "000" Then
		CATEGORYS1 = Left(PARENTS_CATEGORY,3)
		If Len(PARENTS_CATEGORY) > 3 Then
			CATEGORYS2 = Left(PARENTS_CATEGORY,6)
			If Len(PARENTS_CATEGORY) > 9 Then
			CATEGORYS3 = Left(PARENTS_CATEGORY,9)
			End If
		End If
	End If

	If Len(PARENTS_CATEGORY) = 3 Then C_DEPTH = "2" End If
	If Len(PARENTS_CATEGORY) = 6 Then C_DEPTH = "3" End If
	If PARENTS_CATEGORY = "000" Then C_DEPTH = "1" End If



%>
<link rel="stylesheet" type="text/css" href="/modP/bootstrap/bootstrap.css" />
<link rel="stylesheet" href="1on1.css" />
<script type="text/javascript" src="1on1.js?v1"></script>
<script type="text/javascript">
	/*
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
			$("#cate2").html("<option value=''>상위 카테고리를 선택해주세요.</option>");
		} else {
			$.ajax({
				type: "POST"
				,url: "1on1_Category_d2.asp"
				,data: {
					 "mode"				: mode
					,"cate"				: cate
					,"strNationCode"	: '<%=strNationCode%>'

				}
				,success: function(data) {
					var FormErrorChk = data.split(",");
					if (FormErrorChk[0] == "FORMERROR")
					{
						alert("필수값:"+FormErrorChk[1]+"가 넘어오지 않았습니다.\n다시 시도해주세요");
						loadings();
					} else {
						$("#cate2").attr("disabled",false);
						$("#cate2").html(data);
						$("#cate2").val("<%=CATEGORYS2%>");
					}
				}
				,error:function(data) {
					loadings();
					alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				}
			});

		}
	}
	*/
</script>
</head>
<body onload="document.frms.strCateName.focus();">
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="counseling" class="category">
	<div id="cate_select">
		<form name="cateFrm" action="1on1_category.asp" method="post">
			<table <%=tableatt%> class="width100">
				<tr>
					<th>카테고리 선택 </th>
				</tr><tr>
					<td class="tcenter">
						<p>
							<select id="cate1" name="cate1" class="">
								<option value="">상위 메뉴를 선택해주세요.</option>
								<%
									arrParams = Array(_
										Db.makeParam("@strNationCode",adVarChar,adParamInput,6,viewAdminLangCode), _
										Db.makeParam("@strCatrParent",adVarChar,adParamInput,20,"000") _
									)
									arrList = Db.execRsList("DKSP_COUNSEL_1ON1_CATEGORY_LIST_ADMIN",DB_PROC,arrParams,listLen,Nothing)
									If Not IsArray(arrList) Then
										PRINT "<option value="""">메뉴가 없습니다.</option>"
									Else
										For i = 0 To listLen
											arrList_intIDX				= arrList(1,i)
											arrList_strCateCode			= arrList(3,i)
											arrList_strCateName			= arrList(4,i)
											arrList_strCateParent		= arrList(5,i)
											arrList_intCateDepth		= arrList(6,i)
											arrList_intCateSort			= arrList(7,i)
											arrList_isView				= arrList(8,i)
											PRINT "<option value="""&arrList_strCateCode&""""& isSelect(CATEGORYS1,arrList_strCateCode)&">"&arrList_strCateName&"</option>"
										Next
									End If
								%>
							</select>
						</p>
						<br />
						<input type="submit" value="카테고리 이동" class="input_submit design3" />
					</td>
				</tr>
			</table>
		</form>
	</div>

	<div id="cate_insert">
		<form name="frms" method="post" action="1on1_category_Handler.asp" onsubmit="return menuIn(this)">
			<input type="hidden" name="mode" value="INSERT" />
			<input type="hidden" name="intCateDepth" value="<%=C_DEPTH%>" />
			<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
			<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
			<table <%=tableatt%> class="width100">
				<colgroup>
					<col width="180" />
					<col width="*" />
				</colgroup>
				<thead>
					<tr>
						<th colspan="4">메뉴 추가</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th>메뉴명</td>
						<td ><input type="text" name="strCateName" class="input_text" style="width:300px;" /></td>
					</tr><tr>
						<th>메뉴 보임</td>
						<td class="tds2">
							<label><input type="radio" name="isView" value="T" class="vmiddle" checked="checked" /> 메뉴 보임</label>
							<label><input type="radio" name="isView" value="F" class="vmiddle" /> 메뉴 숨김</label>
						</td>
					</tr>
					<%If C_DEPTH > 1 Then%>
						<tr>
							<th>기본 문구</td>
							<td class="tds2">
								<textarea name="strBaseText" class="input_area" style="width:90%; height:150px;"></textarea>
							</td>
						</tr>
					<%Else%>
						<tr>
							<th>기본 문구</td>
							<td class="tds2">기본 문구는 최종 카테고리에서만 입력 가능합니다.</td>
						</tr>
					<%End If%>
				</tbody>
				<tr>
					<td colspan="2" class="btnZone"><input type="submit" class="input_submit design1" value="등록" /></td>
				</tr>
			</table>
		</form>
	</div>

	<div id="cate_List">
		<table <%=tableatt%> class="width100">
			<colgroup>
				<col width="60" />
				<col width="90" />
				<col width="120" />
				<col width="*" />

				<col width="70" />
				<col width="120" />
				<col width="150" />
			</colgroup>
			<tr>
				<th>번호</th>
				<th>순서</th>
				<th>코드</th>
				<th>메뉴명</th>

				<th>노출</th>
				<th>기본문구여부</th>

				<th>비고</th>
			</tr>
			<%

				arrParams = Array(_
					Db.makeParam("@strNationCode",adVarChar,adParamInput,6,viewAdminLangCode), _
					Db.makeParam("@strCatrParent",adVarChar,adParamInput,20,PARENTS_CATEGORY) _
				)
				arrList = Db.execRsList("DKSP_COUNSEL_1ON1_CATEGORY_LIST_ADMIN",DB_PROC,arrParams,listLen,Nothing)

				styleWidth = 60
				If IsArray(arrList) Then
					For i = 0 To listLen
						arrList_intIDX				= arrList(1,i)
						arrList_strNationCode		= arrList(2,i)
						arrList_strCateCode			= arrList(3,i)
						arrList_strCateName			= arrList(4,i)
						arrList_strCateParent		= arrList(5,i)
						arrList_intCateDepth		= arrList(6,i)
						arrList_intCateSort			= arrList(7,i)
						arrList_isView				= arrList(8,i)
						arrList_strBaseText			= arrList(9,i)



			%>

				<tr>
					<td><%=arrList_intCateSort%></td>
					<td>
						<a href="javascript:sortUp('<%=arrList_strCateCode%>')" style="font-size:19px;"><i class="fas fa-arrow-circle-up"></i></a>
						<a href="javascript:sortDown('<%=arrList_strCateCode%>')" style="font-size:19px;"><i class="fas fa-arrow-circle-down"></i></i></a>
					<td><%=arrList_strCateCode%></td>
					<td class="tleft"><%=arrList_strCateName%></td>
					<td><%=TFVIEWER(arrList_isView,"VIEW")%></td>
					<td>
						<%If arrList_strBaseText = "" Then%>
							<span class="text_red">없음</span>
						<%Else%>
							<span class="text_blue">있음</span>
						<%End If%>
					</td>
					<td>
						<input type="hidden" name="m_strCateCode" value="<%=arrList_strCateCode%>" />
						<input type="hidden" name="m_strCateName" value="<%=arrList_strCateName%>" />
						<input type="hidden" name="m_isView" value="<%=arrList_isView%>" />
						<input type="hidden" name="m_strBaseText" value="<%=BACKWORD(arrList_strBaseText)%>" />

						<button type="button" class="input_submit design1 dataModify">수정</button>

						<a href="javascript:delok('<%=arrList_strCateCode%>')" class="a_submit design4">삭제</a>
					</td>
				</tr>

			<%
					Next
				Else

					PRINT "		<tr>"
					PRINT "			<td colspan=""11"" height=""80""> 등록된 카테고리가 없습니다.</td>"
					PRINT "		</tr>"

				End If

			%>
		</table>


	</div>
</div>

<form name="delFrm" action="1on1_Category_Handler.asp" method="post" >
	<input type="hidden" name="mode" value="DELETE" />
	<input type="hidden" name="strCateCode" value="" />
	<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
	<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
</form>
<form name="sortFrm" action="1on1_Category_Handler.asp" method="post" >
	<input type="hidden" name="strCateCode" value="" />
	<input type="hidden" name="mode" value="" />
	<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
	<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
</form>

<!-- Modal 1 S -->
	<div class="modal fade modal_category" id="ModalScrollable1" tabindex="-1" role="dialog" aria-labelledby="ModalScrollableTitle1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-scrollable" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title tweight" id="ModalScrollableTitle1">수정</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
				</div>
				<div class="modal-body">
					<form name="ufrm" action="1on1_Category_Handler.asp" method="post">
						<input type="hidden" name="mode" value="UPDATE" />
						<input type="hidden" name="strCateParent" value="<%=PARENTS_CATEGORY%>" />
						<input type="hidden" name="strNationCode" value="" />
						<input type="hidden" name="strCateCode" value="" />
						<table <%=tableatt%> class="width100 asList" id="TableGrid1">
							<col width="130" />
							<col width="*" />
							<tbody>
								<tr>
									<th>메뉴명</th>
									<td><input type="text" name="strCateName" class="input_text" style="width:300px;" /></th>
								</tr><tr>
									<th>메뉴보임</th>
									<td>
										<label><input type="radio" name="isView" value="T" class="vmiddle" /> 메뉴 보임</label>
										<label><input type="radio" name="isView" value="F" class="vmiddle" /> 메뉴 숨김</label>
									</td>
								</tr><tr>
									<%If C_DEPTH > 1 Then%>
										<tr>
											<th>기본 문구</td>
											<td>
												<textarea name="strBaseText" class="input_area" style="width:90%; height:150px;"></textarea>
											</td>
										</tr>
									<%Else%>
										<tr>
											<th>기본 문구</td>
											<td class="tds2">기본 문구는 최종 카테고리에서만 입력 가능합니다.</td>
										</tr>
									<%End If%>
									</td>
								</tr><tr>
									<td colspan="2" class="tcenter"><input type="submit" class="input_submit design1" value="변경"></td>
								</tr>
							</tbody>
						</table>
					</form>
				</div>
				<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
<!-- Modal 2 E -->
<script src="/modP/bootstrap/bootstrap.bundle.min.js"></script>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
