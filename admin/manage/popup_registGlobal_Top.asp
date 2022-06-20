<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
' ===================================================================
' 게시판 변수 받아오기(설정)
' ===================================================================
	Dim popWidth,popHeight
		popWidth = 400
		popHeight = 530

	strNationCode = Request("nc")

' ===================================================================


%>
<link rel="stylesheet" href="../css/manage.css" />
<link rel="stylesheet" href="../css/popup.css" />
<!-- <script type="text/javascript" src="/admin/jscript/manage.js"></script> -->
<script type="text/javascript">
<!--

	function chkPopupRegist(f) {

		if (f.popTitle.value == '')
		{
			alert("팝업타이틀을 입력해주세요.");
			f.popTitle.focus();
			return false;
		}
		if (f.strScontent.value == '')
		{
			alert("짧은 설명은 입력해주세요.");
			f.strScontent.focus();
			return false;
		}
		if (f.popKind.value == '')
		{
			alert("팝업의 종류를 선택해주세요.");
			f.popKind.focus();
			return false;
		}
		if (f.linkType.value == '')
		{
			alert("링크를 적용하실 윈도우(창)을 선택해주세요.");
			f.linkType.focus();
			return false;
		}
		if (f.linkUrl.value == '')
		{
			alert("링크주소를 입력해주세요.");
			f.linkUrl.focus();
			return false;
		}
	}


	function pageGoto(page,nc){
		var target = '<%=strNationCode%>'
		if(page == 1){
			location.href = "popup_registGlobal.asp?nc="+nc
		}else if(page == 2){
			location.href = "popup_registGlobal_Top.asp?nc="+nc
		}
	}

// -->
</script>
</head>
<body>
<div id="popup">
	<div id="pop_all">
		<div class="top"><%=viewImg(IMG_POP&"/tit_popup_regist.gif",250,40,"")%></div>
		<div class="content">
			<form name="frms" method="post" action="popup_registGlobalOk_Top.asp" onsubmit="return chkPopupRegist(this)" enctype="multipart/form-data">
				<input type="hidden" name="strNationCode" value="<%=strNationCode%>" />
				<input type="hidden" name="isViewCom" value="T" />
				<input type="hidden" name="isViewShop" value="F" />
				<!-- <input type="hidden" name="popKind" value="P" /> -->
				<!-- <input type="hidden" name="popKind" value="L" /> -->
				<table <%=tableatt%> class="tables1">
					<colgroup>
						<col width="100" />
						<col width="*" />
					</colgroup>
					<tbody>
						<tr>
							<th>국가코드</th>
							<td><%=strNationCode%></td>
						</tr>
						<tr>
							<th>팝업값</th>
							<td>자동설정</td>
						</tr><tr>
							<th>사용유무</th>
							<td><label><input type="radio" name="useTF" class="vmiddle" value="T" />사용함</label> <label><input type="radio" name="useTF" class="vmiddle" checked="checked" value="F" />사용안함</label></td>
						</tr><tr>
							<th>팝업종류</th>
							<td>
								<label><input type="radio" name="popKind" class="vmiddle" value="P" onClick="pageGoto(1,'<%=strNationCode%>');"/>일반팝업</label>
								<!-- <label><input type="radio" name="popKind" class="vmiddle" value="L" onClick="pageGoto(1,'<%=strNationCode%>');" />레이어팝업</label> -->
								<label><input type="radio" name="popKind" class="vmiddle" value="T" onClick="pageGoto(2,'<%=strNationCode%>');" checked="checked"/>상단팝업</label>
							</td>
						</tr><tr>
							<th>팝업타이틀</th>
							<td><input type="text" name="popTitle" class="input_text" style="width:270px;" /></td>
						</tr><!-- <tr>
							<th>팝업이미지</th>
							<td><input type="file" name="imgName" class="input_file" style="width:270px;" /></td>
						</tr> -->
						<tr>
							<th>짧은 설명</th>
							<td>
								<span style="line-height:120%;">한글기준 30자 이내로 작성해주세요.</span>
							</td>
						</tr><tr>
							<td colspan="2">
								<!-- <textarea name="strScontent" class="input_area fleft" cols="50" rows="10" style="width:96%; height:30px;"></textarea> -->
								<input type="text" name="strScontent" class="input_text" style="width:370px;" />
							</td>
						</tr>
						<!-- <tr>
							<th>팝업위치</th>
							<td>상단 : <input type="text" name="marginTop" class="input_text vmiddle" style="width:50px;" <%=onLyKeys%>/>PX &nbsp;&nbsp;&nbsp;좌측 : <input type="text" name="marginLeft" class="input_text vmiddle" style="width:50px;" <%=onLyKeys%>/>PX</td>
						</tr> --><tr>
							<th>연결주소</th>
							<td>
								<select name="linkType" class="input_select">
									<option value="">==선택==</option>
									<option value="S">기존창링크</option>
									<option value="B">새 창 링크</option>
								</select> <input type="text" name="linkUrl" class="input_text" style="width:180px;" />
							</td>
						</tr><!-- <tr>
							<th>팝업페이지</th>
							<td><label><input type="radio" name="isViewShop" class="vmiddle" value="F" checked="checked" />메인페이지</label> <label><input type="radio" name="isViewShop" class="vmiddle" value="T" />쇼핑몰메인페이지</label></td>
						</tr> -->

					</tbody>
					<tfoot>
						<tr>
							<td colspan="2" class="submit_area"><input type="image" src="<%=IMG_BTN%>/btn_popup.gif" style="width:142px;height:39px" /></td>
						</tr>
					</tfoot>
				</table>
			</form>
		</div>
		<div class="bottom">
			<div class="info"><%=viewImg(IMG_POP&"/pop_bottom_info.gif",160,60,"")%></div>
			<div class="btn_area"><%=aImgSt("javascript:self.close()",IMG_BTN&"/btn_close_01.gif",52,23,"","margin-top:20px;margin-right:20px;","")%></div>

		</div>
	</div>
</div>
<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
<%
'	<td>
'		<select name="popKind" class="input_select">
'			<option value="">=종류선택=</option>
'			<option value="P">일반팝업</option>
'			<option value="L">레이어팝업</option>
'		</select>
'	</td>
'	<td>
'		<label><input type="checkbox" name="isViewShop" class="input_chk" value="T" />쇼핑몰</label>
'		<label><input type="checkbox" name="isViewCom" class="input_chk" value="T" />커뮤니티</label>
'	</td>

%>
