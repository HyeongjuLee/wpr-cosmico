<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<%

	'한글
		Session.CodePage = 65001
		Response.CharSet = "UTF-8"
		Response.AddHeader "Pragma","no-cache"
		Response.AddHeader "Expires","0"

		intIDX = pRequestTF_AJAX("intIDX",True)
		i = pRequestTF_AJAX("Ri",True)


'==================================================================
	'▣▣ CS사업자회원일때만 적립금 / CS마일리지 가감!! 2014-03-17
	nowTime = Now
	RegTime = Right("0000"&Year(nowTime),4) & Right("00"&Month(nowTime),2) & Right("00"&Day(nowTime),2)
	Recordtime = Left(nowTime,10) & " "& Right("00"&Hour(nowTime),2) &":"&Right("00"&Minute(nowTime),2) &":"&Right("00"&Second(nowTime),2)

	SQL = " SELECT [OrderNum],[strUserID],[totalPrice],[totalDelivery],[totalPoint],[usePoint],[status],[payWay] FROM [DK_ORDER] WHERE [intIDX] = ? "
	arrParams2 = Array( _
	Db.makeParam("@intIDX",adInteger,adParamInput,0,intIDX) _
	)
	Set DKRS2 = Db.execRs(SQL,DB_TEXT,arrParams2,Nothing)
		If Not DKRS2.BOF And Not DKRS2.EOF Then
			OrderNum		= DKRS2("OrderNum")			'웹주문번호 DK...!!!
			strUserID		= DKRS2("strUserID")
			totalPrice		= DKRS2("totalPrice")		'구매금액
			totalPoint		= DKRS2("totalPoint")		'적립금
			CS_USED_MILEAGE	= DKRS2("usePoint")			'사용한 CS마일리지
			status			= DKRS2("status")
			payWay			= DKRS2("payWay")
			'totalDonation	= DKRS2("totalDonation")
		Else
			OrderNum		= ""
			strUserID		= ""
			CS_USED_MILEAGE	= 0
			'totalDonation	= 0
		End If
	Call closeRS(DKRS2)

	If Left(strUserID,3) = "CS_" Then
		'=========================================================================
		'▣1. CS웹아이디존재, CS_WebID형식
	'	CS_WebID = Replace(strUserID,"CS_","")
	'	SQL_CS = " SELECT * FROM [tbl_Memberinfo] WHERE [WebID] = ? "
	'	arrParams3 = Array( _
	'		Db.makeParam("@WebID",adVarChar,adParamInput,30,CS_WebID) _
	'	)
	'	Set DKRS3 = Db.execRs(SQL_CS,DB_TEXT,arrParams3,DB3)
	'		If Not DKRS3.BOF And Not DKRS3.EOF Then
	'			CS_MBID1		= DKRS3("mbid")
	'			CS_MBID2		= DKRS3("mbid2")
	'			CS_MNAME		= DKRS3("M_Name")
	'			CS_CPNO			= DKRS3("cpno")
	'			CS_Sell_Mem_TF	= DKRS3("Sell_Mem_TF")
	'			CS_D_Sex		= DKRS3("D_Sex")
	'				If CS_Sell_Mem_TF = 0 Then		'CS 판매원
	'					CS_SELLER_TYPE = 1
	'				ElseIf CS_Sell_Mem_TF = 1 Then	'CS 소비자
	'					CS_SELLER_TYPE = 2
	'				End if
	'		Else
	'			Call ALERTS("CS회원정보가 없습니다.","BACK","")
	'		End If
	'	Call closeRS(DKRS3)
		'=========================================================================
		'▣2. CS웹아이디없거나, CS_mbid_mbid2형식
		CS_MBID_MBID2 = Replace(strUserID,"CS_","")

		arrCSMBID = Split(CS_MBID_MBID2,"_")

		CS_MBID1  = arrCSMBID(0)
		CS_MBID2  = arrCSMBID(1)

		SQL_CS = " SELECT * FROM [tbl_Memberinfo] WHERE [mbid] = ? AND [mbid2] = ? "

		arrParams3 = Array( _
			Db.makeParam("@MBID1",adVarChar,adParamInput,20,CS_MBID1) , _
			Db.makeParam("@MBID2",adInteger,adParamInput,4,CS_MBID2) _
		)
		Set DKRS3 = Db.execRs(SQL_CS,DB_TEXT,arrParams3,DB3)
			If Not DKRS3.BOF And Not DKRS3.EOF Then
				CS_MBID1		= DKRS3("mbid")
				CS_MBID2		= DKRS3("mbid2")
				CS_MNAME		= DKRS3("M_Name")
				CS_CPNO			= DKRS3("cpno")
				CS_Sell_Mem_TF	= DKRS3("Sell_Mem_TF")
				CS_D_Sex		= DKRS3("D_Sex")

				If CS_Sell_Mem_TF = 0 Then		'CS 판매원
					CS_SELLER_TYPE = 1
				ElseIf CS_Sell_Mem_TF = 1 Then	'CS 소비자
					CS_SELLER_TYPE = 2
				End if
			Else
				Call ALERTS("CS회원정보가 없습니다.","BACK","")
			End If
		Call closeRS(DKRS3)
		'=========================================================================

		'CS 주문번호 호출
		SQL2 = "SELECT [OrderNumber] FROM [tbl_SalesDetail] WHERE [ETC2] = '웹주문번호:'+ ? "
		arrParams = Array(_
			Db.makeParam("@OrderNum",adVarChar,adParamInput,20,OrderNum) _
		)
		Set HJRSC = DB.execRs(SQL2,DB_TEXT,arrParams,DB3)
		If Not HJRSC.BOF And Not HJRSC.EOF Then
			CS_OrderNumber   = HJRSC(0)
		Else
			CS_OrderNumber   = ""
		End If
		Call closeRS(HJRSC)
	End If
