<%

'온오프코리아 취소

'Call PG_ONOFFKOREA_CANCEL(PGorderNum,orderNum,totalPrice,isDirect,GoodIDX,chgPage,ThisMsg)

'▣  [승인취소/매입취소] S

	'Function PG_ONOFFKOREA_CANCEL(ByVal F_PGorderNum, ByVal F_orderNum, ByVal F_totalPrice , ByVal F_isDirect, ByVal F_GoodIDX, ByVal F_chgPage , ByRef F_errMsg)
	Function PG_ONOFFKOREA_CANCEL(ByVal F_onfftid, ByVal F_PGorderNum, ByVal F_orderNum, ByVal F_totalPrice , ByVal F_PGAcceptNum	, ByVal F_PGAcceptDate	, ByVal F_isDirect, ByVal F_GoodIDX, ByVal F_chgPage , ByRef F_errMsg)

		'isDirect or Cart 체크 (GO_BACK_ADDR)
		If F_isDirect = "T" Then
			F_GO_BACK_ADDR = F_chgPage&"/shop/detailView.asp?gidx="&F_GoodIDX
		Else
			F_GO_BACK_ADDR = F_chgPage&"/shop/cart.asp"
		End If

			onfftid_C = F_onfftid

			oXmlParam_C = ""
			oXmlParam_C = oXmlParam_C & "onfftid="&onfftid_C		'(필) 온오프코리아 TID
			oXmlParam_C = oXmlParam_C & "&method=cancel"			'(필) 승인취소 : cancel
			oXmlParam_C = oXmlParam_C & "&tot_amt="&F_totalPrice	'(선) 취소금액(원결제금액과동일)
			oXmlParam_C = oXmlParam_C & "&transeq="&F_PGorderNum	'(필) 원거래고유번호
			oXmlParam_C = oXmlParam_C & "&auth_no="&F_PGAcceptNum	'(필) 원승인번호
			oXmlParam_C = oXmlParam_C & "&app_dt="&F_PGAcceptDate	'(필) 원승인일자 (YYYYMMDD)
			oXmlParam_C = oXmlParam_C & "&order_no="&F_orderNum		'(선) 주문번호
			oXmlParam_C = oXmlParam_C & "&pay_type=card"			'(선) 결제타입	기본 신용카드 : card,  현금영수증 : cash

			''oXmlURL_C = "https://store.onoffkorea.co.kr/payment"				'절대 안됨!!!!!!!
			oXmlURL_C = "https://store.onoffkorea.co.kr/payment/index.php"

			Set oXmlhttp_C = server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

				oXmlhttp_C.setOption 2, 13056
				oXmlhttp_C.open "POST", oXmlURL_C, False
				oXmlhttp_C.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
				oXmlhttp_C.setRequestHeader "Accept-Language","UTF-8"
				oXmlhttp_C.setRequestHeader "CharSet", "UTF-8"
				oXmlhttp_C.setRequestHeader "Content", "text/html;charset=UTF-8"
				oXmlhttp_C.setRequestHeader "Content-Length", Len(oXmlParam_C)
				oXmlhttp_C.send oXmlParam_C

				oResponse_C  = oXmlhttp_C.responseText
				oXmlStatus_C = oXmlhttp_C.status

			Set oXmlhttp_C = Nothing '개체 소멸

			'Call ResRW(oResponse_C,"oResponse_C")
			'Call ResRW(oXmlStatus_C,"oXmlStatus_C")


			On Error Resume Next
			Dim Fso_C : Set  Fso_C=CreateObject("Scripting.FileSystemObject")

			Dim LogPath_C : LogPath_C = Server.MapPath ("/PG/ONOFFKOREA/cardCancel/te_") & Replace(Date(),"-","") & ".log"
			Dim Sfile_C : Set  Sfile_C = Fso_C.OpenTextFile(LogPath_C,8,true)
				Sfile_C.WriteLine chr(13)
				Sfile_C.WriteLine "Date : " & now()
				Sfile_C.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
				Sfile_C.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
				Sfile_C.WriteLine "THIS_PAGE_URL	: " & Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")
				Sfile_C.WriteLine "--- Card REFUND(CANCEL) --------------------"
				Sfile_C.WriteLine "oResponse_C	: "	& oResponse_C
				Sfile_C.WriteLine "oXmlStatus_C	: " & oXmlStatus_C

				ALERT_MSG = ""
				ALERT_BR = "\n"

					'XML 파싱
					Set objMsXmlDom_C = Server.CreateObject("microsoft.XMLDOM")
						objMsXmlDom_C.async = False	' 동기식 호출
						objMsXmlDom_C.validateOnParse = false
						objMsXmlDom_C.loadXML(oResponse_C)

						result_cd_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("result_cd").Item(0).Text)		'결과 코드
						result_msg_C= "" & Trim(objMsXmlDom_C.getElementsByTagName("result_msg").Item(0).Text)		'결과 메시지
						transeq_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("transeq").Item(0).Text)			'원거래고유번호
						app_date_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("app_date").Item(0).Text)		'승인일자(YYYYMMDD)
						app_dt_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("app_dt").Item(0).Text)			'승인일자
						app_tm_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("app_tm").Item(0).Text)			'승인시간
						tot_amt_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("tot_amt").Item(0).Text)			'취소금액

					Set objMsXmlDom_C  = Nothing

				Sfile_C.WriteLine "oXmlParam_C	: " & oXmlParam_C
				Sfile_C.WriteLine "F_onfftid	: " & F_onfftid
				Sfile_C.WriteLine "PGorderNum	: " & F_PGorderNum
				Sfile_C.WriteLine "orderNum		: " & F_orderNum
				Sfile_C.WriteLine "totalPrice	: " & F_totalPrice
				Sfile_C.WriteLine "PGAcceptNum	: " & F_PGAcceptNum
				Sfile_C.WriteLine "PGAcceptDate	: " & F_PGAcceptDate

				Sfile_C.WriteLine "result_cd	: " & result_cd_C
				Sfile_C.WriteLine "result_msg	: " & result_msg_C
				Sfile_C.WriteLine "transeq		: "	& transeq_C
				Sfile_C.WriteLine "app_date		: "	& app_date_C
				Sfile_C.WriteLine "app_dt		: "	& app_dt_C
				Sfile_C.WriteLine "app_tm		: "	& app_tm_C
				Sfile_C.WriteLine "tot_amt		: "	& tot_amt_C
				Sfile_C.WriteLine "CanCel_Msg	: " & ThisMsg
				Sfile_C.WriteLine "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

				Sfile_C.Close
			Set Fso_C= Nothing
			Set objError= Nothing
			On Error Goto 0


			If result_cd_C = "0000" Then
				Call ALERTS("데이터 처리중 오류가 발생하여 카드결제를 취소하였습니다\n\n취소사유 : "&F_errMsg,"GO",F_GO_BACK_ADDR)
			Else
				Call ALERTS("카드취소중 오류가 발생하였습니다. 결제취소가 정상적으로 이루어 지지 않은 경우 업체에 문의해주세요\n\result_msg : "&result_msg_C,"GO",F_GO_BACK_ADDR)
			End If

	End Function

	'♠온오프코리아 복합 결제
	Function PG_ONOFFKOREA_PAY_M(ByVal F_ONOFFKOREA_PARAMS, ByVal F_orderNum,	ByVal F_tot_amt , ByRef R_transeq, ByRef R_auth_no, ByRef R_iss_cd, ByRef R_iss_nm, ByRef R_result_cd, ByRef R_result_msg)

			CardLogss	= "/PG/ONOFFKOREA/mCardShopAPI"

			oXmlParam_P = F_ONOFFKOREA_PARAMS

			oXmlURL_P = "http://store.onoffkorea.co.kr/payment/index.php"

			Set oXmlhttp_P = server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

				oXmlhttp_P.setOption 2, 13056
				oXmlhttp_P.open "POST", oXmlURL_P, False
				oXmlhttp_P.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
				oXmlhttp_P.setRequestHeader "Accept-Language","UTF-8"
				oXmlhttp_P.setRequestHeader "CharSet", "UTF-8"
				oXmlhttp_P.setRequestHeader "Content", "text/html;charset=UTF-8"
				oXmlhttp_P.setRequestHeader "Content-Length", Len(oXmlParam_P)
				oXmlhttp_P.send oXmlParam_P

				oResponse_P  = oXmlhttp_P.responseText
				oXmlStatus_P = oXmlhttp_P.status

			Set oXmlhttp_P = Nothing '개체 소멸

			'Call ResRW(oResponse_C,"oResponse_C")
			'Call ResRW(oXmlStatus_C,"oXmlStatus_C")

			On Error Resume Next
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If oXmlParam_P	<> "" Then oXmlParam_P	= objEncrypter.Encrypt(oXmlParam_P)
			Set objEncrypter = Nothing
			On Error GoTo 0

			On Error Resume Next
			Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
			Dim LogPath2 : LogPath2 = Server.MapPath (CardLogss&"/mCard_") & Replace(Date(),"-","") & ".log"
			Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

				Sfile2.WriteLine chr(13)
				Sfile2.WriteLine "--- mCard PAY -------------------------------"
				Sfile2.WriteLine "Date : " & now()
				Sfile2.WriteLine "oXmlParam_P	: " & oXmlParam_P
				Sfile2.WriteLine "oXmlStatus_P	: " & oXmlStatus_P

				ALERT_MSG = ""
				ALERT_BR = "\n"

				Select Case oXmlStatus_P
					Case "200"

						'XML 파싱
						Set objMsXmlDom = Server.CreateObject("microsoft.XMLDOM")
							objMsXmlDom.async = False	' 동기식 호출
							objMsXmlDom.validateOnParse = false
							objMsXmlDom.loadXML(oResponse_P)

							result_cd	= "" & Trim(objMsXmlDom.getElementsByTagName("result_cd").Item(0).Text)			'결과 코드
							result_msg	= "" & Trim(objMsXmlDom.getElementsByTagName("result_msg").Item(0).Text)		'결과 메시지

							Sfile2.WriteLine "onfftid : "	& onfftid
							Sfile2.WriteLine "result_cd	: " & result_cd
							Sfile2.WriteLine "result_msg : " & result_msg

							transeq		= "" & Trim(objMsXmlDom.getElementsByTagName("transeq").Item(0).Text)			'결제 일련번호
							auth_no		= "" & Trim(objMsXmlDom.getElementsByTagName("auth_no").Item(0).Text)			'승인번호
							app_date	= "" & Trim(objMsXmlDom.getElementsByTagName("app_date").Item(0).Text)			'결제일시
							app_dt		= "" & Trim(objMsXmlDom.getElementsByTagName("app_dt").Item(0).Text)			'결제일
							app_tm		= "" & Trim(objMsXmlDom.getElementsByTagName("app_tm").Item(0).Text)			'결제시간
							tot_amt		= "" & Trim(objMsXmlDom.getElementsByTagName("tot_amt").Item(0).Text)			'결제금액(총 승인금액)
							order_no	= "" & Trim(objMsXmlDom.getElementsByTagName("order_no").Item(0).Text)			'주문번호
							iss_cd		= "" & Trim(objMsXmlDom.getElementsByTagName("iss_cd").Item(0).Text)			'신용카드사 코드
							iss_nm		= "" & Trim(objMsXmlDom.getElementsByTagName("iss_nm").Item(0).Text)			'신용카드사

						Set objMsXmlDom  = Nothing

						Sfile2.WriteLine "transeq		: "	& transeq
						Sfile2.WriteLine "auth_no		: "	& auth_no
						Sfile2.WriteLine "app_date		: "	& app_date
						Sfile2.WriteLine "app_dt		: "	& app_dt
						Sfile2.WriteLine "app_tm		: "	& app_tm
						Sfile2.WriteLine "tot_amt		: "	& tot_amt
						Sfile2.WriteLine "order_no		: "	& order_no
						Sfile2.WriteLine "iss_cd		: "	& iss_cd
						Sfile2.WriteLine "iss_nm		: "	& iss_nm
						Sfile2.WriteLine "---------------------------------------------"

					Case Else
						ALERT_MSG = "ErrorCode : "&oXmlStatus_P&""
						Sfile2.WriteLine "---ERROR2------------------------------------"
						Sfile2.WriteLine "ALERT_MSG	: " & ALERT_MSG
						Sfile2.WriteLine "---------------------------------------------"
						'Call ALERTS(ALERT_MSG,"GO",GO_BACK_ADDR)
						'Response.End
						'Exit Function

				End Select

				R_transeq		= transeq
				R_auth_no		= auth_no
				R_iss_cd		= iss_cd
				R_iss_nm		= iss_nm
				R_result_cd		= result_cd
				R_result_msg	= result_msg


				Sfile2.Close
			Set Fso2= Nothing
			Set objError= Nothing
			On Error Goto 0

	End Function





	'♠온오프코리아 복합 결제 취소
	Function PG_ONOFFKOREA_CANCEL_M(ByVal F_onfftid,  ByVal F_PGorderNum, ByVal F_orderNum, ByVal F_totalPrice, ByVal F_PGAcceptNum, ByVal F_PGAcceptDate)

			PG_ONOFFKOREA_CANCEL_M = True

			CardLogss	= "/PG/ONOFFKOREA/mCardShopAPI"

			onfftid_C = F_onfftid

			oXmlParam_C = ""
			oXmlParam_C = oXmlParam_C & "onfftid="&onfftid_C		'(필) 온오프코리아 TID
			oXmlParam_C = oXmlParam_C & "&method=cancel"			'(필) 승인취소 : cancel
			oXmlParam_C = oXmlParam_C & "&tot_amt="&F_totalPrice	'(선) 취소금액(원결제금액과동일)
			oXmlParam_C = oXmlParam_C & "&transeq="&F_PGorderNum	'(필) 원거래고유번호
			oXmlParam_C = oXmlParam_C & "&auth_no="&F_PGAcceptNum	'(필) 원승인번호
			oXmlParam_C = oXmlParam_C & "&app_dt="&F_PGAcceptDate	'(필) 원승인일자 (YYYYMMDD)
			oXmlParam_C = oXmlParam_C & "&order_no="&F_orderNum		'(선) 주문번호
			oXmlParam_C = oXmlParam_C & "&pay_type=card"			'(선) 결제타입	기본 신용카드 : card,  현금영수증 : cash

			''oXmlURL_C = "https://store.onoffkorea.co.kr/payment"				'절대 안됨!!!!!!!
			oXmlURL_C = "https://store.onoffkorea.co.kr/payment/index.php"

			Set oXmlhttp_C = server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

				oXmlhttp_C.setOption 2, 13056
				oXmlhttp_C.open "POST", oXmlURL_C, False
				oXmlhttp_C.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
				oXmlhttp_C.setRequestHeader "Accept-Language","UTF-8"
				oXmlhttp_C.setRequestHeader "CharSet", "UTF-8"
				oXmlhttp_C.setRequestHeader "Content", "text/html;charset=UTF-8"
				oXmlhttp_C.setRequestHeader "Content-Length", Len(oXmlParam_C)
				oXmlhttp_C.send oXmlParam_C

				oResponse_C  = oXmlhttp_C.responseText
				oXmlStatus_C = oXmlhttp_C.status

			Set oXmlhttp_C = Nothing '개체 소멸


			On Error Resume Next
			Dim Fso_C : Set  Fso_C=CreateObject("Scripting.FileSystemObject")
			Dim LogPath_C : LogPath_C = Server.MapPath (CardLogss&"/cMCard_") & Replace(Date(),"-","") & ".log"
			Dim Sfile_C : Set  Sfile_C = Fso_C.OpenTextFile(LogPath_C,8,true)
				Sfile_C.WriteLine chr(13)
				Sfile_C.WriteLine "Date : " & now()
				Sfile_C.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
				Sfile_C.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
				Sfile_C.WriteLine "THIS_PAGE_URL	: " & Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")
				Sfile_C.WriteLine "--- Card REFUND(CANCEL) --------------------"
				Sfile_C.WriteLine "oResponse_C	: "	& oResponse_C
				Sfile_C.WriteLine "oXmlStatus_C	: " & oXmlStatus_C

				ALERT_MSG = ""
				ALERT_BR = "\n"

					'XML 파싱
					Set objMsXmlDom_C = Server.CreateObject("microsoft.XMLDOM")
						objMsXmlDom_C.async = False	' 동기식 호출
						objMsXmlDom_C.validateOnParse = false
						objMsXmlDom_C.loadXML(oResponse_C)

						result_cd_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("result_cd").Item(0).Text)		'결과 코드
						result_msg_C= "" & Trim(objMsXmlDom_C.getElementsByTagName("result_msg").Item(0).Text)		'결과 메시지
						transeq_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("transeq").Item(0).Text)			'원거래고유번호
						app_date_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("app_date").Item(0).Text)		'승인일자(YYYYMMDD)
						app_dt_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("app_dt").Item(0).Text)			'승인일자
						app_tm_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("app_tm").Item(0).Text)			'승인시간
						tot_amt_C	= "" & Trim(objMsXmlDom_C.getElementsByTagName("tot_amt").Item(0).Text)			'취소금액

					Set objMsXmlDom_C  = Nothing

				Sfile_C.WriteLine "oXmlParam_C	: " & oXmlParam_C
				Sfile_C.WriteLine "F_onfftid	: " & F_onfftid
				Sfile_C.WriteLine "PGorderNum	: " & F_PGorderNum
				Sfile_C.WriteLine "orderNum		: " & F_orderNum
				Sfile_C.WriteLine "totalPrice	: " & F_totalPrice
				Sfile_C.WriteLine "PGAcceptNum	: " & F_PGAcceptNum
				Sfile_C.WriteLine "PGAcceptDate	: " & F_PGAcceptDate

				Sfile_C.WriteLine "result_cd	: " & result_cd_C
				Sfile_C.WriteLine "result_msg	: " & result_msg_C
				Sfile_C.WriteLine "transeq		: "	& transeq_C
				Sfile_C.WriteLine "app_date		: "	& app_date_C
				Sfile_C.WriteLine "app_dt		: "	& app_dt_C
				Sfile_C.WriteLine "app_tm		: "	& app_tm_C
				Sfile_C.WriteLine "tot_amt		: "	& tot_amt_C
				Sfile_C.WriteLine "CanCel_Msg	: " & ThisMsg
				Sfile_C.WriteLine "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

				Sfile_C.Close
			Set Fso_C= Nothing
			Set objError= Nothing
			On Error Goto 0

			If result_cd_C = "0000" Then
				PG_ONOFFKOREA_CANCEL_M = True
			Else
				PG_ONOFFKOREA_CANCEL_M = False
			End If

	End Function



	'♠온오프코리아 카드사코드 2019-10-15~
	Function ONOFFKOREA_CARDCODE(ByVal values)

		Select Case values
			Case "008"			: ONOFFKOREA_CARDCODE = "01"		'"외환"
			Case "045","047"	: ONOFFKOREA_CARDCODE = "03"		'"(신)롯데 / 롯데"
			Case "027"			: ONOFFKOREA_CARDCODE = "04"		'"현대"
			Case "016"			: ONOFFKOREA_CARDCODE = "06"		'"국민"
			Case "026"			: ONOFFKOREA_CARDCODE = "11"		'"비씨"
			Case "031"			: ONOFFKOREA_CARDCODE = "12"		'"삼성"
			Case "029"			: ONOFFKOREA_CARDCODE = "14"		'"신한"
			Case "018"			: ONOFFKOREA_CARDCODE = "16"		'"농협"
			Case "006"			: ONOFFKOREA_CARDCODE = "17"		'"하나"
			Case "010"			: ONOFFKOREA_CARDCODE = "18"		'"전북"
			Case "021"			: ONOFFKOREA_CARDCODE = "19"		'"우리"
			Case "002"			: ONOFFKOREA_CARDCODE = "28"		'"광주"
			Case "022","034"	: ONOFFKOREA_CARDCODE = "30"		'"씨티은행 / 씨티"
			Case "017"			: ONOFFKOREA_CARDCODE = "32"		'"수협"
			Case "011"			: ONOFFKOREA_CARDCODE = "33"		'"제주"
			Case "기타"			: ONOFFKOREA_CARDCODE = "99"		'"기타"
			Case Else			: ONOFFKOREA_CARDCODE = "99"		'Else
		End Select

	End Function


	'♠온오프코리아 현금영수증 발급(가상계좌 입금시) 미완(CS 업데이트 후!!)
	Function PG_ONOFFKOREA_CASH_RECEIPT(F_onfftid, vBankAmt, CSORDERNUM)

		On Error Resume Next
			'▣ 현금영수증 신고 정보
			arrParams = Array(_
				Db.makeParam("@orderNum",adVarChar,adParamInput,20,CSORDERNUM) _
			)
			Set HJRS = DB.execRs("HJSP_VBANK_INFOS_FOR_CASH_RECEIPT",DB_PROC,arrParams,DB3)
			If Not HJRS.BOF And Not HJRS.EOF Then
				HJRS_wcc								= HJRS("C_HY_Division")				'신청구분 (0:개인소득공제용, 1:사업자용)
				HJRS_card_user_type			= HJRS("C_HY_Number_Division")'신청번호구분 (0:휴대전화, 1:주민번호, 2:현금영수증카드번호, 3:사업자등록번호)
				HJRS_cash_report_number	= HJRS("C_HY_SendNum")				'현금영수증 신청번호

				HJRS_user_nm						= HJRS("C_Name2")
				HJRS_user_phone2				= HJRS("Get_Tel2")
				HJRS_product_nm					= HJRS("name")

				On Error Resume Next
				Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
					objEncrypter.Key = con_EncryptKey
					objEncrypter.InitialVector = con_EncryptKeyIV
					If HJRS_cash_report_number <> "" Then HJRS_cash_report_number	 = objEncrypter.Decrypt(HJRS_cash_report_number)
					If HJRS_user_phone2 <> "" Then HJRS_user_phone2	 = objEncrypter.Decrypt(HJRS_user_phone2)
				Set objEncrypter = Nothing
				On Error Goto 0

				'신청구분 치환
				Select Case HJRS_wcc
					Case "0" : HJRS_wcc = "01"		'소득공제(개인)
					Case "2" : HJRS_wcc = "02"		'지출증빙(사업자)
					Case Else : HJRS_wcc = ""
				End Select

				'신청번호구분 치환
				Select Case HJRS_card_user_type
					Case "0" : card_user_type = "03"		'휴대전화
					Case "1" : card_user_type = "02"		'주민번호
					Case "3" : card_user_type = "04"		'사업자번호
					Case Else : card_user_type = ""
				End Select

				'현금영수증 신청번호 복호화
				If HJRS_cash_report_number <> "" Then HJRS_cash_report_number = Replace(HJRS_cash_report_number,"-","")

			End IF
			Call closeRS(HJRS)
		On Error Goto 0

		'Call ResRW(HJRS_wcc,"HJRS_wcc")
		'Call ResRW(HJRS_cash_report_number,"HJRS_cash_report_number")
		'Call ResRW(HJRS_user_nm,"HJRS_user_nm")
		'Call ResRW(HJRS_user_phone2,"HJRS_user_phone2")
		'Call ResRW(HJRS_product_nm,"HJRS_product_nm")

		IF HJRS_wcc = "" Or HJRS_cash_report_number = "" Then
			Print "Exit Func"
			Exit Function
		End If

		oXmlParam = ""
		oXmlParam = oXmlParam & "onfftid="&F_onfftid		'(필) 온오프코리아 TID
		oXmlParam = oXmlParam & "&tot_amt="&vBankAmt		'(필) 결제금액
		oXmlParam = oXmlParam & "&wcc="&HJRS_wcc		'(필) 발행용도 01:소득공제 02:지출증빙 03:자진발급
		oXmlParam = oXmlParam & "&card_user_type="&card_user_type	'(필) 인증구분 02:주민번호 03:휴대폰번호 04:사업자번호
		oXmlParam = oXmlParam & "&card_no="&HJRS_cash_report_number	'(필) 인증번호 card_user_type(인증구분) 데이터(휴대폰번호/사업자번호)
		oXmlParam = oXmlParam & "&user_nm="&HJRS_user_nm	'(필) 고객명
		oXmlParam = oXmlParam & "&user_phone2="&HJRS_user_phone2	'(필) 고객연락처
		oXmlParam = oXmlParam & "&product_nm="&HJRS_product_nm		'(필) 상품명
		oXmlParam = oXmlParam & "&pay_type=cash"			'(필) 결제타입 현금영수증 : cash
		oXmlParam = oXmlParam & "&order_no="&CSORDERNUM		'(선) 주문번호

		oXmlURL = "https://store.onoffkorea.co.kr/payment/index.php"

		Set oXmlhttp = server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

			oXmlhttp.setOption 2, 13056
			oXmlhttp.open "POST", oXmlURL, False
			oXmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
			oXmlhttp.setRequestHeader "Accept-Language","UTF-8"
			oXmlhttp.setRequestHeader "CharSet", "UTF-8"
			oXmlhttp.setRequestHeader "Content", "text/html;charset=UTF-8"
			oXmlhttp.setRequestHeader "Content-Length", Len(oXmlParam)
			oXmlhttp.send oXmlParam

			oResponse  = oXmlhttp.responseText
			oXmlStatus = oXmlhttp.status

		Set oXmlhttp = Nothing '개체 소멸
		'Call ResRW(oXmlParam,"oXmlParam")
		'Call ResRW(oResponse,"oResponse")
		'Call ResRW(oXmlStatus,"oXmlStatus")

		'XML 파싱
		Set objMsXmlDom = Server.CreateObject("microsoft.XMLDOM")
			objMsXmlDom.async = False	' 동기식 호출
			objMsXmlDom.validateOnParse = false
			objMsXmlDom.loadXML(oResponse)

			result_cd	= "" & Trim(objMsXmlDom.getElementsByTagName("result_cd").Item(0).Text)		'결과 코드
			result_msg= "" & Trim(objMsXmlDom.getElementsByTagName("result_msg").Item(0).Text)		'결과 메시지
			transeq	= "" & Trim(objMsXmlDom.getElementsByTagName("transeq").Item(0).Text)			'원거래고유번호
			auth_no	= "" & Trim(objMsXmlDom.getElementsByTagName("auth_no").Item(0).Text)			'승인번호
			app_date	= "" & Trim(objMsXmlDom.getElementsByTagName("app_date").Item(0).Text)		'승인일자(YYYYMMDDHHMMSS)
			app_dt	= "" & Trim(objMsXmlDom.getElementsByTagName("app_dt").Item(0).Text)			'승인일자(YYYYMMDD)
			app_tm	= "" & Trim(objMsXmlDom.getElementsByTagName("app_tm").Item(0).Text)			'승인시간
			tot_amt	= "" & Trim(objMsXmlDom.getElementsByTagName("tot_amt").Item(0).Text)			'승인금액
			order_no	= "" & Trim(objMsXmlDom.getElementsByTagName("order_no").Item(0).Text)			'주문번호
		Set objMsXmlDom  = Nothing

		On Error Resume Next
			Dim Fso : Set  Fso=CreateObject("Scripting.FileSystemObject")
			Dim LogPath : LogPath = Server.MapPath ("/PG/ONOFFKOREA/vBankShopAPI/cReceipt_") & Replace(Date(),"-","") & ".log"
			Dim Sfile : Set  Sfile = Fso.OpenTextFile(LogPath,8,true)
				Sfile.WriteLine chr(13)
				Sfile.WriteLine "Date : " & now()
				Sfile.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
				Sfile.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
				Sfile.WriteLine "THIS_PAGE_URL	: " & Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")
				Sfile.WriteLine "--- Cash Receipt --------------------"
				Sfile.WriteLine "oResponse	: "	& oResponse
				Sfile.WriteLine "oXmlStatus	: " & oXmlStatus
				Sfile.WriteLine "F_onfftid	: " & F_onfftid
				Sfile.WriteLine "vBankAmt	: " & vBankAmt
				Sfile.WriteLine "CSORDERNUM		: " & CSORDERNUM
				Sfile.WriteLine "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
				Sfile.Close
			Set Fso= Nothing
			Set objError= Nothing
		On Error Goto 0

		If result_cd = "0000" Then

			auth_no = transeq		'승인번호를 거래번호로

			'◆ 현금영수증 승인번호(거래번호) UPDATE
			SQL_CU = "UPDATE [tbl_Sales_Cacu] SET [C_HY_ApNum] = ?, [C_HY_Date] = ? "
			SQL_CU = SQL_CU& " WHERE [OrderNumber] = ? And [C_TF] = 5 "
			arrParamsCU = Array(_
				Db.makeParam("@C_HY_ApNum",adVarChar,adParamInput,50,auth_no), _
				Db.makeParam("@C_HY_Date",adVarChar,adParamInput,10,app_dt), _
				Db.makeParam("@ORDERNUMBER",adVarChar,adParamInput,20,CSORDERNUM) _
			)
			Call Db.exec(SQL_CU,DB_TEXT,arrParamsCU,DB3)

		End If

	End Function

