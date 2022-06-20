<!-- #include virtual = "/_lib/strFunc.asp" -->
<!-- #include virtual = "/PG/KSNET/KSPayApprovalCancel_ansi.inc" -->
<%
	Call MEMBER_AUTH_CHECK(DK_MEMBER_LEVEL,1)

	'KSNET 오토쉽 인증

	proceed   		 	= request.form("proceed")				' 성공여부	(true/ false)
	payKey    		 	= request.form("payKey")				' 결제 토큰 (== 페이키)
	errorCode 		 	= request.form("errorCode")				' 오류코드	(0000 정상)
	msg1      		 	= request.form("msg1")					' 메시지1	(성공시 카드사명(한글))
	msg2      		 	= request.form("msg2")					' 메시지2
	cardNumb  		 	= request.form("cardNumb")				' (마스킹된)카드번호
	cardIssuerCode		= request.form("cardIssuerCode")		' 카드 발급사 코드
	cardPurchaserCode	= request.form("cardPurchaserCode")		' 카드 매입사 코드

	If errorCode = "" Then Call ALERTS(LNG_ALERT_WRONG_ACCESS,"BACK","")

	proceed   		 	= Trim(proceed)
	payKey    		 	= Trim(payKey)
	errorCode 		 	= Trim(errorCode)
	msg1      		 	= Trim(msg1)
	msg2      		 	= Trim(msg2)
	cardNumb  		 	= Trim(cardNumb)
	cardIssuerCode		= Trim(cardIssuerCode)
	cardPurchaserCode	= Trim(cardPurchaserCode)

'	Response.End
%>
<%
	'임시테이블 동글저장
	IDENTITY = ""
	If errorCode = "0000" And payKey <> "" Then

		PGCardNum = cardNumb
		If PGCardNum <> "" Then
			'카드번호* 처리
			C_Number_LEN = 0
			C_Number_LEFT = ""
			C_Number_LEN = Len(PGCardNum)

			cStars = ""
			If C_Number_LEN >= 14 Then
				For s = 1 To 8
					cStars = cStars&"*"
				Next
				PGCardNum = Left(PGCardNum,4) & cStars & Right(PGCardNum,C_Number_LEN - (4+8))
			Else
				For s = 1 To 8
					cStars = cStars&"*"
				Next
				PGCardNum =	Left(PGCardNum,4) & cStars & Right(PGCardNum,1)
			End If
		End If

		cardIssuerCode	= KSNET_CARDCODE(CStr(cardIssuerCode))	'신용카드사코드(KSNET 치환)

		'카드사명
		SQLC = "SELECT [cardname] FROM [tbl_Card] WITH(NOLOCK) WHERE [recordid] = 'admin' AND [ncode] = ? "
		arrParamsC = Array(_
			Db.makeParam("@ncode",adVarWChar,adParamInput,70,cardIssuerCode) _
		)
		CardName = Db.execRsData(SQLC,DB_TEXT,arrParamsC,DB3)

		A_Card_Dongle = payKey
		A_Card_Dongle_ORI = payKey

		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			On Error Resume Next
				If A_Card_Dongle <> "" Then A_Card_Dongle = objEncrypter.Encrypt(A_Card_Dongle)
			On Error GoTo 0
		Set objEncrypter = Nothing

		If DK_MEMBER_ID1 <> "" And DK_MEMBER_ID2 <> "" Then
			SQLD = "DELETE FROM [HJ_tbl_Memberinfo_A_Dongle_Chk] WHERE [MBID] = ? AND [MBID2] = ? AND [regDate] < GETDATE() - 3 "
			arrParamsD = Array( _
				Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			Call Db.exec(SQLD,DB_TEXT,arrParamsD,DB3)

			SQLA = "INSERT INTO [HJ_tbl_Memberinfo_A_Dongle_Chk] ( "
			SQLA = SQLA & " [MBID],[MBID2],[A_Card_Dongle] "
			SQLA = SQLA & " ) VALUES ( "
			SQLA = SQLA & " ?,?,? "
			SQLA = SQLA & " ); "
			SQLA = SQLA & "SELECT ? = @@IDENTITY"
			arrParamsA = Array( _
				Db.makeParam("@mbid1",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2), _
				Db.makeParam("@A_Card_Dongle",adVarWchar,adParamInput,100,A_Card_Dongle), _
				Db.makeParam("@IDENTITY",adInteger,adParamOutput,0,0) _
			)
			Call Db.exec(SQLA,DB_TEXT,arrParamsA,DB3)
			IDENTITY = arrParamsA(UBound(arrParamsA))(4)
		End If

		If IDENTITY <> "" Then
			On Error Resume Next
			Set StrCipher = Server.CreateObject("Hoyasoft.StrCipher")
				IDENTITY = Trim(StrCipher.Encrypt(IDENTITY,EncTypeKey1,EncTypeKey2))
			Set StrCipher = Nothing
			On Error GoTo 0
		End If

	End If
%>
<!-- #include virtual = "/PG/KSNET/encoding_utf8.asp" -->
</head>
<body>
<script language="javascript">

	<%If errorCode = "0000" AND IDENTITY <> "" Then%>
		top.opener.document.cfrm.cardCheck.value = "T";
		top.opener.$("select[name=A_CardCode] option").val('<%=cardIssuerCode%>');
		top.opener.$("#CardNameTXT").text("<%=CardName%>");
		top.opener.$("#CardNumberTXT").text("<%=PGCardNum%>");
		top.opener.document.cfrm.A_CardNumber1.value	= "<%=cardNumb%>";
		top.opener.document.cfrm.chkA_Card_Dongle.value	= "<%=A_Card_Dongle_ORI%>";
		top.opener.document.cfrm.chkA_Card_DongleIDX.value	= "<%=IDENTITY%>";
		top.opener.$("#cardCheckTXT").css({"color": "blue"}).text("정상 인증처리 되었습니다");
	<%Else%>
		top.opener.document.cfrm.cardCheck.value = "F";
		//top.opener.$("select[name=A_CardCode] option").val('');
		//top.opener.$("#CardNameTXT").text("");
		//top.opener.$("#CardNumberTXT").text("");
		top.opener.document.cfrm.A_CardNumber1.value	= "";
		top.opener.document.cfrm.chkA_Card_Dongle.value	= "";
		top.opener.document.cfrm.chkA_Card_DongleIDX.value	= "";
		top.opener.$("#cardCheckTXT").css({"color": "red"}).text("인증실패 : <%=msg1%>, <%=msg2%>");
	<%End If%>
	self.close();

</script>
</body>
</html>
