<!--#include virtual="/_lib/strFunc.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
	<title>EDUKIN ACADEMY</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi" />
	<link href="/css/common.css" rel="stylesheet" type="text/css" />
    <link href="/css/campus.css" rel="stylesheet" type="text/css" />
	<link href="board.css" rel="stylesheet" type="text/css" />

	<script src="/js/js.js" type="text/javascript"></script>
	<script type="text/javascript" src="board.js"></script>

</head>
<body>
<!--#include virtual="/_inc/top_btn.asp"-->
<%
	' 게시판 변수 받아오기(설정)
	strBoardName = gRequestTF("bname",True)
	'LOCATIONS = gRequestTF("dom",True)
	LOCTYPE = gRequestTF("ty",True)
	intIDX = gRequestTF("num",True)


	SQL = "SELECT [strSubject] FROM [DK_NBOARD_CONTENT] WHERE [intIDX] = ?"
	arrParams = Array(_
		Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	THIS_BBS_SUBJECT = Db.execRsData(SQL,DB_TEXT,arrParams,Nothing)








%>
<!--#include file="board_config.asp"-->

<div id="wrapper">
	<div id="sub_header"><img src="/img/main_top.jpg" alt="EDUKIN ACADEMY" width="100%" /></div>
    <div id="container">
    	<dl><dt>에듀킨아카데미 질문과 답변</dt></dl>
    </div>
	<div id="board" class="secret">
		<div class="innerContent">
			<p class="subjects">제목 : <%=BACKWORD(THIS_BBS_SUBJECT)%></p>
			<p class="comments">선택하신 게시물은 비밀글로 작성되었습니다.작성시 입력한 비밀번호를 입력해주세요. 답글의 경우 질문글과 비밀번호가 같습니다.</p>
			<form name="sfrm" action="board_secret.asp" method="post" onsubmit="return secretSubmit()" >
				<input type="hidden" name="bname" value="<%=strBoardName%>" />
				<input type="hidden" name="ty" value="<%=LOCTYPE%>" />
				<input type="hidden" name="idx" value="<%=intIDX%>" />
				<table <%=tableatt%> style="width:100%; margin-top:15px;">
					<col width="30%" />
					<col width="70%" />
					<tr>
						<th>비밀번호입력</th>
						<td><input type="password" name="strPass" value="" class="input_text" style="width:90%;" /></td>
					</tr><tr>
						<td colspan="2" class="tcenter btn_area"><input type="submit" value="확인" style="padding:10px 20px;" /></td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</div>


<!--#include virtual="/_inc/menuWrapper_hair2.asp"-->
<!--#include virtual="/_inc/menuWrapper_hair.asp"-->
<!--#include virtual="/_inc/footer.asp"-->
</body>
</html>