<!--#include virtual="/_lib/strFunc.asp" -->
<!--#include virtual="/admin/_inc/adminFunc.asp" -->
<!--#include virtual = "/admin/_inc/document.asp"-->
<%
	ADMIN_LEFT_MODE = "ORDERS"
	INFO_MODE = "ORDERS4-2"



	orderNum = Request.form("orderNum")

	arrParams = Array(_
		Db.makeParam("@orderNum",adVarChar,adParamInput,20,orderNum) _
	)
	Set DKRS = Db.execRs("DKPA_INICIS_SAFEKEY_CHECK",DB_PROC,arrParams,Nothing)
	If Not DKRS.EOF And Not DKRS.BOF Then
		Call ALERTS("중복결제가 요청되었습니다. 페이지를 다시 로드합니다.","GO","SafeKey_in.asp")
	Else

	'*******************************************************************************
	'INISafeKeyIN.asp
	'
	'INI Safe Key IN 플러그인을 통해 요청된 지불을 처리한다.
	'코드에 대한 자세한 설명은 매뉴얼을 참조하십시오.
	'http://www.inicis.com
	'Copyright (C) 2010 Inicis, Co. All rights reserved.
	'*******************************************************************************

	'###############################################################################
	'# 1. 객체 생성 #
	'################
	Set INIpay = Server.CreateObject("INItx42.INItx42.1")

	'###############################################################################
	'# 2. 인스턴스 초기화 #
	'######################
	PInst = INIpay.Initialize("")

	'###############################################################################
	'# 3. 거래 유형 설정 #
	'#####################
	INIpay.SetActionType CLng(PInst), "SECUREPAY"

	'###############################################################################
	'# 4. 지불 정보 설정 #
	'################
	INIpay.SetField CLng(PInst), "pgid", "IniTechPG_"							'PG ID (고정)
	INIpay.SetField CLng(PInst), "spgip", "203.238.3.10"						'예비 PG IP (고정)

	INIpay.SetField CLng(PInst), "uid", Request("uid")							'INIpay User ID
	INIpay.SetField CLng(PInst), "mid", Request("mid")							'상점아이디

	INIpay.SetField CLng(PInst), "UseINIsafeKeyin", "1"							'INIsafeKeyIN 사용 (고정)

	INIpay.SetField CLng(PInst), "admin", "1111"								'키패스워드(상점아이디에 따라 변경)

	INIpay.SetField CLng(PInst), "oid", "merchant_oid"							'주문번호
	INIpay.SetField CLng(PInst), "paymethod", Request("paymethod")				'지불방법
	INIpay.SetField CLng(PInst), "goodname", Request("goodname")				'상품명
	INIpay.SetField CLng(PInst), "currency", "WON"								'화폐단위
	INIpay.SetField CLng(PInst), "price", Request("price")						'가격
	INIpay.SetField CLng(PInst), "buyername", Request("buyername")				'성명
	INIpay.SetField CLng(PInst), "buyertel", Request("buyertel")				'이동전화
	INIpay.SetField CLng(PInst), "buyeremail", Request("buyeremail")			'이메일
	INIpay.SetField CLng(PInst), "encrypted", Request("encrypted")				'암호문
	INIpay.SetField CLng(PInst), "sessionkey", Request("sessionkey")			'암호문
	INIpay.SetField CLng(PInst), "url", "http://www.your_domain.co.kr"			'상점 홈페이지 주소 (URL)
	INIpay.SetField CLng(PInst), "debug", "true"								'로그모드("true"로 설정하면 상세한 로그를 남김)
	INIpay.SetField CLng(PInst), "merchantreserved1", "예비1"					'예비1
	INIpay.SetField CLng(PInst), "merchantreserved2", "예비2"					'예비2
	INIpay.SetField CLng(PInst), "merchantreserved3", "예비3"					'예비3


	'###############################################################################
	'# 5. 지불 요청 #
	'################
	INIpay.StartAction(CLng(PInst))

	'###############################################################################
	'# 6. 지불 결과 #
	'###############################################################################
	'-------------------------------------------------------------------------------
	' 가.모든 결제 수단에 공통되는 결제 결과 내용
	'-------------------------------------------------------------------------------
	Tid = INIpay.GetResult(CLng(PInst), "tid") '거래번호
	ResultCode = INIpay.GetResult(CLng(PInst), "resultcode") '결과코드 ("00"이면 지불성공)
	ResultMsg = INIpay.GetResult(CLng(PInst), "resultmsg") '결과내용
	PayMethod = INIpay.GetResult(CLng(PInst), "paymethod") '지불방법 (매뉴얼 참조)
	Moid = INIpay.GetResult(CLng(PInst), "moid") '상점 사용 주문번호
	IF ResultCode <> "00" THEN
		tmpErrCode = split(ResultMsg,"]")
		ResultErrCode = mid(tmpErrCode(0),2,Len(tmpErrCode(0))) '6자리 이하의 에러코드
	END IF

	'-------------------------------------------------------------------------------
	' 나. 신용카드,ISP,핸드폰, 전화 결제, 은행계좌이체, OK CASH BAG Point 결제시에만 결제 결과 내용  (무통장입금 , 문화 상품권 , 네모 제외)
	'-------------------------------------------------------------------------------
	PGAuthDate = INIpay.GetResult(CLng(PInst), "pgauthdate") '이니시스 승인날짜
	PGAuthTime = INIpay.GetResult(CLng(PInst), "pgauthtime") '이니시스 승인시각

	'-------------------------------------------------------------------------------
	' 다. 신용카드  결제수단을 이용시에만  결제결과 내용
	'-------------------------------------------------------------------------------
	AuthCode = INIpay.GetResult(CLng(PInst), "authcode") '신용카드 승인번호
	CardQuota = INIpay.GetResult(CLng(PInst), "cardquota") '할부기간
	QuotaInterest = Request("quotainterest") '무이자할부 여부("1"이면 무이자할부)
	CardNumber = INIpay.GetResult(CLng(PInst), "cardnumber") '카드번호 12자리
	CardCode = INIpay.GetResult(CLng(PInst), "cardcode") '신용카드사 코드 (매뉴얼 참조)
	CardIssuerCode = INIpay.GetResult(CLng(PInst), "cardissuercode") '신용카드 발급사(은행) 코드 (매뉴얼 참조)


	'###############################################################################
	'# 7. 결과 수신 확인 #
	'#####################
	'지불결과를 잘 수신하였음을 이니시스에 통보.
	'[주의] 이 과정이 누락되면 모든 거래가 자동취소됩니다.
	IF ResultCode = "00" THEN
		AckResult = INIpay.Ack(CLng(PInst))
		IF AckResult <> "SUCCESS" THEN '(실패)
			'=================================================================
			' 정상수신 통보 실패인 경우 이 승인은 이니시스에서 자동 취소되므로
			' 지불결과를 다시 받아옵니다(성공 -> 실패).
			'=================================================================
			ResultCode = INIpay.GetResult(CLng(PInst), "resultcode")
			ResultMsg = INIpay.GetResult(CLng(PInst), "resultmsg")
		END IF
	END IF


	'###############################################################################
	'# 8. 인스턴스 해제 #
	'####################
	INIpay.Destroy CLng(PInst)

	'###############################################################################
	'# 9. 지불결과 DB 연동 #
	'#######################
	'DB를 운영하는 경우 지불결과에 따라 이곳에 데이터베이스 연동 코드 등을 추가.
	'DB 입력에 실패하면 다음의 취소 코드를 수행하여 DB에 없는 거래가 발생하는 것을
	'막아주십시오.

		If resultcode = "00" Then

			goodname			= Request.Form("goodname")
			price    			= Request.Form("price")
			buyername   		= Request.Form("buyername")
			buyertel    		= Request.Form("buyertel")
			buyeremail  		= Request.Form("buyeremail")
			isDel				= "F"
			'OrderNum			= orderNum
			strGoodsName		= goodname
			intPrice			= price
			strName				= buyername
			strTel				= buyertel
			strEmail			= buyeremail
			strTid				= Tid				' 이니시스 거래번호
			strResultCode		= resultcode		' 결과코드 (00 일시 지불 성공)
			strResultMsg		= ResultMsg			' 결과내용
			strETC1				= PayMethod			' 지불방법
			strETC2				= PGAuthDate		' 이니시스 승인날짜
			strETC3				= PGAuthTime		' 이니시스 승인시각
			strETC4				= AuthCode			' 신용카드 승인번호
			strETC5				= CardQuota			' 할부기간
			strETC6				= QuotaInterest		' 무이자할부 여부("1"이면 무이자할부)
			strETC7				= CardNumber		' 카드번호 12자리
			strETC8				= CardCode			' 신용카드사 코드 (매뉴얼 참조)
			strETC9				= CardIssuerCode	' 신용카드 발급사(은행) 코드 (매뉴얼 참조)
			strETC10			= DK_MEMBER_ID


			arrParams = Array(_
				Db.makeParam("@isDel",adChar,adParamInput,1,isDel),_
				Db.makeParam("@OrderNum",adVarChar,adParamInput,50,OrderNum),_
				Db.makeParam("@strGoodsName",adVarWChar,adParamInput,200,strGoodsName), _
				Db.makeParam("@intPrice",adInteger,adParamInput,4,intPrice), _
				Db.makeParam("@strName",adVarWChar,adParamInput,100,strName), _
				Db.makeParam("@strTel",adVarChar,adParamInput,50,strTel),_
				Db.makeParam("@strEmail",adVarChar,adParamInput,200,strEmail),_
				Db.makeParam("@strMid",adVarChar,adParamInput,40,strTid),_
				Db.makeParam("@strResultCode",adVarChar,adParamInput,2,strResultCode),_
				Db.makeParam("@strResultMsg",adVarChar,adParamInput,200,strResultMsg),_
				Db.makeParam("@strETC1",adVarWChar,adParamInput,50,strETC1), _
				Db.makeParam("@strETC2",adVarWChar,adParamInput,50,strETC2), _
				Db.makeParam("@strETC3",adVarWChar,adParamInput,50,strETC3), _
				Db.makeParam("@strETC4",adVarWChar,adParamInput,50,strETC4), _
				Db.makeParam("@strETC5",adVarWChar,adParamInput,50,strETC5), _
				Db.makeParam("@strETC6",adVarWChar,adParamInput,50,strETC6), _
				Db.makeParam("@strETC7",adVarWChar,adParamInput,50,strETC7), _
				Db.makeParam("@strETC8",adVarWChar,adParamInput,50,strETC8), _
				Db.makeParam("@strETC9",adVarWChar,adParamInput,50,strETC9), _
				Db.makeParam("@strETC10",adVarWChar,adParamInput,50,strETC10), _
				Db.makeParam("@OUTPUT_VALUE",adVarChar,adParamOutput,10,"ERROR") _
			)

			Call Db.exec("DKPA_INICIS_SAFEKEY_INSERT",DB_PROC,arrParams,Nothing)
			OUTPUT_VALUE = arrParams(Ubound(arrParams))(4)

			If OUTPUT_VALUE = "FINISH" Then
			Else
				CancelInst = INIpay.Initialize("")
				INIpay.SetActionType CLng(CancelInst), "CANCEL"
				INIpay.SetField CLng(CancelInst), "pgid", "IniTechPG_" 'PG ID (고정)
				INIpay.SetField CLng(CancelInst), "spgip", "203.238.3.10" '예비 PG IP (고정)
				INIpay.SetField CLng(CancelInst), "admin", "1111" '키패스워드(상점아이디에 따라 변경)
				INIpay.SetField CLng(CancelInst), "debug", "true" '로그모드("true"로 설정하면 상세한 로그를 남김)
				INIpay.SetField CLng(CancelInst), "mid", Request("mid")
				INIpay.SetField CLng(CancelInst), "tid", Tid
				INIpay.SetField CLng(CancelInst), "msg", "MERCHANT'S DB FAIL" '취소사유
				INIpay.StartAction(CLng(CancelInst))
				CancelResultCode = INIpay.GetResult(CLng(CancelInst), "resultcode")
				CancelResultMsg = INIpay.GetResult(CLng(CancelInst), "resultmsg")
				INIpay.Destroy CLng(CancelInst)
				IF CancelResultCode = "00" THEN '취소성공이면 지불결과 변경
						ResultCode = "01"
						ResultMsg = "지불결과 DB 연동 실패"
				END IF
			End If



		End If




	'CancelInst = INIpay.Initialize("")
	'INIpay.SetActionType CLng(CancelInst), "CANCEL"
	'INIpay.SetField CLng(CancelInst), "pgid", "IniTechPG_" 'PG ID (고정)
	'INIpay.SetField CLng(CancelInst), "spgip", "203.238.3.10" '예비 PG IP (고정)
	'INIpay.SetField CLng(CancelInst), "admin", "1111" '키패스워드(상점아이디에 따라 변경)
	'INIpay.SetField CLng(CancelInst), "debug", "true" '로그모드("true"로 설정하면 상세한 로그를 남김)
	'INIpay.SetField CLng(CancelInst), "mid", Request("mid")
	'INIpay.SetField CLng(CancelInst), "tid", Tid
	'INIpay.SetField CLng(CancelInst), "msg", "MERCHANT'S DB FAIL" '취소사유
	'INIpay.StartAction(CLng(CancelInst))
	'CancelResultCode = INIpay.GetResult(CLng(CancelInst), "resultcode")
	'CancelResultMsg = INIpay.GetResult(CLng(CancelInst), "resultmsg")
	'INIpay.Destroy CLng(CancelInst)
	'IF CancelResultCode = "00" THEN '취소성공이면 지불결과 변경
	'		ResultCode = "01"
	'		ResultMsg = "지불결과 DB 연동 실패"
	'END IF
