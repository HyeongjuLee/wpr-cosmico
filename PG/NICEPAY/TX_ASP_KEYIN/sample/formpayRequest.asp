<!DOCTYPE html>
<html>
<head>
<title>NICEPAY FORMPAY REQUEST(EUC-KR)</title>
<meta charset="euc-kr">
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes, target-densitydpi=medium-dpi" />
<link rel="stylesheet" type="text/css" href="./css/import.css"/>
<script type="text/javascript">
function goPay(){	
    document.payForm.submit();
}
</script>
</head>
<body>
<form name="payForm" method="post" action="formpayResult.asp">
    <div class="payfin_area">
      <div class="top">NICEPAY PAY REQUEST(EUC-KR)</div>
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
                <th><span>��ǰ��</span></th>
                <td><input type="text" name="goodsname" value="���̽�����"></td>
              </tr>              
              <tr>
                <th><span>����</span></th>
                <td><input type="text" name="amt" value="1004"></td>
              </tr>              
              <tr>
                <th><span>������ �̸�</span></th>
                <td><input type="text" name="buyername" value="���̽�"></td>
              </tr>            
              <tr>
                <th><span>������ ����ó</span></th>
                <td><input type="text" name="buyertel" value="01000000000"></td>
              </tr>
              <tr>
                <th><span>������ �̸���</span></th>
                <td><input type="text" name="buyeremail" value="happy@day.co.kr"></td>
              </tr>              
              <tr>
                <th><span>�ſ�ī�� �ҺαⰣ(mm)</span></th>
                <td><input type="text" name="cardquota" value="00"></td>
              </tr>
              <tr>
                <th><span>ī���ȣ</span></th>
                <td><input type="text" name="cardnumber" value=""></td>
              </tr>               
              <tr>
                <th><span>ī����ȿ�Ⱓ</span></th>
                <td><input type="text" name="cardexpire" placeholder="YYMM" value=""></td>
              </tr>              
              <tr>
                <th><span>�ֹι�ȣ(�������)</span></th>
                <td><input type="password" name="regnumber" value=""></td>
              </tr> 
              <tr>
                <th><span>ī�� ��й�ȣ(�� 2�ڸ�)</span></th>
                <td><input type="password" name="cardpw" value=""></td>
              </tr>
              
              <!-- �ɼ� -->
              <input name="paymethod" type="hidden" value="CARD">   <!-- ������� -->          
            </table>         
          </div>
        </div>
        <div class="btngroup">
          <a href="#" class="btn_blue" onClick="goPay();">�� û</a>
        </div>
      </div>
    </div>
</form>
</body>
</html>
