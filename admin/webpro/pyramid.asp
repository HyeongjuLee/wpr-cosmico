<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "WEBPRO"
	INFO_MODE = "WEBPRO1-1"






	intCate = gRequestTF("cate",True)
	arrParams = Array(_
		Db.makeParam("@intCate",adInteger,adParamInput,4,intCate) _
	)
	arrList = Db.execRsList("DKP_PYRAMID_LIST_FOR_ADMIN",DB_PROC,arrParams,listLen,Nothing)





%>
<script type="text/javascript">
	function delOk(values) {

		var f = document.mfrm;

		var msg = "삭제하시겠습니까?\n\n삭제 후 복구는 불가능합니다.";
		if(confirm(msg)){
			f.intIDX.value = values;
			f.MODE.value = "DELETE";
			f.submit();
		}else{
			return;
		}
	}
	function Sorts(values,modes) {

		var f = document.mfrm;

		var msg = "정렬값을 변경 하시겠습니까?";
		if(confirm(msg)){
			f.intIDX.value = values;
			f.MODE.value = modes;
			f.submit();
		}else{
			return;
		}
	}
</script>
<link rel="stylesheet" type="text/css" href="pyramid.css" />
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div class="list">
	<table <%=tableatt%> class="width100">
		<col width="60" />
		<col width="70" />
		<col width="90" />
		<col width="350" />
		<col width="" />
		<col width="100" />
		<tr>
			<th>정렬값</th>
			<th>정렬수정</th>
			<th>장,조,항</th>
			<th>제목</th>
			<th>내용</th>
			<th>기능</th>
		<tr>
		<%
			If IsArray(arrList) Then
				set tagfree = New Regexp
				tagfree.Pattern= "<[^>]+>"
				tagfree.Global=true
				For i = 0 To listLen
					arrList_intIDX				= arrList(0,i)
					arrList_intSort				= arrList(1,i)
					arrList_intCate				= arrList(2,i)
					arrList_strAticle			= arrList(3,i)
					arrList_strSubject			= arrList(4,i)
					arrList_strContent			= arrList(5,i)


					arrList_strContent = tagfree.Replace(arrList_strContent,"")


		%>
			<tr>
				<td class="tcenter"><%=arrList_intSort%></td>
				<td class="tcenter">
				<%
					RESPONSE.WRITE "<span>"&viewImgStJS(IMG_BTN&"/cate_up.gif",16,16,"","","bor1 vmiddle cp","onclick=""Sorts('"&arrList_intIDX&"','SORTUP')""")&"</span>"
					RESPONSE.WRITE "<span>"&viewImgStJS(IMG_BTN&"/cate_down.gif",16,16,"","margin-left:3px;","bor1 vmiddle cp","onclick=""Sorts('"&arrList_intIDX&"','SORTDOWN')""")&"</span>"
				%>
				</td>
				<td class="tcenter"><%=arrList_strAticle%></td>
				<td class="content"><%=arrList_strSubject%></td>
				<td class="content"><%=cutString(backword_Area(arrList_strContent),18)%></td>
				<td class="tcenter">
					<div class="btnArea"><input type="button" class="a_submit design1" value="수정" onclick="location.href='pyramid_modify.asp?view=<%=arrList_intIDX%>'" /></div>
					<div class="btnArea"><input type="button" class="a_submit design4" value="삭제" onclick="delOk('<%=arrList_intIDX%>')" /></div>
				</td>
			</tr>
		<%
				Next
			End If
		%>
	</table>

	<form name="mfrm" method="post" action="pyramid_handler.asp" onsubmit="return chkGFrm(this);">
		<input type="hidden" name="intIDX" value="" />
		<input type="hidden" name="intCate" value="<%=intCate%>" />
		<input type="hidden" name="MODE" value="" />
	</form>
</div>
<!--#include virtual = "/admin/_inc/copyright.asp"-->