%>
<link rel="stylesheet" href="SafeKey.css" />
<link rel="stylesheet" href="css/group.css" type="text/css">
<script type="text/javascript" src="SafeKey.js"></script>
<script type="text/javascript" src="/jscript/calendar.js"></script>
<script type="text/javascript">
<!--
	var openwin=window.open("childwin.html","childwin","width=300,height=160");
	openwin.close();

	/*-------------------------------------------------------------------------------------------------------
    * 1. ResultCode
    *       가. 결 과 코 드: "00" 인 경우 결제 성공[무통장입금인 경우 - 고객님의 무통장입금 요청이 완료]	*
    *       나. 결 과 코 드: "00"외의 값인 경우 결제 실패  						*
    *------------------------------------------------------------------------------------------------------*/

	function receipt(tid)
	{
		if("<%=ResultCode%>" == "00")
		{
			var receiptUrl = "https://iniweb.inicis.com/DefaultWebApp/mall/cr/cm/mCmReceipt_head.jsp?noTid=" + "<%=Tid%>" + "&noMethod=1";
			window.open(receiptUrl,"receipt","width=430,height=700, scrollbars=yes,resizable=yes");
		}
		else
		{
			alert("해당하는 결제내역이 없습니다");
		}
	}

	function errhelp()
	{
		var errhelpUrl = "http://www.inicis.com/ErrCode/Error.jsp?result_err_code=" + "<%=ResultErrCode%>"
						 + "&mid=" + "<%=request("mid")%>" +  "&tid=<%=Tid%>" + "&goodname=" + "<%=request("goodname")%>"
						 + "&price=" + "<%=request("price")%>" + "&paymethod=" + "<%=PayMethod%>" + "&buyername=" + "<%=request("buyername")%>"
						 + "&buyertel=" + "<%=request("buyertel")%>" + "&buyeremail=" + "<%=request("buyeremail")%>"
						 + "&codegw=" + "<%=CodeGW%>";
		window.open(errhelpUrl,"errhelp","width=520,height=150");
	}
	function MM_reloadPage(init) {  //reloads the window if Nav4 resized
	  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
		document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
	  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}
	MM_reloadPage(true);
