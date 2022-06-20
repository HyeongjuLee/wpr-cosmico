<!--#include virtual = "/_lib/strFunc.asp"-->
<!--#include virtual = "/_lib/json2.asp"-->
<%
If webproIP <>"T" Then Response.Redirect "/index.asp"

	Function convJSON(s)
		s = Trim(s)
		If Not s = "" Or Not IsNull(s) Then
			s = Replace(s, "\", "")
			s = Replace(s, " ", "")
			s = Replace(s, """{","{")
			s = Replace(s, "}""","}")
		End If
		convJSON  = s
	End Function

%>
<%
'#1차원 JSON은 이게 좋고

		API_COMP_KEY = "API_COMP_KEY"
		id			= "iddd"
		DK_MEMBER_WEBID = "MEMBER_WEBID"
		DK_HIPIS_CARD_NUMBER = "123-1254-2222"
		OrderNum = "DK123123123"
		totalPrice = 123.21

		'	{"api_key":{"id":"iddd","company_id":"API_COMP_KEY"},"mem_id":"MEMBER_WEBID","card_num":"123-1254-2222","req_ip":"112.170.184.62","order_number":"DK123123123","total_price":123.21,"item_number":[1,2,3],"items":[{"prodId":"prd0","qty":0},{"prodId":"prd1","qty":2},{"prodId":"prd2","qty":4}],"memInfos":[{"name":"park","age":20,"sex":"male"},{"name":"park","age":21,"sex":"male"},{"name":"park","age":22,"sex":"male"}]}

		Dim JsonObj
		Set JsonObj = jsObject()

		Set JsonObj_api_key = jsObject()
			JsonObj_api_key("id")			= id
			JsonObj_api_key("company_id")	= API_COMP_KEY
			inner_api_key					= toJSON(JsonObj_api_key)

		JsonObj("api_key")			= inner_api_key		'	{"api_key":"{"mem_id":"DK_MEMBER_WEBID","company_id":"1"}
		JsonObj("mem_id")			= DK_MEMBER_WEBID
		JsonObj("card_num")			= DK_HIPIS_CARD_NUMBER
		JsonObj("req_ip")			= getUserIP
		JsonObj("order_number")		= OrderNum
		JsonObj("total_price")		= totalPrice

		'배열 S======================================================================================================================================
	'	Set JsonObj("item_number")	= jsArray()
		Set JsonObj("items")		= jsArray()
		'Set JsonObj("memInfos")		= jsArray()

		'Dim JsonObj_memInfos		'#배열 방법 2
		'Dim memInfos
			max_K= 2
		'Redim memInfos(max_K)		'#배열 방법 2

			For k = 0 To max_K

				'JsonObj("item_number")(k) = (k+1)						'	,"item_number":[1,2,3]

				'#배열 방법 1
				Set JsonObj_itmes = jsObject()
					JsonObj_itmes("prodId")	= "prd"&k
					JsonObj_itmes("qty")	= k*2
					inner_items				= toJSON(JsonObj_itmes)
				JsonObj("items")(k)		= inner_items					'	,"items":[{"prodId":"prd0","qty":0},{"prodId":"prd1","qty":2},{"prodId":"prd2","qty":4}]

				'#배열 방법 2
			'	Set JsonObj_memInfos = jsObject()
			'		JsonObj_memInfos("name")	= "park"
			'		JsonObj_memInfos("age")		= 20+k
			'		JsonObj_memInfos("sex")		= "male"
			'	Set memInfos(k) = JsonObj_memInfos						'	,"memInfos":[{"name":"park","age":20,"sex":"male"},{"name":"park","age":21,"sex":"male"},{"name":"park","age":22,"sex":"male"}]
			Next

		'#배열 방법 2
		'JsonObj("memInfos")	= Ubound(memInfos)
		'JsonObj("memInfos")	= memInfos
		'배열 E ======================================================================================================================================

		'PRINT toJSON(JsonObj)
		aResponse = toJSON(JsonObj)
		aResponse = convJSON(aResponse)

		'PRINT aResponse&"<br/>"
		'	aResponse = Replace(aResponse,"\","")
		'	aResponse = Replace(aResponse," ","")
		'	aResponse = Replace(aResponse,"""{","{")
		'	aResponse = Replace(aResponse,"}""","}")
		PRINT aResponse&"<br/>"
Response.End
		Dim aInfo : Set aInfo = JSON.parse(Join(Array(aResponse)))

		id			= aInfo.api_key.id
		company_id	= aInfo.api_key.company_id
		mem_id		= aInfo.mem_id
		card_num	= aInfo.card_num

		prodId0	= aInfo.items.get(0).prodId
		qty0	= aInfo.items.get(0).qty

		name0	= aInfo.memInfos.get(0).name
		age0	= aInfo.memInfos.get(0).age
		sex0	= aInfo.memInfos.get(0).sex
		name1	= aInfo.memInfos.get(1).name
		age1	= aInfo.memInfos.get(1).age
		sex1	= aInfo.memInfos.get(1).sex

		print "<hr>"
		print id &"<br>"
		print company_id &"<br>"
		print mem_id &"<br>"
		print card_num &"<br>"

		print prodId0 &"<br>"
		print qty0 &"<br>"

		print name0 &"<br>"
		print age0 &"<br>"
		print sex0 &"<br>"
		print name1 &"<br>"
		print age1 &"<br>"
		print sex1 &"<br>"

'Response.End
%>

<%
'#2차원 JSON은 이게 좋을거 같음(내부 배열 선언 등)

strName = "strName"
strEmail = "strEmail"
orderNum = "asdfasdf"
totalPrice = 0
inUidx = 10
GoodsName = "GoodsName"
GoodsPrice = 100

		Dim jsonParam_2

		jsonParam_2 = ""
		jsonParam_2 = jsonParam_2& "{"
		jsonParam_2 = jsonParam_2& """pay"":{"
		jsonParam_2 = jsonParam_2&		" ""payerName"":"""&strName&""""				'Y	구매자 성명
		jsonParam_2 = jsonParam_2&		",""payerEmail"":"""&strEmail&""""				'Y	구매자 이메일
		jsonParam_2 = jsonParam_2&		",""payerTel"":"""&strMobile&""""				'Y	구매자 전화번호
		jsonParam_2 = jsonParam_2&		",""card"": {"									'Y	카드 결제 시 사용되는 카드 정보
		jsonParam_2 = jsonParam_2&			" ""number"":"""&cardNo&""""				'Y		20 자리 미만의 카드 번호
		jsonParam_2 = jsonParam_2&			",""expiry"":"""&cardYYMM&""""				'Y		카드 유효기간 YYMM
		jsonParam_2 = jsonParam_2&			",""cvv"": """""							'O		카드 뒷면에 표기된 3~4자리 숫자
		jsonParam_2 = jsonParam_2&			",""installment"":"""&quotabase&""""		'O		할부기간 2자리 숫자로 (00).
		jsonParam_2 = jsonParam_2&		"}"

		jsonParam_2 = jsonParam_2&		",""products"": ["								'Y	온라인 주문 시 상품 정보 Array 로 구성됨
		jsonParam_2 = jsonParam_2&			"{"
		jsonParam_2 = jsonParam_2&			" ""prodId"":"""&inUidx&""""				'		inUidx
		jsonParam_2 = jsonParam_2&			",""name"": """&GoodsName&""""				'Y		상품명
		jsonParam_2 = jsonParam_2&			",""qty"": 1"								'N		구매 수량
		jsonParam_2 = jsonParam_2&			",""price"": "&GoodsPrice&""				'N		객 단가
		jsonParam_2 = jsonParam_2&			",""desc"": ""상품구매"""					'N		상세설명
		jsonParam_2 = jsonParam_2&			"}"
		jsonParam_2 = jsonParam_2&		"]"

		jsonParam_2 = jsonParam_2&		",""trxId"": """""
		jsonParam_2 = jsonParam_2&		",""trxType"": ""ONTR"""						'Y	“ONTR” 기본
		jsonParam_2 = jsonParam_2&		",""trackId"": """&orderNum&""""				'Y	가맹점 주문번호
		jsonParam_2 = jsonParam_2&		",""amount"": "&totalPrice&""					'Y	결제 금액
		jsonParam_2 = jsonParam_2&		",""udf1"": """""								'O	가맹점 정의 필드 1
		jsonParam_2 = jsonParam_2&		",""udf2"": """""								'O	가맹점 정의 필드 2
		jsonParam_2 = jsonParam_2&		",""metadata"": {"								'N	로컬 결제 또는 카드 결제에 Option 으로 필요한 값.
		jsonParam_2 = jsonParam_2&			" ""cardAuth"": ""ddd"""					'Y		인증사용시										'어라! 비생 다르게 넣어도 승인되네... 비생기능 없어졌다함 ㅡㅜ
		jsonParam_2 = jsonParam_2&			",""authPw"": """&CardPass&""""				'Y		카드비밀번호 앞 2자리
		jsonParam_2 = jsonParam_2&			",""authDob"": """&CardBirth&""""			'Y		카드 소유자 생년월일 6자리 (YYMMDD)
		jsonParam_2 = jsonParam_2&		"}"

		jsonParam_2 = jsonParam_2& "  }"
		jsonParam_2 = jsonParam_2& "}"

		Call ResRW(jsonParam_2,"jsonParam_2")
		print "<br>"

	'	Call ResRW((toJSON(jsonParam_2)),"toJSON(jsonParam_2)")
	'	jsonPARSE_2 = toJSON(jsonParam_2)
	'	jsonPARSE_2 = convJSON(jsonPARSE_2)
	'	Call ResRW(jsonPARSE_2,"<br/>jsonPARSE_2")

		Dim jsonInfo_2 : Set jsonInfo_2 = JSON.parse(join(array(jsonParam_2)))

	'	{"pay":{"payerName":"strName","payerEmail":"strEmail","payerTel":"","card":{"number":"","expiry":"","cvv":"","installment":""},"products":[{"prodId":"10","name":"GoodsName","qty":1,"price":100,"desc":"uC0C1uD488uAD6CuB9E4"}],"trxId":"","trxType":"ONTR","trackId":"asdfasdf","amount":0,"udf1":"","udf2":"","metadata":{"cardAuth":"ddd","authPw":"","authDob":""}}}

		pay_card_cardId		= jsonInfo_2.pay.payerName
		cardAuth			= jsonInfo_2.pay.metadata.cardAuth
		products			= jsonInfo_2.pay.products

		print pay_card_cardId &"<BR>"
		print cardAuth &"<BR>"

		response.end
		Response.end
%>
