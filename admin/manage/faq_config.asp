<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "MANAGE"
	INFO_MODE = "MANAGE1-4"

	Call FN_WEBPRO_ONLY(DK_MEMBER_LEVEL)

%>
<link rel="stylesheet" href="faq.css" />
<script type="text/javascript" src="faq.js"></script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="faq">
	<p class="titles">FAQ 기본설정 <!-- (<%=UCase(strNationCode)%>) --><p>
	<div class="insert">
		<form name="iFrm" method="post" action="faq_config_handler.asp" onsubmit="return chkRegConfig(this)">
			<input type="hidden" name="MODE" value="REGIST">
			<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
			<table <%=tableatt%> class="width100">
				<col width="180" />
				<col width="440" />
				<col width="*" />
				<tr>
					<th>FAQ 그룹명</th>
					<td><input type="text" name="strGroup" class="input_text" style="width:330px; ime-mode:disabled;" value="" /></td>
					<td>FAQ 그룹을 설정합니다 (<span class="text_red">영문만 허용</span>)</td>
				</tr><tr>
					<th>FAQ 출력위치/사용</th>
					<td>
						<input type="text" name="strCateCode" class="input_text" style="width:330px;" value="" />
						<select name="isUse">
							<option value="T">사용</option>
							<option value="F">미사용</option>
						</select>
					</td>
					<td>FAQ의 출력위치를 설정합니다</td>
				</tr><tr>
					<th>FAQ 위치(메뉴 추적)</th>
					<td>메인 : <input type="text" name="mainVar" class="input_text" style="width:45px;" value="<%=DKRS_mainVar%>" />&nbsp;&nbsp; 서브 (view값) : <input type="text" name="SubVar" class="input_text" style="width:45px;" value="<%=DKRS_SubVar%>" />&nbsp;&nbsp; 서브2 (sview값) : <input type="text" name="sViewVar" class="input_text" style="width:45px;" value="<%=DKRS_sViewVar%>" /></td>
					<td class="borLeft">게시판네비추적 (서브 = view값, 서브2 = sview값(기본값:0) ).</td>
				</tr><tr>
					<th>FAQ 노출레벨</th>
					<td>
						<select name="intViewLevel">
							<option value="0">0레벨 (비회원)</option>
							<option value="1">1레벨 (소비자)</option>
							<option value="2">2레벨 (판매자)</option>
							<option value="3">3레벨</option>
							<option value="4">4레벨</option>
							<option value="5">5레벨</option>
							<option value="6">6레벨</option>
							<option value="7">7레벨</option>
							<option value="8">8레벨</option>
							<option value="9">9레벨</option>
							<option value="10">10레벨 (관리자)</option>
							<option value="11">11레벨 (개발자)</option>
						</select>

					</td>
					<td>FAQ 노출 레벨 설정(loginOk 에서 지정한 레벨에 따름)</td>
				</tr></tr>
					<td colspan="3" class="tcenter"><input type="submit" class="input_submit design3" value="등록" /></td>
				</tr>
			</table>
		</form>
	</div>




	<p class="titles">FAQ 설정 목록 <!-- (<%=UCase(strNationCode)%>) --></p>
	<div class="list">
		<table <%=tableatt%> class="width100">
			<col width="260" />
			<col width="150" />
			<col width="80" />
			<col width="70" />
			<col width="70" />
			<col width="70" />
			<col width="150" />
			<col width="*" />
			<tr>
				<th>그룹명</th>
				<th>출력위치</th>
				<th>사용</th>
				<th>메인</th>
				<th>서브</th>
				<th>서브2</th>
				<th>레벨</th>
				<th>기능</th>
			</tr>
			<%

				arrParams = Array(_
					Db.makeParam("@strNationCode",adVarChar,adParamInput,10,viewAdminLangCode) _
				)
				arrList = Db.execRsList("[DKSP_FAQ_CONFIG_LIST_ADMIN]",DB_PROC,arrParams,listLen,Nothing)
				If IsArray(arrList) Then
					For i = 0 To listLen
						arrList_intIDX			= arrList(0,i)
						arrList_strNationCode	= arrList(1,i)
						arrList_strGroup		= arrList(2,i)
						arrList_strCateCode		= arrList(3,i)
						arrList_isUse			= arrList(4,i)
						arrList_mainVar			= arrList(5,i)
						arrList_SubVar			= arrList(6,i)
						arrList_sViewVar		= arrList(7,i)
						arrList_intViewLevel	= arrList(8,i)


			%>
			<tr>
				<td class="tcenter"><input type="text" name="strGroup" class="input_text" style="width:95%;" value="<%=arrList_strGroup%>" /></td>
				<td class="tcenter"><input type="text" name="strCateCode" class="input_text" style="width:90%;" value="<%=arrList_strCateCode%>" /></td>
				<td class="tcenter">
						<select name="isUse">
							<option value="T" <%=isSelect(arrList_isUse,"T")%>>사용</option>
							<option value="F" <%=isSelect(arrList_isUse,"F")%>>미사용</option>
						</select>
				</td>
				<td class="tcenter"><input type="text" name="mainVar" class="input_text tcenter" style="width:90%;" value="<%=arrList_mainVar%>" /></td>
				<td class="tcenter"><input type="text" name="SubVar" class="input_text tcenter" style="width:90%;" value="<%=arrList_SubVar%>" /></td>
				<td class="tcenter"><input type="text" name="sViewVar" class="input_text tcenter" style="width:90%;" value="<%=arrList_sViewVar%>" /></td>
				<td class="tcenter"><%=arrList_intViewLevel%>
					<select name="intViewLevel">
							<option value="0"  <%=isSelect(arrList_intViewLevel,"0")%>>0레벨 (비회원)</option>
							<option value="1"  <%=isSelect(arrList_intViewLevel,"1")%>>1레벨 (소비자)</option>
							<option value="2"  <%=isSelect(arrList_intViewLevel,"2")%>>2레벨 (판매자)</option>
							<option value="3"  <%=isSelect(arrList_intViewLevel,"3")%>>3레벨</option>
							<option value="4"  <%=isSelect(arrList_intViewLevel,"4")%>>4레벨</option>
							<option value="5"  <%=isSelect(arrList_intViewLevel,"5")%>>5레벨</option>
							<option value="6"  <%=isSelect(arrList_intViewLevel,"6")%>>6레벨</option>
							<option value="7"  <%=isSelect(arrList_intViewLevel,"7")%>>7레벨</option>
							<option value="8"  <%=isSelect(arrList_intViewLevel,"8")%>>8레벨</option>
							<option value="9"  <%=isSelect(arrList_intViewLevel,"9")%>>9레벨</option>
							<option value="10" <%=isSelect(arrList_intViewLevel,"10")%>>10레벨 (관리자)</option>
							<option value="11" <%=isSelect(arrList_intViewLevel,"11")%>>11레벨 (개발자)</option>
						</select>
				</td>
				<td class="tcenter">
					<input type="hidden" name="intIDX" value="<%=arrList_intIDX%>" />
					<input type="hidden" name="ORI_strGroup" value="<%=arrList_strGroup%>" />
					<button type="button" class="input_submit design1 configDataModify">수정</button>
					<button type="button" class="input_submit design4 configDataDelete">삭제</button>

				</td>
			</tr>
			<%
					Next
				Else
			%>
			<tr>
				<td colspan="7" class="notData">등록된 FAQ가 없습니다.</td>
			</tr>
			<%
				End If
			%>
		</table>
	</div>
</div>
<form name="modFrm" action="faq_config_handler.asp" method="post">
	<input type="hidden" name="MODE" value="" />
	<input type="hidden" value="" name="intIDX" />
	<input type="hidden" value="" name="strGroup" />
	<input type="hidden" value="" name="strCateCode" />
	<input type="hidden" value="" name="isUse" />
	<input type="hidden" value="" name="mainVar" />
	<input type="hidden" value="" name="SubVar" />
	<input type="hidden" value="" name="sViewVar" />
	<input type="hidden" value="" name="ORI_strGroup" />
	<input type="hidden" value="" name="intViewLevel" />
	<input type="hidden" name="strNationCode" value="<%=viewAdminLangCode%>" />
</form>



<!--#include virtual = "/admin/_inc/copyright.asp"-->
