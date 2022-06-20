<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/PG/FIRSTDATA/sha256.asp"-->
<!--#include virtual = "/PG/FIRSTDATA/json2.asp"-->
<%

	Dim keyData, EncodeType, fdkSendUrl, hashValue, reqData, resData, fdtid, mxid, mxissueno, amount, pids

	keyData = "6aMoJujE34XnL9gvUqdKGMqs9GzYaNo6"											'가맹점 배포 PASSKEY 입력
	EncodeType = "U"																									'인코딩 TYPE 입력(U:utf-8, E:euc-kr)
''	fdkSendUrl = "http://ps.firstpay.co.kr/jsp/common/req.jsp"			'FDK 요청 URL(REAL)
	fdkSendUrl = "http://testps.firstpay.co.kr/jsp/common/req.jsp"		'FDK 요청 URL(TEST)
'	fdkSendUrl = "https://testps.firstpay.co.kr/jsp/common/req.jsp"		'FDK 요청 URL

	fdtid		= pRequestTF("FDTid",True)
	mxid		= pRequestTF("MxID",True)				'가맹점 ID
	mxissueno	= pRequestTF("MxIssueNO",True)			'주문번호 : 가맹점 사용 주문번호
	amount		= pRequestTF("Amount",True)				'결제금액
	pids		= pRequestTF("PIDS",False)

	Call ResRw(fdtid,"fdtid")
	Call ResRw(mxid,"mxid")
	Call ResRw(mxissueno,"mxissueno")
	Call ResRw(amount,"amount")
	'Call ResRw(PIDS,"PIDS")


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

''	For Each item in Request.Form
''		for j=1 to Request.Form(item).count
''			reqData = reqData & item & "=" & Request.Form(item)(j) & "&"
''		Next
''	Next
	reqData = reqData &"MxID="&mxid&"&MxIssueNO="&mxissueno&"&FDTid="&fdtid&"&"		'▣수정/추가

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
<%
	'Webpro~
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	' <결제 결과 필드> 변수치환
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	PayMethod		= fdkResult.PayMethod		'서비스종류			'CC	신용카드, IC 계좌이체, MO 핸드폰결제, VA 가상계좌, CA 현금영수증, KF 현금IC결제, PT 포인트결제
	MxID			= fdkResult.MxID			'가맹점 ID
	MxIssueNO		= fdkResult.MxIssueNO		'주문번호
	MxIssueDate		= fdkResult.MxIssueDate		'주문시간
	Amount			= fdkResult.Amount			'결제금액
	CcMode			= fdkResult.CcMode			'거래모드
	ReplyCode		= fdkResult.ReplyCode		'응답코드
	ReplyMessage	= fdkResult.ReplyMessage	'응답메세지
	AuthNO			= fdkResult.AuthNO			'승인번호
	AcqCD			= fdkResult.AcqCD			'매입사코드
	AcqName			= fdkResult.AcqName			'매입사명
	IssCD			= fdkResult.IssCD			'발급사코드
	IssName			= fdkResult.IssName			'발급사명
	CheckYn			= fdkResult.CheckYn			'체크카드여부
	CcNO			= fdkResult.CcNO			'카드번호
	AcqNO			= fdkResult.AcqNO			'가맹점번호
	Installment		= fdkResult.Installment		'할부개월
	CAP				= fdkResult.CAP				'잔여사용가능금액
	BkCode			= fdkResult.BkCode			'가상계좌은행코드
	vactno			= fdkResult.vactno			'가상계좌번호
	EscrowYn		= fdkResult.EscrowYn		'에스크로결제여부
	EscrowCustNo	= fdkResult.EscrowCustNo	'에스크로회원번호
	BkName			= fdkResult.BkName			'가상계좌은행명



'PG 설정
	Dim PGID				: PGID			= mxid

'공통 필드
	Dim paykind				: paykind			= pRequestTF("paykind",True)
	Dim orderNum			: orderNum			= pRequestTF("OrdNo",True)
	Dim inUidx				: inUidx			= pRequestTF("cuidx",True)
	Dim gopaymethod			: gopaymethod		= pRequestTF("gopaymethod",True)

	Dim orderMode			: orderMode			= Trim(pRequestTF("orderMode",False))

' 주문정보필드 받아오기

	Dim strName				: strName			= pRequestTF("strName",True)
	Dim strTel				: strTel			= pRequestTF("strTel",False)
	Dim strMobile			: strMobile			= pRequestTF("strMobile",True)
	Dim strEmail			: strEmail			= pRequestTF("strEmail",False)
	Dim strZip				: strZip			= pRequestTF("strZip",True)
	Dim strADDR1			: strADDR1			= pRequestTF("strADDR1",True)
	Dim strADDR2			: strADDR2			= pRequestTF("strADDR2",True)

	Dim takeName			: takeName			= pRequestTF("takeName",True)
	Dim takeTel				: takeTel			= pRequestTF("takeTel",False)
	Dim takeMobile			: takeMobile		= pRequestTF("takeMobile",True)
	Dim takeZip				: takeZip			= pRequestTF("takeZip",True)
	Dim takeADDR1			: takeADDR1			= pRequestTF("takeADDR1",True)
	Dim takeADDR2			: takeADDR2			= pRequestTF("takeADDR2",True)

	Dim infoChg				: infoChg			= pRequestTF("infoChg",False)


