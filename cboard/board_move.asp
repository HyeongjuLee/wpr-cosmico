<!--#include virtual = "/_lib/strFunc.asp"-->
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual="/admin/_inc/adminPath.asp" -->
<%End If%>
<%

	If DK_MEMBER_TYPE <> "ADMIN" And DK_MEMBER_TYPE <> "OPERATOR" Then
		Call ALERTS("관리자 혹은 오퍼레이터만 사용가능한 기능입니다.","CLOSE","")
	End If
	moveIDX = Trim(pRequestTF("mchk",True))
	bnames =  Trim(pRequestTF("bnames",True))
	popWidth = 430
	popHeight = 350

	moveIDXs = Split(moveIDX,",")
	moveIDXc = UBound(moveIDXs) + 1

	Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")

		moveIDXencoe		= Trim(StrCipher.Encrypt(moveIDX,EncTypeKey1,EncTypeKey2))		'아이디

		'DK_MEMBER_ID = StrCipher.Decrypt(Request.Cookies("ilovekt")("id"),EncTypeKey1,EncTypeKey2) 		'아이디
	Set StrCipher = Nothing



%>
<%IF CONST_MOBILE_ONLY = "T" Then%>
<!--#include virtual = "/admin/_inc/document.asp"-->
<%Else%>
<!--#include virtual = "/_include/document.asp"-->
<%End If%>
<script type="text/javascript">
<!--

//-->
</script>
<style type="text/css">
	#pop_tops {clear:both; float:left;width:430px; height:40px; border-bottom:1px solid #777777; background:url(/images/pop/tit_line_bg.gif) right bottom no-repeat; overflow:hidden;}
	#pop_content {clear:both; float:left; width:430px; line-height:160%;}
	#pop_bottom {clear:both; float:left;width:430px; height:30px;text-align:right;margin-top:13px;}
	.line1 {height:1px; background-color:#dedede;}
	.line2 {height:2px; background-color:#f4f4f4;}
</style>
</head>
<body>
<div id="pop_tops"><img src="<%=IMG_POP%>/tit_board_move.gif" width="250" height="40" alt="게시물 이동" /></div>
<div id="pop_content">
	<form name="moveFrm" action="board_move_handler.asp" method="post">
		<input type="hidden" name="mchk" value="<%=moveIDXencoe%>" />
		<input type="hidden" name="bnames" value="<%=bnames%>" />
		<p class="tcenter" style="margin-top:10px;">선택하신 게시물의 번호는</p>
		<p class="tcenter"><strong><%=moveIDX%></strong></p>
		<p class="tcenter">총 <strong><%=moveIDXc%></strong> 개 입니다.</p>
		<div class="line1" style="margin-top:20px;"></div>
		<p class="tcenter" style="color:red;margin-top:20px;">이동 혹은 복사시에는 답글까지 모두 복사/이동 됩니다.</p>

		<p class="tcenter tweight" style="margin-top:7px;">해당 게시물을
			<select name="slocations">
			<%
				arrList = Db.execRsList("DKC_ACADEMY_LIST_T",DB_PROC,Nothing,listLen,Nothing)
				If IsArray(arrList) Then
					For i = 0 To listLen
						PRINT TABS(4)& "	<option value="""&arrList(0,i)&""">"&arrList(1,i)&"</option>"
					Next
				End If
			%>
		</select> 로 <select name="mode2"><option value="xmove">이동</option><option value="xcopy">복사</option></select> 합니다.</p>
		<p class="tcenter" style="margin-top:7px;"><input type="image" src="<%=IMG_BTN%>/btn_apply.gif" /></p>
	</form>
	<div class="line1" style="margin-top:20px;"></div>
	<p class="tcenter" style="margin-top:10px;">
	<form name="delFrm" action="board_delete_multi.asp" method="post">
		<input type="hidden" name="mchk" value="<%=moveIDXencoe%>" />
		<input type="hidden" name="bnames" value="<%=bnames%>" />
		<input type="image" src="./images/btn_delete.gif" />
	</form>
	</p>
</div>
<div id="pop_bottom">
	<div class="line1"></div>
	<div class="line2"></div>
	<img src="<%=IMG_POP%>/btn_close01.gif" width="52" height="23" alt="창 닫기" style="margin-top:4px;cursor:pointer;" onclick="self.close();" />
</div>

<script type="text/javascript">
<!--
resizePopupWindow(parseInt("<%=popWidth%>", 10), parseInt("<%=popHeight%>", 10));
//-->
</script>
</body>
</html>
