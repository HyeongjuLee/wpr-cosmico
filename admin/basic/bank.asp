<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "CONFIG"
	INFO_MODE = "CONFIG3-3"

%>
</head>
<body>
<script type="text/javascript">
<!--
function delok(idx){
	var f = document.frm_update;
	if (confirm("등록된 계좌를 삭제하시겠습니까? \n\n\삭제된 배송업체는 복구가 불가능하며, 새로 입력 하셔야합니다.")) {
		f.intIDX.value = idx;
		f.iMode.value = 'D';
		if (f.intIDX.value =='')
		{
			alert("삭제할 계좌의 고유값이 없습니다.");
			return false;
		}
		f.submit();
	}
	
}

function insertChk(f) {
	if(chkEmpty(f.bankNumber)) {
		alert("계좌번호를 입력해주세요.");
		f.bankNumber.focus();
		return false;
	}

	if(chkEmpty(f.bankOwner)) {
		alert("예금주를 입력해주세요.");
		f.bankOwner.focus();
		return false;
	}
	
}
//-->
</script>
<link rel="stylesheet" href="/admin/css/base.css" />
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="bank">
	<p>무통장 계좌 추가</p>
	<form name="frm_insert" method="post" action="bank_insert.asp" onsubmit="return insertChk(this);">
	<input type="hidden" name="iMode" value="I" />
	<table <%=tableatt%> class="input">
		<colgroup>
			<col width="200" />
			<col width="800" />
		</colgroup>
		<tr>
			<th>은행선택</th>
			<td>
				<select name="bankName">
					<option value="">은행을 선택해주세요</option>			
					<%
						SQL = "SELECT * FROM [DK_BANK_CODE] ORDER BY BANKNAME ASC"
						arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,Nothing)
						If IsArray(arrList) Then
							For i = 0 To listLen
								PRINT tabs(5)&"<option value="""&arrList(2,i)&""">"&arrList(2,i)&"</option>"
							Next
						End If
					%>
				</select>
			</td>
		</tr><tr>
			<th>계좌번호</th>
			<td><input type="text" name="bankNumber" class="input_text" style="width:300px" /></td>
		</tr><tr>
			<th>예금주</th>
			<td><input type="text" name="bankOwner" class="input_text" style="width:300px" /></td>
		</tr><tr>
			<td colspan="2" class="tcenter" ><input type="submit" value="계좌 추가" class="submit" /></td>
		</tr>
	</table>
	</form>
	<p>현재 등록된 무통장 계좌</p>
	<form name="frm_update" method="post" action="bank_insert.asp">
		<input type="hidden" name="iMode" value="" />
		<input type="hidden" name="intIDX" value="" />
	</form>
	<table <%=tableatt%> class="list">
		<colgroup>
			<col width="50" />
			<col width="200" />
			<col width="200" />
			<col width="200" />
			<col width="*" />
		</colgroup>
		<thead>
			<tr>
				<th>No</th>
				<th>은행명</th>
				<th>계좌번호</th>
				<th>예금주</th>
				<th>기능</th>
			</tr>
		</thead>
		<tbody>
		<%
			SQL = "SELECT * FROM [DK_BANK] ORDER BY [intIDX] ASC"
			arrList = Db.execRsList(SQL,DB_TEXT,Nothing,listLen,Nothing)
			If IsArray(arrList) Then
				For i = 0 To listLen
					PRINT tabs(1)&"<tr>"
					PRINT tabs(2)&"<td>"&arrList(0,i)&"</td>"
					PRINT tabs(2)&"<td>"&arrList(1,i)&"</td>"
					PRINT tabs(2)&"<td>"&arrList(2,i)&"</td>"
					PRINT tabs(2)&"<td>"&arrList(3,i)&"</td>"
					PRINT tabs(2)&"<td><img src="""&IMG_BTN&"/btn_del.gif"" width=""34"" height=""17"" alt=""현재행삭제"" style=""margin-left:5px;"" class=""cp vmiddle"" onclick=""delok('"&arrList(0,i)&"')"" /></td>"
					PRINT tabs(1)&"</tr>"

				Next
			Else
				PRINT tabs(1)&"<tr>"
				PRINT tabs(2)&"<td colspan=""5"" style=""padding:60px 0px;text-align:center;"">등록된 계좌번호가 없습니다.</td>"
				PRINT tabs(1)&"</tr>"

			End If
		%>
		</tbody>
	</table>
</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
