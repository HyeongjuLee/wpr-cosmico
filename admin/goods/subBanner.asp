<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "GOODS"
	INFO_MODE = "GOODS3-1"





%>
<link rel="stylesheet" href="/admin/css/design.css" />
<script type="text/javascript">
<!--
	function chkFrm(f)
	{
		if (f.strTitle.value=="")
		{
			alert("타이틀을 입력해주세요");
			f.strTitle.focus();
			return false;
		}
		if (f.strfile.value=="")
		{
			alert("파일을 선택해주세요");
			f.strfile.focus();
			return false;
		}



	}
	function delOk(idx) {
		var f = document.frm_mode;
		if (confirm("삭제하시겠습니까? 삭제 후 복구할 수 없습니다.")) {
			f.intIDX.value = idx;
			f.mode.value = 'DELETE';
			if (f.intIDX.value =='')
			{
				alert("변경할 사용상태값의 고유값이 없습니다.");
				return false;
			}
			f.submit();
		}
	}
//-->
</script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="indexMap">
	<p class="titles">이미지 새로 등록</p>
	<div class="insert">
		<form name="ifrm" action="subBannerHandler.asp" method="post" enctype="multipart/form-data" onsubmit="return chkFrm(this)">
			<input type="hidden" name="mode" value="INSERT" />
			<table <%=tableatt%> class="adminFullTable">
				<colgroup>
					<col width="180" />
					<col width="400" />
					<col width="*" />
				</colgroup>
				<tr>
					<th>간략정보</th>
					<td><input type="text" class="input_text" name="strTitle" style="width:350px;" /></td>
					<td>JPG,GIF등의 이미지 파일만 가능(가로 사이즈는 970px 입니다)</td>
				</tr><tr>
					<th>이미지 선택</th>
					<td><input type="file" class="input_file" name="strfile" style="width:350px;" /></td>
					<td>JPG,GIF등의 이미지 파일만 가능(가로 사이즈는 970px 입니다)</td>
				</tr><tr>
					<th>이미지 크기 (50% 사이즈)</th>
					<td>가로 970px 사이즈에 최적화 되어있습니다.</td>
					<td>970px 가 넘어가는 이미지는 가로 기준으로 재작성됩니다.</td>
				</tr><tr>
					<td colspan="3" style="padding:0px;" class="tcenter"><input type="image" src="<%=IMG_BTN%>/btn_submit_gray.gif" /></td>
				</tr>
			</table>
		</form>
	</div>
	<p class="titles">등록된 이미지</p>
	<div class="list">
		<%


			arrList = Db.execRsList("DKPA_DETAIL_BANNER_LIST",DB_PROC,Nothing,listLen,Nothing)

		%>
		<table <%=tableatt%> class="adminFullTable">
			<colgroup>
				<col width="110" />
				<col width="110" />
				<col width="" />
				<col width="60" />
			</colgroup>
			<thead>
				<tr>
					<th>고유번호</th>
					<th>이미지타이틀</th>
					<th>이미지정보</th>
					<th>삭제</th>
				</tr>
			</thead>
			<tbody>
				<%
					If IsArray(arrList) Then
						For i = 0 To listLen
							imgWidth = 0
							imgHeight = 0
							Call imgInfo(VIR_PATH("DetailBanner")&"/"&arrList(2,i),imgWidth,imgHeight,"")
							imgWidth = imgWidth / 2
							imgHeight = imgHeight / 2
							PRINT TABS(3)&"	<tr>" &VbCrlf
							PRINT TABS(3)&"		<td>"&arrList(0,i)&"</td>" &VbCrlf
							PRINT TABS(3)&"		<td>"&arrList(1,i)&"</td>" &VbCrlf
							PRINT TABS(3)&"		<td>"&viewImg(VIR_PATH("DetailBanner")&"/"&arrList(2,i),imgWidth,imgHeight,"")&"</td>" &VbCrlf
							PRINT TABS(3)&"		<td>"&viewImgJs(IMG_BTN&"/btn_gray_delete.gif",45,22,"","onclick=""delOk('"&arrList(0,i)&"')""")&"</td>" &VbCrlf
							PRINT TABS(3)&"	</tr>" &VbCrlf
						Next
					Else
						PRINT TABS(3)&"	<tr>" &VbCrlf
						PRINT TABS(3)&"		<td colspan=""3"" style=""height:80px;"" class=""tcenter"">등록된 이미지가 없습니다.</td>" &VbCrlf
						PRINT TABS(3)&"	</tr>" &VbCrlf
					End If
				%>
			</tbody>
		</table>
	</div>
	<form name="frm_mode" action="subBannerHandler.asp" method="post" enctype="multipart/form-data" >
		<input type="hidden" name="intIDX" value="" />
		<input type="hidden" name="mode" value="" />
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
