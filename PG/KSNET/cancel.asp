<%@ CodePage="65001" Language="VBScript"%>
<%
	Session.CodePage = 65001
	Response.CodePage = 65001
	Response.CharSet = "UTF-8"
	Response.AddHeader "Expires","0"
	'쿠키 미 사용시
		Response.AddHeader "Pragma","no-cache"
	'쿠키 사용시
		'Response.AddHeader "Pragma", "private"
		'Response.AddHeader "Cache-Control", "private, must-revalidate"


TX_KSNET_TID = Request.Form("TX_KSNET_TID")
F_PGorderNum = Request.Form("F_PGorderNum")

%>
<!-- #include file=KSPayApprovalCancel_ansi.inc -->
<%
		EncType       = "2"			     		' 0: 암화안함, 1:openssl, 2: seed
		Version       = "0210"				    ' 전문버전
		VersionType   = "00"					' 구분
		Resend        = "0"					    ' 전송구분 : 0 : 처음,  2: 재전송
		' 요청일자 : yyyymmddhhmmss
		RequestDate   = SetData(Year(Now),    4, "9") & _
						SetData(Month(Now),   2, "9") & _
						SetData(Day(Now),     2, "9") & _
						SetData(Hour(Now),    2, "9") & _
						SetData(Minute(Now),  2, "9") & _
						SetData(Second(Now),  2, "9")
		KeyInType     = "K"					    ' KeyInType 여부 : S : Swap, K: KeyInType
		LineType      = "1"			            ' lineType 0 : offline, 1:internet, 2:Mobile
		ApprovalCount = "1"				        ' 복합승인갯수
		GoodType      = "1"	                    ' 제품구분 1 : 실물, 2 : 디지털
		HeadFiller    = ""				        ' 예비
	'-------------------------------------------------------------------------------

	' Header (입력값 (*) 필수항목)--------------------------------------------------
		StoreId     = TX_KSNET_TID				' *상점아이디
		OrderNumber = ""							' 주문번호
		UserName    = ""							' 주문자명
		IdNum       = ""							' 주민번호 or 사업자번호
		Email       = ""							' email
		GoodName    = ""		' 제품명
		PhoneNo     = ""		' 휴대폰번호
	' Header end -------------------------------------------------------------------

	' Data Default(수정항목이 아님)-------------------------------------------------
		ApprovalType	  = "1010"	' 승인구분
		TrNo   			  =	F_PGorderNum	' 거래번호
	' Data Default end -------------------------------------------------------------

	' Server로 부터 응답이 없을시 자체응답
		rApprovalType	   = "1011"
		rTransactionNo      = ""				' 거래번호
		rStatus             = "X"				' 상태 O : 승인, X : 거절
		rTradeDate          = "" 				' 거래일자
		rTradeTime          = "" 				' 거래시간
		rIssCode            = "00" 				' 발급사코드
		rAquCode			= "00" 				' 매입사코드
		rAuthNo             = "9999" 			' 승인번호 or 거절시 오류코드
		rMessage1           = "취소거절" 		' 메시지1
		rMessage2           = "C잠시후재시도"	' 메시지2
		rCardNo             = "" 				' 카드번호
		rExpDate            = "" 				' 유효기간
		rInstallment        = "" 				' 할부
		rAmount             = "" 				' 금액
		rMerchantNo         = "" 				' 가맹점번호
		rAuthSendType       = "N" 				' 전송구분
		rApprovalSendType   = "N" 				' 전송구분(0 : 거절, 1 : 승인, 2: 원카드)
		rPoint1             = "000000000000"	' Point1
		rPoint2             = "000000000000"	' Point2
		rPoint3             = "000000000000"	' Point3
		rPoint4             = "000000000000"	' Point4
		rVanTransactionNo   = ""
		rFiller             = "" 				' 예비
		rAuthType	 	    = "" 				' ISP : ISP거래, MP1, MP2 : MPI거래, SPACE : 일반거래
		rMPIPositionType	= "" 				' K : KSNET, R : Remote, C : 제3기관, SPACE : 일반거래
		rMPIReUseType	    = "" 				' Y : 재사용, N : 재사용아님
		rEncData			= "" 				' MPI, ISP 데이터
	' --------------------------------------------------------------------------------

		KSPayApprovalCancel "210.181.28.137", 21001

		HeadMessage EncType, Version, VersionType, Resend, RequestDate, StoreId, OrderNumber, UserName, IdNum, Email, GoodType, GoodName, KeyInType, LineType, PhoneNo, ApprovalCount, HeadFiller


		CancelDataMessage ApprovalType, "0", TrNo, "", "", "","",""

		if SendSocket("1") = true then
			rApprovalType		= ApprovalType
			rTransactionNo		= TransactionNo	  		' 거래번호
			rStatus				= Status		  		' 상태 O : 승인, X : 거절
			rTradeDate			= TradeDate		  		' 거래일자
			rTradeTime			= TradeTime		  		' 거래시간
			rIssCode			= IssCode		  		' 발급사코드
			rAquCode			= AquCode		  		' 매입사코드
			rAuthNo				= AuthNo		  		' 승인번호 or 거절시 오류코드
			rMessage1			= Message1		  		' 메시지1
			rMessage2			= Message2		  		' 메시지2
			rCardNo				= CardNo		  		' 카드번호
			rExpDate			= ExpDate		  		' 유효기간
			rInstallment		= Installment	  		' 할부
			rAmount				= Amount		  		' 금액
			rMerchantNo			= MerchantNo	  		' 가맹점번호
			rAuthSendType		= AuthSendType	  		' 전송구분= new String(this.read(2))
			rApprovalSendType	= ApprovalSendType		' 전송구분(0 : 거절, 1 : 승인, 2: 원카드)
			rPoint1				= Point1		  		' Point1
			rPoint2				= Point2		  		' Point2
			rPoint3				= Point3		  		' Point3
			rPoint4				= Point4		  		' Point4
			rVanTransactionNo   = VanTransactionNo      ' Van거래번호
			rFiller				= Filler		  		' 예비
			rAuthType			= AuthType		  		' ISP : ISP거래, MP1, MP2 : MPI거래, SPACE : 일반거래
			rMPIPositionType	= MPIPositionType 		' K : KSNET, R : Remote, C : 제3기관, SPACE : 일반거래
			rMPIReUseType		= MPIReUseType			' Y : 재사용, N : 재사용아님
			rEncData			= EncData		  		' MPI, ISP 데이터
		End If