//-->
</script>
</head>
<body>
<!--#include virtual = "/admin/_inc/header.asp"-->
<div id="safekey" class="">
	<p class="titles">결제 요청</p>
	<p class="caution">상단의 페이지 설명의 주의사항을 반드시 읽고 결제를 진행하세요</p>
	<form name="ini" method="post" action="INSafeKeyIN.asp" onSubmit="return pay(this)">
<table width="632" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="85" background=<%
					'*-------------------------------------------------------------------------------------------------------
					'* 결제 방법에 따라 상단 이미지가 변경 된다
					'* 	 가. 결제 실패 시에 "img/spool_top.gif" 이미지 사용
					'*       가. 결제 방법에 따라 상단 이미지가 변경
					'*       	ㄱ. 신용카드 	- 	"img/card.gif"
					'*		ㄴ. ISP		-	"img/card.gif"
					'*		ㄷ. 은행계좌	-	"img/bank.gif"
					'*		ㄹ. 무통장입금	-	"img/bank.gif"
					'*		ㅁ. 핸드폰	- 	"img/hpp.gif"
					'*		ㅂ. 전화결제 (ars전화 결제)	-	"img/phone.gif"
					'*		ㅅ. 전화결제 (받는전화결제)	-	"img/phone.gif"
					'*		ㅇ. OK CASH BAG POINT		-	"img/okcash.gif"
					'*		ㅈ. 문화상품권	-	"img/ticket.gif"
					'*		ㅊ. 네모	-	"img/nemo.gif"
					'-------------------------------------------------------------------------------------------------------*/

    			IF ResultCode = "01" THEN 		'실패인 경우
					response.write "img/spool_top.gif"
				ELSE
    				Select Case PayMethod
						Case "Card"  ' 신용카드
							response.write "img/card.gif"
						Case "VCard"  ' ISP
							response.write "img/card.gif"
						Case "HPP"  ' 휴대폰
							response.write "img/hpp.gif"
						Case "Ars1588Bill"  ' 1588
							response.write "img/phone.gif"
						Case "PhoneBill"  ' 폰빌
							response.write "img/phone.gif"
						Case "OCBPoint"  ' OKCASHBAG
							response.write "img/okcash.gif"
						Case "DirectBank"   ' 은행계좌이체
							response.write "img/bank.gif"
						Case "VBank"   ' 무통장 입금 서비스
							response.write "img/bank.gif"
						Case "Culture"   ' 문화상품권 결제
							response.write "img/ticket.gif"
						Case "NEMO"   ' 네모 결제
							response.write "img/nemo.gif"
						Case Else // 기타 지불수단의 경우
							response.write "img/card.gif"
					End Select
				END IF

    				%> style="padding:0 0 0 64">

	  <!-------------------------------------------------------------------------------------------------------
	   *  아래 부분은 모든 결제수단의 공통적인 결과메세지 출력 부분입니다.
	   *	1. ResultCode 	(결 과 코 드)
	   *  	2. ResultMsg		(결과 메세지)
	   *  	3. PayMethod		(결 제 수 단)
	   *  	4. Tid			(거 래 번 호)
	   *  	5. Moid  		(주 문 번 호)
	   -------------------------------------------------------------------------------------------------------->
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="3%" valign="top"><img src="img/title_01.gif" width="8" height="27" vspace="5"></td>
          <td width="97%" height="40" class="pl_03"><font color="#FFFFFF"><b>결제결과(통신판매용)</b></font></td>
        </tr>
      </table>
	</td>
  </tr>
  <tr>
    <td align="center" bgcolor="6095BC">
      <table width="620" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td bgcolor="#FFFFFF" style="padding:0 0 0 56">
		  <table width="510" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="7"><img src="img/life.gif" width="7" height="30"></td>
                <td background="img/center.gif"><img src="img/icon03.gif" width="12" height="10">

                <!-------------------------------------------------------------------------------------------------------
                 * 1. ResultCode 										*
                 *       가. 결 과 코 드: "00" 인 경우 결제 성공[무통장입금인 경우 - 고객님의 무통장입금 요청이 완료]	*
                 *       나. 결 과 코 드: "00"외의 값인 경우 결제 실패  						*
                 -------------------------------------------------------------------------------------------------------->
                  <b>
                  <% 	IF (ResultCode = "00") AND (PayMethod = "VBank") THEN
                  			response.write "입금 요청이 완료되었습니다."
						ELSEIF ResultCode = "00" THEN
							response.write "고객님의 결제요청이 성공되었습니다."
                        ELSE
                        	response.write "고객님의 결제요청이 실패되었습니다."
                        END IF
				  %></b></td>
                <td width="8"><img src="img/right.gif" width="8" height="30"></td>
              </tr>
            </table>
            <br>
            <table width="510" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="407"  style="padding:0 0 0 9">
				  <img src="img/icon.gif" width="10" height="11">
                  <strong><font color="433F37">결제내역</font></strong></td>
                <td width="103">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" style="padding:0 0 0 23">
		  		  <table width="470" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                	  <!-------------------------------------------------------------------------------------------------------
                	   * 2. PayMethod 										*
                	   *       가. 결제 방법에 대한 값									*
                	   *       	ㄱ. 신용카드 	- 	Card								*
                	   *		ㄴ. ISP		-	VCard								*
                	   *		ㄷ. 은행계좌	-	DirectBank							*
                	   *		ㄹ. 무통장입금	-	VBank								*
                	   *		ㅁ. 핸드폰	- 	HPP								*
                	   *		ㅂ. 전화결제 (ars전화 결제)	-	Ars1588Bill					*
                	   *		ㅅ. 전화결제 (받는전화결제)	-	PhoneBill					*
                	   *		ㅇ. OK CASH BAG POINT		-	OCBPoint					*
                	   *		ㅈ. 문화상품권	-	Culture								*
                	   *		ㅊ. 네모	-	NEMO								*
                	   -------------------------------------------------------------------------------------------------------->
                      <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                      <td width="109" height="25">결 제 방 법</td>
                      <td width="343"><%=PayMethod%></td>
                    </tr>
                    <tr>
                      <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                    </tr>
                    <tr>
                      <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                      <td width="109" height="26">결 과 코 드</td>
                      <td width="343">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td><%=ResultCode%></td>
                            <td width='142' align='right'>
                			<!-------------------------------------------------------------------------------------------------------
                			 * 2. ResultCode 값에 따라 "영수증 보기" 또는 "실패 내역 자세히 보기" 버튼 출력		*
                			 *       가. 결제 코드의 값이 "00"인 경우에는 "영수증 보기" 버튼 출력					*
                			 *       나. 결제 코드의 값이 "00" 외의 값인 경우에는 "실패 내역 자세히 보기" 버튼 출력			*
                			 -------------------------------------------------------------------------------------------------------->
							<!-- 실패결과 상세 내역 버튼 출력 -->
							<%
                            IF ResultCode = "00" THEN
                				response.write "<a href='javascript:receipt();'><img src='img/button_02.gif' width='94' height='24' border='0'></a>"
                			ELSE
                            	response.write "<a href='javascript:errhelp();'><img src='img/button_01.gif' width='142' height='24' border='0'></a>"
                            END IF

                            %>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>

                <!-------------------------------------------------------------------------------------------------------
                 * 1. ResultMsg 										*
                 *       가. 결과 내용을 보여 준다 실패시에는 "[에러코드] 실패 메세지" 형태로 보여 준다.                *
                 *		예> [9121]서명확인오류									*
                 -------------------------------------------------------------------------------------------------------->
                    <tr>
                      <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                    </tr>
                    <tr>
                      <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                      <td width="109" height="25">결 과 내 용</td>
                      <td width="343"><%=ResultMsg%></td>
                    </tr>
                    <tr>
                      <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                    </tr>

                <!-------------------------------------------------------------------------------------------------------
                 * 1. Tid											*
                 *       가. 이니시스가 부여한 거래 번호 -모든 거래를 구분할 수 있는 키가 되는 값			*
                 -------------------------------------------------------------------------------------------------------->
                    <tr>
                      <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                      <td width="109" height="25">거 래 번 호</td>
                      <td width="343"><%=Tid%></td>
                    </tr>
                    <tr>
                      <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                    </tr>

                <!-------------------------------------------------------------------------------------------------------
                 * 1. Moid											*
                 *       가. 상점에서 할당한 주문번호 									*
                 -------------------------------------------------------------------------------------------------------->

				 <!--
                    <tr>
                      <td width="18" align="center"><img src="img/icon02.gif" width="7" height="7"></td>
                      <td width="109" height="25">주 문 번 호</td>
                      <td width="343"><%=Moid%></td>
                    </tr>
                    <tr>
                      <td height="1" colspan="3" align="center"  background="img/line.gif"></td>
                    </tr>
				-->