' 금액 관련
	Dim totalPrice			: totalPrice		= pRequestTF("totalPrice",True)
	Dim totalDelivery		: totalDelivery		= pRequestTF("totalDelivery",False)
	Dim DeliveryFeeType		: DeliveryFeeType	= pRequestTF("DeliveryFeeType",False)
	Dim GoodsPrice			: GoodsPrice		= pRequestTF("GoodsPrice",False)

	Dim totalOptionPrice	: totalOptionPrice  = pRequestTF("totalOptionPrice",False)
	Dim totalOptionPrice2	: totalOptionPrice2 = pRequestTF("totalOptionPrice2",False)		'goodsOPTcost
	Dim totalPoint			: totalPoint		= pRequestTF("totalPoint",False)

	Dim usePoint			: usePoint			= pRequestTF("useCmoney",False)			: 	If usePoint = Null Or usePoint = "" Then usePoint = 0
	Dim totalVotePoint		: totalVotePoint	= pRequestTF("totalVotePoint",False)

	Dim GoodsName			: GoodsName			= pRequestTF("GoodsName",True)


'기타 필드
	Dim orderMemo			: orderMemo			= pRequestTF("orderMemo",False)
	'isDirect or Cart 체크
	Dim isDirect			: isDirect			= pRequestTF("isDirect",False)
	Dim GoodIDX				: GoodIDX			= pRequestTF("GoodIDX",False)

'CS관련
	Dim v_SellCode			: v_SellCode		= pRequestTF("v_SellCode",False)				'CS상품 구매종류
	Dim BusCode				: BusCode			= pRequestTF("BusCode",False)


'카드 추가필드 S
	Dim quotabase			: quotabase			= Installment

'치환
	strDomain	= strHostA
	strIDX		= DK_SES_MEMBER_IDX
	strUserID	= DK_MEMBER_ID

	cardNo		= CcNO


	state = "101"


	If LCase(orderMode) = "mobile" Then
		chgPage = "/m"
		CardLogss = "cardShopM"
	Else
		chgPage = ""
		CardLogss = "cardShop"
	End If

	'isDirect or Cart 체크 (GO_BACK_ADDR)
	If isDirect = "T" Then
		GO_BACK_ADDR = chgPage&"/shop/detailView.asp?gidx="&GoodIDX
	Else
		GO_BACK_ADDR = chgPage&"/shop/cart.asp"
	End If



'print totalPrice
'확인
	Call ResRW(PGID					,"PGID				")
	Call ResRW(paykind				,"paykind				")
	Call ResRW(orderNum				,"orderNum			")
	Call ResRW(inUidx				,"inUidx				")
	Call ResRW(gopaymethod			,"gopaymethod			")
	Call ResRW(strName				,"strName				")
	Call ResRW(strTel				,"strTel				")
	Call ResRW(strMobile			,"strMobile			")
	Call ResRW(strEmail				,"strEmail			")
	Call ResRW(strZip				,"strZip				")
	Call ResRW(strADDR1				,"strADDR1			")
	Call ResRW(strADDR2				,"strADDR2			")
	Call ResRW(takeName				,"takeName			")
	Call ResRW(takeTel				,"takeTel				")
	Call ResRW(takeMobile			,"takeMobile			")
	Call ResRW(takeZip				,"takeZip				")
	Call ResRW(takeADDR1			,"takeADDR1			")
	Call ResRW(takeADDR2			,"takeADDR2			")
	Call ResRW(infoChg				,"infoChg				")
	Call ResRW(totalPrice			,"totalPrice			")
	Call ResRW(totalDelivery		,"totalDelivery		")
	Call ResRW(DeliveryFeeType		,"DeliveryFeeType		")
	Call ResRW(GoodsPrice			,"GoodsPrice			")
	Call ResRW(totalOptionPrice		,"totalOptionPrice	")
	Call ResRW(totalOptionPrice2	,"totalOptionPrice2	")
	Call ResRW(totalPoint			,"totalPoint			")
	Call ResRW(usePoint				,"usePoint			")
	Call ResRW(totalVotePoint		,"totalVotePoint		")
	Call ResRW(orderMemo			,"orderMemo			")
	Call ResRW(v_SellCode			,"v_SellCode			")
	Call ResRW(BusCode				,"BusCode				")
	Call ResRW(quotabase			,"quotabase			")
	Call ResRW(strDomain			,"strDomain			")
	Call ResRW(strIDX				,"strIDX			")
	Call ResRW(strUserID			,"strUserID			")
	Call ResRW(cardNo				,"cardNo			")
	Call ResRW(GoodsName			,"GoodsName			")
	Call ResRW(resData			,"resData			")



