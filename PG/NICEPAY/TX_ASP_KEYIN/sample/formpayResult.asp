<%
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <��� ��� ����>
' ����� ��� �ɼ��� ����� ȯ�濡 �µ��� �����ϼ���.
' ����Ű, MID�� �� �����ϼ���.
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Set NICEpay = Server.CreateObject("NICE.NICETX2.1")
PInst = NICEpay.Initialize("")
merchantKey = "b+zhZ4yOZ7FsH8pm5lhDfHZEb79tIwnjsdA0FBXh86yLc6BJeFVrZFXhAoJ3gEWgrWwN+lJMV0W4hvDdbe4Sjw=="

NICEpay.SetField CLng(PInst),"MID",Request("MID")                   '���� ID
NICEpay.SetField CLng(PInst),"logpath","C:\log"                     'Log Path ����
NICEpay.SetField CLng(PInst),"LicenseKey",merchantKey               'MID
NICEpay.SetField CLng(PInst),"CardInterest","0"                     '�������Һ� ���� (1:YES, 0:NO) 
NICEpay.SetField CLng(PInst),"CancelPwd","123456"                   '�ŷ���� �н�����
NICEpay.SetField CLng(PInst),"debug", "true"                        '�α׸��(true = �� �α�)
NICEpay.SetField CLng(PInst),"AuthFlag","2"                         '����������: 2
NICEpay.SetActionType CLng(PInst), "FORMPAY"                        '�������
NICEpay.SetField CLng(PInst),"PayMethod",Request("paymethod")	      '��������
NICEpay.SetField CLng(PInst),"Amt",Request("amt")                   '�����ݾ� 
NICEpay.SetField CLng(PInst),"Moid","123456789moid"                 '�����ֹ���ȣ
NICEpay.SetField CLng(PInst),"GoodsName",Request("goodsname")       '��ǰ��
NICEpay.SetField CLng(PInst),"Currency","KRW"                       'ȭ�����
NICEpay.SetField CLng(PInst),"BuyerName",Request("buyername")       '������ �̸�
NICEpay.SetField CLng(PInst),"MallUserID",Request("malluserid")     '������ ID
NICEpay.SetField CLng(PInst),"BuyerTel",Request("buyertel")         '������ ��ȭ��ȣ
NICEpay.SetField CLng(PInst),"BuyerEmail",Request("buyeremail")     '������ �̸���
NICEpay.SetField CLng(PInst),"CardNum",Request("cardnumber")        'ī�� ��ȣ 
NICEpay.SetField CLng(PInst),"CardExpire",Request("cardexpire")     'ī�� ��ȿ�Ⱓ
NICEpay.SetField CLng(PInst),"CardQuota",Request("cardquota")       'ī�� �ҺαⰣ
NICEpay.SetField CLng(PInst),"CardPwd",Request("cardpw")            'ī�� ��й�ȣ
NICEpay.SetField CLng(PInst),"BuyerAuthNum",Request("regnumber")
NICEpay.StartAction(CLng(PInst))

''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <���� ��� �ʵ�>
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
tid             = NICEpay.GetResult(CLng(PInst),"TID")              '�ŷ���ȣ
moid            = NICEpay.GetResult(CLng(PInst),"Moid")             '�ŷ���ȣ
resultCode      = NICEpay.GetResult(CLng(PInst),"ResultCode")       '����ڵ�TID
resultMsg       = NICEpay.GetResult(CLng(PInst),"ResultMsg")        '����޽���
n_mid           = NICEpay.GetResult((PInst),"MID")                  'MID 
paymethod       = NICEpay.GetResult((PInst),"PayMethod")            '��������
authDate        = NICEpay.GetResult((PInst),"AuthDate")             '�����Ͻ�YYMMDDHH24mmss
authCode        = NICEpay.GetResult((PInst),"AuthCode")             '���ι�ȣ
amt             = NICEpay.GetResult((PInst),"Amt")                  '���αݾ�
buyerName       = NICEpay.GetResult((PInst),"BuyerName")            '�����ڸ�
mallUserID      = NICEpay.GetResult((PInst),"MallUserID")           'ȸ�����ID malluserid
goodsName       = NICEpay.GetResult((PInst),"GoodsName")            '��ǰ��
cardcode        = NICEpay.GetResult((PInst),"CardCode")             '�ſ�ī��� �ڵ� 
cardcodename    = NICEpay.GetResult((PInst),"CardName")             '�ſ�ī��� ��
cardcapturecode = NICEpay.GetResult((PInst),"AcquCardCode")         '����ī��� �ڵ�
cardcapturename = NICEpay.GetResult((PInst),"AcquCardName")         '����ī��� ��
cardnumber      = NICEpay.GetResult((PInst),"CardNum")              'ī�� ��ȣ
cardQuota       = NICEpay.GetResult((PInst),"CardQuota")            'ī�� �ҺαⰣ
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' <�ν��Ͻ� ����>
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
                <th><span>�������</span></th>
                <td>[<%=resultCode%>]<%=resultMsg%></td>
              </tr>        
              <tr>
                <th><span>��������</span></th>
                <td><%=payMethod%></td>
              </tr>        
              <tr>
                <th><span>��ǰ��</span></th>
                <td><%=goodsName%></td>
              </tr>
              <tr>
                <th><span>�ݾ�</span></th>
                <td><%=amt%>��</td>
              </tr>        
              <tr>
                <th><span>�ŷ����̵�</span></th>
                <td><%=tid%></td>
              </tr>        
              <tr>
                <th><span>ī����</span></th>
                <td><%=cardcodename%></td>
              </tr>
              <tr>
                <th><span>�Һΰ���</span></th>
                <td><%=cardQuota%></td>
              </tr>
          </table>
        </div>
      </div>
      <p>*�׽�Ʈ ���̵��ΰ�� ���� ���� 11�� 30�п� ��ҵ˴ϴ�.</p>
    </div>
  </div>
</body>
</html>