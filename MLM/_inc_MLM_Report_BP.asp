<!--'include virtual = "/_lib/strFunc.asp"-->
<%
	MLM_TF = "T"
	'특판방판 유무
	KOSSA_BP_TF = "T" :	If KOSSA_BP_TF = "T" Then MLM_TF = "F"

	'MLM_CmpCode = "MLM_CmpCode"
	KOSSA_BP_COMPANY_CODE = MLM_CmpCode


	'OUT_ORDERNUMBER = "TEST12345555"
%>
<%
	'##################################################################################################
	'############## [특판 방판] CS주문 승인여부체크 / MLM 신고 S ####################################
	' 방판 API 실시간 신고

	If KOSSA_BP_TF = "T" And OUT_ORDERNUMBER <> "" And KOSSA_BP_COMPANY_CODE <> "" AND UCase(DK_MEMBER_NATIONCODE) = "KR" Then

		HJCS_ORDER_SELLTF = 0
		SQL_TF = "SELECT [SellTF] FROM [tbl_SalesDetail_TF] WHERE [OrderNumber] = ?"
		arrParams_TF = Array(_
			Db.makeParam("@OrderNumber",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
		)
		HJCS_ORDER_SELLTF = Db.execRsData(SQL_TF,DB_TEXT,arrParams_TF,DB3)
		'HJCS_ORDER_SELLTF = 1

		'승인주문 확인
		If HJCS_ORDER_SELLTF = 1 Then

			arrParams_MLM1 = Array(_
				Db.makeParam("@mbid",adVarChar,adParamInput,20,DK_MEMBER_ID1), _
				Db.makeParam("@mbid2",adInteger,adParamInput,0,DK_MEMBER_ID2) _
			)
			Set DKRS = Db.execRs("DKP_MEMBER_INFO",DB_PROC,arrParams_MLM1,DB3)
			If Not DKRS.BOF And Not DKRS.EOF Then
				DKRS_mbid		= DKRS("mbid")
				DKRS_mbid2		= DKRS("mbid2")
				DKRS_M_Name		= DKRS("M_Name")
				DKRS_cpno		= DKRS("cpno")
				DKRS_Addcode1			= DKRS("Addcode1")
				DKRS_Address1	= DKRS("Address1")
				DKRS_Address2	= DKRS("Address2")
				DKRS_hometel	= DKRS("hometel")
				DKRS_hptel		= DKRS("hptel")
				DKRS_Sell_Mem_TF		= DKRS("Sell_Mem_TF")
				DKRS_WebID				= DKRS("WebID")

				Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					On Error Resume Next
						If DKRS_cpno		<> "" Then DKRS_cpno		= objEncrypter.Decrypt(DKRS_cpno)
						If DKRS_Address1	<> "" Then DKRS_Address1	= objEncrypter.Decrypt(DKRS_Address1)
						If DKRS_Address2	<> "" Then DKRS_Address2	= objEncrypter.Decrypt(DKRS_Address2)
						If DKRS_hometel		<> "" Then DKRS_hometel		= objEncrypter.Decrypt(DKRS_hometel)
						If DKRS_hptel		<> "" Then DKRS_hptel		= objEncrypter.Decrypt(DKRS_hptel)
					On Error GoTo 0
				Set objEncrypter = Nothing
			End If
			Call closeRS(DKRS)

			'제품명, 단가, 수량
			SPLITER = "" :	ItmeNams = "" :	ItmePrices = "" :	ItemCounts = ""
			SQL_ID = "SELECT B.[name],A.[ItemPrice],A.[ItemCount] FROM [tbl_SalesItemDetail] AS A"
			SQL_ID = SQL_ID & " LEFT JOIN [tbl_Goods] AS B ON B.ncode = A.ItemCode WHERE A.[OrderNumber] = ?"
			arrParams_ID = Array(_
				Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OUT_ORDERNUMBER) _
			)
			arrList_ID = Db.execRsList(SQL_ID,DB_TEXT,arrParams_ID,listLen_ID,DB3)
			If IsArray(arrList_ID) Then
				For i = 0 To listLen_ID
					arr_ItmeNams		 = arrList_ID(0,i)
					arr_ItmePrices		 = arrList_ID(1,i)
					arr_ItemCounts		 = arrList_ID(2,i)

					If i > 0 Then SPLITER = "|"

					ItmeNams = ItmeNams &SPLITER& arr_ItmeNams
					ItmePrices = ItmePrices &SPLITER& arr_ItmePrices
					ItemCounts = ItemCounts &SPLITER& arr_ItemCounts
				Next
				Call ResRW(ItmeNams,"ItmeNams")
				Call ResRW(ItmePrices,"ItmePrices")
				Call ResRW(ItemCounts,"ItemCounts")
			End If


			parent_code = "00000"
			'company_code = KOSSA_BP_COMPANY_CODE
			company_code = "A0000"
			api_key = "6cn973e4jiykwicb3aptm6px"

			'직판로그기록생성
			On Error Resume Next
			Dim FsoMLM : Set  FsoMLM=CreateObject("Scripting.FileSystemObject")
			Dim LogPathMLM : LogPathMLM = Server.MapPath("/MLM/logss/Result_") & Replace(Date(),"-","") & ".log"
			Dim SfileMLM : Set  SfileMLM = FsoMLM.OpenTextFile(LogPathMLM,8,True,-1)

				SfileMLM.WriteLine chr(13)
				SfileMLM.WriteLine "Date : " & now()
				SfileMLM.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
				SfileMLM.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
				SfileMLM.WriteLine "Referer : " & Request.ServerVariables("HTTP_REFERER")
				SfileMLM.WriteLine "IP_ADRESS	: " & getUserIP()
				SfileMLM.WriteLine "payway	: " & UCase(payway)
				SfileMLM.WriteLine "orderID	: " & OUT_ORDERNUMBER
				SfileMLM.WriteLine "KOSSA_CODE	: " & KOSSA_BP_COMPANY_CODE
				SfileMLM.WriteLine "totalmoney	: " & totalPrice-totalDelivery
				SfileMLM.WriteLine "seller_type	: " & DKRS_Sell_Mem_TF
				SfileMLM.WriteLine "name	: " & DKRS_M_Name
				SfileMLM.WriteLine "userid	: " & DKRS_WebID
				SfileMLM.WriteLine "mem_id	: " & DK_MEMBER_ID1&"-"&DK_MEMBER_ID2

				oXmlParam = ""
				oXmlParam = oXmlParam & "parent_code="&parent_code			'모기업코드 독립사업자인 경우 00000
				oXmlParam = oXmlParam & "&company_code="&company_code		'회사코드 대리점 및 독립사업자 코드		(특판 조합사 코드?)
				oXmlParam = oXmlParam & "&api_key="&api_key							'인증코드

				oXmlParam = oXmlParam & "&saleorder_num="&OUT_ORDERNUMBER		'주문번호
				oXmlParam = oXmlParam & "&member_kind="&DKRS_Sell_Mem_TF			'회원구분 0: 판매원, 1: 소비자
				oXmlParam = oXmlParam & "&member_name="&DKRS_M_Name			'회원명
				oXmlParam = oXmlParam & "&member_num="&DK_MEMBER_ID1&"-"&DK_MEMBER_ID2			'회원번호
				oXmlParam = oXmlParam & "&tel_no="&DKRS_hometel			'전화번호
				oXmlParam = oXmlParam & "&mobile_no="&DKRS_hptel			'휴대폰
				oXmlParam = oXmlParam & "&zipcode="&DKRS_Addcode1			'우편번호
				oXmlParam = oXmlParam & "&post_addr1="&DKRS_Address1			'주소
				oXmlParam = oXmlParam & "&post_addr2="&DKRS_Address2			'상세주소
				oXmlParam = oXmlParam & "&sum_amt="&totalPrice-totalDelivery		'특판신고 : 배송비제외!
				oXmlParam = oXmlParam & "&sales_dt="&date()				'매출일자 yyyy-mm-dd
				oXmlParam = oXmlParam & "&goods_name="&ItmeNams				'제품명 중복가능(구분자는 ‘|’)
				oXmlParam = oXmlParam & "&goods_cost="&ItmePrices				'단가 중복가능(구분자는 ‘|’)
				oXmlParam = oXmlParam & "&quantity="&ItemCounts				'주문수량 중복가능(구분자는 ‘|’)

				Call ResRW2(oXmlParam,"oXmlParam")
				SfileMLM.WriteLine "oXmlParam	: " & oXmlParam

				mlmURL1 = "https://kssfc.or.kr/sales.ddo"
				'mlmURL1 = "https://dev-api.bizppurio.com"

				Set oXmlhttp1 = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

				oXmlhttp1.setOption 2, 13056
				oXmlhttp1.open "POST", mlmURL1, False
				oXmlhttp1.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;"
				oXmlhttp1.setRequestHeader "Accept-Language","UTF-8"
				oXmlhttp1.setRequestHeader "CharSet", "UTF-8"
				oXmlhttp1.setRequestHeader "Content", "text/html;charset=UTF-8"
				oXmlhttp1.setRequestHeader "Content-Length", Len(oXmlParam)

				oXmlhttp1.send oXmlParam											'작업 시간을 초과했습니다.
				'sResponse = oXmlhttp1.responseText						'시스템이 지정한 인코딩을 지원하지 않습니다. -1072896658 (0xC00CE56E)

				sResponse = BinaryToText(oXmlhttp1.ResponseBody,"UTF-8")
				xmlStatus = oXmlhttp1.status

				Call ResRW(xmlStatus,"xmlStatus")
				Call ResRW2(sResponse,"sResponse")
				SfileMLM.WriteLine "xmlStatus	: " & xmlStatus
				SfileMLM.WriteLine "sResponse	: " & sResponse

				'XML 파싱
				Set oDOM = Server.CreateObject("Microsoft.XMLDOM")
					oDOM.Async = False ' 동기식 호출
					oDOM.validateOnParse = false
					oDomXML = oDOM.loadXML(sResponse)

					Set r_status			= oDOM.selectNodes("//status")				'상태코드 : 3번의 결과코드값 참조
					Set r_statusmsg			= oDOM.selectNodes("//statusmsg")		'상태메시지
						KOSSA_BP_status				= r_status(0).Text
						KOSSA_BP_statusmsg				= r_statusmsg(0).Text
					Set r_status			= Nothing
					Set r_statusmsg			= Nothing

					'0000 정상완료  ※결과코드 "0000" 이외의 코드는 에러
					KOSSA_BP_guarante_num = ""
					If KOSSA_BP_status = "0000" Then
						Set r_guarante_num			= oDOM.selectNodes("//guarante_num")	'공제번호 : 발급된 공제번호
							KOSSA_BP_guarante_num			= r_guarante_num(0).Text
						Set r_guarante_num			= Nothing
					End If


					Call ResRW(KOSSA_BP_status,"KOSSA_BP_status")
					Call ResRW(KOSSA_BP_statusmsg,"KOSSA_BP_statusmsg")
					Call ResRW(KOSSA_BP_guarante_num,"KOSSA_BP_guarante_num")
					SfileMLM.WriteLine "KOSSA_BP_status		: " & KOSSA_BP_status
					SfileMLM.WriteLine "KOSSA_BP_statusmsg		: " & KOSSA_BP_statusmsg
					SfileMLM.WriteLine "KOSSA_BP_guarante_num		: " & KOSSA_BP_guarante_num

					If KOSSA_BP_guarante_num <> "" Then
						print "특판 공제번호 발급이 완료되었습니다 : " &KOSSA_BP_guarante_num
					'	ALERTS_MESSAGE = "특판 공제번호 발급이 완료되었습니다 : " &KOSSA_BP_guarante_num
					Else
						print "특판 공제번호 발급이 실패되었습니다. 에러코드 : "&KOSSA_BP_status&"\n\n"&KOSSA_BP_statusmsg&""
					'	ALERTS_MESSAGE = "특판 공제번호 발급이 실패되었습니다. 에러코드 : "&KOSSA_BP_status&"\n\n"&KOSSA_BP_statusmsg&""
					End If

				Set oDOM = Nothing
				Set oXmlhttp1 = Nothing

			SfileMLM.Close
			Set FsoMLM= Nothing
			On Error Goto 0

			'데이터 입력
			If KOSSA_BP_guarante_num <> "" Or KOSSA_BP_status <> "" Then

				SQL = "UPDATE [tbl_SalesDetail] SET"
				SQL = SQL &" [InsuranceNumber]		= ?"
				SQL = SQL &",[InsuranceNumber_Date]	= CONVERT(VARCHAR(24),GETDATE(),121)"
				SQL = SQL &",[INS_Num_Err]			= ?"
				SQL = SQL &" WHERE [OrderNumber]	= ?"

					'Db.makeParam("@INS_NUM_DATE",adVarChar,adParamInput,30,Recordtime),_
				arrParams = Array(_
					Db.makeParam("@INS_NUM",adVarChar,adParamInput,30,KOSSA_BP_guarante_num),_
					Db.makeParam("@INS_Num_Err",adVarChar,adParamInput,50,KOSSA_BP_status),_
					Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,DB3)

			End If


		End If

	End If


%>
<%
	Function  BinaryToText(BinaryData, CharSet)
		Const adTypeText = 2
		Const adTypeBinary = 1

		Dim BinaryStream
		Set BinaryStream = CreateObject("ADODB.Stream")

		'원본 데이터 타입
		BinaryStream.Type = adTypeBinary
		BinaryStream.Open
		BinaryStream.Write BinaryData

		' binary -> text
		BinaryStream.Position = 0
		BinaryStream.Type = adTypeText

		' 변환할 데이터 캐릭터셋
		BinaryStream.CharSet = CharSet

		'변환한 데이터 반환
		BinaryToText = BinaryStream.ReadText

	End Function
%>
