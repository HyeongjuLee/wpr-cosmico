<!--#include virtual = "/_lib/strFunc.asp"-->
<%
		If WebproIP <> "T" Then CAll WRONG_ACCESS()

			'mlmURL1 = "http://naturesleep2020.webpro.kr/api/mlm2.asp"
			'mlmURL1 = "https://store.onoffkorea.co.kr/payment/index.php"
			'mlmURL1 = "https://store.onoffkorea.co.kr/payment/index.php"
			mlmURL1 = "https://kssfc.or.kr/sales.ddo"

			Set oXmlhttp1 = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

			'oXmlhttp1.setOption 2, 13056
			oXmlhttp1.open "POST", mlmURL1, False
			oXmlhttp1.setRequestHeader "Content-Type", "application/x-www-form-urlencoded;"
			'oXmlhttp1.setRequestHeader "Accept-Language","UTF-8"
			'oXmlhttp1.setRequestHeader "CharSet", "UTF-8"
			'oXmlhttp1.setRequestHeader "Content", "text/html;charset=UTF-8"
			'oXmlhttp1.setRequestHeader "Content-Length", Len(oXmlParam)

			oXmlhttp1.send 'oXmlParam											'작업 시간을 초과했습니다.
			'sResponse = oXmlhttp1.responseText
			Response.Write binarytotext(oXmlhttp1.responseBody,"UTF-8")
			sResponse = binarytotext(oXmlhttp1.responseBody,"UTF-8")

					Set oDOM = Server.CreateObject("Microsoft.XMLDOM")
						oDOM.Async = False ' 동기식 호출
						oDOM.validateOnParse = false
						oDomXML = oDOM.loadXML(sResponse)


						Set rMLM_orderID			= oDOM.selectNodes("//status")
						Set rMLM_guaranteeResult	= oDOM.selectNodes("//statusmsg")
						'Set rMLM_memID				= oDOM.selectNodes("//guarante_num")

						MLM_orderID					= rMLM_orderID(0).Text
						MLM_guaranteeResult			= rMLM_guaranteeResult(0).text
						'MLM_memID					= rMLM_memID(0).text

						Set rMLM_orderID			= Nothing
						Set rMLM_guaranteeResult	= Nothing
						'Set rMLM_memID				= Nothing


		print MLM_orderID
		print MLM_guaranteeResult
		print MLM_memID

response.end


%>