%>

<%
'● 다우(키움)페이 K모듈 취소 함수 S
'●  Server.CreateObject 확인!!


	log_CardCancel = "cardCancel"


	'다우(키움)페이 K모듈 취소 함수 S

	Function PG_DAOU_K_CANCEL(ByVal F_CardOrderNo, ByVal F_AMOUNT	, ByVal F_isDirect, ByVal F_GoodIDX, ByVal F_chgPage		, ByRef F_errMsg)

		'isDirect or Cart 체크 (GO_BACK_ADDR)
		If F_isDirect = "T" Then
			F_GO_BACK_ADDR = F_chgPage&"/shop/detailView.asp?gidx="&F_GoodIDX
		Else
			F_GO_BACK_ADDR = F_chgPage&"/shop/cart.asp"
		End If

		PG_DAOU_K_CANCEL = True

		Set daou = Server.CreateObject("CardDaouPay.CardAgentAPI.1")

		DAOUTRX		= F_CardOrderNo
		AMOUNT		= F_AMOUNT
		CANCELMEMO	= F_errMsg

		ret = daou.CardCancel(CP_ID       , _
			DAOUTRX     , _
			AMOUNT      , _
			CANCELMEMO  , _
			r_RESULTCODE, _
			r_ERRORMESSA, _
			r_DAOUTRX   , _
			r_AMOUNT    , _
			r_CANCELDATE _
		)

		On Error Resume Next
		Dim Fso00 : Set  Fso00 = CreateObject("Scripting.FileSystemObject")
		Dim LogPath00 : LogPath00 = Server.MapPath ("/PG/DAOU/"&log_CardCancel&"/log_") & Replace(Date(),"-","") & ".log"
		Dim Sfile00 : Set  Sfile00 = Fso00.OpenTextFile(LogPath00,8,true)
			Sfile00.WriteLine "--- Card Cancel Result "& now() &"-----------------------------"
			Sfile00.WriteLine "Date			: "	& now()
			Sfile00.WriteLine "Domain			: "	& Request.ServerVariables("HTTP_HOST")
			Sfile00.WriteLine "Browser			: "	& Request.ServerVariables("HTTP_USER_AGENT")

			Sfile00.WriteLine "CP_ID			: "	& CP_ID
			Sfile00.WriteLine "OrderNo			: "	& OrderNo
			Sfile00.WriteLine "DAOUTRX			: "	& DAOUTRX
			Sfile00.WriteLine "AMOUNT			: "	& AMOUNT
			Sfile00.WriteLine "CANCELMEMO		: "	& CANCELMEMO

			Sfile00.WriteLine "ret			: "	& ret & "[" & daou.GETERRORMSG(ret) & "]"
			Sfile00.WriteLine "r_RESULTCODE		: "	& r_RESULTCODE
			Sfile00.WriteLine "r_ERRORMESSA		: " & r_ERRORMESSA
			Sfile00.WriteLine "r_ORDERNO		: " & ORDERNO
			Sfile00.WriteLine "r_AMOUNT		: " & r_AMOUNT
			Sfile00.WriteLine "r_CANCELDATE		: " & r_CANCELDATE
			Sfile00.WriteLine "r_DAOUTRX		: " & r_DAOUTRX
			Sfile00.WriteLine "F_errMsg		: " & F_errMsg
			Sfile00.WriteLine "---------------------------------------------"
			Sfile00.WriteLine chr(13)
			Sfile00.WriteLine chr(13)
			Sfile00.Close
		Set Fso00= Nothing
		Set objError= Nothing


		'F_errMsg = r_RESULTCODE
				'PRINT "{""statusCode"":"""&r_RESULTCODE&""",""message"":"""&r_ERRORMESSA&""",""result"":{""PGTRX"":"""&r_DAOUTRX&""",""ORDERNO"":"""&ORDERNO&""",""AMOUNT"":"""&r_AMOUNT&""",""CANCELDATE"":"""&r_CANCELDATE&"""}}"
		If r_RESULTCODE = "0000" Then
			Call ALERTS("데이터 처리중 오류가 발생하여 카드결제를 취소하였습니다\n\n취소사유 : "&F_errMsg,"GO",F_GO_BACK_ADDR)
		Else
			Call ALERTS("카드취소중 오류가 발생하였습니다. 결제취소가 정상적으로 이루어 지지 않은 경우 업체에 문의해주세요","GO",F_GO_BACK_ADDR)
		End If

	End Function

