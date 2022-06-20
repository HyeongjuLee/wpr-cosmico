<!--#include virtual = "/_lib/strFunc.asp"-->
<%
		MLM_TF = "T"
		OUT_ORDERNUMBER = "TEST12345555"
		MLM_CmpCode = "MLM_CmpCode"

	' 방판 API 실시간 신고

	If MLM_TF = "T" And OUT_ORDERNUMBER <> "" And MLM_CmpCode <> "" AND UCase(DK_MEMBER_NATIONCODE) = "KR" Then

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


			parent_code = ""
			company_code = ""
			api_key = ""

			oXmlParam = ""
			oXmlParam = oXmlParam & "parent_code="&parent_code		'모기업코드 독립사업자인 경우 00000
			oXmlParam = oXmlParam & "&company_code="&company_code		'회사코드 대리점 및 독립사업자 코드
			oXmlParam = oXmlParam & "&api_key="&api_key		'인증코드

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
			oXmlParam = oXmlParam & "&goods_name="&goods_name				'제품명 중복가능(구분자는 ‘|’)
			oXmlParam = oXmlParam & "&goods_cost="&goods_cost				'단가 중복가능(구분자는 ‘|’)
			oXmlParam = oXmlParam & "&quantity="&quantity				'주문수량 중복가능(구분자는 ‘|’)


			mlmURL1 = "https://kssfc.or.kr/sales.ddo"
			'mlmURL1 = "https://store.onoffkorea.co.kr/payment/index.php"
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
			sResponse = oXmlhttp1.responseText
			xmlStatus = oXmlhttp1.status

			Call ResRW(sResponse,"sResponse")

					'XML 파싱
'					Set oDOM = Server.CreateObject("Microsoft.XMLDOM")
'						oDOM.Async = False ' 동기식 호출
'						oDOM.validateOnParse = false
'						oDomXML = oDOM.loadXML(sResponse)
'
'						Set r_status			= oDOM.selectNodes("//status")		'상태코드 3번의 결과코드값 참조
'						Set r_statusmsg			= oDOM.selectNodes("//statusmsg")
'						Set r_guarante_num			= oDOM.selectNodes("//guarante_num")	'공제번호 발급된 공제번호
'
'						status					= r_status(0).Text
'						statusmsg					= r_statusmsg(0).Text
'						guarante_num					= r_guarante_num(0).Text
'
'						Set r_status			= Nothing
'						Set r_statusmsg			= Nothing
'						Set r_guarante_num			= Nothing
'
'						If r_guarante_num <> "" Then
'							ALERTS_MESSAGE = "특판 공제번호 발급이 완료되었습니다 : " &guarante_num
'						Else
'							ALERTS_MESSAGE = "특판 공제번호 발급이 실패되었습니다. 에러코드 : "&status&"\n\n"&statusmsg&""
'						End If
'
'					Set oDOM = Nothing
'					Set oXmlhttp1 = Nothing


	End If

response.end


%>
