<%


'/* --------------------------------------------------------
' DK_CONFIG 의 PGJAVA 항목 관련내용
'
' ANSI : EUC-KR 일반
' UTF8 : UTF-8 일반
' ANSISSL : EUC-KR + SSL
' UTF8SSL : UTF-8 + SSL
'
' 다우기술은 페이지 방식으로 해당 내용 상관없음.
'-----------------------------------------------------------/
'------------------------------------------------------------------------------------------------------------------------------------------------------------------------/
'																								[PRODUCT 테스트] [BILL 테스트]	[PRODUCT 실결제]	[BILL 실결제]
'테스트그룹1	CTS10405	PC	일반결제	http://pg.webpro.kr/PG/DAOU/cardResult.asp				2				1					2				1
'				CTS10406	PC	키인결제	http://pg.webpro.kr/PG/DAOU/cardResult_keyin.asp		2				1					2				1

'테스트그룹2	CTS10409	PC	일반결제	http://pg.webpro.kr/PG/DAOU2/cardResult.asp				2				1					2				1
'				CTS10410	PC	키인결제	http://pg.webpro.kr/PG/DAOU2/cardResult_keyin.asp		2				1					2				1

'테스트그룹3	CTS10413	PC	일반결제	http://pg.webpro.kr/PG/DAOU3/cardResult.asp				2				1					2				1
'				CTS10414	PC	키인결제	http://pg.webpro.kr/PG/DAOU3/cardResult_keyin.asp		2				1					2				1


'' 이니시스 기본 javascript 호출 주소
'	DEFAULT_INICIS_ANSI			= "http://plugin.inicis.com/pay61_secuni_cross.js"
'	DEFAULT_INICIS_UTF8			= "https://plugin.inicis.com/pay61_secunissl_cross.js"
'	DEFAULT_INICIS_ANSISSL		= "http://plugin.inicis.com/pay61_secuni_cross.js"
'	DEFAULT_INICIS_UTF8SSL		= "https://plugin.inicis.com/pay61_secunissl_cross.js"
'
'' KICC 플러그인 기본 javascript 호출 주소 (테스트는 SSL 이 없음)
'	DEFAULT_KICCP_ANSI			= "http://pg.easypay.co.kr/plugin/EasyPayPlugin.js"
'	DEFAULT_KICCP_UTF8			= "http://pg.easypay.co.kr/plugin/EasyPayPlugin_utf8.js"
'	DEFAULT_KICCP_ANSISSL		= "https://pg.easypay.co.kr/plugin/EasyPayPlugin.js"
'	DEFAULT_KICCP_UTF8SSL		= "https://pg.easypay.co.kr/plugin/EasyPayPlugin_utf8.js"
'
'	DEFAULT_KICCP_ANSI_TEST		= "http://testpg.easypay.co.kr/plugin/EasyPayPlugin.js"
'	DEFAULT_KICCP_UTF8_TEST		= "http://testpg.easypay.co.kr/plugin/EasyPayPlugin_utf8.js"
'
'	DEFAULT_KICCP_URL_TEST		= "testgw.easypay.co.kr"
'	DEFAULT_KICCP_URL_REAL		= "gw.easypay.co.kr"
'
'
'	DEFAULT_PGIDS_KICCP			= "T5102001"
'	DEFAULT_PGIDS_INICIS		= "INIpayTest"
'
''------------------------------------------------------------------------------------------------------------------------------------------------------------------------/



