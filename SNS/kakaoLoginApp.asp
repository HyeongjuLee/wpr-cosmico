<script type="text/javascript">
    var userAgent = navigator.userAgent;

    $(function(){
        /*
        $(".kakaoLogin").on("click", fnKakaoMakeToken);
        $(".kakaoLogout").on("click", unlinkApp);
        */

        $(".kakaoLogin").on("click", function(){
            location.href="/SNS/linkedPage.asp?action=login&cd=kakao";
        });
        /*
        $(".kakaoLogin").on("click", function(){
           window.webkit.messageHandlers.snsLogin.postMessage({method:"post"});
        });
        */        
    });

    <%
        'Kakao API 사용을 위한 토큰 생성
    %>
    function fnKakaoMakeToken(){
        $(".kakaoLogin").off("click");

        Kakao.Auth.login({
            success: function(response){
                fnKakaoLogin();
            },
            fail: function(error){
                alert("카카오 로그인 처리 중 오류가 발생했습니다.");
                return false;
            },
            always: function(){
                $(".kakaoLogin").on("click", fnKakaoLogin);
            }
        });
    }

    <%
        'Kakao.Auth.login 에서 토큰 생성 후 회원 카카오로그인 정보 가져오기
    %>
    function fnKakaoLogin(response){
        $.ajax({
            type: "post",
            url: "/SNS/authCheck.asp",
            data: {"snsType" : "kakao", "token" : response.id},
            dataType: 'json',
            success: function(rData){
                if (rData.result == "success"){     <%' 카카오 회원가입을 한 회원인 경우 로그인 처리 후 메인화면으로 이동시킴 %>
                    alert("카카오 회원으로 로그인 처리되었습니다.");
                    location.href="/index.asp";
                    return false;
                } else {
                    var askYn = confirm("회원정보가 없습니다. 회원가입을 진행하시겠습니까?");
                    if (askYn){
                        fnKakaoJoin(response.id, response.kakao_account.email, response.kakao_account.profile.nickname);
                    }
                    return false;
                }
            },
            error: function(rData){
                alert("로그인 중 오류가 발생했습니다.");
                return false;
            }
        });
    }

    function fnKakaoLogout(){
        Kakao.Auth.logout(function(){
            console.log(Kakao.Auth.getAccessToken());
        });
    }

    function unlinkApp() {
        Kakao.API.request({
            url: '/v1/user/unlink',
            success: function(res) {
                alert('success: ' + JSON.stringify(res))
            },
            fail: function(err) {
                alert('fail: ' + JSON.stringify(err))
            },
        })
    }

    function fnKakaoJoin(token, email, name){
        var currentUrl = window.location.href;

        var joinForm = $('<form></form>');

        joinForm.attr("name", "joinForm");
        joinForm.attr("method", "post");

        if (currentUrl.toLowerCase().indexOf("/m/") > -1){
            joinForm.attr("action", "/m/common/joinStep_n02_g.asp"); <% 'Mobile 버전 URL %>
        } else {
            joinForm.attr("action", "/common/joinStep_n02_g.asp"); <% 'PC 버전 URL %>
        }

        joinForm.append($('<input />', {type: 'hidden', name: 'S_SellMemTF', value:'1'}));
        joinForm.append($('<input />', {type: 'hidden', name: 'snsType', value:'kakao'}));
        joinForm.append($('<input />', {type: 'hidden', name: 'snsToken', value:token}));
        joinForm.append($('<input />', {type: 'hidden', name: 'eMail', value:email}));
        if (name.length > 2) {
            joinForm.append($('<input />', {type: 'hidden', name: 'familyName', value:name.substring(0, 1)}));
            joinForm.append($('<input />', {type: 'hidden', name: 'givenName', value:name.substring(1)}));
        } else {
            joinForm.append($('<input />', {type: 'hidden', name: 'familyName', value:""}));
            joinForm.append($('<input />', {type: 'hidden', name: 'givenName', value:name}));
        }

        joinForm.appendTo('body');

        joinForm.submit();        
    }
</script>