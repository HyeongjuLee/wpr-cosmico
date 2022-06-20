<script src="//apis.google.com/js/platform.js?onload=init" async defer></script>
<script type="text/javascript">
    <%
        'Google Sign-in 사용을 위한 초기 설정
    %>

    $(function(){
        $(".googleLogin").on("click", signIn);
        $(".googleLogout").on("click", signOut);
    });

    function init() {
        gapi.load('auth2', function() {
            auth2 = gapi.auth2.init({
                client_id: '<%=GOOGLE_AUTHKEY%>'
            });
        });
    }

    function signIn(){
        var auth2 = gapi.auth2.getAuthInstance();
        auth2.signIn().then(onSignIn);
    }

    function onSignIn(googleUser) {
        var profile = googleUser.getBasicProfile();

        if (googleUser.isSignedIn()){ <%' 구글 로그인이 되어있다면 %>
            $.ajax({
                type: "post", 
                async : false,
                url: "/SNS/authCheck.asp",
                data: {"snsType" : "google", "token" : profile.getId()},
                dataType: 'json',
                success: function(rData){
                    if (rData.result == "success"){     <%' 구글 회원가입을 한 회원인 경우 로그인 처리 후 메인화면으로 이동시킴 %>
                        alert("구글 회원으로 로그인 처리되었습니다.");
                        location.href="/index.asp";
                        return false;
                    } else {
                        var askYn = confirm("회원정보가 없습니다. 회원가입을 진행하시겠습니까?");
                        if (askYn){
                            fnGoogleJoin(profile.getId(), profile.getFamilyName(), profile.getGivenName(), profile.getEmail());
                        }
                        return false;
                    }
                },
                error: function(rData){
                    alert("로그인 중 오류가 발생했습니다.");
                    return false;
                },
                complete: function(){
                    signOut();
                }
            });
        }
    }

    function signOut() {
        var auth2 = gapi.auth2.getAuthInstance();
        auth2.signOut().then(function () {
            console.log('User signed out.');
        });
    }

    function fnGoogleJoin(token, familyName, givenName, eMail){
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
        joinForm.append($('<input />', {type: 'hidden', name: 'snsType', value:'google'}));
        joinForm.append($('<input />', {type: 'hidden', name: 'snsToken', value:token}));
        joinForm.append($('<input />', {type: 'hidden', name: 'familyName', value:familyName}));
        joinForm.append($('<input />', {type: 'hidden', name: 'givenName', value:givenName}));
        joinForm.append($('<input />', {type: 'hidden', name: 'eMail', value:eMail}));

        joinForm.appendTo('body');

        joinForm.submit();        
    }
</script>