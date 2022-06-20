<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>Naver Login Callback</title>
    <script type="text/javascript" src="//static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" charset="utf-8"></script>
    <script type="text/javascript" src="//code.jquery.com/jquery-1.11.3.min.js"></script>
    <script type="text/javascript">
    <%
        '네이버 로그인 사용을 위한 초기 설정
    %>
    var naverLogin = new naver.LoginWithNaverId({
        clientId: "<%=NAVER_CLIENT_ID%>", 
        callbackUrl: "https://www.inqten.com/SNS/naverCallback.asp",
        isPopup: true
    });

    <% '네아로 로그인 정보를 초기화하기 위하여 init을 호출 %>
    naverLogin.init();

    <% 'Dom 로딩 완료 시 로그인 여부 확인 %>
    $(function(){
        naverLogin.getLoginStatus(function(status){
            if (status) {
                window.open("about:blank","_self").close();
            } else {
                alert("네이버 로그인에 실패했습니다. 재 로그인 바랍니다.");
                naverLogin.reprompt();
                return false;
            }
        });
    });
</script>
</head>
</html>