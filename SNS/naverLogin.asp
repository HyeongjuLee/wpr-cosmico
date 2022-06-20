<script type="text/javascript" src="//static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" charset="utf-8"></script>
<script type="text/javascript">
    <%
        '네이버 로그인 사용을 위한 초기 설정
    %>
    var naverLogin = new naver.LoginWithNaverId({
        clientId: "<%=NAVER_CLIENT_ID%>",
        //callbackUrl: "https://www.inqten.com/SNS/naverCallback.asp",
        callbackUrl: "https://www.metac21g.com/SNS/naverCallback.asp",
        isPopup: true
    });

    <% '네아로 로그인 정보를 초기화하기 위하여 init을 호출 %>
    naverLogin.init();

    <% 'Dom 로딩 완료 시 로그인 여부 확인 %>
    $(function(){
        $(".naverLogin").on("click", function(){
            if (agent.toLowerCase().indexOf("cordova") > -1){
			    if (window.popupBridge && window.popupBridge.open) {
                    window.popupBridge.open("https://api.happytalk.io/api/kakao/chat_open?yid=@%EC%9D%B8%ED%81%90%ED%85%90&site_id=5000001139&category_id=129925&division_id=129926undefined");
                }
            }
        });

        naverLogin.getLoginStatus(function(status){
            if (status) {
                naverLogin();
            }
        });

        $(".naverIdLogin").on("click", function(){
            var loginUrl = naverLogin.generateAuthorizeUrl();
            window.open(loginUrl, "_blank", "left=20, top=20");
        });
    });

    function naverLogin(naverObj) {
        console.log(naverLogin.user);
        return false;
        <%
            '** 네이버 아이디로 로그인 시 넘겨받는 정보들
            'inner_profileParams.age           = result.response.age;
			'inner_profileParams.birthday      = result.response.birthday;
			'inner_profileParams.email         = result.response.email;
			'inner_profileParams.enc_id        = result.response.enc_id;
			'inner_profileParams.gender        = result.response.gender;
			'inner_profileParams.id            = result.response.id;
			'inner_profileParams.nickname      = result.response.nickname;
			'inner_profileParams.profile_image = result.response.profile_image;
			'inner_profileParams.name          = result.response.name;

        %>
        console.log(naverObj.getProfileData.id);
        if (naverObj.isSignedIn()){ <%' 구글 로그인이 되어있다면 %>
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
            joinForm.attr("action", "/m/common/joinStep02.asp"); <% 'Mobile 버전 URL %>
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