<%

'-------------------------------------------------------------------------------------------------------
'													*
'  아래 부분은 결제 수단별 결과 메세지 출력 부분입니다.			    			*
'  													*
'  if ELSEIF 문 형태로 결제 수단별로 출력 하고 있습니다.						*
'  아래 순서로 출력 합니다.										*
'													*
'  1.	신용카드 , ISP 결제 (OK CASH BAG POINT 복합 결제 내역 )						*
'  2.  계좌이체 											*
'  3.  무통장입금											*
'  4.  												*
'------------------------------------------------------------------------------------------------------*/

	'-------------------------------------------------------------------------------------------------------
	'													*
	'  아래 부분은 결제 수단별 결과 메세지 출력 부분입니다.    						*
	'													*
	'  1.  신용카드 , ISP 결제 결과 출력 (OK CASH BAG POINT 복합 결제 내역 )				*
	'------------------------------------------------------------------------------------------------------*/

	IF (PayMethod = "Card") OR (PayMethod = "VCard") THEN
%>
					<tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>신용카드번호</td>
                      <td width='343'><%=CardNumber%>****</td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
					<tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 날 짜</td>
                      <td width='343'><%=PGAuthDate%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 시 각</td>
                      <td width='343'><%=PGAuthTime%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 번 호</td>
                      <td width='343'><%=AuthCode%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>할 부 기 간</td>
                      <td width='343'><%=CardQuota%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>카 드 종 류</td>
                      <td width='343'><%=CardCode%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>카드발급사</td>
                      <td width='343'><%=CardIssuerCode%></td>
                    </tr>

					<!--
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3'>&nbsp;</td>
                    </tr>
                    <tr>
                	 <td style='padding:0 0 0 9' colspan='3'><img src='img/icon.gif' width='10' height='11'>
        	        	  <strong><font color='433F37'>OK CASHBAG 적립 및 사용내역</font></strong></td>
                	</tr>
                	<tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>카 드 번 호</td>
                      <td width='343'><%=OCBCardNumber%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>적립 승인번호</td>
                      <td width='343'><%=OCBSaveAuthCode%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>사용 승인번호</td>
                      <td width='343'><%=OCBUseAuthCode%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 일 시</td>
                      <td width='343'><%=OCBAuthDate%></td>
                    </tr>
                	<tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>포인트지불금액</td>
                      <td width='343'><%=Price2%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>

					-->
