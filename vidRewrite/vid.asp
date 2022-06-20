<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	'URL 재작성 설정 확인!
	'<rule name="viral member join">
	'		<match url="^vid/([0-9a-z]+)" />
	'		<action type="Rewrite" url="/vidRewrite/vid.asp?vid={R:1}" />
	'</rule>

	ORIGINAL_URL = Request.ServerVariables("HTTP_X_ORIGINAL_URL")

	'/v/Q6ytCvWO61 → /vidRewrite/vid.asp?vid=Q6ytCvWO61

	'확장자의 '.' 없는 형태만 OK
	If InStr(ORIGINAL_URL,".") > 0 Then
		Response.Status = "404 page not found"
		Response.End
	End If

	'▣바이럴 id decodeBase62(string to string) 복호화
	vid = gRequestTF("vid",False)
%>
<script type="text/javascript" src="/jscript/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/jscript/jquery.base62.js"></script><%'js 추가!%>
<script type="text/javascript">
  $(document).ready(function(){
    let vidBase62Dec = '';
    try {
      vidBase62Dec = $d.decodeBase62('<%=vid%>');
    }catch{
      vidBase62Dec = '';
    }
    //console.log(vidBase62Dec);
    $("#vid").val(vidBase62Dec);
  });
</script>
<body onload="document.frm.submit();">
<form name="frm" method="post" action="/vidRedirect/vidRedirect.asp">
  <input type="hidden" name="vid" id="vid" value="" readonly="readonly">
  <input type="hidden" name="vidOri"  value="<%=vid%>" readonly="readonly">
</form>
