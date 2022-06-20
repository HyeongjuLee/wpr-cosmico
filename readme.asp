<!--#include virtual="/_lib/strFunc.asp" -->
<%
  If webproIP <> "T" Then
    Response.Redirect "/index.asp"
  End If
  Response.End
%>
<%
  '########################################################
  ' 기준샵2 기능 (기준샵1 기능 + META21 기준, 2022-06-09~)
  '########################################################

  '● 전체적 디자인 + style 변경


  '● 특판 방판
  ' <!--#include virtual = "/MLM/_inc_MLM_Report.asp"-->
  ' p_mlmunion_Order_3  : CS프로시져 내 특판 방판 신고방식


  '● 뿌리오 문자, 알림톡
    '관리자 템플릿 관리

    '회원가입 이메일 발송(meta21)
    'Call FnWelComeMail(Dec_strEmail, THISMEMID1, THISMEMID2, "join2", "")		'이메일 전용

    '회원가입 알림톡 발송(meta21)
    'Call FN_PPURIO_MESSAGE(THISMEMID1, THISMEMID2, "join", "at", "", "")

    '회원가입 문자 발송(meta21)
    'Call Fn_MemMessage_Send(THISMEMID1, THISMEMID2, "join")


  '● 뿌리오 알림톡 CS용 api
  ' /api/cs/ppurio/join
  ' /api/cs/ppurio/order


  '● 회원가입
	' NICE 계좌인증 + 핸드폰인증
  ' joinStep01.asp ~ joinStep04Handler.asp
	'	NICE_BANK_WITH_MOBILE_USE = "T"

	' NICE 계좌인증
  ' joinStep01.asp ~ joinStep04Handler.asp
	'	NICE_BANK_WITH_MOBILE_USE = "F"


  '● 바이럴 추천 단축URL    ex) http://abc.com/v/T6Kn
  ' IIS rewrite (or web.config) 설정
  ' <rule name="viral member join">
  '    <match url="^v/([0-9a-z]+)" />
  '    <action type="Rewrite" url="/vidRewrite/vid.asp?vid={R:1}" />
  ' </rule>
  ' vidRewite 폴더 확인
  ' vidRedirect 폴더 확인


  '● 현금영수증 기록 / 신고 (ONOFFKOREA .js 파일 기준)
  ' 무통장 / 가상계좌(ONOFFKOREA)
    'C_HY_TF
    'C_HY_Date
    'C_HY_ApNum
    'C_HY_SendNum
    'C_HY_Division
    'C_HY_Number_Division


  '● 가상계좌(ONOFFKOREA)
  ' /PG/ONOFFKOREA/vBankResult.asp
  '  Call PG_ONOFFKOREA_CASH_RECEIPT(TX_ONOFF_TID, vBankAmt, HJRS_CSORDERNUM)
  ' /myoffice/buy/order_list.asp
  ' /myoffice/buy/cashReceipt.asp?seq=


  '● Table Sort 플러그인
  '  jquery.wprTablesorter.js
  '  $("#tableID").wprTablesorter({ ....
  ' 추천/후원인 정보
  ' 본인구매내역
  ' 수당페이지
  ' 포인트내역


  '● 본인구매 페이지
  ' 본인구매 상세내역 Modal Popup 변경
  ' order_list_detail.asp
  ' ONOFFKOREA 가상계좌 현금영수증 확인(cashReceiptBtn)


  '● 수당페이지
  ' 일자별 조회기능 추가 - HJPS_CS_PRICE01
  ' 합계내역 표기 - HJPS_CS_PRICE01_ALL_TOTAL
  ' 수당 상세내역 Modal Popup 변경


  '● 포인트1,2,3 메뉴 통합
  ' 리스트
  ' 이체/출금
  ' 보안비번(이체/출금핀) 관리 페이지


  '● box 조직도 스타일(라인굵기, box) 변경

%>
<%
  '▲ SNS 로그인 진행중
%>