<%
     '-------------------------------------------------------------------------------------------------------
	 '													*
	 '  아래 부분은 결제 수단별 결과 메세지 출력 부분입니다.    						*
	 '													*
	 '  2.  은행계좌결제 결과 출력 										*
	 '------------------------------------------------------------------------------------------------------*/

          ELSEIF PayMethod = "DirectBank" THEN

%>
          			<tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 날 짜</td>
                      <td width='343'><%=PGAuthDate%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 시 각</td>
                      <td width='343'><%=PGAuthTime%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>

<%
     '-------------------------------------------------------------------------------------------------------
	 '													*
	 '  아래 부분은 결제 수단별 결과 메세지 출력 부분입니다.    						*
	 '													*
	 '  3.  무통장입금 입금 예정 결과 출력 (결제 성공이 아닌 입금 예정 성공 유무)				*
	 '------------------------------------------------------------------------------------------------------*/

          ELSEIF PayMethod = "VBank" THEN

%>
          			<tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>입금계좌번호</td>
                      <td width='343'><%=Vacct%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>입금 은행코드</td>
                      <td width='343'><%=VcdBank%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>예금주 명</td>
                      <td width='343'><%=NmVacct%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>송금자 명</td>
                      <td width='343'><%=NmInput%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>송금자 주민번호</td>
                      <td width='343'><%=PerNo%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>송금 일자</td>
                      <td width='343'><%=DtInput&" "&TMInput%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>