%>
<%
'● 다우(키움)페이 D모듈 취소 함수 S
'●  Server.CreateObject 확인!!
'●  CANCELIP			 취소IP확인!!


	Function PG_DAOU_DMODULE_CANCEL(ByVal F_CardOrderNo, ByVal F_AMOUNT	, ByVal F_isDirect, ByVal F_GoodIDX, ByVal F_chgPage		, ByRef F_errMsg)

		'isDirect or Cart 체크 (GO_BACK_ADDR)
		If F_isDirect = "T" Then
			F_GO_BACK_ADDR = F_chgPage&"/shop/detailView.asp?gidx="&F_GoodIDX
		Else
			F_GO_BACK_ADDR = F_chgPage&"/shop/cart.asp"
		End If

		PG_DAOU_DMODULE_CANCEL = True

'		Set daou = Server.CreateObject("CardDaouPay.CardAgentAPI.1")		'K모듈
		Set daou = Server.CreateObject("DCardDaouPay.DCardAgentAPI.1")		'D모듈(2019-02-15~)

		CP_ID		= CP_ID
		DAOUTRX		= F_CardOrderNo
		AMOUNT		= F_AMOUNT
		CANCELIP    = Request.ServerVariables("REMOTE_ADDR")				'D모듈추가(2019-02-15~) ### 없으면 서버로그 반응 없음!!!!! ###
		CANCELMEMO	= Left(F_errMsg,50)

		ret = daou.CardCancel(CP_ID       , _
			DAOUTRX     , _
			AMOUNT      , _
				CANCELIP	, _
			CANCELMEMO  , _
			r_RESULTCODE, _
			r_ERRORMESSA, _
			r_DAOUTRX   , _
			r_AMOUNT    , _
			r_CANCELDATE _
		)

			On Error Resume Next
			Dim Fso00 : Set  Fso00 = CreateObject("Scripting.FileSystemObject")
			Dim LogPath00 : LogPath00 = Server.MapPath ("/PG/DAOU/"&log_CardCancel&"/log_") & Replace(Date(),"-","") & ".log"
			Dim Sfile00 : Set  Sfile00 = Fso00.OpenTextFile(LogPath00,8,true)
				Sfile00.WriteLine "--- Card Cancel Result "& now() &"-----------------------------"
				Sfile00.WriteLine "Date				: "	& now()
				Sfile00.WriteLine "Domain			: "	& Request.ServerVariables("HTTP_HOST")
				Sfile00.WriteLine "Browser			: "	& Request.ServerVariables("HTTP_USER_AGENT")
				Sfile00.WriteLine "IPADDRESS		: "	& IPADDRESS
				Sfile00.WriteLine "CANCELIP		: "	& CANCELIP
				Sfile00.WriteLine "OrderNo			: "	& OrderNo

				Sfile00.WriteLine "CP_ID			: "	& CP_ID
				Sfile00.WriteLine "DAOUTRX			: "	& DAOUTRX
				Sfile00.WriteLine "AMOUNT			: "	& AMOUNT
				Sfile00.WriteLine "CANCELMEMO		: "	& CANCELMEMO

				Sfile00.WriteLine "ret				: "	& ret & "[" & daou.GETERRORMSG(ret) & "]"
				Sfile00.WriteLine "r_RESULTCODE		: "	& r_RESULTCODE
				Sfile00.WriteLine "r_ERRORMESSA		: " & r_ERRORMESSA
				Sfile00.WriteLine "r_ORDERNO		: " & ORDERNO
				Sfile00.WriteLine "r_AMOUNT			: " & r_AMOUNT
				Sfile00.WriteLine "r_CANCELDATE		: " & r_CANCELDATE
				Sfile00.WriteLine "r_DAOUTRX		: " & r_DAOUTRX
				Sfile00.WriteLine "F_errMsg			: " & F_errMsg
				Sfile00.WriteLine "---------------------------------------------"

				Sfile00.WriteLine chr(13)
				Sfile00.WriteLine chr(13)
				Sfile00.Close
			Set Fso00= Nothing
			Set objError= Nothing

		Set daou = Nothing


		'F_errMsg = r_RESULTCODE
				'PRINT "{""statusCode"":"""&r_RESULTCODE&""",""message"":"""&r_ERRORMESSA&""",""result"":{""PGTRX"":"""&r_DAOUTRX&""",""ORDERNO"":"""&ORDERNO&""",""AMOUNT"":"""&r_AMOUNT&""",""CANCELDATE"":"""&r_CANCELDATE&"""}}"
		If r_RESULTCODE = "0000" Then
			Call ALERTS("데이터 처리중 오류가 발생하여 카드결제를 취소하였습니다\n\n취소사유 : "&F_errMsg,"GO",F_GO_BACK_ADDR)
		Else
			Call ALERTS("카드취소중 오류가 발생하였습니다. 결제취소가 정상적으로 이루어 지지 않은 경우 업체에 문의해주세요","GO",F_GO_BACK_ADDR)
		End If

	End Function



