<%
	Dim rtnCode, rtnMsg, rtnFDTid
	rtnCode = request("Code")
	rtnMsg = request("Msg")
	rtnFDTid = request("FDTid")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>
			FDK 결제 테스트 페이지
		</title>
		<meta http-equiv="content-type" content="text/html; charset=utf-8">
		<style type="text/css">
			body { margin: 0 }
		</style>
		<script type="text/javascript">
			function payProc(rtncode, rtnmsg, fdtid){

				if(rtncode != ""){
					
					parent.msgtran(rtncode, rtnmsg, fdtid);
					
				}else{

					try{ document.fdcall.PAYDATA.value = parent.document.fdpop.PAYDATA.value; }catch (e) { document.fdcall.PAYDATA.value = ""; } 
					
					var frm = document.fdcall;
	
					frm.acceptCharset = 'euc-kr';

					try{
						document.charset = 'euc-kr';
					}catch (e){
						var strUserAgent = navigator.userAgent.toLowerCase();
						
						if(strUserAgent.indexOf("windows nt 10") > -1){	//Windows 10
							if(strUserAgent.indexOf("trident/7.0") > -1){	//IE 11
								frm.PAYDATA.value = "ENCODE" + encodeURIComponent(frm.PAYDATA.value);
							}
						}
					}
	
					frm.action = "https://testpg.firstpay.co.kr/jsp/main.jsp";
					frm.submit();
				}
			}
		</script>
	</head>
	<body onload="payProc('<%=rtnCode%>','<%=rtnMsg%>','<%=rtnFDTid%>');">
		<form name="fdcall" id="fdcall" accept-charset="euc-kr" method="post">
			<input type="hidden" name="PAYDATA" value="" />
		</form>
	</body>
</html>


