<script src="//developers.kakao.com/sdk/js/kakao.js"></script>
<script type="text/javascript">
    <%
        'Kakao Javascript 사용을 위한 초기 설정
    %>
    Kakao.init('<%=KAKAO_AUTHKEY%>');

    var userAgent = navigator.userAgent;

    $(function(){
        /*
        if (agent.toLowerCase().indexOf("cordova") > -1){
            $(".kakaoLogin").on("click", function(){
                var href = window.location.href;
                var url = href.substring(0, href.lastIndexOf("/"))+'/kakaoLoginApp.asp' +
                '?popupBridgeReturnUrlPrefix=' + window.popupBridge.getReturnUrlPrefix();

                window.popupBridge.open(url);

                window.popupBridge.onCancel = function () {
					alert("카카오 로그인이 .");
					return false;
				};

				window.popupBridge.onComplete = function (err, payload) {
					if (err) {
						alert("서버 통신 중 오류가 발생했습니다. 다시 시도 바랍니다.");
						doubleSubmit = false;
						return false;
					} else if (payload.queryItems) {
						console.log(payload.queryItems);
                        return false;
                        
                        $("input[name=iab_authyn]").val(payload.queryItems.authyn);
                        $("input[name=iab_trno]").val(payload.queryItems.trno);
                        $("input[name=iab_trddt]").val(payload.queryItems.trddt);
                        $("input[name=iab_trdtm]").val(payload.queryItems.trdtm);
                        $("input[name=iab_amt]").val(payload.queryItems.amt);
                        $("input[name=iab_authno]").val(payload.queryItems.authno);
                        $("input[name=iab_msg1]").val(payload.queryItems.msg1);
                        $("input[name=iab_msg2]").val(payload.queryItems.msg2);
                        $("input[name=iab_ordno]").val(payload.queryItems.ordno);
                        $("input[name=iab_isscd]").val(payload.queryItems.isscd);
                        $("input[name=iab_aqucd]").val(payload.queryItems.aqucd);
                        $("input[name=iab_result]").val(payload.queryItems.result);
                        $("input[name=iab_halbu]").val(payload.queryItems.halbu);
                        $("input[name=iab_cardno]").val(payload.queryItems.cardno);
                        f.target = '_self';
                        f.action = '/PG/KSNET/payResult_iab.asp';
                        f.submit();
					}
					
                };
                
            });
        } else {
            $(".kakaoLogin").on("click", fnKakaoMakeToken);
            $(".kakaoLogout").on("click", unlinkApp);
        }
        */
        $(".kakaoLogin").on("click", fnKakaoMakeToken);
        $(".kakaoLogout").on("click", unlinkApp);
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
    function fnKakaoLogin(){
        Kakao.API.request({
            url: '/v2/user/me',
            success: function(response){
                $.ajax({
                    type: "post",
                    async : false,
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
            },
            fail: function(error){
                console.log(error);
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