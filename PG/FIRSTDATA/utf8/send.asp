<!-- #include file="sha256.asp" -->
<!-- #include file="json2.asp" -->
<%

	Dim keyData, EncodeType, fdkSendUrl, hashValue, reqData, resData, fdtid, mxid, mxissueno, amount, pids

	keyData = "6aMoJujE34XnL9gvUqdKGMqs9GzYaNo6"											'가맹점 배포 PASSKEY 입력
	EncodeType = "U"																									'인코딩 TYPE 입력(U:utf-8, E:euc-kr)
	fdkSendUrl = "http://testps.firstpay.co.kr/jsp/common/req.jsp"	  'FDK 요청 URL
'	fdkSendUrl = "https://testps.firstpay.co.kr/jsp/common/req.jsp"		'FDK 요청 URL

	fdtid = request("FDTid")
	mxid = request("MxID")
	mxissueno = request("MxIssueNO")
	amount = request("Amount")
	pids = request("PIDS")

	'*****
	'* ■ Hash DATA 생성 처리
	'* FDTid 값이 있는 경우  MxID + MxIssueNO + keyData로 HashData 생성 처리
	'* FDTid 값이 없는 경우
	'*   1. PIDS(현금영수증 신분확인번호) 값이 있는 경우
	'*     MxID + MxIssueNO + Amount + PIDS + keyData로 HashData 생성 처리
	'*   2. PIDS(현금영수증 신분확인번호) 값이 없는 경우
	'*     MxID + MxIssueNO + Amount + keyData로 HashData 생성 처리
	'***********************************
	IF IsEmpty(fdtid) OR IsNull(fdtid) Then
		IF IsEmpty(pids) OR IsNull(pids) Then
			hashValue = UCase(sha256(mxid & mxissueno & amount & keyData))
		Else
			hashValue = UCase(sha256(mxid & mxissueno & amount & pids & keyData))
		End If
	Else
		hashValue = UCase(sha256(mxid & mxissueno & keyData))
	End If

	'*****
	'* ■ FDK 전송 DATA 생성 처리
	'***********************************
	Dim item, j

	For Each item in Request.Form
		for j=1 to Request.Form(item).count
			reqData = reqData & item & "=" & Request.Form(item)(j) & "&"
		Next
	Next

	'* hashData 추가
	reqData = reqData & "FDHash=" & hashValue & "&"

	'*EncodeType 추가
	reqData = reqData & "EncodeType=" & EncodeType & "&"

	'*SpecVer 추가
	reqData = reqData & "SpecVer=F100C000"

	'*****
	'* ■ 지불 요청 송/수신 처리
	'***********************************
	Dim xmlHttp, dataStream

	'* http 통신 시
  Set xmlHttp = CreateObject("Msxml2.XMLHTTP")

	xmlHttp.Open "POST", fdkSendUrl, False
	xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded; charset=euc_kr"
	xmlHttp.Send reqData

	'* https 통신 시
	'Set xmlHttp = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
	'xmlHttp.SetClientCertificate("LOCAL_MACHINE\My\MyCertificate")
	'xmlHttp.open "POST", fdkSendUrl, FALSE
	'xmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
	'xmlHttp.send reqData


	resData = Cstr( xmlHttp.responseText )

	Set xmlHttp = nothing

	'*****
	'* ■ 결과 데이터 처리
	'***********************************
	Dim fdkResult
	resData = UrlDecode_GBToUtf8(resData)

	Set fdkResult = JSON.parse(resData)

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>
			FDK 결제 테스트 페이지
		</title>
		<meta http-equiv="content-type" content="text/html; charset=utf-8">
		<style type="text/css">
			body { margin: 0; padding: 15px; }
		</style>
	</head>
	<body>
		* 서비스종류 : <%=fdkResult.PayMethod%></br>
		* 가맹점 ID : <%=fdkResult.MxID%></br>
 		* 주문번호 : <%=fdkResult.MxIssueNO%></br>
 		* 주문시간 : <%=fdkResult.MxIssueDate%></br>
 		* 결제금액 : <%=fdkResult.Amount%></br>
 		* 거래모드 : <%=fdkResult.CcMode%></br>
 		<font color="red"><b>* 응답코드 : <%=fdkResult.ReplyCode%></b></font></br>
 		<font color="red"><b>* 응답메세지 : <%=fdkResult.ReplyMessage%></b></font></br>
 		* 승인번호 : <%=fdkResult.AuthNO%></br>
 		* 매입사코드 : <%=fdkResult.AcqCD%></br>
 		* 매입사명 : <%=fdkResult.AcqName%></br>
 		* 발급사코드 : <%=fdkResult.IssCD%></br>
 		* 발급사명 : <%=fdkResult.IssName%></br>
 		* 체크카드여부 : <%=fdkResult.CheckYn%></br>
 		* 카드번호 : <%=fdkResult.CcNO%></br>
 		* 가맹점번호 : <%=fdkResult.AcqNO%></br>
 		* 할부개월 : <%=fdkResult.Installment%></br>
 		* 잔여사용가능금액 : <%=fdkResult.CAP%></br>
 		* 가상계좌은행코드 : <%=fdkResult.BkCode%></br>
 		* 가상계좌번호 : <%=fdkResult.vactno%></br>
 		* 에스크로결제여부 : <%=fdkResult.EscrowYn%></br>
 		* 에스크로회원번호 : <%=fdkResult.EscrowCustNo%></br>
 		* 가상계좌은행명 : <%=fdkResult.BkName%></br>
	</body>
</html>
<%
'Encoding된 파라미터를 DecoDing 해준다.
Function UrlDecode_GBToUtf8(ByVal str)
    Dim B,ub
    Dim UtfB
    Dim UtfB1, UtfB2, UtfB3
    Dim i, n, s
    n=0
    ub=0
    For i = 1 To Len(str)
        B=Mid(str, i, 1)
        Select Case B
            Case "+"
                s=s & " "
            Case "%"
                ub=Mid(str, i + 1, 2)
                UtfB = CInt("&H" & ub)
                If UtfB<128 Then
                    i=i+2
                    s=s & ChrW(UtfB)
                Else
                    UtfB1=(UtfB And &H0F) * &H1000
                    UtfB2=(CInt("&H" & Mid(str, i + 4, 2)) And &H3F) * &H40
                    UtfB3=CInt("&H" & Mid(str, i + 7, 2)) And &H3F
                    s=s & ChrW(UtfB1 Or UtfB2 Or UtfB3)
                    i=i+8
                End If
            Case Else
                s=s & B
        End Select
    Next
    UrlDecode_GBToUtf8 = s
End Function
%>