<%
	Dim rtnCode, rtnMsg, rtnFDTid, rtnMxID, rtnMxIssueNO
	rtnCode = request("Code")
	rtnMsg = request("Msg")
	rtnFDTid = request("FDTid")
	rtnMxID = request("MxID")
	rtnMxIssueNO = request("MxIssueNO")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>
			FDK 결제 테스트 페이지
		</title>
		<meta http-equiv="content-type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=0,maximum-scale=10,user-scalable=yes">
		<meta name="HandheldFriendly" content="true">
		<meta name="format-detection" content="telephone=no">
		<style type="text/css">
			body { margin: 10px; font-size:12px;}
		</style>
		<script type="text/javascript" src="js/sha256.js"></script>
		<script type="text/javascript" src="js/jquery1.7.1.js"></script>
		<script type="text/javascript">

			var payflag = "C";									//C:클라이언트 결제(javascript 결제 처리), S:서버 결제(JSP 결제 처리)(Default)
			var keyData = "6aMoJujE34XnL9gvUqdKGMqs9GzYaNo6";	//가맹점 배포 PASSKEY 입력
		
			function result(rtncode, rtnmsg, fdtid, mxid, mxissueno){
				
				if(rtncode == "0000"){
					
					if(payflag == "C"){	//클라이언트 결제 시
					
						//HASH DATA 생성!!
						var fdhash = Sha256.hash(mxid + mxissueno + keyData).toUpperCase();

						//결제 요청!!
						$.ajax({
						 	type : "POST",
						    url : "https://testps.firstpay.co.kr/jsp/common/req.jsp",
						    data : {
						       "MxID" : mxid,
						       "MxIssueNO" : mxissueno,
						       "FDTid" : fdtid,
						       "FDHash" : fdhash,
						       "SpecVer" : "F100C000"
						    },
						    dataType : "jsonp",
						    jsonp : "callback",
						    success: function(data) {
						        if(data != null)    {
	
						            if(data.ReplyCode == "0000"){
	
										var msg = "[결제성공]\n"
												+ "서비스종류[" + data.PayMethod + "]\n"
												+ "가맹점ID[" + data.MxID + "]\n"
												+ "주문번호[" + data.MxIssueNO + "]\n"
												+ "주문시간[" + data.MxIssueDate + "]\n"
												+ "결제금액[" + data.Amount + "]\n"
												+ "거래모드[" + data.CcMode + "]\n"
												+ "응답코드[" + data.ReplyCode + "]\n"
												+ "응답메세지[" + data.ReplyMessage + "]\n"
												+ "승인번호[" + data.AuthNO + "]\n"
												+ "매입사코드[" + data.AcqCD + "]\n"
												+ "매입사명[" + data.AcqName + "]\n"
												+ "발급사코드[" + data.IssCD + "]\n"
												+ "발급사명[" + data.IssName + "]\n"
												+ "체크카드여부[" + data.CheckYn + "]\n"
												+ "카드번호[" + data.CcNO + "]\n"
												+ "가맹점번호[" + data.AcqNO + "]\n"
												+ "할부개월[" + data.Installment + "]\n"
												+ "잔여사용금액[" + data.CAP + "]\n"
												+ "가상계좌은행코드[" + data.BkCode + "]\n"
												+ "가상계좌번호[" + data.vactno + "]\n"
												+ "에스크로결제여부[" + data.EscrowYn + "]\n"
												+ "에스크로회원번호[" + data.EscrowCustNo + "]\n"
												+ "가상계좌은행명[" + data.BkName + "]";
	
										alert(msg);
	
										/*********************************
										* 결제 결과 DATA (가맹점 필요에 따라 아래 DATA 사용)
										* ※ 아래 변수에 대한 상세 내용은 첨부된 엑셀의 변수정의 문서를 참조 하세요.
	           					        * data.PayMethod	: 서비스종류
	           					     	* data.MxID			: 가맹점ID
	           					     	* data.MxIssueNO	: 주문번호
	           					     	* data.MxIssueDate	: 주문시간
	           					     	* data.Amount		: 결제금액
	           					     	* data.CcMode		: 거래모드
	           					     	* data.ReplyCode	: 응답코드(0000:결제성공, 그 외:결제실패)
	           					     	* data.ReplyMessage	: 응답메세지
	           					     	* data.AuthNO		: 승인번호(신용카드)
	           					     	* data.AcqCD		: 매입사코드(신용카드)
	           					     	* data.AcqName		: 매입사명(신용카드)
	           					     	* data.IssCD		: 발급사코드(신용카드)
	           					     	* data.IssName		: 발급사명(신용카드)
	           					     	* data.CheckYn		: 체크카드여부(신용카드)
	           					     	* data.CcNO			: 카드번호(신용카드)
	           					     	* data.AcqNO		: 가맹점번호(신용카드)
	           					     	* data.Installment	: 할부개월(신용카드)
	           					     	* data.CAP			: 잔여사용금액(휴대폰)
	           					     	* data.BkCode		: 가상계좌은행코드(가상계좌)
	           					     	* data.vactno		: 가상계좌번호(가상계좌)
	           					     	* data.EscrowYn		: 에스크로결제여부(계좌,가상)
	           					     	* data.EscrowCustNo	: 에스크로회원번호(계좌,가상)
	           					     	* data.BkName		: 가상계좌은행명(가상계좌)
										*********************************/
										
						            }else{
										alert("결제 실패[실패 사유:["+data.ReplyCode+"]" + data.ReplyMessage + "]");
						            }
	
						        }else{
							        alert("거래 전송 후 응답 없음(관리자 확인 요망)");
						        }
						    },
						    error: function(data) {
						    	if(data != null)    {
						            alert(data.result);
						        }else{
							        alert("거래 전송 실패(관리자 확인 요망)");
						        }
						    }
						});
					
					}else{				//서버 결제 시
						
						document.pay.MxID.value = mxid;
						document.pay.MxIssueNO.value = mxissueno;
						document.pay.FDTid.value = fdtid;

						document.pay.action = "send.asp";
						document.pay.submit();
					}
					
				}else{
					alert("인증실패["+rtncode+"("+rtnmsg+")]");
				}
			}
		</script>
	</head>
	<body onload="result('<%=rtnCode%>','<%=rtnMsg%>','<%=rtnFDTid%>','<%=rtnMxID%>','<%=rtnMxIssueNO%>');">
		<form name="pay" id="pay" method="post">
			<input type="hidden" name="MxID" value="" />
			<input type="hidden" name="MxIssueNO" value="" />
			<input type="hidden" name="FDTid" value="" />
		</form>
		결제 처리중 입니다...</br></br>
		인증 또는 결제에 실패하신 경우</br>다시 시도 하시려면 아래 링크를 클릭 하세요.</br></br>
		<a href="mstart.html"><b><u><font color="blue">다시하기</font></u></b></a>
	</body>
</html>