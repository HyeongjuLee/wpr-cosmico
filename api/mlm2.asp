<!--#include virtual = "/_lib/strFunc.asp"-->
<%
		If WebproIP <> "T" Then CAll WRONG_ACCESS()

		MLM_TF = "T"
		'특판방판 유무
		KOSSA_BP_TF = "T" :	If KOSSA_BP_TF = "T" Then MLM_TF = "F"

		'MLM_CmpCode = "MLM_CmpCode"
		KOSSA_BP_COMPANY_CODE = MLM_CmpCode


		OUT_ORDERNUMBER = "TEST12345555"
%>
<%

	' 방판 API 실시간 신고

	If KOSSA_BP_TF = "T" And OUT_ORDERNUMBER <> "" And KOSSA_BP_COMPANY_CODE <> "" AND UCase(DK_MEMBER_NATIONCODE) = "KR" Then

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


			parent_code = ""
			company_code = KOSSA_BP_COMPANY_CODE
			api_key = ""

			'직판로그기록생성
			On Error Resume Next
			Dim FsoM : Set  FsoM=CreateObject("Scripting.FileSystemObject")
			Dim LogPathM : LogPathM = Server.MapPath("/MLM/logss/Result_") & Replace(Date(),"-","") & ".log"
			Dim SfileM : Set  SfileM = FsoM.OpenTextFile(LogPathM,8,True,-1)

				SfileM.WriteLine chr(13)
				SfileM.WriteLine "Date : " & now()
				SfileM.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
				SfileM.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
				SfileM.WriteLine "Referer : " & Request.ServerVariables("HTTP_REFERER")
				SfileM.WriteLine "IP_ADRESS	: " & getUserIP()
				SfileM.WriteLine "payway	: " & UCase(payway)
				SfileM.WriteLine "orderID	: " & OUT_ORDERNUMBER
				SfileM.WriteLine "KOSSA_CODE	: " & KOSSA_BP_COMPANY_CODE
				SfileM.WriteLine "totalmoney	: " & totalPrice-totalDelivery
				SfileM.WriteLine "seller_type	: " & DKRS_Sell_Mem_TF
				SfileM.WriteLine "name	: " & DKRS_M_Name
				SfileM.WriteLine "userid	: " & DKRS_WebID
				SfileM.WriteLine "mem_id	: " & DK_MEMBER_ID1&"-"&DK_MEMBER_ID2

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
				SfileM.WriteLine "oXmlParam	: " & oXmlParam

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
				SfileM.WriteLine "xmlStatus	: " & xmlStatus
				SfileM.WriteLine "sResponse	: " & sResponse

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
					SfileM.WriteLine "KOSSA_BP_status		: " & KOSSA_BP_status
					SfileM.WriteLine "KOSSA_BP_statusmsg		: " & KOSSA_BP_statusmsg
					SfileM.WriteLine "KOSSA_BP_guarante_num		: " & KOSSA_BP_guarante_num

					If KOSSA_BP_guarante_num <> "" Then
						print "특판 공제번호 발급이 완료되었습니다 : " &KOSSA_BP_guarante_num
					'	ALERTS_MESSAGE = "특판 공제번호 발급이 완료되었습니다 : " &KOSSA_BP_guarante_num
					Else
						print "특판 공제번호 발급이 실패되었습니다. 에러코드 : "&KOSSA_BP_status&"\n\n"&KOSSA_BP_statusmsg&""
					'	ALERTS_MESSAGE = "특판 공제번호 발급이 실패되었습니다. 에러코드 : "&KOSSA_BP_status&"\n\n"&KOSSA_BP_statusmsg&""
					End If

				Set oDOM = Nothing
				Set oXmlhttp1 = Nothing

			SfileM.Close
			Set FsoM= Nothing
			On Error Goto 0

			'데이터 입력
			If KOSSA_BP_guarante_num <> "" Or KOSSA_BP_status <> "" Then

				SQL = "UPDATE [tbl_SalesDetail] SET"
				SQL = SQL &" [InsuranceNumber]		= ?"
				SQL = SQL &",[InsuranceNumber_Date]	= ?"
				SQL = SQL &",[INS_Num_Err]			= ?"
				SQL = SQL &" WHERE [OrderNumber]	= ?"

				arrParams = Array(_
					Db.makeParam("@INS_NUM",adVarChar,adParamInput,30,KOSSA_BP_guarante_num),_
					Db.makeParam("@INS_NUM_DATE",adVarChar,adParamInput,30,Recordtime),_
					Db.makeParam("@INS_Num_Err",adVarChar,adParamInput,50,KOSSA_BP_status),_
					Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,OUT_ORDERNUMBER) _
				)
				Call Db.exec(SQL,DB_TEXT,arrParams,DB3)

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
<%
response.end
	'제품명, 단가, 수량
		'1. 프로시져에서 분기값 가져오기
		arrParams = Array(_
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OUT_ORDERNUMBER) _
		)
		Set HJRSC = DB.execRs("HJP_KOSSA_ITEM_DETAIL_REPORT",DB_PROC,arrParams,DB3)
		If Not HJRSC.BOF And Not HJRSC.EOF Then
			RS_ItmeNams		 = HJRSC(0)
			RS_ItmePrices		 = HJRSC(1)
			RS_ItemCounts		 = HJRSC(2)
		Else
			RS_ItmeNams		 = ""
			RS_ItmePrices		 = ""
			RS_ItemCounts		 = ""
		End If
		Call closeRS(HJRSC)

		Call ResRW(RS_ItmeNams,"RS_ItmeNams")
		Call ResRW(RS_ItmePrices,"RS_ItmePrices")
		Call ResRW2(RS_ItemCounts,"RS_ItemCounts")
	'Response.end
%>
