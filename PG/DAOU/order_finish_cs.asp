<!--#include virtual="/_lib/strFunc.asp" -->
<%
	orderIDX = request("orderIDX")		'마오 웹주문번호

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>


<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Imagetoolbar" content="no" />

<meta name="keywords" content="<%=strShopKeyword%>" />
<meta name="description" content="<%=strShopDescription%>" />

<script type="text/javascript">
//	opener.document.location.href = 'https://<%=houUrl%>/MyOffice/buy/order_list_macco.asp';
	opener.document.location.href = 'https://<%=houUrl%>/MyOffice/buy/order_finish.asp?orderNum=<%=orderIDX%>';
	self.close();
</script>
</head>
<body>


<body>
</html>