'로그기록생성 1
	Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
	Dim LogPath2 : LogPath2 = Server.MapPath("CardLogss/Result_") & Replace(Date(),"-","") & ".log"
	Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

	Sfile2.WriteLine ""
	Sfile2.WriteLine "Date : " & now()
	Sfile2.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
	Sfile2.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
	Sfile2.WriteLine "THIS_PAGE_URL  : " & Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")
	Sfile2.WriteLine "mbid1		 : " & DK_MEMBER_ID1
	Sfile2.WriteLine "mbid2		 : " & DK_MEMBER_ID2
	Sfile2.WriteLine "MxID		 : " & MxID
	'Sfile2.WriteLine "resData:"&Trim(Replace(resData," ",""))
	Sfile2.WriteLine "ReplyCode	: " & ReplyCode
	Sfile2.WriteLine "resData01 : " & PayMethod&"☞"&MxID&"☞"&MxIssueNO&"☞"&MxIssueDate&"☞"&Amount&"☞"&CcMode&"☞"&ReplyCode&"☞"&ReplyMessage
	Sfile2.WriteLine "resData02 : " & AuthNO&"☞"&AcqCD&"☞"&AcqName&"☞"&IssCD&"☞"&IssName&"☞"&CheckYn&"☞"&CcNO&"☞"&AcqNO&"☞"&Installment&"☞"&CAP

	If CDbl(Amount) <> CDbl(totalPrice) Then
		Sfile2.WriteLine "Amount금액과 주문금액(totalPrice)이 다릅니다."
		Call ALERTS("Amount금액과 주문금액(totalPrice)이 다릅니다.","GO",GO_BACK_ADDR)
	End If

	If ReplyCode = "0000" Then

		'▣주문정보 암호화
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If strADDR1		<> "" Then strADDR1		= objEncrypter.Encrypt(strADDR1)
			If strADDR2		<> "" Then strADDR2		= objEncrypter.Encrypt(strADDR2)
			If strTel		<> "" Then strTel		= objEncrypter.Encrypt(strTel)
			If strMob		<> "" Then strMob		= objEncrypter.Encrypt(strMob)
			If takeTel		<> "" Then takeTel		= objEncrypter.Encrypt(takeTel)
			If takeMob		<> "" Then takeMob		= objEncrypter.Encrypt(takeMob)
			If takeADDR1	<> "" Then takeADDR1	= objEncrypter.Encrypt(takeADDR1)
			If takeADDR2	<> "" Then takeADDR2	= objEncrypter.Encrypt(takeADDR2)
			If strEmail		<> "" Then strEmail		= objEncrypter.Encrypt(strEmail)
		Set objEncrypter = Nothing

		Sfile2.WriteLine "paykind		 : " & paykind
		Sfile2.WriteLine "orderNum	 : " & orderNum
		Sfile2.WriteLine "inUidx		 : " & inUidx
		Sfile2.WriteLine "orderMode	 : " & orderMode
		Sfile2.WriteLine "strEmail	 : " & strEmail
		Sfile2.WriteLine "주문자정보	 : " & strName&"☞"&strTel&"☞"&strMob&"☞"&strZip&"☞"&strADDR1&"☞"&strADDR2
		Sfile2.WriteLine "배송지정보	 : " & takeName&"☞"&takeTel&"☞"&takeMob&"☞"&takeZip&"☞"&takeADDR1&"☞"&takeADDR2
		Sfile2.WriteLine "totalPrice	 : " & totalPrice
		Sfile2.WriteLine "totalDelivery : " & totalDelivery
		Sfile2.WriteLine "DeliveryFeeType ~: " & DeliveryFeeType&"☞"&GoodsPrice&"☞"&totalOptionPrice&"☞"&totalOptionPrice2&"☞"&totalPoint&"☞"&usePoint&"☞"&GoodsName
		Sfile2.WriteLine "isDirect	 : " & isDirect
		Sfile2.WriteLine "GoodIDX		 : " & GoodIDX
		Sfile2.WriteLine "v_SellCode	 : " & v_SellCode
		Sfile2.WriteLine "quotabase	 : " & quotabase

	Else
		'Sfile2.WriteLine "결제가 정상적으로 이루어 지지 않았습니다. 오류코드 ["&ReplyCode&"],  오류내용은 ["&ReplyMessage&"] 입니다"
		Call ALERTS("결제가 정상적으로 이루어 지지 않았습니다. \n\n오류코드 ["&ReplyCode&"],  오류내용은 ["&ReplyMessage&"] 입니다","GO","/shop")
	End If


	Sfile2.Close
	Set Fso2= Nothing






	'스킨파워 개발 중단 ~2018-09-13
	'DB 입력처리



Response.end
Response.end
Response.end
Response.end
Response.end
Response.end
Response.end
Response.end
Response.end
Response.end
Response.end
Response.end





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