%>
<%
'KSNET 취소

	Function PG_KSNET_CANCEL(ByVal F_PG_IDS, ByVal F_PGorderNum, ByVal F_GoodIDX, ByVal F_isDirect, ByVal F_chgPage , ByRef F_errMsg)

		If F_isDirect = "M" Then		'myoffice 결제
			If F_chgPage = "/m" Then
				F_chgPage = "/m"
			Else
				F_chgPage = "/myoffice"
			End If
			F_GO_BACK_ADDR = F_chgPage&"/buy/cart.asp"

		Else							'SHOP 결제

			If F_isDirect = "T" Then
				F_GO_BACK_ADDR = F_chgPage&"/shop/detailView.asp?gidx="&F_GoodIDX
			Else
				F_GO_BACK_ADDR = F_chgPage&"/shop/cart.asp"
			End If

		End If

			oXmlParam_C = ""
			oXmlParam_C = oXmlParam_C & "TX_KSNET_TID="&F_PG_IDS			'(필) 상점아이디
			oXmlParam_C = oXmlParam_C & "&F_PGorderNum="&F_PGorderNum		'(필) 거래번호

			'oXmlURL_C = "http://byonglobal.com/PG/KSNET/Cancel.asp"
			oXmlURL_C = HTTPS&"://"&houUrl&"/PG/KSNET/Cancel.asp"

			Set oXmlhttp_C = server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

				oXmlhttp_C.setOption 2, 13056
				oXmlhttp_C.open "POST", oXmlURL_C, False
				oXmlhttp_C.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
				oXmlhttp_C.setRequestHeader "Accept-Language","UTF-8"
				oXmlhttp_C.setRequestHeader "CharSet", "UTF-8"
				oXmlhttp_C.setRequestHeader "Content", "text/html;charset=UTF-8"
				oXmlhttp_C.setRequestHeader "Content-Length", Len(oXmlParam_C)
				oXmlhttp_C.send oXmlParam_C

				oResponse_C  = oXmlhttp_C.responseText
				oXmlStatus_C = oXmlhttp_C.status

			Set oXmlhttp_C = Nothing '개체 소멸

			'Call ResRW(oResponse_C,"oResponse_C")
			'Call ResRW(oXmlStatus_C,"oXmlStatus_C")


			On Error Resume Next
			Dim Fso_C : Set  Fso_C=CreateObject("Scripting.FileSystemObject")
			Dim LogPath_C : LogPath_C = Server.MapPath ("cardCancel/te_") & Replace(Date(),"-","") & ".log"
			Dim Sfile_C : Set  Sfile_C = Fso_C.OpenTextFile(LogPath_C,8,true)
				Sfile_C.WriteLine chr(13)
				Sfile_C.WriteLine "--- Card Cancel Status(CANCEL) --------------------"
				Sfile_C.WriteLine "mbid1	: " & DK_MEMBER_ID1
				Sfile_C.WriteLine "mbid2	: " & DK_MEMBER_ID2
				Sfile_C.WriteLine "sndStoreid	: " & F_PG_IDS
				Sfile_C.WriteLine "TransactionNo	: " & F_PGorderNum
				Sfile_C.WriteLine "oResponse_C	: "	& oResponse_C
				Sfile_C.WriteLine "oXmlStatus_C	: " & oXmlStatus_C
				ALERT_MSG = ""
				ALERT_BR = "\n"
				Sfile_C.Close
			Set Fso_C= Nothing
			Set objError= Nothing
			On Error Goto 0


			Dim aInfo : Set aInfo = JSON.parse(Join(Array(oResponse_C)))



			'print bXmlStatus
			If oXmlStatus_C >= 400 And oXmlStatus_C <= 599 Then
				errorMsg = aInfo.rMessage1
				Response.Write "<script type='text/javascript'>"
				Response.Write "alert('PG 연결에 문제가 발생했습니다. \n\n에러내용은 : "&errorMsg&" 입니다1');"
				Response.Write "location.href="""&F_GO_BACK_ADDR&""";"
				Response.Write "</script>"
				Response.End
			Else
				'aInfo_rSendSoket				= aInfo.rSendSoket			'
				aInfo_rStatus					= aInfo.rStatus				'' 상태 O : 승인, X : 거절
				aInfo_rAuthNo					= aInfo.rAuthNo				'' 승인번호 or 거절시 오류코드
				aInfo_rMessage1					= aInfo.rMessage1			'' 메시지1
				aInfo_rMessage2					= aInfo.rMessage2			'' 메시지2

				aInfo_rAuthNo   = Trim(aInfo_rAuthNo)
				aInfo_rMessage1 = Trim(aInfo_rMessage1)
				aInfo_rMessage2 = Trim(aInfo_rMessage2)
			End If


		If aInfo_rStatus = "O" Then

			If aInfo_rAuthNo = "" Then
				Call ALERTS("카드취소중 오류가 발생하였습니다. 결제취소가 정상적으로 이루어 지지 않은 경우 업체에 문의해주세요\n\nresult_msg : "&aInfo_rMessage1&" : "&aInfo_rMessage2 ,"GO",F_GO_BACK_ADDR)
			Else
				Call ALERTS("데이터 처리중 오류가 발생하여 카드결제를 취소하였습니다\n\n취소사유 : "&F_errMsg,"GO",F_GO_BACK_ADDR)
			End If

		Else
			Call ALERTS("카드취소중 오류가 발생하였습니다. 결제취소가 정상적으로 이루어 지지 않은 경우 업체에 문의해주세요\n\nresult_msg : "&aInfo_rMessage1&" : "&aInfo_rMessage2 ,"GO",F_GO_BACK_ADDR)
		End If

	End Function




'♠KSNET 복합 결제 취소
	Function PG_KSNET_CANCEL_M(ByVal F_PG_IDS, ByVal F_PGorderNum, ByVal F_orderNum, ByVal F_totalPrice, ByVal F_PGAcceptNum, ByVal F_PGAcceptDate)

			PG_KSNET_CANCEL_M = True

			CardLogss	= "/PG/KSNET/mCardShopAPI"

			oXmlParam_C = ""
			oXmlParam_C = oXmlParam_C & "TX_KSNET_TID="&F_PG_IDS			'(필) 상점아이디
			oXmlParam_C = oXmlParam_C & "&F_PGorderNum="&F_PGorderNum		'(필) 거래번호

			'oXmlURL_C = "http://byonglobal.com/PG/KSNET/Cancel.asp"
			oXmlURL_C = HTTPS&"://"&houUrl&"/PG/KSNET/Cancel.asp"

			Set oXmlhttp_C = server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

				oXmlhttp_C.setOption 2, 13056
				oXmlhttp_C.open "POST", oXmlURL_C, False
				oXmlhttp_C.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
				oXmlhttp_C.setRequestHeader "Accept-Language","UTF-8"
				oXmlhttp_C.setRequestHeader "CharSet", "UTF-8"
				oXmlhttp_C.setRequestHeader "Content", "text/html;charset=UTF-8"
				oXmlhttp_C.setRequestHeader "Content-Length", Len(oXmlParam_C)
				oXmlhttp_C.send oXmlParam_C

				oResponse_C  = oXmlhttp_C.responseText
				oXmlStatus_C = oXmlhttp_C.status

			Set oXmlhttp_C = Nothing '개체 소멸

			'Call ResRW(oResponse_C,"oResponse_C")
			'Call ResRW(oXmlStatus_C,"oXmlStatus_C")


			On Error Resume Next
			Dim Fso_C : Set  Fso_C=CreateObject("Scripting.FileSystemObject")
			Dim LogPath_C : LogPath_C = Server.MapPath (CardLogss&"/cMCard_") & Replace(Date(),"-","") & ".log"
			Dim Sfile_C : Set  Sfile_C = Fso_C.OpenTextFile(LogPath_C,8,true)
				Sfile_C.WriteLine chr(13)
				Sfile_C.WriteLine "--- Card Cancel Status(CANCEL) --------------------"
				Sfile_C.WriteLine "Date : " & now()
				Sfile_C.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
				Sfile_C.WriteLine "Browser : " & Request.ServerVariables("HTTP_USER_AGENT")
				Sfile_C.WriteLine "THIS_PAGE_URL	: " & Request.ServerVariables("URL")&"?"&Request.ServerVariables("QUERY_STRING")
				Sfile_C.WriteLine "mbid1	: " & DK_MEMBER_ID1
				Sfile_C.WriteLine "mbid2	: " & DK_MEMBER_ID2
				Sfile_C.WriteLine "sndStoreid	: " & F_PG_IDS
				Sfile_C.WriteLine "TransactionNo	: " & F_PGorderNum
				Sfile_C.WriteLine "oResponse_C	: "	& oResponse_C
				Sfile_C.WriteLine "oXmlStatus_C	: " & oXmlStatus_C
				ALERT_MSG = ""
				ALERT_BR = "\n"

				Dim aInfo : Set aInfo = JSON.parse(Join(Array(oResponse_C)))


				'print bXmlStatus
				If oXmlStatus_C >= 400 And oXmlStatus_C <= 599 Then
					errorMsg = aInfo.rMessage1
					'Response.Write "<script type='text/javascript'>"
					'Response.Write "alert('PG 연결에 문제가 발생했습니다. \n\n에러내용은 : "&errorMsg&" 입니다1');"
					'Response.Write "location.href="""&F_GO_BACK_ADDR&""";"
					'Response.Write "</script>"
					'Response.End
					aInfo_rStatus = ""
					aInfo_rAuthNo = ""
				Else
					'aInfo_rSendSoket				= aInfo.rSendSoket			'
					aInfo_rStatus					= aInfo.rStatus				'' 상태 O : 승인, X : 거절
					aInfo_rAuthNo					= aInfo.rAuthNo				'' 승인번호 or 거절시 오류코드
					aInfo_rMessage1					= aInfo.rMessage1			'' 메시지1
					aInfo_rMessage2					= aInfo.rMessage2			'' 메시지2

					aInfo_rAuthNo   = Trim(aInfo_rAuthNo)
					aInfo_rMessage1 = Trim(aInfo_rMessage1)
					aInfo_rMessage2 = Trim(aInfo_rMessage2)
				End If

				Sfile_C.WriteLine "oXmlParam_C	: " & oXmlParam_C
				Sfile_C.WriteLine "F_PG_IDS	: " & F_PG_IDS
				Sfile_C.WriteLine "PGorderNum	: " & F_PGorderNum
				Sfile_C.WriteLine "orderNum		: " & F_orderNum
				Sfile_C.WriteLine "totalPrice	: " & F_totalPrice
				Sfile_C.WriteLine "PGAcceptNum	: " & F_PGAcceptNum
				Sfile_C.WriteLine "PGAcceptDate	: " & F_PGAcceptDate

				Sfile_C.WriteLine "aInfo_rStatus	: " & aInfo_rStatus
				Sfile_C.WriteLine "aInfo_rAuthNo	: " & aInfo_rAuthNo
				Sfile_C.WriteLine "aInfo_rMessage1		: "	& aInfo_rMessage1
				Sfile_C.WriteLine "aInfo_rMessage2		: "	& aInfo_rMessage2
				Sfile_C.WriteLine "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
				Sfile_C.Close
			Set Fso_C= Nothing
			Set objError= Nothing
			On Error Goto 0


		If aInfo_rStatus = "O" And aInfo_rAuthNo <> "" Then
			PG_KSNET_CANCEL_M = True
		Else
			PG_KSNET_CANCEL_M = False
		End If

	End Function
%>

<%
	'KSNET 다카드 결제
	Function PG_KSNET_PAY_M(ByVal V_oXmlParam_P, ByVal V_GO_BACK_ADDR, ByRef R_rStatus, ByRef R_rAuthNo, ByRef R_rMessage1, ByRef R_rMessage2 , ByRef R_rTransactionNo, ByRef R_rInstallment, ByRef R_rIssCode, ByRef R_rTradeDate, ByRef R_StoreId)

		oXmlURL_P = HTTPS&"://"&houUrl&"/PG/KSNET/mCardPay.asp"
		oXmlParam_P = V_oXmlParam_P

		Set oXmlhttp_P = server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

			oXmlhttp_P.setOption 2, 13056
			oXmlhttp_P.open "POST", oXmlURL_P, False
			oXmlhttp_P.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
			oXmlhttp_P.setRequestHeader "Accept-Language","UTF-8"
			oXmlhttp_P.setRequestHeader "CharSet", "UTF-8"
			oXmlhttp_P.setRequestHeader "Content", "text/html;charset=UTF-8"
			oXmlhttp_P.setRequestHeader "Content-Length", Len(oXmlParam_P)
			oXmlhttp_P.send oXmlParam_P

			oResponse_P  = oXmlhttp_P.responseText
			oXmlStatus_P = oXmlhttp_P.status

		Set oXmlhttp_P = Nothing '개체 소멸

		'Call ResRW(oResponse_P,"oResponse_P")
		'Call ResRW(oXmlStatus_P,"oXmlStatus_P")

		On Error Resume Next
			'Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			'	objEncrypter.Key = con_EncryptKey
			'	objEncrypter.InitialVector = con_EncryptKeyIV
			'	If oXmlParam_P	<> "" Then oXmlParam_P	= objEncrypter.Encrypt(oXmlParam_P)
			'Set objEncrypter = Nothing

			Dim Fso_P : Set  Fso_P=CreateObject("Scripting.FileSystemObject")
			Dim LogPath_P : LogPath_P = Server.MapPath ("mCardShopAPI/mCardPay_") & Replace(Date(),"-","") & ".log"
			Dim Sfile_P : Set  Sfile_P = Fso_P.OpenTextFile(LogPath_P,8,true)
				Sfile_P.WriteLine chr(13)
				Sfile_P.WriteLine "--- mCardPay Status [PG_KSNET_PAY_M]--------------------"
				'Sfile_P.WriteLine "oXmlParam_P	: " & oXmlParam_P
				Sfile_P.WriteLine "oResponse_P	: "	& oResponse_P
				Sfile_P.WriteLine "oXmlStatus_P	: " & oXmlStatus_P

				Sfile_P.Close
			Set Fso_P= Nothing
			Set objError= Nothing
		On Error Goto 0

		Dim aInfo : Set aInfo = JSON.parse(Join(Array(oResponse_P)))

		If oXmlStatus_P >= 400 And oXmlStatus_P <= 599 Then
			errorMsg = aInfo.rMessage1
			Response.Write "<script type='text/javascript'>"
			Response.Write "alert('PG 연결에 문제가 발생했습니다. \n\n에러내용은 : "&errorMsg&" 입니다1');"
			Response.Write "location.href="""&V_GO_BACK_ADDR&""";"
			Response.Write "</script>"
			Response.End
		Else

			R_rStatus			= aInfo.rStatus				' 상태 O : 승인, X : 거절
			R_rAuthNo			= aInfo.rAuthNo				' 승인번호 or 거절시 오류코드
			R_rMessage1			= aInfo.rMessage1			' 메시지1
			R_rMessage2			= aInfo.rMessage2			' 메시지2
			R_rTransactionNo	= aInfo.rTransactionNo		' 거래번호
			R_rInstallment		= aInfo.rInstallment		' 할부
			R_rIssCode			= aInfo.rIssCode			' 발급사코드
			R_rTradeDate		= aInfo.rTradeDate			' 거래일자
			R_StoreId		  	= aInfo.StoreId

		End If

	End Function
%>
<%

'♠YESPAY 즉시취소
	Function PG_YESPAY_CANCEL(ByVal F_PGorderNum, ByVal F_orderNum, ByVal F_totalPrice , ByVal F_isDirect, ByVal F_GoodIDX, ByVal F_chgPage , ByRef F_errMsg)

		'isDirect or Cart 체크 (GO_BACK_ADDR)
		If F_isDirect = "T" Then
			F_GO_BACK_ADDR = F_chgPage&"/shop/detailView.asp?gidx="&F_GoodIDX
		Else
			F_GO_BACK_ADDR = F_chgPage&"/shop/cart.asp"
		End If

		cXmlParam = ""
		cXmlParam = cXmlParam & "orgOrderNo="&F_PGorderNum		'pg주문번호
		cXmlParam = cXmlParam & "&orgPayAmount="&F_totalPrice	'결제금액
		cXmlParam = cXmlParam & "&orgComOrderNo="&F_orderNum	'업체주문번호
		cXmlParam = cXmlParam & "&memManageNo="&TX_YESPAY_TID
		cXmlParam = cXmlParam & "&receiveType=json"				'결과 return 방식 json, xml, url
		cXmlParam = cXmlParam & "&receiveUrl="					'결과를 url 로 전송받을 경우 결과를 받을 주소입니다. http://를 포함한 full 주소를 입력하세요
		cXmlParam = cXmlParam & "&sendSMS=N"					'결제성공시 구매자휴대폰 번호로 SMS 발신여부 'Y' or 'N' ,  기본 발송안함

		cXmlURL = "http://yespay.kr/extLink/requestCancel_utf8.asp"

		Set cXmlhttp = Server.CreateObject("Msxml2.ServerXMLHTTP")

			cXmlhttp.setOption 2, 13056
			cXmlhttp.open "POST", cXmlURL, False
			cXmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
			cXmlhttp.setRequestHeader "Accept-Language","UTF-8"
			cXmlhttp.setRequestHeader "CharSet", "UTF-8"
			cXmlhttp.setRequestHeader "Content", "text/html;charset=UTF-8"
			cXmlhttp.setRequestHeader "Content-Length", Len(cXmlParam)
			cXmlhttp.send cXmlParam

			cResponse = cXmlhttp.responseText
			cXmlStatus = cXmlhttp.status

		Set cXmlhttp = Nothing '개체 소멸

		'Call ResRW(cResponse,"cResponse")
		'Call ResRW(cXmlStatus,"cXmlStatus")


		Dim cInfo : Set cInfo = JSON.parse(Join(Array(cResponse)))

		On Error Resume Next
		Dim Fso_C : Set  Fso_C=CreateObject("Scripting.FileSystemObject")
		Dim LogPath_C : LogPath_C = Server.MapPath("cardCancel/CResult_") & Replace(Date(),"-","") & ".log"
		Dim Sfile_C : Set  Sfile_C = Fso_C.OpenTextFile(LogPath_C,8,true)

			Sfile_C.WriteLine chr(13)
			Sfile_C.WriteLine "Date : " & now()
			Sfile_C.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
			Sfile_C.WriteLine "THIS_PAGE_URL	: " & Request.ServerVariables("URL")
			Sfile_C.WriteLine "--- Card REFUND(CANCEL) --------------------"
			Sfile_C.WriteLine "PGID	: " & TX_YESPAY_TID
			Sfile_C.WriteLine "getUserIP	: " & getUserIP
			Sfile_C.WriteLine "F_errMsg		: " & F_errMsg
			Sfile_C.WriteLine "cXmlStatus	: " & cXmlStatus
			Sfile_C.WriteLine "cResponse	: " &Replace(Replace(cResponse,"	",""),vbCrLf,"")

			resCode = cInfo.resCode
			resMessage = cInfo.resMessage

			If cXmlStatus >= 400 And cXmlStatus <= 599 Then

				Sfile_C.WriteLine "PG 결제취소 연결에 문제가 발생했습니다.1 : " & resMessage
				Call ALERTS("PG 결제취소 연결에 문제가 발생했습니다.1 \n\n에러메세지 : "&resMessage&"","GO",F_GO_BACK_ADDR)

			Else

				If LCase(resCode) <> "00" Then
					Sfile_C.WriteLine "결제가 취소 되지 않았습니다. 관리자에게 문의해주세요 : " & resMessage
					Call ALERTS("결제가 취소 되지 않았습니다. 관리자에게 문의해주세요2\n\n에러메세지 : "&resMessage&"","GO",F_GO_BACK_ADDR)
				Else
					Sfile_C.WriteLine "데이터 처리중 오류가 발생하여 카드결제를 취소하였습니다.취소사유 : "&F_errMsg
					Call ALERTS("데이터 처리중 오류가 발생하여 카드결제를 취소하였습니다.\n\n결제가 취소 되지 않은 경우 관리자에게 문의해주세요\n\n취소사유 : "&F_errMsg,"GO",F_GO_BACK_ADDR)

				End If

			End If

		Sfile_C.WriteLine chr(13)
		Sfile_C.Close
		Set Fso_C= Nothing


	End Function



'♠YESPAY 복합 결제
	Function PG_YESPAY_PAY_M(ByVal F_YESPAY_PARAMS, ByVal F_orderNum,	ByVal F_CardPrice , ByRef R_PGorderNum, ByRef R_PGCardNum, ByRef R_PGAcceptNum, ByRef R_PGinstallment, ByRef R_PGCardCode, ByRef R_resCode, ByRef R_resMessage)

			CardLogss	= "/PG/YESPAY/mCardShopAPI"

			bXmlParam = F_YESPAY_PARAMS

			bXmlURL = "http://yespay.kr/extlink/requestpay_utf8.asp"

			set bXmlhttp = Server.CreateObject("Msxml2.ServerXMLHTTP")

				bXmlhttp.setOption 2, 13056
				bXmlhttp.open "POST", bXmlURL, False
				bXmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
				bXmlhttp.setRequestHeader "Accept-Language","UTF-8"
				bXmlhttp.setRequestHeader "CharSet", "UTF-8"
				bXmlhttp.setRequestHeader "Content", "text/html;charset=UTF-8"
				bXmlhttp.setRequestHeader "Content-Length", Len(bXmlParam)
				bXmlhttp.send bXmlParam

				bResponse = bXmlhttp.responseText
				bXmlStatus = bXmlhttp.status

			Set bXmlhttp = Nothing '개체 소멸

			On Error Resume Next
			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If bXmlParam	<> "" Then bXmlParam	= objEncrypter.Encrypt(bXmlParam)
			Set objEncrypter = Nothing
			On Error GoTo 0

			Dim bInfo : Set bInfo = JSON.parse(Join(Array(bResponse)))

				On Error Resume Next
				Dim Fso2 : Set  Fso2=CreateObject("Scripting.FileSystemObject")
				Dim LogPath2 : LogPath2 = Server.MapPath (CardLogss&"/mCardPay_") & Replace(Date(),"-","") & ".log"
				Dim Sfile2 : Set  Sfile2 = Fso2.OpenTextFile(LogPath2,8,true)

					Sfile2.WriteLine chr(13)
					Sfile2.WriteLine "--- mCard PAY #"&Right(F_orderNum,1)&" --------------------------"
					Sfile2.WriteLine "PGID	: " & PGID
					Sfile2.WriteLine "Date : " & now()
					Sfile2.WriteLine "mbid1	 : " & DK_MEMBER_ID1
					Sfile2.WriteLine "mbid2	 : " & DK_MEMBER_ID2
					Sfile2.WriteLine "getUserIP	: " & getUserIP
					Sfile2.WriteLine "orderNum	: " & F_orderNum
					'Sfile2.WriteLine "bXmlParam	: " & bXmlParam
					Sfile2.WriteLine "F_CardPrice	: " & F_CardPrice
					Sfile2.WriteLine "bXmlURL	: " & bXmlURL
					Sfile2.WriteLine "bXmlStatus	: " & bXmlStatus

					''Sfile2.WriteLine "bResponse : " &Replace(Replace(bResponse,"	",""),vbCrLf,"")
					Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
						objEncrypter.Key = con_EncryptKey
						objEncrypter.InitialVector = con_EncryptKeyIV
						If bResponse	<> "" Then bResponse	= objEncrypter.Encrypt(Replace(Replace(bResponse,"	",""),vbCrLf,""))
					Set objEncrypter = Nothing
					Sfile2.WriteLine "bResponse	: " & bResponse

					resCode = bInfo.resCode
					resMessage = bInfo.resMessage

					If bXmlStatus >= 400 And bXmlStatus <= 599 Then
						Sfile2.WriteLine "PG 연결에 문제가 발생했습니다 : " & resMessage
						'Call ALERTS("PG 연결에 문제가 발생했습니다.1 \n\n에러메세지 : "&resMessage&"","GO",GO_BACK_ADDR)

					Else
						If LCase(resCode) <> "00" Then
							Sfile2.WriteLine "PG 연결에 문제가 발생했습니다. : " & resMessage
							'Call ALERTS("PG 연결에 문제가 발생했습니다2\n\n에러메세지 : "&resMessage&"","GO",GO_BACK_ADDR)
						End If

					End If

					'"comOrderNo":"업체주문번호",
					'"comMemID":"업체회원아이디",
					'"payAmount":"금액",
					'"cardNo":"카드번호",
					'"installment":"할부기간",
					'"orderUserName":"주문자명",
					'"orderTel":"주문자휴대폰번호",
					'"orderEmail":"이메일",
					'"productName":"상품명",
					'"orderId":"yesmecha주문번호",
					'"resCode":"결과코드(00-정상, 나마저는 메세지 참고)",
					'"resMessage":"결과메세지",
					'"apprNo":"카드승인번호",
					'"payDate":"결제일자(yyyyMMdd)",
					'"payTime":"결제시간(HHmmss)",
					'"cardCode":"카드사코드"

					R_PGorderNum   	= bInfo.orderId			'거래번호
					R_PGCardNum    	= bInfo.cardNo			'카드번호
					R_PGAcceptNum  	= bInfo.apprNo			'신용카드 승인번호
					R_PGinstallment	= bInfo.installment		'할부기간
					R_PGCardCode   	= bInfo.cardCode		'신용카드사코드(YESPAY 치환)
					R_resCode   	= resCode
					R_resMessage   	= resMessage



				Sfile2.Close
			Set Fso2= Nothing
			Set objError= Nothing
			On Error Goto 0

	End Function



'♠YESPAY 복합 결제 취소
	Function PG_YESPAY_CANCEL_M(ByVal F_TX_YESPAY_TID,  ByVal F_PGorderNum, ByVal F_orderNum, ByVal F_CardPrice)

			PG_YESPAY_CANCEL_M = True

			CardLogss	= "/PG/YESPAY/mCardShopAPI"

			cXmlParam = ""
			cXmlParam = cXmlParam & "orgOrderNo="&F_PGorderNum		'pg주문번호
			cXmlParam = cXmlParam & "&orgPayAmount="&F_CardPrice	'결제금액
			cXmlParam = cXmlParam & "&orgComOrderNo="&F_orderNum	'업체주문번호
			cXmlParam = cXmlParam & "&memManageNo="&F_TX_YESPAY_TID
			cXmlParam = cXmlParam & "&receiveType=json"				'결과 return 방식 json, xml, url
			cXmlParam = cXmlParam & "&receiveUrl="					'결과를 url 로 전송받을 경우 결과를 받을 주소입니다. http://를 포함한 full 주소를 입력하세요
			cXmlParam = cXmlParam & "&sendSMS=N"					'결제성공시 구매자휴대폰 번호로 SMS 발신여부 'Y' or 'N' ,  기본 발송안함

			cXmlURL = "http://yespay.kr/extLink/requestCancel_utf8.asp"

			Set cXmlhttp = Server.CreateObject("Msxml2.ServerXMLHTTP")

				cXmlhttp.setOption 2, 13056
				cXmlhttp.open "POST", cXmlURL, False
				cXmlhttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
				cXmlhttp.setRequestHeader "Accept-Language","UTF-8"
				cXmlhttp.setRequestHeader "CharSet", "UTF-8"
				cXmlhttp.setRequestHeader "Content", "text/html;charset=UTF-8"
				cXmlhttp.setRequestHeader "Content-Length", Len(cXmlParam)
				cXmlhttp.send cXmlParam

				cResponse = cXmlhttp.responseText
				cXmlStatus = cXmlhttp.status

			Set cXmlhttp = Nothing '개체 소멸

			'Call ResRW(cResponse,"cResponse")
			'Call ResRW(cXmlStatus,"cXmlStatus")

			Dim cInfo : Set cInfo = JSON.parse(Join(Array(cResponse)))

			On Error Resume Next
			Dim Fso_C : Set  Fso_C=CreateObject("Scripting.FileSystemObject")
			Dim LogPath_C : LogPath_C = Server.MapPath(CardLogss&"/c_mCard_") & Replace(Date(),"-","") & ".log"
			Dim Sfile_C : Set  Sfile_C = Fso_C.OpenTextFile(LogPath_C,8,true)

				Sfile_C.WriteLine chr(13)
				Sfile_C.WriteLine "Date : " & now()
				Sfile_C.WriteLine "Domain : " & Request.ServerVariables("HTTP_HOST")
				Sfile_C.WriteLine "THIS_PAGE_URL	: " & Request.ServerVariables("URL")
				Sfile_C.WriteLine "mbid1	 : " & DK_MEMBER_ID1
				Sfile_C.WriteLine "mbid2	 : " & DK_MEMBER_ID2
				Sfile_C.WriteLine "--- mCard REFUND(CANCEL) #"&Right(F_orderNum,1)&" --------------------------"
				Sfile_C.WriteLine "PGID	: " & F_TX_YESPAY_TID
				Sfile_C.WriteLine "getUserIP	: " & getUserIP
				Sfile_C.WriteLine "F_errMsg		: " & F_errMsg
				Sfile_C.WriteLine "cXmlParam	: " & cXmlParam
				Sfile_C.WriteLine "cXmlStatus	: " & cXmlStatus
				Sfile_C.WriteLine "cResponse	: " &Replace(Replace(cResponse,"	",""),vbCrLf,"")

				resCode = cInfo.resCode
				resMessage = cInfo.resMessage

				If cXmlStatus >= 400 And cXmlStatus <= 599 Then
					Sfile_C.WriteLine "PG 결제취소 연결에 문제가 발생했습니다.1 : " & resMessage
				Else

					If LCase(resCode) <> "00" Then
						Sfile_C.WriteLine "결제가 취소 되지 않았습니다. 관리자에게 문의해주세요 : " & resMessage
					Else
						Sfile_C.WriteLine "데이터 처리중 오류가 발생하여 카드결제를 취소하였습니다"
					End If

				End If

				Sfile_C.WriteLine "PGorderNum	: " & F_PGorderNum
				Sfile_C.WriteLine "orderNum		: " & F_orderNum
				Sfile_C.WriteLine "F_CardPrice	: " & F_CardPrice
				'Sfile_C.WriteLine "PGAcceptNum	: " & F_PGAcceptNum
				'Sfile_C.WriteLine "PGAcceptDate	: " & F_PGAcceptDate
				Sfile_C.WriteLine "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

				Sfile_C.Close
			Set Fso_C= Nothing
			Set objError= Nothing
			On Error Goto 0

			If LCase(resCode) = "00" Then
				PG_YESPAY_CANCEL_M = True
			Else
				PG_YESPAY_CANCEL_M = False
			End If

	End Function


%>
<%
'PAYTAG 취소

'	TX_PAYTAG_shopcode	= Request.Form("TX_PAYTAG_shopcode")	'페이태그 가맹점 번호
'		TX_PAYTAG_loginid	= Request.Form("TX_PAYTAG_loginid")		'가맹점 로그인ID
'		TX_PAYTAG_api_key	= Request.Form("TX_PAYTAG_api_key")		'가맹점 암호화 키값
'	recv_orderno		= Request.Form("recv_orderno")			'페이태그 거래번호
'	recv_trandate		= Request.Form("recv_trandate")			'원거래 승인일자 ( YYYYMMDD )
'	recv_tran_amt		= Request.Form("recv_tran_amt")			'원거래 승인금액


	Function PG_PAYTAG_CANCEL(ByVal F_PG_IDS, ByVal F_PGorderNum, ByVal F_loginid, ByVal F_api_key, ByVal F_trandate, ByVal F_tran_amt, ByVal F_GoodIDX, ByVal F_isDirect, ByVal F_chgPage , ByRef F_errMsg)

		If F_isDirect = "M" Then		'myoffice 결제
			If F_chgPage = "/m" Then
				F_chgPage = "/m"
			Else
				F_chgPage = "/myoffice"
			End If
			F_GO_BACK_ADDR = F_chgPage&"/buy/cart.asp"

		Else							'SHOP 결제

			If F_isDirect = "T" Then
				F_GO_BACK_ADDR = F_chgPage&"/shop/detailView.asp?gidx="&F_GoodIDX
			Else
				F_GO_BACK_ADDR = F_chgPage&"/shop/cart.asp"
			End If

		End If

			oXmlParam_C = ""
			oXmlParam_C = oXmlParam_C & "TX_PAYTAG_shopcode="&F_PG_IDS			'페이태그 가맹점 번호
			oXmlParam_C = oXmlParam_C & "&TX_PAYTAG_loginid="&F_loginid			'가맹점 로그인ID
			oXmlParam_C = oXmlParam_C & "&TX_PAYTAG_api_key="&F_api_key			'가맹점 암호화 키값
			oXmlParam_C = oXmlParam_C & "&recv_orderno="&F_PGorderNum			'페이태그 거래번호
			oXmlParam_C = oXmlParam_C & "&recv_trandate="&F_trandate			'원거래 승인일자 ( YYYYMMDD )
			oXmlParam_C = oXmlParam_C & "&recv_tran_amt="&F_tran_amt			'원거래 승인금액

			oXmlURL_C = HTTPS&"://"&houUrl&"/PG/PAYTAG/Cancel.asp"

			Set oXmlhttp_C = server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

				oXmlhttp_C.setOption 2, 13056
				oXmlhttp_C.open "POST", oXmlURL_C, False
				oXmlhttp_C.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"
				oXmlhttp_C.setRequestHeader "Accept-Language","UTF-8"
				oXmlhttp_C.setRequestHeader "CharSet", "UTF-8"
				oXmlhttp_C.setRequestHeader "Content", "text/html;charset=UTF-8"
				oXmlhttp_C.setRequestHeader "Content-Length", Len(oXmlParam_C)
				oXmlhttp_C.send oXmlParam_C

				oResponse_C  = oXmlhttp_C.responseText
				oXmlStatus_C = oXmlhttp_C.status

			Set oXmlhttp_C = Nothing '개체 소멸

			'Call ResRW(oResponse_C,"oResponse_C")
			'Call ResRW(oXmlStatus_C,"oXmlStatus_C")


			On Error Resume Next
			Dim Fso_C : Set  Fso_C=CreateObject("Scripting.FileSystemObject")
			Dim LogPath_C : LogPath_C = Server.MapPath ("cardCancel/cancel_") & Replace(Date(),"-","") & ".log"
			Dim Sfile_C : Set  Sfile_C = Fso_C.OpenTextFile(LogPath_C,8,true)
				Sfile_C.WriteLine chr(13)
				Sfile_C.WriteLine "--- Card Cancel Status(Function) --------------------"
				Sfile_C.WriteLine "Date : " & now()
				Sfile_C.WriteLine "mbid1	: " & DK_MEMBER_ID1
				Sfile_C.WriteLine "mbid2	: " & DK_MEMBER_ID2
				Sfile_C.WriteLine "shopcode	: " & F_PG_IDS
				Sfile_C.WriteLine "recv_orderno	: " & F_PGorderNum
				'Sfile_C.WriteLine "oXmlParam_C	: " & oXmlParam_C
				Sfile_C.WriteLine "oResponse_C	: "	& oResponse_C
				Sfile_C.WriteLine "oXmlStatus_C	: " & oXmlStatus_C
				ALERT_MSG = ""
				ALERT_BR = "\n"
				Sfile_C.Close
			Set Fso_C= Nothing
			Set objError= Nothing
			On Error Goto 0


			Dim aInfo : Set aInfo = JSON.parse(Join(Array(oResponse_C)))



			'print bXmlStatus
			If oXmlStatus_C >= 400 And oXmlStatus_C <= 599 Then
				errorMsg = aInfo.rMessage1
				Response.Write "<script type='text/javascript'>"
				Response.Write "alert('PG 연결에 문제가 발생했습니다. \n\n에러내용은 : "&errorMsg&" 입니다1');"
				Response.Write "location.href="""&F_GO_BACK_ADDR&""";"
				Response.Write "</script>"
				Response.End
			Else

				aInfo_recv_resultcode	= aInfo.recv_resultcode		''결과코드 0000' or '00' 정상
				aInfo_recv_apprno		= aInfo.recv_apprno			''원거래-승인번호
				aInfo_recv_errmsg		= aInfo.recv_errmsg			''에러내용(실패시 오류내용)


				aInfo_recv_resultcode   = Trim(aInfo_recv_resultcode)
				aInfo_recv_apprno		= Trim(aInfo_recv_apprno)
				aInfo_recv_errmsg		= Trim(aInfo_recv_errmsg)
			End If


		If aInfo_recv_resultcode = "0000" Or aInfo_recv_resultcode = "00"Then		'PAYTAG(코드블럭)

			If aInfo_recv_apprno = "" Then
				Call ALERTS("카드취소중 오류가 발생하였습니다. 결제취소가 정상적으로 이루어 지지 않은 경우 업체에 문의해주세요\n\nresult_msg : "&aInfo_recv_errmsg ,"GO",F_GO_BACK_ADDR)
			Else
				Call ALERTS("데이터 처리중 오류가 발생하여 카드결제를 취소하였습니다\n\n취소사유 : "&F_errMsg,"GO",F_GO_BACK_ADDR)
			End If

		Else
			Call ALERTS("카드취소중 오류가 발생하였습니다. 결제취소가 정상적으로 이루어 지지 않은 경우 업체에 문의해주세요\n\nresult_msg : "&aInfo_recv_errmsg,"GO",F_GO_BACK_ADDR)
		End If

	End Function
%>