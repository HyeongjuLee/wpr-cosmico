<!-- #include file="sha256.asp" -->
<%
    'INSERT 페이지는 가상계좌 입금이 이루어지면 데이터가 전송 되며 
    '결과 코드에 따라 정상 또는 실패에 대해 주문 관련 DB에 저장 합니다.
    '따라서, INSERT가 비 정상적인 경우에는 결제 지연의 원인이 될 수 있습니다.

    '아래와 같은 값이 POST 방식으로 전송됩니다. 자세한 설명은 매뉴얼을 참고바랍니다.

    Amount = Request("Amount")  ' 거래 금액
    ReplyCode = Request("ReplyCode")  ' 결과 코드
    ReplyMessage = Request("ReplyMessage")  ' 결과 메시지
    MxIssueNO = Request("MxIssueNO")  ' 거래 번호 (결제 요청시 사용값)
    MxIssueDate = Request("MxIssueDate")  ' 거래 일시 (결제 요청시 사용값) 
    MxHASH = Request("MxHASH256")  ' 결과 검증값(데이터 조작 여부 확인)

    '결제 정보의 위/변조 여부를 확인하기 위해,
    '주요 결제 정보를 MD5 암호화 알고리즘으로 HASH 처리한 MxHASH 값을 받아
    '동일한 규칙으로 DBPATH에서 생성한 값(output)과 비교합니다.

    mxid1 = "testcorp"  ' 가맹점 ID (고정 값 : 테스트용이므로 발급된 ID로 변경바람)  
    mxotp1 = "6aMoJujE34XnL9gvUqdKGMqs9GzYaNo6"  ' 접근키 (고정 값 : 테스트용이므로 발급된 ID로 변경바람)
    currency1 = "KRW"  ' 화폐코드 (고정 값) 
    amount1 = ""   ' 가맹점 주문 DB에 기록되어 있는 거래금액

    '가맹점 주문 DB에서 거래금액(amount) 값을 가져 오는 것을 추천 드립니다.
    '(주문 DB는 최초 결제 요청 시에 입금대기 상태로 기록한 초기 장바구니 정보)
    '
    '예) query = "select amount01 from 주문테이블 where 거래번호='"+MxIssueNO+"', and 거래일시='"+MxIssueDate
    '    => amount01
    '
    '    amount1 = amount01
    
    amount1 = Amount  '예제 테스트를 위해 결과값을 사용 (위와 같이 주문 DB 이용바람)

    'SHA-256 알고리즘을 이용한 HASH 값 생성

    output = sha256(mxid1 & mxotp1 & MxIssueNO & MxIssueDate & amount1 & currency1)

    isOK = "0"
    returnMsg = "ACK=400FAIL"

    'MxHASH 값과 output 생성 값을 비교해서 일치하는 경우에만 결과 저장
    
    if not isnull(MxHASH) and MxHASH=output then  ' 일치하는 경우
		if ReplyCode = "00003000" then  
            '결제 성공이거나, 가상계좌("2601") 발급성공 = "00004000"
            '이 부분에서 주문 DB에 결과를 저장하는 소스 코딩 필요
            '예) isOK = (DB 업데이트 결과)

            returnMsg = "ACK=400FAIL"					' DB 저장 실패이면
            if isOK="1" then returnMsg = "ACK=200OKOK"	' DB 저장 성공이면
        else  
            ' 결제 실패인 경우
            '이 부분에서 주문 DB에 결과를 저장하는 소스 코딩 필요
            '예) isOK = (DB 업데이트 결과)

            returnMsg = "ACK=400FAIL"					' DB 저장 실패이면
            if isOK="1" then returnMsg = "ACK=200OKOK"	' DB 저장 성공이면
        end if
    else
        returnMsg = "ACK=400FAIL"  ' 결제 정보가 일치하지 않는 경우 : 데이타 조작의 가능성이 있으므로, 결제 취소
    end if
%>
<%=returnMsg%><% //return 메시지('ACK=200OKOK' or 'ACK=400FAIL')를 출력해야 정상 처리됩니다. %>