%>


<%
'==================================================================
'	▣'직판 무통장 입금확인상태변경클릭시!
	If UCase(payWay) = "INBANK" And CS_OrderNumber <> "" Then

		'CS주문번호 존재
		If CS_OrderNumber <> "" Then
			'▣직판 일동휴먼 : CS상품 무통장구매: 관리자 입금확인시 공제번호발급▣

			Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
				objEncrypter.Key = con_EncryptKey
				objEncrypter.InitialVector = con_EncryptKeyIV
				If CS_CPNO	<> "" Then CS_CPNO	= objEncrypter.Decrypt(CS_CPNO)
			'	PRINT  objEncrypter.Decrypt("Z0SPQ6DkhLd4e")
			Set objEncrypter = Nothing

			If CS_SELLER_TYPE = 2 Then	'소비자회원
				CS_CPNO = Left("999999",6)&CS_D_Sex
			Else
				CS_CPNO = Left(CS_CPNO,7)
			End If

			' 직판용 공제번호 체크썸 (MACCO_NUM확인!! 테스트:5500)
				'DK_MEMBER_NAME = "가나다"
				oXmlParam = ""
				oXmlParam = oXmlParam & "orderid="&CS_OrderNumber
				oXmlParam = oXmlParam & "&shopid="&MACCO_NUM
				oXmlParam = oXmlParam & "&totalmoney="&totalPrice-totalDelivery	'직판신고시 배송비제외
				oXmlParam = oXmlParam & "&seller_type="&CS_SELLER_TYPE			'1=판매원  2=소비자
				oXmlParam = oXmlParam & "&name="&Server.URLEncode(CS_MNAME)
				oXmlParam = oXmlParam & "&userid="&CS_CPNO
				oXmlParam = oXmlParam & "&mem_id="&CS_MBID1&"-"&CS_MBID2
				oXmlParam = oXmlParam & "&merc_code="
				oXmlParam = oXmlParam & "&ctype=w"
				oXmlParam = oXmlParam & "&returntype=xml"

				maccoURL1 = "https://real.macco.or.kr/deduct/deductPass.action"
				maccoURL2 = "https://real2.macco.or.kr/deduct/deductPass.action"

				set oXmlhttp1 = Server.CreateObject("Msxml2.ServerXMLHTTP")
				set oXmlhttp2 = Server.CreateObject("Msxml2.ServerXMLHTTP")

				oXmlhttp1.setOption 2, 13056
				oXmlhttp1.open "POST", maccoURL1, False
				oXmlhttp1.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;"
				oXmlhttp1.setRequestHeader "Accept-Language","UTF-8"
				oXmlhttp1.setRequestHeader "CharSet", "UTF-8"
				oXmlhttp1.setRequestHeader "Content", "text/html;charset=UTF-8"
				oXmlhttp1.setRequestHeader "Content-Length", Len(oXmlParam)

				oXmlhttp1.send oXmlParam
				sResponse = oXmlhttp1.responseText
				xmlStatus = oXmlhttp1.status

				If xmlStatus <> "200" Then
					oXmlhttp2.setOption 2, 13056
					oXmlhttp2.open "POST", maccoURL2, False
					oXmlhttp2.setRequestHeader "Accept-Language","UTF-8"
					oXmlhttp2.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;"
					oXmlhttp2.setRequestHeader "CharSet", "UTF-8"
					oXmlhttp2.setRequestHeader "Content", "text/html;charset=UTF-8"
					oXmlhttp2.setRequestHeader "Content-Length", Len(oXmlParam)

					oXmlhttp2.send oXmlParam
					sResponse = oXmlhttp2.responseText
					xmlStatus = oXmlhttp2.status
				End If

				'XML 파싱
				Set oDOM = Server.CreateObject("Microsoft.XMLDOM")
					oDOM.Async = False ' 동기식 호출
					oDOM.validateOnParse = false
					oDomXML = oDOM.loadXML(sResponse)

					Set rMLM_orderID			= oDOM.selectNodes("//orderID")
					Set rMLM_guaranteeResult	= oDOM.selectNodes("//guaranteeResult")
					Set rMLM_memID				= oDOM.selectNodes("//memID")
					Set rMLM_mallID				= oDOM.selectNodes("//mallID")
					MLM_orderID					= rMLM_orderID(0).Text
					MLM_guaranteeResult			= rMLM_guaranteeResult(0).text
					MLM_memID					= rMLM_memID(0).text
					MLM_mallID					= rMLM_mallID(0).text

					Set rMLM_orderID			= Nothing
					Set rMLM_guaranteeResult	= Nothing
					Set rMLM_memID				= Nothing
					Set rMLM_mallID				= Nothing


					Select Case MLM_guaranteeResult
						Case "Y","D"
							Set rMLM_GuaranteeCode		= oDOM.selectNodes("//GuaranteeCode")
								MLM_GuaranteeCode		= rMLM_GuaranteeCode(0).Text
								MLM_errorCode			= ""
							Set rMLM_GuaranteeCode		= Nothing

							'발급됬을때 실행
							arrParams = Array(_
								Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
								Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
								Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _
								Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
							)
							Call Db.exec("DKPA_ORDER_CHG_101",DB_PROC,arrParams,Nothing)
							OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

							ALERTS_MESSAGE = "공제번호 발급이 완료되었습니다 : " &MLM_GuaranteeCode

						'	<script type='text/javascript'>
						'		alert("공제번호 발급이 완료되었습니다 : < %=MLM_GuaranteeCode % >");
						'		parent.location.reload();
						'	</script>
						Case "N"
							Set rMLM_errorCode			= oDOM.selectNodes("//ErrorCode")
								MLM_errorCode			= rMLM_errorCode(0).text
								MLM_GuaranteeCode		= ""
							Set rMLM_errorCode			= Nothing
							ALERTS_MESSAGE = "공제번호 발급이 실패되었습니다. 에러코드 : " &MLM_errorCode &vbcrlf&vbcrlf&"https://m.macco.co.kr/it/errcode/list.action 접속해서 에러코드 확인후에"&vbcrlf&vbcrlf&"다온스토리 전산담당자에게 문의해 보시기 바랍니다."
						'	<script type='text/javascript'>
						'		alert("공제번호 발급이 실패되었습니다. 에러코드 : < %=MLM_errorCode% >\n\nhttps://m.macco.co.kr/it/errcode/list.action 접속해서 에러코드 확인후에\n\n다온스토리 전산담당자에게 문의해 보시기 바랍니다.");
						'		parent.location.reload();
						'	</script>
						Case Else
							ALERTS_MESSAGE = "공제번호 서버오류 또는 알수없는 오류"
						'	<script type='text/javascript'>
						'		alert("공제번호 서버오류 또는 알수없는 오류");
						'		parent.location.reload();
						'	</script>
					End Select

				' 데이터 입력
					SQL = "UPDATE [tbl_SalesDetail] SET"
					SQL = SQL &" [INS_Num]			= ?"
					SQL = SQL &",[INS_Num_Date]		= ?"
					SQL = SQL &",[INS_Num_Err]		= ?"
					SQL = SQL &" WHERE [OrderNumber] = ?"

					arrParams = Array(_
						Db.makeParam("@INS_NUM",adVarChar,adParamInput,30,MLM_GuaranteeCode),_
						Db.makeParam("@INS_NUM_DATE",adVarChar,adParamInput,30,now),_
						Db.makeParam("@INS_Num_Err",adVarChar,adParamInput,50,MLM_errorCode),_
						Db.makeParam("@OUT_ORDERNUMBER",adVarChar,adParamInput,50,CS_OrderNumber) _
					)

					Call Db.exec(SQL,DB_TEXT,arrParams,DB3)

					Set oDOM = Nothing
					Set oXmlhttp1 = Nothing
					Set oXmlhttp2 = Nothing

		Else
			'CS주문번호 없는경우
			MLM_guaranteeResult = "Z"

			arrParams = Array(_
				Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
				Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
				Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)
			Call Db.exec("DKPA_ORDER_CHG_101",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
		End If
	Else
		MLM_guaranteeResult = "Z"

		arrParams = Array(_
			Db.makeParam("@intIDX",adInteger,adParamInput,4,intIDX), _
			Db.makeParam("@regID",adVarChar,adParamInput,30,DK_MEMBER_ID), _
			Db.makeParam("@regIP",adVarChar,adParamInput,30,getUserIP), _
			Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
		)
		Call Db.exec("DKPA_ORDER_CHG_101",DB_PROC,arrParams,Nothing)
		OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)
	End If


PRINT MLM_guaranteeResult & "&&&&&&" & ALERTS_MESSAGE & "&&&&&&"

%>
<%If isMACCO = "T" Then%>
<!--#include file="order_list_ajax_chg_MACCO.asp" -->
<%Else%>
<!--#include file="order_list_ajax_chg.asp" -->
<%End If%>
