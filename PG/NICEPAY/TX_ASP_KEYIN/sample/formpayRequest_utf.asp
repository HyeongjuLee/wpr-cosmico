<!DOCTYPE html>
<html>
<head>
<title>NICEPAY FORMPAY REQUEST(UTF-8)</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
<script type="text/javascript">
function goPay(){
    document.payForm.submit();
}
</script>
</head>
<body>
<form name="payForm" method="post" action="formpayResult_utf.asp">
    <div class="payfin_area">
      <div class="top">NICEPAY PAY REQUEST(UTF-8)</div>
      <div class="conwrap">
        <div class="con">
          <div class="tabletypea">
            <table>
              <colgroup><col width="30%" /><col width="*" /></colgroup>
              <tr>
                <th><span>MID</span></th>
                <td><input type="text" name="MID" value="nictest04m"></td>
              </tr>
              <tr>
                <th><span>상품명</span></th>
                <td><input type="text" name="goodsname" value="나이스페이"></td>
              </tr>
              <tr>
                <th><span>가격</span></th>
                <td><input type="text" name="amt" value="1004"></td>
              </tr>
              <tr>
                <th><span>구매자 이름</span></th>
                <td><input type="text" name="buyername" value="나이스"></td>
              </tr>
              <tr>
                <th><span>구매자 연락처</span></th>
                <td><input type="text" name="buyertel" value="01000000000"></td>
              </tr>
              <tr>
                <th><span>구매자 이메일</span></th>
                <td><input type="text" name="buyeremail" value="happy@day.co.kr"></td>
              </tr>
              <tr>
                <th><span>신용카드 할부기간(mm)</span></th>
                <td><input type="text" name="cardquota" value="00"></td>
              </tr>
              <tr>
                <th><span>카드번호</span></th>
                <td><input type="text" name="cardnumber" value=""></td>
              </tr>
              <tr>
                <th><span>카드유효기간</span></th>
                <td><input type="text" name="cardexpire" placeholder="YYMM" value=""></td>
              </tr>
              <tr>
                <th><span>주민번호(생년월일)</span></th>
                <td><input type="password" name="regnumber" value=""></td>
              </tr>
              <tr>
                <th><span>카드 비밀번호(앞 2자리)</span></th>
                <td><input type="password" name="cardpw" value=""></td>
              </tr>

              <!-- 옵션 -->
              <input name="paymethod" type="hidden" value="CARD">   <!-- 결제방법 -->
            </table>
          </div>
        </div>
        <div class="btngroup">
          <a href="#" class="btn_blue" onClick="goPay();">요 청</a>
        </div>
      </div>
    </div>
</form>
</body>
</html>