<%
     '-------------------------------------------------------------------------------------------------------
	 '													*
	 '  아래 부분은 결제 수단별 결과 메세지 출력 부분입니다.    						*
	 '													*
	 '  4.  핸드폰 결제 											*
	 '------------------------------------------------------------------------------------------------------*/

          ELSEIF PayMethod = "HPP" THEN

%>

          			<tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>휴대폰번호</td>
                      <td width='343'><%=NoHPP%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 날 짜</td>
                      <td width='343'><%=PGAuthDate%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 시 각</td>
                      <td width='343'><%=PGAuthTime%></td>
                    </tr>
					<tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
<%
     '-------------------------------------------------------------------------------------------------------
	 '													*
	 '  아래 부분은 결제 수단별 결과 메세지 출력 부분입니다.    						*
	 '													*
	 '  4.  전화 결제 											*
	 '------------------------------------------------------------------------------------------------------*/

         ELSEIF PayMethod = "Ars1588Bill" OR PayMethod = "PhoneBill" THEN

%>
                	<tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>전 화 번 호</td>
                      <td width='343'><%=NoARS%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                	<tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 날 짜</td>
                      <td width='343'><%=PGAuthDate%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 시 각</td>
                      <td width='343'><%=PGAuthTime%></td>
                    </tr>
                	<tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
<%
     '-------------------------------------------------------------------------------------------------------
	 '													*
	 '  아래 부분은 결제 수단별 결과 메세지 출력 부분입니다.    						*
	 '													*
	 '  4.  OK CASH BAG POINT 적립 및 지불 									*
	 '------------------------------------------------------------------------------------------------------*/

         ELSEIF PayMethod = "OCBPoint" THEN

%>
                	<tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>카 드 번 호</td>
                      <td width='343'><%=OCBCardNumber%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                	<tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 날 짜</td>
                      <td width='343'><%=PGAuthDate%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 시 각</td>
                      <td width='343'><%=PGAuthTime%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>적립 승인번호</td>
                      <td width='343'><%=OCBSaveAuthCode%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>사용 승인번호</td>
                      <td width='343'><%=OCBUseAuthCode%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>승 인 일 시</td>
                      <td width='343'><%=OCBAuthDate%></td>
                    </tr>
                	<tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                    <tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>포인트지불금액</td>
                      <td width='343'><%=Price2%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
<%
     '-------------------------------------------------------------------------------------------------------
	 '													*
	 '  아래 부분은 결제 수단별 결과 메세지 출력 부분입니다.    						*
	 '													*
	 '  4.  문화 상품권						                			*
	 '------------------------------------------------------------------------------------------------------*/

         ELSEIF PayMethod = "Culture" THEN

%>
                	<tr>
                      <td width='18' align='center'><img src='img/icon02.gif' width='7' height='7'></td>
                      <td width='109' height='25'>컬쳐랜드 ID</td>
                      <td width='343'><%=CultureId%></td>
                    </tr>
                    <tr>
                      <td height='1' colspan='3' align='center'  background='img/line.gif'></td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
            <br>

