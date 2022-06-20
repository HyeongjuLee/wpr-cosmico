<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <취소 결과 설정>
' 사용전 결과 옵션을 사용자 환경에 맞도록 변경하세요.
' 상점키, MID는 꼭 변경하세요.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set NICEpay = Server.CreateObject("NICE.NICETX2.1")
PInst = NICEpay.Initialize("")
merchantKey = "b+zhZ4yOZ7FsH8pm5lhDfHZEb79tIwnjsdA0FBXh86yLc6BJeFVrZFXhAoJ3gEWgrWwN+lJMV0W4hvDdbe4Sjw=="

NICEpay.SetField CLng(PInst),"MID",Request("MID")                   '상점 ID
NICEpay.SetField CLng(PInst),"logpath","C:\log"                     'Log Path 설정
NICEpay.SetField CLng(PInst),"LicenseKey",merchantKey               'MID
NICEpay.SetField CLng(PInst),"CardInterest","0"                     '무이자할부 여부 (1:YES, 0:NO) 
NICEpay.SetField CLng(PInst),"CancelPwd","123456"                   '거래취소 패스워드
NICEpay.SetField CLng(PInst),"debug", "true"                        '로그모드(true = 상세 로그)
NICEpay.SetField CLng(PInst),"AuthFlag","2"                         '비인증결제: 2
NICEpay.SetActionType CLng(PInst), "FORMPAY"                        '결제방법
NICEpay.SetField CLng(PInst),"PayMethod",Request("paymethod")	      '결제수단
NICEpay.SetField CLng(PInst),"Amt",Request("amt")                   '결제금액 
NICEpay.SetField CLng(PInst),"Moid","123456789moid"                 '상점주문번호
NICEpay.SetField CLng(PInst),"GoodsName",Request("goodsname")       '상품명
NICEpay.SetField CLng(PInst),"Currency","KRW"                       '화폐단위
NICEpay.SetField CLng(PInst),"BuyerName",Request("buyername")       '구매자 이름
NICEpay.SetField CLng(PInst),"MallUserID",Request("malluserid")     '구매자 ID
NICEpay.SetField CLng(PInst),"BuyerTel",Request("buyertel")         '구매자 전화번호
NICEpay.SetField CLng(PInst),"BuyerEmail",Request("buyeremail")     '구매자 이메일
NICEpay.SetField CLng(PInst),"CardNum",Request("cardnumber")        '카드 번호 
NICEpay.SetField CLng(PInst),"CardExpire",Request("cardexpire")     '카드 유효기간
NICEpay.SetField CLng(PInst),"CardQuota",Request("cardquota")       '카드 할부기간
NICEpay.SetField CLng(PInst),"CardPwd",Request("cardpw")            '카드 비밀번호
NICEpay.SetField CLng(PInst),"BuyerAuthNum",Request("regnumber")
NICEpay.StartAction(CLng(PInst))

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <결제 결과 필드>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
tid             = NICEpay.GetResult(CLng(PInst),"TID")              '거래번호
moid            = NICEpay.GetResult(CLng(PInst),"Moid")             '거래번호
resultCode      = NICEpay.GetResult(CLng(PInst),"ResultCode")       '결과코드TID
resultMsg       = NICEpay.GetResult(CLng(PInst),"ResultMsg")        '결과메시지
n_mid           = NICEpay.GetResult((PInst),"MID")                  'MID 
paymethod       = NICEpay.GetResult((PInst),"PayMethod")            '결제수단
authDate        = NICEpay.GetResult((PInst),"AuthDate")             '승인일시YYMMDDHH24mmss
authCode        = NICEpay.GetResult((PInst),"AuthCode")             '승인번호
amt             = NICEpay.GetResult((PInst),"Amt")                  '승인금액
buyerName       = NICEpay.GetResult((PInst),"BuyerName")            '구매자명
mallUserID      = NICEpay.GetResult((PInst),"MallUserID")           '회원사고객ID malluserid
goodsName       = NICEpay.GetResult((PInst),"GoodsName")            '상품명
cardcode        = NICEpay.GetResult((PInst),"CardCode")             '신용카드사 코드 
cardcodename    = NICEpay.GetResult((PInst),"CardName")             '신용카드사 명
cardcapturecode = NICEpay.GetResult((PInst),"AcquCardCode")         '매입카드사 코드
cardcapturename = NICEpay.GetResult((PInst),"AcquCardName")         '매입카드사 명
cardnumber      = NICEpay.GetResult((PInst),"CardNum")              '카드 번호
cardQuota       = NICEpay.GetResult((PInst),"CardQuota")            '카드 할부기간
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <인스턴스 해제>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
NICEpay.Destroy CLng(PInst)
%>
<!DOCTYPE html>
<html>
<head>
<title>NICEPAY PAYFORM RESULT(EUC-KR)</title>
<meta charset="euc-kr">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
</head>
<body> 
  <div class="payfin_area">
    <div class="top">NICEPAY PAYFORM RESULT(EUC-KR)</div>
    <div class="conwrap">
      <div class="con">
        <div class="tabletypea">
          <table>
            <colgroup><col width="30%"/><col width="*"/></colgroup>
              <tr>
                <th><span>결과내용</span></th>
                <td>[<%=resultCode%>]<%=resultMsg%></td>
              </tr>        
              <tr>
                <th><span>결제수단</span></th>
                <td><%=payMethod%></td>
              </tr>        
              <tr>
                <th><span>상품명</span></th>
                <td><%=goodsName%></td>
              </tr>
              <tr>
                <th><span>금액</span></th>
                <td><%=amt%>원</td>
              </tr>        
              <tr>
                <th><span>거래아이디</span></th>
                <td><%=tid%></td>
              </tr>        
              <tr>
                <th><span>카드사명</span></th>
                <td><%=cardcodename%></td>
              </tr>
              <tr>
                <th><span>할부개월</span></th>
                <td><%=cardQuota%></td>
              </tr>
          </table>
        </div>
      </div>
      <p>*테스트 아이디인경우 당일 오후 11시 30분에 취소됩니다.</p>
    </div>
  </div>
</body>
</html>