' /* PG관련 내용 분리 -----------------------------------------------------
' strFuncData.asp 에서 PGMOD를 받아온 후 관련 내용으로 전송시작
'
' PGCOMPANY					: PG업체 (다우: DAOU, 이니시스 : INICIS, KICC : KICC // 테스트의 경우 TEST_ 가 붙음
' PGPASSKEY					: PG패스워드 (이니시스만 사용)
' PGIDS_SHOP				: PG아이디 : 쇼핑몰
' PGIDS_SHOP_KEYIN			: PG아이디 : 쇼핑몰 키인
' PGIDS_MOBILE				: PG아이디 : 모바일
' PGIDS_MOBILE_KEYIN		: PG아이디 : 모바일 키인
' PGJAVA_ENCODE				: PG 자바스크립트 인코딩
' PGSSL						: PG SSL 적용여부
' PGJAVA_BASE1				: PG 자바스크립트 경로 : 다우 : 쇼핑몰				,이니시스 : ANSI				,KICC : ANSI
' PGJAVA_BASE2	 			: PG 자바스크립트 경로 : 다우 : 쇼핑몰 키인			,이니시스 : UTF8				,KICC : UTF8
' PGJAVA_BASE3      		: PG 자바스크립트 경로 : 다우 : 모바일				,이니시스 : ANSI + SSL			,KICC : ANSI + SSL (테스트엔 없음)
' PGJAVA_BASE4				: PG 자바스크립트 경로 : 다우 : 모바일 키인			,이니시스 : UTF8 + SSL			,KICC : UTF8 + SSL (테스트엔 없음)
' ------------------------------------------------------------------------/
'	PRINT DKFD_PGMOD		'DAOU/DAOU_TEST / INICIS/INICIS_TEST / KICCP/KICCP_TEST

	arrParams = Array(_
		Db.makeParam("@PGMOD",adVarChar,adParamInput,20,DKFD_PGMOD) _
	)
	Set DKPG = Db.execRs("DKPC_PG_CONFIG",DB_PROC,arrParams,Nothing)
	If Not DKPG.BOF And Not DKPG.EOF Then
		DKPG_intIDX						= DKPG("intIDX")
		DKPG_PGMOD						= DKPG("PGMOD")
		DKPG_PGCOMPANY					= DKPG("PGCOMPANY")
		DKPG_PGPASSKEY					= DKPG("PGPASSKEY")
		DKPG_PGIDS_SHOP					= DKPG("PGIDS_SHOP")
		DKPG_PGIDS_SHOP_KEYIN			= DKPG("PGIDS_SHOP_KEYIN")
		DKPG_PGIDS_MOBILE				= DKPG("PGIDS_MOBILE")
		DKPG_PGIDS_MOBILE_KEYIN			= DKPG("PGIDS_MOBILE_KEYIN")
		DKPG_PGJAVA_ENCODE				= DKPG("PGJAVA_ENCODE")

		DKPG_PGSSL						= DKPG("PGSSL")
		DKPG_PGJAVA_BASE1				= DKPG("PGJAVA_BASE1")
		DKPG_PGJAVA_BASE2				= DKPG("PGJAVA_BASE2")
		DKPG_PGJAVA_BASE3				= DKPG("PGJAVA_BASE3")
		DKPG_PGJAVA_BASE4				= DKPG("PGJAVA_BASE4")

		DKPG_PGURL						= DKPG("PGURL")
		DKPG_PGADDRESS_ORI				= DKPG("PGADDRESS_ORI")
		DKPG_PGADDRESS_TAKE				= DKPG("PGADDRESS_TAKE")
		DKPG_KEYIN						= DKPG("PG_KEYIN")
	Else
		'Call ALERTS("설정되지 않은 PG입니다.","back","")
		Call ALERTS(LNG_STRPGDEFAULT_TEXT01,"back","")
	End If
	Call CloseRS(DKPG)

	'PRINT DKPG_PGMOD

	PGCOMURL = DKPG_PGURL
	oriAdd	 = DKPG_PGADDRESS_ORI									'주소선택
	takeAdd  = DKPG_PGADDRESS_TAKE

	Select Case DKPG_PGCOMPANY
		Case "INICIS"
			PGIDS		= DKPG_PGIDS_SHOP
			PGPASSKEY	= DKPG_PGPASSKEY

			Select Case DKPG_PGJAVA_ENCODE
				Case "ANSI"		: PGJAVA = DKPG_PGJAVA_BASE1
				Case "UTF8"		: PGJAVA = DKPG_PGJAVA_BASE2
				Case "ANSISSL"	: PGJAVA = DKPG_PGJAVA_BASE3
				Case "UTF8SSL"	: PGJAVA = DKPG_PGJAVA_BASE4
			End Select

		Case "KICCP"
			PGIDS		= DKPG_PGIDS_SHOP
			PGPASSKEY	= DKPG_PGPASSKEY

			Select Case DKPG_PGJAVA_ENCODE
				Case "ANSI"		: PGJAVA = DKPG_PGJAVA_BASE1
				Case "UTF8"		: PGJAVA = DKPG_PGJAVA_BASE2
				Case "ANSISSL"	: PGJAVA = DKPG_PGJAVA_BASE3
				Case "UTF8SSL"	: PGJAVA = DKPG_PGJAVA_BASE4
			End Select
		Case "DAOU"
			' PGIDS 아이디 관련 DKPG 그대로 사용
			' DKPG_PGJAVA_BASE1 : 쇼핑몰 일반용 JAVA
			' DKPG_PGJAVA_BASE2 : 쇼핑몰 키인용 JAVA
			' DKPG_PGJAVA_BASE3 : 모바일 일반용 JAVA
			' DKPG_PGJAVA_BASE4 : 모바일 키인용 JAVA

		Case Else

	End Select



	'▣ 카드 / 은행 코드 S


		Function Fnc_bankname(ByVal values)

			Select Case Right(values,2)
				Case "02" : Fnc_bankname = "산업"
				Case "03" : Fnc_bankname = "기업"
				Case "04" : Fnc_bankname = "국민"
				Case "05" : Fnc_bankname = "외환"
				Case "07" : Fnc_bankname = "수협"
				Case "08" : Fnc_bankname = "수출입"
				Case "11" : Fnc_bankname = "농협"
				Case "20" : Fnc_bankname = "우리"
				Case "88" : Fnc_bankname = "신한"
				Case "23" : Fnc_bankname = "SC제일"
				Case "81" : Fnc_bankname = "하나"
				Case "27" : Fnc_bankname = "한국씨티"
				Case "31" : Fnc_bankname = "대구"
				Case "32" : Fnc_bankname = "부산"
				Case "34" : Fnc_bankname = "광주"
				Case "35" : Fnc_bankname = "제주"
				Case "37" : Fnc_bankname = "전북"
				Case "39" : Fnc_bankname = "경남"
				Case "45" : Fnc_bankname = "새마을금고"
				Case "48" : Fnc_bankname = "신협"
				Case "50" : Fnc_bankname = "상호저축은행"
				Case "54" : Fnc_bankname = "HSBC"
				Case "71" : Fnc_bankname = "우체국"
				Case "64" : Fnc_bankname = "산림조합"
				Case "89" : Fnc_bankname = "케이뱅크"
				Case "90" : Fnc_bankname = "카카오뱅크"
				'Case Else : Fnc_bankname = "은행코드에러"
				Case Else : Fnc_bankname = values
			End Select

		End Function


		Function YESPAY_CARDCODE(ByVal codeData)
			Select Case codeData
				Case "01"	: YESPAY_CARDCODE = "11"		'"비씨카드"
				Case "02"	: YESPAY_CARDCODE = "06"		'"국민카드"
				Case "03"	: YESPAY_CARDCODE = "01"		'"외환카드"
				Case "04"	: YESPAY_CARDCODE = "12"		'"삼성카드"
				Case "05"	: YESPAY_CARDCODE = "14"		'"신한카드"
				Case "08"	: YESPAY_CARDCODE = "04"		'"현대카드"
				Case "09"	: YESPAY_CARDCODE = "03"		'"롯데카드"
				Case "11"	: YESPAY_CARDCODE = "15"		'"한미은행"
				Case "12"	: YESPAY_CARDCODE = ""			'"수협"
				Case "14"	: YESPAY_CARDCODE = ""			'"우리은행"
				Case "15"	: YESPAY_CARDCODE = "16"		'"농협NH"
				Case "16"	: YESPAY_CARDCODE = ""			'"제주은행"
				Case "17"	: YESPAY_CARDCODE = ""			'"광주은행"
				Case "18"	: YESPAY_CARDCODE = ""			'"전북은행"
				Case "19"	: YESPAY_CARDCODE = ""			'"조흥은행"
				Case "23"	: YESPAY_CARDCODE = ""			'"주택은행"
				Case "24"	: YESPAY_CARDCODE = "17"		'"하나은행"
				Case "26"	: YESPAY_CARDCODE = ""			'"씨티은행"
				Case "25"	: YESPAY_CARDCODE = "26"		'"해외카드사"
				Case "99"	: YESPAY_CARDCODE = ""			'"기타"

				Case Else : YESPAY_CARDCODE = ""				'
			End Select
		End Function

		Function YESPAY_CARDNAME(ByVal codeData)
			Select Case codeData
				Case "01"	: YESPAY_CARDNAME = "비씨카드"
				Case "02"	: YESPAY_CARDNAME = "국민카드"
				Case "03"	: YESPAY_CARDNAME = "외환카드"
				Case "04"	: YESPAY_CARDNAME = "삼성카드"
				Case "05"	: YESPAY_CARDNAME = "신한카드"
				Case "08"	: YESPAY_CARDNAME = "현대카드"
				Case "09"	: YESPAY_CARDNAME = "롯데카드"
				Case "11"	: YESPAY_CARDNAME = "한미은행"
				Case "12"	: YESPAY_CARDNAME = "수협"
				Case "14"	: YESPAY_CARDNAME = "우리은행"
				Case "15"	: YESPAY_CARDNAME = "농협NH"
				Case "16"	: YESPAY_CARDNAME = "제주은행"
				Case "17"	: YESPAY_CARDNAME = "광주은행"
				Case "18"	: YESPAY_CARDNAME = "전북은행"
				Case "19"	: YESPAY_CARDNAME = "조흥은행"
				Case "23"	: YESPAY_CARDNAME = "주택은행"
				Case "24"	: YESPAY_CARDNAME = "하나은행"
				Case "26"	: YESPAY_CARDNAME = "씨티은행"
				Case "25"	: YESPAY_CARDNAME = "해외카드사"
				Case "99"	: YESPAY_CARDNAME = "기타"

				Case Else : YESPAY_CARDNAME = ""				'
			End Select
		End Function

		Function DAOUPAY_CARDCODE(ByVal codeData)
			Select Case codeData
				Case "CCAM"	: DAOUPAY_CARDCODE = "24"
				Case "CCNH"	: DAOUPAY_CARDCODE = "16"
				Case "CCCJ"	: DAOUPAY_CARDCODE = ""
				Case "CCDI"	: DAOUPAY_CARDCODE = "04"
				Case "CCHM"	: DAOUPAY_CARDCODE = "15"
				Case "CCJB"	: DAOUPAY_CARDCODE = ""
				Case "CCKE"	: DAOUPAY_CARDCODE = "01"
				Case "CCKM"	: DAOUPAY_CARDCODE = "06"
				Case "CCLG"	: DAOUPAY_CARDCODE = "14"
				Case "CCPH"	: DAOUPAY_CARDCODE = ""
				Case "CCSG"	: DAOUPAY_CARDCODE = "15"
				Case "CCSS"	: DAOUPAY_CARDCODE = "12"
				Case "CCKW"	: DAOUPAY_CARDCODE = "14"
				Case "CCKD"	: DAOUPAY_CARDCODE = ""
				Case "CCCU"	: DAOUPAY_CARDCODE = ""
				Case "CCSU"	: DAOUPAY_CARDCODE = ""
				Case "CAMF"	: DAOUPAY_CARDCODE = ""
				Case "CJCF"	: DAOUPAY_CARDCODE = "23"
				Case "CMCF"	: DAOUPAY_CARDCODE = "22"
				Case "CCLO"	: DAOUPAY_CARDCODE = "03"
				Case "CCBC"	: DAOUPAY_CARDCODE = "11"
				Case "CCSH"	: DAOUPAY_CARDCODE = "14"
				Case "CCCT"	: DAOUPAY_CARDCODE = ""
				Case "CCCH"	: DAOUPAY_CARDCODE = ""
				Case "CCHN"	: DAOUPAY_CARDCODE = "15"
				Case "CDIF"	: DAOUPAY_CARDCODE = "25"
				Case "CCKJ"	: DAOUPAY_CARDCODE = ""
				Case "CVSF"	: DAOUPAY_CARDCODE = "21"
				Case "CCSB"	: DAOUPAY_CARDCODE = ""
				Case Else : DAOUPAY_CARDCODE = ""
			End Select
		End Function

		Function DAOUPAY_BANKCODE(ByVal codeData)
			Select Case codeData
				Case "03" : DAOUPAY_BANKCODE = "003"		'03	기업은행
				Case "04" : DAOUPAY_BANKCODE = "004"		'04	국민은행
				Case "05" : DAOUPAY_BANKCODE = "005"		'05	외환은행
				Case "08" : DAOUPAY_BANKCODE = "011"		'08	농협은행
				Case "09" : DAOUPAY_BANKCODE = "020"		'09	우리은행
				Case "10" : DAOUPAY_BANKCODE = "088"		'10	신한은행
				Case "11" : DAOUPAY_BANKCODE = "023"		'11	ＳＣ제일은행
				Case "12" : DAOUPAY_BANKCODE = "081"		'12	하나은행
				Case "15" : DAOUPAY_BANKCODE = "032"		'15	부산은행
				Case "31" : DAOUPAY_BANKCODE = "071"		'31	우체국
				Case Else : DAOUPAY_BANKCODE = ""
			End Select
		End Function

		'다우 실시간계좌이체 : BANKNAME(한글) → 코드값치환
		Function DAOUPAY_DBANKCODE(ByVal codeData)
			Select Case codeData
				Case "산업"			: DAOUPAY_DBANKCODE = "002"
				Case "기업"			: DAOUPAY_DBANKCODE = "003"
				Case "국민"			: DAOUPAY_DBANKCODE = "004"
				Case "외환"			: DAOUPAY_DBANKCODE = "005"
				Case "수협"			: DAOUPAY_DBANKCODE = "007"
				Case "미래에셋"		: DAOUPAY_DBANKCODE = "008"
				Case "농협"			: DAOUPAY_DBANKCODE = "011"
				Case "축협"			: DAOUPAY_DBANKCODE = "016"
				Case "우리"			: DAOUPAY_DBANKCODE = "020"
				Case "SC제일"		: DAOUPAY_DBANKCODE = "023"
				Case "대구"			: DAOUPAY_DBANKCODE = "031"
				Case "부산"			: DAOUPAY_DBANKCODE = "032"
				Case "광주"			: DAOUPAY_DBANKCODE = "034"
				Case "제주"			: DAOUPAY_DBANKCODE = "035"
				Case "전북"			: DAOUPAY_DBANKCODE = "037"
				Case "경남"			: DAOUPAY_DBANKCODE = "039"
				Case "새마을금고"	: DAOUPAY_DBANKCODE = "045"
				Case "신협"			: DAOUPAY_DBANKCODE = "048"
				Case "우체국"		: DAOUPAY_DBANKCODE = "071"
				Case "하나"			: DAOUPAY_DBANKCODE = "081"
				Case "신한"			: DAOUPAY_DBANKCODE = "088"
				Case "동양증권"		: DAOUPAY_DBANKCODE = "209"
				Case "한국투자증권" : DAOUPAY_DBANKCODE = "243"
				Case "신한금융투자" : DAOUPAY_DBANKCODE = "신한금융투자"
				Case "삼성증권"		: DAOUPAY_DBANKCODE = "삼성증권"
				Case "한화증권"		: DAOUPAY_DBANKCODE = "한화증권"
				Case Else : DAOUPAY_DBANKCODE = ""
			End Select
		End Function


	'온오프코리아 카드사코드 2019-10-15~
	Function ONOFFKOREA_CARDCODE(ByVal values)

		Select Case values
			Case "008"			: ONOFFKOREA_CARDCODE = "01"		'"외환"
			Case "045","047"	: ONOFFKOREA_CARDCODE = "03"		'"(신)롯데 / 롯데"
			Case "027"			: ONOFFKOREA_CARDCODE = "04"		'"현대"
			Case "016"			: ONOFFKOREA_CARDCODE = "06"		'"국민"
			Case "026"			: ONOFFKOREA_CARDCODE = "11"		'"비씨"
			Case "031"			: ONOFFKOREA_CARDCODE = "12"		'"삼성"
			Case "029"			: ONOFFKOREA_CARDCODE = "14"		'"신한"
		'	Case "한미"			: ONOFFKOREA_CARDCODE = "15"		'"한미"
			Case "018"			: ONOFFKOREA_CARDCODE = "16"		'"농협"
			Case "006"			: ONOFFKOREA_CARDCODE = "17"		'"하나"
			Case "010"			: ONOFFKOREA_CARDCODE = "18"		'"전북"
			Case "021"			: ONOFFKOREA_CARDCODE = "19"		'"우리"
		'	Case "대구"			: ONOFFKOREA_CARDCODE = "20"		'"대구"
		'	Case "해외비자"		: ONOFFKOREA_CARDCODE = "21"		'"해외비자"
		'	Case "해외마스터"	: ONOFFKOREA_CARDCODE = "22"		'"해외마스터"
		'	Case "JCB"			: ONOFFKOREA_CARDCODE = "23"		'"JCB"
		'	Case "해외아멕스"	: ONOFFKOREA_CARDCODE = "24"		'"해외아멕스"
		'	Case "해외다이너스"	: ONOFFKOREA_CARDCODE = "25"		'"해외다이너스"
		'	Case "새마을"		: ONOFFKOREA_CARDCODE = "26"		'"새마을"
		'	Case "신협"			: ONOFFKOREA_CARDCODE = "27"		'"신협"
			Case "002"			: ONOFFKOREA_CARDCODE = "28"		'"광주"
		'	Case "우체국"		: ONOFFKOREA_CARDCODE = "29"		'"우체국"
			Case "022","034"	: ONOFFKOREA_CARDCODE = "30"		'"씨티은행 / 씨티"
		'	Case "부산"			: ONOFFKOREA_CARDCODE = "31"		'"부산"
			Case "017"			: ONOFFKOREA_CARDCODE = "32"		'"수협"
			Case "011"			: ONOFFKOREA_CARDCODE = "33"		'"제주"
			Case "기타"			: ONOFFKOREA_CARDCODE = "99"		'"기타"
			Case Else			: ONOFFKOREA_CARDCODE = "99"		'Else
		End Select

	End Function



	'온오프코리아 가상계좌은행코드 치환
	Function ONOFFKOREA_vBANKCODE(ByVal values)
		Select Case values
			Case "003"			: ONOFFKOREA_vBANKCODE = "BK03"		'기업은행
			Case "004"			: ONOFFKOREA_vBANKCODE = "BK04"		'국민은행
			Case "007"			: ONOFFKOREA_vBANKCODE = "BK07"		'수협
			Case "011"			: ONOFFKOREA_vBANKCODE = "BK11"		'농협은행
			Case "020"			: ONOFFKOREA_vBANKCODE = "BK20"		'우리은행
			Case "023"			: ONOFFKOREA_vBANKCODE = "BK23"		'SC제일은행
			Case "026"			: ONOFFKOREA_vBANKCODE = "BK26"		'신한은행
			Case "032"			: ONOFFKOREA_vBANKCODE = "BK32"		'부산은행
			Case "034"			: ONOFFKOREA_vBANKCODE = "BK34"		'광주은행
			Case "071"			: ONOFFKOREA_vBANKCODE = "BK71"		'우체국
			Case "081"			: ONOFFKOREA_vBANKCODE = "BK81"		'하나은행
			Case Else			: ONOFFKOREA_vBANKCODE = ""		'Else
		End Select
	End Function



	Function KSNET_CARDCODE(ByVal codeData)
		Select Case Right(codeData,2)
			Case "01"	: KSNET_CARDCODE = "11"		'"010001"	비씨카드	O
			Case "02"	: KSNET_CARDCODE = "06"		'"010002"	국민카드  	O
			Case "03"	: KSNET_CARDCODE = "01"		'"010003"	외환카드  		O
			Case "04"	: KSNET_CARDCODE = "12"		'"010004"	삼성카드  		O
			Case "05"	: KSNET_CARDCODE = "14"		'"010005"	신한카드  		O	2008.8.18. 신한-LG카드사 통합
			Case "08"	: KSNET_CARDCODE = "04"		'"010008"	현대카드  		O
			Case "09"	: KSNET_CARDCODE = "03"		'"010009"	롯데카드		O	롯데아멕스 카드 포함
			Case "11"	: KSNET_CARDCODE = "15"		'"010011"	한미은행  		O
			Case "12"	: KSNET_CARDCODE = "32"		'"010012"	수협      		O
			Case "14"	: KSNET_CARDCODE = "19"		'"010014"	우리은행  	O
			Case "15"	: KSNET_CARDCODE = "16"		'"010015"	농협NH      		O	일반
			Case "16"	: KSNET_CARDCODE = "33"		'"010016"	제주은행  		O
			Case "17"	: KSNET_CARDCODE = "28"		'"010017"	광주은행  		O
			Case "18"	: KSNET_CARDCODE = "18"		'"010018"	전북은행  		O
			Case "19"	: KSNET_CARDCODE = "99"		'"010019"	조흥은행		O	(조흥카드 신한으로 통합되어 없어짐, 취소는 존재)
			Case "23"	: KSNET_CARDCODE = "99"		'"010023"	주택은행 			(거절시 발급사코드로 나올수 있음, 승인은 불가)
			Case "24"	: KSNET_CARDCODE = "17"		'"010024"	하나은행  		O
			Case "26"	: KSNET_CARDCODE = "30"		'"010026"	씨티은행  		O
			Case "25"	: KSNET_CARDCODE = "98"		'"010025"	해외카드사			일반
			Case "99"	: KSNET_CARDCODE = "99"		'"010099"	기타
			Case Else : KSNET_CARDCODE = ""
		End Select
	End Function


	Function KSNET_BANKCODE(ByVal codeData)
		Select Case codeData
			Case "01"	: KSNET_BANKCODE = "001"	'	한국은행
			Case "02"	: KSNET_BANKCODE = "002"		'	산업은행
			Case "03"	: KSNET_BANKCODE = "003"	'	기업은행
			Case "04"	: KSNET_BANKCODE = "004"	'	국민은행
			Case "05"	: KSNET_BANKCODE = "005"	'	외환은행
			Case "07"	: KSNET_BANKCODE = "007"	'	수협중앙회
			Case "08"	: KSNET_BANKCODE = "008"	'	수출입은행
			Case "11"	: KSNET_BANKCODE = "011"	'	농협은행
			Case "12","13","14","15"	: KSNET_BANKCODE = "012"	'12~15	지역농.축협
			Case "20"	: KSNET_BANKCODE = "020"	'	우리은행
			Case "23"	: KSNET_BANKCODE = "023"	'	제일은행
			Case "26"	: KSNET_BANKCODE = "026"	'	신한은행
			Case "27"	: KSNET_BANKCODE = "027"	'	한미은행
			Case "31"	: KSNET_BANKCODE = "031"	'	대구은행
			Case "32"	: KSNET_BANKCODE = "032"	'	부산은행
			Case "34"	: KSNET_BANKCODE = "034"	'	광주은행
			Case "35"	: KSNET_BANKCODE = "035"	'	제주은행
			Case "37"	: KSNET_BANKCODE = "037"	'	전북은행
			Case "39"	: KSNET_BANKCODE = "039"	'	경남은행
			Case "45"	: KSNET_BANKCODE = "045"	'	새마을금고중앙회
			Case "48"	: KSNET_BANKCODE = "048"	'	신협중앙회
			Case "50"	: KSNET_BANKCODE = "050"	'	상호저축은행
			Case "52"	: KSNET_BANKCODE = "052"	'	모건스탠리은행
			Case "54"	: KSNET_BANKCODE = "054"	'	HSBC은행
			Case "55"	: KSNET_BANKCODE = "055"	'	도이치은행
			Case "56"	: KSNET_BANKCODE = "056"	'	알비에스피엘씨은행
			Case "57"	: KSNET_BANKCODE = "057"	'	제이피모간체이스은행
			Case "58"	: KSNET_BANKCODE = "058"	'	미즈호은행
			Case "59"	: KSNET_BANKCODE = "059"	'	미쓰비시도쿄UFJ은행
			Case "60"	: KSNET_BANKCODE = "060"	'	BOA은행
			Case "61"	: KSNET_BANKCODE = "061"	'	비엔피파리바은행
			Case "62"	: KSNET_BANKCODE = "062"	'	중국공상은행
			Case "63"	: KSNET_BANKCODE = "063"	'	중국은행
			Case "64"	: KSNET_BANKCODE = "064"	'	산림조합중앙회
			Case "65"	: KSNET_BANKCODE = "065"	'	대화은행
			Case "53"	: KSNET_BANKCODE = "053"	'	씨티은행
			Case "71"	: KSNET_BANKCODE = "071"	'	우체국
			Case "76"	: KSNET_BANKCODE = "076"	'	신용보증
			Case "77"	: KSNET_BANKCODE = "077"	'	기술보증기금
			Case "81"	: KSNET_BANKCODE = "081"	'	하나은행
			Case "88"	: KSNET_BANKCODE = "088"	'	신한은행
			Case "89"	: KSNET_BANKCODE = "089"	'	케이뱅크
			Case "90"	: KSNET_BANKCODE = "090"	'	카카오뱅크
			Case "93"	: KSNET_BANKCODE = "093"	'	한국주택금융공사
			Case "94"	: KSNET_BANKCODE = "094"	'	서울보증보험
			Case "95"	: KSNET_BANKCODE = "095"	'	경찰청
			Case "96"	: KSNET_BANKCODE = "096"	'	한국전자금융㈜
			Case "99"	: KSNET_BANKCODE = "099"	'	금융결제원
			Case "209"	: KSNET_BANKCODE = "209"	'	유안타증권
			Case "218"	: KSNET_BANKCODE = "218"	'	현대증권
			Case "230"	: KSNET_BANKCODE = "230"	'	미래에셋증권
			Case "238"	: KSNET_BANKCODE = "238"	'	대우증권
			Case "240"	: KSNET_BANKCODE = "240"	'	삼성증권
			Case "243"	: KSNET_BANKCODE = "243"	'	한국투자증권
			Case "247"	: KSNET_BANKCODE = "247"	'	우리투자증권
			Case "261"	: KSNET_BANKCODE = "261"	'	교보증권
			Case "262"	: KSNET_BANKCODE = "262"	'	하이투자증권
			Case "263"	: KSNET_BANKCODE = "263"	'	HMC투자증권
			Case "264"	: KSNET_BANKCODE = "264"	'	키움증권
			Case "265"	: KSNET_BANKCODE = "265"	'	이트레이드증권
			Case "266"	: KSNET_BANKCODE = "266"	'	SK증권
			Case "267"	: KSNET_BANKCODE = "267"	'	대신증권
			Case "268"	: KSNET_BANKCODE = "268"	'	아이엠투자증권
			Case "269"	: KSNET_BANKCODE = "269"	'	한화투자증권
			Case "270"	: KSNET_BANKCODE = "270"	'	하나대투증권
			Case "278"	: KSNET_BANKCODE = "278"	'	신한금융투자
			Case "279"	: KSNET_BANKCODE = "279"	'	동부증권
			Case "280"	: KSNET_BANKCODE = "280"	'	유진투자증권
			Case "287"	: KSNET_BANKCODE = "287"	'	메리츠종합금융증권
			Case "287"	: KSNET_BANKCODE = "287"	'	NH투자증권
			Case "290"	: KSNET_BANKCODE = "290"	'	부국증권
			Case "291"	: KSNET_BANKCODE = "291"	'	신영증권
			Case "292"	: KSNET_BANKCODE = "292"	'	LIG투자증권
			Case Else : KSNET_BANKCODE = ""
		End Select
	End Function

	Function KSNET_BANKNAME(ByVal codeData)
		Select Case codeData
			Case "01"	: KSNET_BANKNAME = "한국은행"
			Case "02"	: KSNET_BANKNAME = "산업은행"
			Case "03"	: KSNET_BANKNAME = "기업은행"
			Case "04"	: KSNET_BANKNAME = "국민은행"
			Case "05"	: KSNET_BANKNAME = "외환은행"
			Case "07"	: KSNET_BANKNAME = "수협중앙회"
			Case "08"	: KSNET_BANKNAME = "수출입은행"
			Case "11"	: KSNET_BANKNAME = "농협은행"
			Case "12","13","14","15"	: KSNET_BANKNAME = "지역농.축협"
			Case "20"	: KSNET_BANKNAME = "우리은행"
			Case "23"	: KSNET_BANKNAME = "제일은행"
			Case "26"	: KSNET_BANKNAME = "신한은행"
			Case "27"	: KSNET_BANKNAME = "한미은행"
			Case "31"	: KSNET_BANKNAME = "대구은행"
			Case "32"	: KSNET_BANKNAME = "부산은행"
			Case "34"	: KSNET_BANKNAME = "광주은행"
			Case "35"	: KSNET_BANKNAME = "제주은행"
			Case "37"	: KSNET_BANKNAME = "전북은행"
			Case "39"	: KSNET_BANKNAME = "경남은행"
			Case "45"	: KSNET_BANKNAME = "새마을금고중앙회"
			Case "48"	: KSNET_BANKNAME = "신협중앙회"
			Case "50"	: KSNET_BANKNAME = "상호저축은행"
			Case "52"	: KSNET_BANKNAME = "모건스탠리은행"
			Case "54"	: KSNET_BANKNAME = "HSBC은행"
			Case "55"	: KSNET_BANKNAME = "도이치은행"
			Case "56"	: KSNET_BANKNAME = "알비에스피엘씨은행"
			Case "57"	: KSNET_BANKNAME = "제이피모간체이스은행"
			Case "58"	: KSNET_BANKNAME = "미즈호은행"
			Case "59"	: KSNET_BANKNAME = "미쓰비시도쿄UFJ은행"
			Case "60"	: KSNET_BANKNAME = "BOA은행"
			Case "61"	: KSNET_BANKNAME = "비엔피파리바은행"
			Case "62"	: KSNET_BANKNAME = "중국공상은행"
			Case "63"	: KSNET_BANKNAME = "중국은행"
			Case "64"	: KSNET_BANKNAME = "산림조합중앙회"
			Case "65"	: KSNET_BANKNAME = "대화은행"
			Case "53"	: KSNET_BANKNAME = "씨티은행"
			Case "71"	: KSNET_BANKNAME = "우체국"
			Case "76"	: KSNET_BANKNAME = "신용보증"
			Case "77"	: KSNET_BANKNAME = "기술보증기금"
			Case "81"	: KSNET_BANKNAME = "하나은행"
			Case "88"	: KSNET_BANKNAME = "신한은행"
			Case "89"	: KSNET_BANKNAME = "케이뱅크"
			Case "90"	: KSNET_BANKNAME = "카카오뱅크"
			Case "93"	: KSNET_BANKNAME = "한국주택금융공사"
			Case "94"	: KSNET_BANKNAME = "서울보증보험"
			Case "95"	: KSNET_BANKNAME = "경찰청"
			Case "96"	: KSNET_BANKNAME = "한국전자금융㈜"
			Case "99"	: KSNET_BANKNAME = "금융결제원"
			Case "209"	: KSNET_BANKNAME = "유안타증권"
			Case "218"	: KSNET_BANKNAME = "현대증권"
			Case "230"	: KSNET_BANKNAME = "미래에셋증권"
			Case "238"	: KSNET_BANKNAME = "대우증권"
			Case "240"	: KSNET_BANKNAME = "삼성증권"
			Case "243"	: KSNET_BANKNAME = "한국투자증권"
			Case "247"	: KSNET_BANKNAME = "우리투자증권"
			Case "261"	: KSNET_BANKNAME = "교보증권"
			Case "262"	: KSNET_BANKNAME = "하이투자증권"
			Case "263"	: KSNET_BANKNAME = "HMC투자증권"
			Case "264"	: KSNET_BANKNAME = "키움증권"
			Case "265"	: KSNET_BANKNAME = "이트레이드증권"
			Case "266"	: KSNET_BANKNAME = "SK증권"
			Case "267"	: KSNET_BANKNAME = "대신증권"
			Case "268"	: KSNET_BANKNAME = "아이엠투자증권"
			Case "269"	: KSNET_BANKNAME = "한화투자증권"
			Case "270"	: KSNET_BANKNAME = "하나대투증권"
			Case "278"	: KSNET_BANKNAME = "신한금융투자"
			Case "279"	: KSNET_BANKNAME = "동부증권"
			Case "280"	: KSNET_BANKNAME = "유진투자증권"
			Case "287"	: KSNET_BANKNAME = "메리츠종합금융증권"
			Case "287"	: KSNET_BANKNAME = "NH투자증권"
			Case "290"	: KSNET_BANKNAME = "부국증권"
			Case "291"	: KSNET_BANKNAME = "신영증권"
			Case "292"	: KSNET_BANKNAME = "LIG투자증권"
			Case Else : KSNET_BANKNAME = ""
		End Select
	End Function



	'2. PAYTAG 자체 매입사코드표입니다.
	'  각 PG사마다 발급사는 제각기 이기 때문에 매입사만 통일하여 관리하고 있습니다.
	' 아래 전문에 추가 응답값으로 반영하겠습니다.
	' [cardcode]
	Function PAYTAG_CARDCODE(ByVal codeData)
		Select Case Right(codeData,2)
			Case "01"	: PAYTAG_CARDCODE = "11"		'비씨카드
			Case "02"	: PAYTAG_CARDCODE = "06"		'국민카드
			Case "03"	: PAYTAG_CARDCODE = "01"		'하나(구외환) 합병
			Case "04"	: PAYTAG_CARDCODE = "12"		'삼성카드
			Case "05"	: PAYTAG_CARDCODE = "14"		'신한카드
			Case "06"	: PAYTAG_CARDCODE = "04"		'현대카드
			Case "07"	: PAYTAG_CARDCODE = "03"		'롯데카드
			Case "08"	: PAYTAG_CARDCODE = "16"		'농협NH
			Case "09"	: PAYTAG_CARDCODE = "17"		'하나은행
			Case "99"	: PAYTAG_CARDCODE = "99"		'기타
			Case Else : PAYTAG_CARDCODE = ""
		End Select
	End Function
%>