%>
<!-- #include file=encoding_utf8.asp -->
<%

	'▣ 로그 기록 S
		On Error Resume Next
			Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
			Dim LogPath2 : LogPath2 = Server.MapPath ("cardCancel/cancel_") & Replace(Date(),"-","") & ".log"
			Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

			Sfile2.WriteLine "--- Card Cancel -------------------------------"
			Sfile2.WriteLine "StoreId		: " & StoreId
			Sfile2.WriteLine "rSendSoket		: " & rSendSoket
			Sfile2.WriteLine "rApprovalType			: "	& rApprovalType
			Sfile2.WriteLine "rTransactionNo		: "	& rTransactionNo
			Sfile2.WriteLine "rStatus				: "	& rStatus
			Sfile2.WriteLine "rTradeDate			: "	& rTradeDate
			Sfile2.WriteLine "rTradeTime			: "	& rTradeTime
			Sfile2.WriteLine "rIssCode				: "	& rIssCode
			Sfile2.WriteLine "rAquCode				: "	& rAquCode
			Sfile2.WriteLine "rAuthNo				: "	& rAuthNo
			Sfile2.WriteLine "rMessage1				: "	& rMessage1
			Sfile2.WriteLine "rMessage2				: "	& rMessage2
			Sfile2.WriteLine "rCardNo				: "	& rCardNo
			Sfile2.WriteLine "rExpDate				: "	& rExpDate
			Sfile2.WriteLine "rInstallment			: "	& rInstallment
			Sfile2.WriteLine "rAmount				: "	& rAmount
			Sfile2.WriteLine "rMerchantNo			: "	& rMerchantNo
			Sfile2.WriteLine "rAuthSendType			: "	& rAuthSendType
			Sfile2.WriteLine "rApprovalSendType		: "	& rApprovalSendType
			Sfile2.WriteLine "rPoint1				: "	& rPoint1
			Sfile2.WriteLine "rPoint2				: "	& rPoint2
			Sfile2.WriteLine "rPoint3				: "	& rPoint3
			Sfile2.WriteLine "rPoint4				: "	& rPoint4
			Sfile2.WriteLine "rVanTransactionNo		: "	& rVanTransactionNo
			Sfile2.WriteLine "rFiller				: "	& rFiller
			Sfile2.WriteLine "rAuthType				: "	& rAuthType
			Sfile2.WriteLine "rMPIPositionType		: "	& rMPIPositionType
			Sfile2.WriteLine "rMPIReUseType			: "	& rMPIReUseType
			Sfile2.WriteLine "rEncData				: "	& rEncData
			Sfile2.WriteLine "---------------------------------------------"


			Sfile2.Close
			Set Fso2= Nothing
			Set objError= Nothing
		On Error Goto 0
	'▣ 로그 기록 E


	Response.Write "{""rStatus"":"""&Trim(rStatus)&""",""rAuthNo"":"""&Trim(rAuthNo)&""",""rMessage1"":"""&rMessage1&""",""rMessage2"":"""&rMessage2&"""}"



%>