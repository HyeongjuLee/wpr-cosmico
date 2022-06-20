<%
	'kspay로부터 결과값을 받아 상점의 결과페이지로 넘기는 페이지
	'화면에서는 보이지 않는 페이지입니다. 변경 및 삭제를 금합니다.

	dim rcid      : rcid	  = Request.Form("reCommConId")
	dim rctype    : rctype	  = Request.Form("reCommType")
	dim rhash     : rhash	  = Request.Form("reHash")
	dim rcncntype : rcncntype = Request.Form("reCnclType")

	' https로 페이지를 연동하는 가맹점에서 보안경고를 막는다.
	dim p_protocol : p_protocol = Request.ServerVariables("SERVER_PROTOCOL"	)

	If Len(p_protocol) > 5 Then
		If Mid(p_protocol,1,5) = "HTTPS" Then
			p_protocol = "https"
		Else
			p_protocol = "http"
		End If
	Else
		p_protocol = "http"
	End If
%>
<html>
<head>
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>KSPay(<%=rcid%>)</title>
<script language="JavaScript">
	function init()
	{
		if("<%=rcncntype%>" == "1")
		{
			if(opener == null)
			{
				parent.mcancel();
				return;
			}else{
				opener.mcancel();
				setTimeout("self.close()",2000);
				return;
			}
		}
		if(opener == null)
		{
			parent.eparamSet("<%=rcid%>","<%=rctype%>","<%=rhash%>");
			parent.goResult();
		}else
		{
			opener.eparamSet("<%=rcid%>","<%=rctype%>","<%=rhash%>");
			opener.goResult();
			setTimeout("self.close()",2000);
		}
  }
  init();
</script>
</head>
<body>
 	<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
     <tr>
        <td valign="middle" align="center"><table width="280" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><img src="./imgs/progress_resouce.jpg" width="280" height="201"></td>
          </tr>
        </table>
		</td>
      </tr>
  </table>
</body>
</html>