<!-------------------------------------------------------------------------------------------------------
 *													*
 *  결제 성공시(ResultCode = "00"인 경우 ) "이용안내"  보여주기 부분입니다.			*
 *  결제 수단별로 이용고객에게 결제 수단에 대한 주의 사항을 보여 줍니다. 				*
 *  switch , case문 형태로 결제 수단별로 출력 하고 있습니다.						*
 *  아래 순서로 출력 합니다.										*
 *													*
 *  1.	신용카드 											*
 *  2.  ISP 결제 											*
 *  3.  핸드폰 												*
 *  4.  전화 결제 (1588Bill)										*
 *  5.  전화 결제 (PhoneBill)										*
 *  6.	OK CASH BAG POINT										*
 *  7.  은행계좌이체											*
 *  8.  무통장 입금 서비스										*
 *  9.  문화상품권 결제											*
 ------------------------------------------------------------------------------------------------------->

            <%

            	IF ResultCode = "00" THEN

            		SELECT CASE PayMethod
            		'-------------------------------------------------------------------------------------------------------
	 				'													*
	 				' 결제 성공시 이용안내 보여주기 			    						*
					'													*
	 				'  1.  신용카드 						                			*
	 				'-------------------------------------------------------------------------------------------------------*/
					CASE "Card"
			%>
			<table width='510' border='0' cellspacing='0' cellpadding='0'>
         	  <tr>
         	    <td height='25'  style='padding:0 0 0 9'><img src='img/icon.gif' width='10' height='11'>
         	      <strong><font color='433F37'>이용안내</font></strong></td>
         	  </tr>
         	  <tr>
         	    <td  style='padding:0 0 0 23'>
         	      <table width='470' border='0' cellspacing='0' cellpadding='0'>
         	        <tr>
         	          <td height='25'>(1) 신용카드 청구서에 <b>\"이니시스(inicis.com)\"</b>으로 표기됩니다.</td>
         	        </tr>
         	        <tr>
         	          <td height='25'>(2) LG카드 및 BC카드의 경우 <b>\"이니시스(이용 상점명)\"</b>으로 표기되고, 삼성카드의 경우 <b>\"이니시스(이용상점 URL)\"</b>로 표기됩니다.</td>
         	        </tr>
         	        <tr>
         	          <td height='1' colspan='2' align='center'  background='img/line.gif'></td>
         	        </tr>
         	      </table>
         	    </td>
         	  </tr>
         	</table>

				<%
		'-------------------------------------------------------------------------------------------------------
	 			'													*
	 			' 결제 성공시 이용안내 보여주기 			    						*
				'													*
	 			'  2.  ISP 						                				*
	 			'-------------------------------------------------------------------------------------------------------*/

				CASE "VCard"// ISP
			%>
			<table width='510' border='0' cellspacing='0' cellpadding='0'>
         	  <tr>
         	    <td height='25'  style='padding:0 0 0 9'><img src='img/icon.gif' width='10' height='11'>
         	      <strong><font color='433F37'>이용안내</font></strong></td>
         	  </tr>
         	  <tr>
         	    <td  style='padding:0 0 0 23'>
         	      <table width='470' border='0' cellspacing='0' cellpadding='0'>
         	        <tr>
         	          <td he
         	          (2) LG카드 및 BC카드의 경우 <b>\"이니시스(이용 상점명)\"</b>으로 표기되고, 삼성카드의 경우 <b>\"이니시스(이용상점 URL)\"</b>로 표기됩니다.
         	          </td>
         	        </tr>
         	        <tr>
         	          <td height='1' colspan='2' align='center'  background='img/line.gif'></td>
         	        </tr>

         	      </table></td>
         	  </tr>
         	</table>

					<%
		'-------------------------------------------------------------------------------------------------------
	 			'													*
	 			' 결제 성공시 이용안내 보여주기 			    						*
				'													*
	 			'  3. 핸드폰 						                				*
	 			'-------------------------------------------------------------------------------------------------------*/

				CASE "HPP"// 휴대폰
			%>
			<table width='510' border='0' cellspacing='0' cellpadding='0'>
         	  <tr>
         	    <td height='25'  style='padding:0 0 0 9'><img src='img/icon.gif' width='10' height='11'>
         	      <strong><font color='433F37'>이용안내</font></strong></td>
         	  </tr>
         	  <tr>
         	    <td  style='padding:0 0 0 23'>
         	      <table width='470' border='0' cellspacing='0' cellpadding='0'>
         	        <tr>
         	          <td height='25'>(1) 핸드폰 청구서에 <b>\"소액결제\"</b> 또는 <b>\"외부정보이용료\"</b>로 청구됩니다.<br>
         	          (2) 본인의 월 한도금액을 확인하시고자 할 경우 각 이동통신사의 고객센터를 이용해주십시오.
         	          </td>
         	        </tr>
         	        <tr>
         	          <td height='1' colspan='2' align='center'  background='img/line.gif'></td>
         	        </tr>

         	      </table></td>
         	  </tr>
         	</table>
				<%
		'-------------------------------------------------------------------------------------------------------
	 			'													*
	 			' 결제 성공시 이용안내 보여주기 			    						*
				'													*
	 			'  4. 전화 결제 (ARS1588Bill)				                				*
	 			'-------------------------------------------------------------------------------------------------------*/

				CASE "Ars1588Bill"
			%>
			<table width='510' border='0' cellspacing='0' cellpadding='0'>
         	  <tr>
         	    <td height='25'  style='padding:0 0 0 9'><img src='img/icon.gif' width='10' height='11'>
         	      <strong><font color='433F37'>이용안내</font></strong></td>
         	  </tr>
         	  <tr>
         	    <td  style='padding:0 0 0 23'>
         	      <table width='470' border='0' cellspacing='0' cellpadding='0'>
         	        <tr>
         	          <td height='25'>(1) 전화 청구서에 <b>\"컨텐츠 이용료\"</b>로 청구됩니다.<br>
                                                      (2) 월 한도금액의 경우 동일한 가입자의 경우 등록된 전화번호 기준이 아닌 주민등록번호를 기준으로 책정되어 있습니다.<br>
                                                      (3) 전화 결제취소는 당월에만 가능합니다.
         	          </td>
         	        </tr>
         	        <tr>
         	          <td height='1' colspan='2' align='center'  background='img/line.gif'></td>
         	        </tr>

         	      </table></td>
         	  </tr>
         	</table>

				<%
		'-------------------------------------------------------------------------------------------------------
	 			'													*
	 			' 결제 성공시 이용안내 보여주기 			    						*
				'													*
	 			'  5. 폰빌 결제 (PhoneBill)				                				*
	 			'-------------------------------------------------------------------------------------------------------*/

				CASE "PhoneBill"
			%>
			<table width='510' border='0' cellspacing='0' cellpadding='0'>
         	  <tr>
         	    <td height='25'  style='padding:0 0 0 9'><img src='img/icon.gif' width='10' height='11'>
         	      <strong><font color='433F37'>이용안내</font></strong></td>
         	  </tr>
         	  <tr>
         	    <td  style='padding:0 0 0 23'>
         	      <table width='470' border='0' cellspacing='0' cellpadding='0'>
         	        <tr>
         	          <td height='25'>(1) 전화 청구서에 <b>\"인터넷 컨텐츠 (음성)정보이용료\"</b>로 청구됩니다.<br>
                                                      (2) 월 한도금액의 경우 동일한 가입자의 경우 등록된 전화번호 기준이 아닌 주민등록번호를 기준으로 책정되어 있습니다.<br>
                                                      (3) 전화 결제취소는 당월에만 가능합니다.
         	          </td>
         	        </tr>
         	        <tr>
         	          <td height='1' colspan='2' align='center'  background='img/line.gif'></td>
         	        </tr>

         	      </table></td>
         	  </tr>
         	</table>

				<%
		'-------------------------------------------------------------------------------------------------------
	 			'													*
	 			' 결제 성공시 이용안내 보여주기 			    						*
				'													*
	 			'  6. OK CASH BAG POINT					                				*
	 			'-------------------------------------------------------------------------------------------------------*/

				CASE "OCBPoint"
			%>
			<table width='510' border='0' cellspacing='0' cellpadding='0'>
         	  <tr>
         	    <td height='25'  style='padding:0 0 0 9'><img src='img/icon.gif' width='10' height='11'>
         	      <strong><font color='433F37'>이용안내</font></strong></td>
         	  </tr>
         	  <tr>
         	    <td  style='padding:0 0 0 23'>
         	      <table width='470' border='0' cellspacing='0' cellpadding='0'>
         	        <tr>
         	          <td height='25'>(1) OK CASH BAG 포인트 결제취소는 당월에만 가능합니다.
         	          </td>
         	        </tr>
         	        <tr>
         	          <td height='1' colspan='2' align='center'  background='img/line.gif'></td>
         	        </tr>

         	      </table></td>
         	  </tr>
         	</table>

				<%
		'-------------------------------------------------------------------------------------------------------
	 			'													*
	 			' 결제 성공시 이용안내 보여주기 			    						*
				'													*
	 			'  7. 은행계좌이체					                				*
	 			'-------------------------------------------------------------------------------------------------------*/

				CASE "DirectBank"
			%>
			<table width='510' border='0' cellspacing='0' cellpadding='0'>
         	  <tr>
         	    <td height='25'  style='padding:0 0 0 9'><img src='img/icon.gif' width='10' height='11'>
         	      <strong><font color='433F37'>이용안내</font></strong></td>
         	  </tr>
         	  <tr>
         	    <td  style='padding:0 0 0 23'>
         	      <table width='470' border='0' cellspacing='0' cellpadding='0'>
         	        <tr>
         	          <td height='25'>(1) 고객님의 통장에는 <b>\"이니시스\"</b>로 표기됩니다.<br>
         	          </td>
         	        </tr>
         	        <tr>
         	          <td height='1' colspan='2' align='center'  background='img/line.gif'></td>
         	        </tr>

         	      </table></td>
         	  </tr>
         	</table>

				<%
		'-------------------------------------------------------------------------------------------------------
	 			'													*
	 			' 결제 성공시 이용안내 보여주기 			    						*
				'													*
	 			'  8. 무통장 입금 서비스					                				*
	 			'-------------------------------------------------------------------------------------------------------*/
				CASE "VBank"
			%>
			<table width='510' border='0' cellspacing='0' cellpadding='0'>
         	  <tr>
         	    <td height='25'  style='padding:0 0 0 9'><img src='img/icon.gif' width='10' height='11'>
         	      <strong><font color='433F37'>이용안내</font></strong></td>
         	  </tr>
         	  <tr>
         	    <td  style='padding:0 0 0 23'>
         	      <table width='470' border='0' cellspacing='0' cellpadding='0'>
         	        <tr>
         			 (1) 기 결과는 입금예약이 완료된 것일뿐 실제 입금완료가 이루어진 것이 아닙니다.<br>
         	         (2) 상기 입금계좌로 해당 상품금액을 무통장입금(창구입금)하시거나, 인터넷 뱅킹 등을 통한 온라인 송금을 하시기 바랍니다.<br>
                                          (3) 반드시 입금기한 내에 입금하시기 바라며, 대금입금시 반드시 주문하신 금액만 입금하시기 바랍니다.
                                          </td>
         	        </tr>
         	        <tr>
         	          <td height='1' colspan='2' align='center'  background='img/line.gif'></td>
         	        </tr>

         	      </table></td>
         	  </tr>
         	</table>

				<%
				'-------------------------------------------------------------------------------------------------------
	 			'													*
	 			' 결제 성공시 이용안내 보여주기 			    						*
				'													*
	 			'  9. 문화상품권 결제					                				*
	 			'-------------------------------------------------------------------------------------------------------*/

				CASE "Culture"
			%>
			<table width='510' border='0' cellspacing='0' cellpadding='0'>
         	  <tr>
         	    <td height='25'  style='padding:0 0 0 9'><img src='img/icon.gif' width='10' height='11'>
         	      <strong><font color='433F37'>이용안내</font></strong></td>
         	  </tr>
         	  <tr>
         	    <td  style='padding:0 0 0 23'>
         	      <table width='470' border='0' cellspacing='0' cellpadding='0'>
         	        <tr>
         	          <td height='25'>(1) 문화상품권을 온라인에서 이용하신 경우 오프라인에서는 사용하실 수 없습니다.<br>
         	                          (2) 컬쳐캐쉬 잔액이 남아있는 경우, 고객님의 컬쳐캐쉬 잔액을 다시 사용하시려면 컬쳐랜드 ID를 기억하시기 바랍니다.
         	          </td>
         	        </tr>
         	        <tr>
         	          <td height='1' colspan='2' align='center'  background='img/line.gif'></td>
         	        </tr>

         	      </table></td>
         	  </tr>
         	</table>
<%
				END SELECT
		END IF
END IF
%>

            <!-- 이용안내 끝 -->
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<table width="632" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><img src="img/bottom01.gif" width="632" height="13"></td>
  </tr>
</table>
</div>

<!--#include virtual = "/admin/_inc/copyright.asp"-->
<%End If%>