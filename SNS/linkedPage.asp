<!--#include virtual="/_lib/strFunc.asp" -->
<html>
<head>
<script type="text/javascript" src="/jscript/jquery-1.10.2.min.js"></script>
<script type="text/javascript">
    function fnNaverLogin(naverObj) {
        <% '"accessToken":"AAAANgnbdmGyO6ox0DSOPMxIU51hg1\/iF1NgFkB5AcUvRJHULvOnexwaHc08dN5kZi4qdNeMZ47ZnIAuP2TNC9oyMqw=","refreshToken":"aNRLB2uQ2HroUsS3d0ExNU47SgisKfh1w987KfWBzQZRfHfhFWonqpdrZmEENjtq1x8lTs3kE8KdRCNDlJq010zbok4fQa0YLZhV6ry74I2AbxRFaRaRQOZDsVOt3vdnV","expiresAt":1631780377,"tokenType":"bearer","id":"35974579","email":"lifeat@naver.com","mobile":"010-9032-1572","mobile_e164":"+821090321572","name":"류희원","birthday":"06-21","birthyear":"1986"'%>
        $.ajax({
            type: "post", 
            url: "/SNS/authCheck.asp",
            data: {"snsType" : "naver", "token" : naverObj.id},
            dataType: 'json',
            success: function(rData){
                if (rData.result == "success"){     <%' 네이버 회원가입을 한 회원인 경우 로그인 처리 후 메인화면으로 이동시킴 %>
                    alert("네이버 회원으로 로그인 처리되었습니다.");
                    location.href="/index.asp";
                    return false;
                } else {
                    var askYn = confirm("회원정보가 없습니다. 회원가입을 진행하시겠습니까?");
                    if (askYn){
                        fnNaverJoin(naverObj.id, naverObj.email, naverObj.name);
                    } else {
                        history.back(-1);
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

    function fnNaverJoin(token, email, name){
        var joinForm = $('<form></form>');

        joinForm.attr("name", "joinForm");
        joinForm.attr("method", "post");
        
        if (navigator.userAgent.match(/Mobile|iP(hone|od)|BlackBerry|IEMobile|Kindle|NetFront|Silk-Accelerated|(hpw|web)OS|Fennec|Minimo|Opera M(obi|ini)|Blazer|Dolfin|Dolphin|Skyfire|Zune/)){
            joinForm.attr("action", "/m/common/joinStep_n02_g.asp"); <% 'Mobile 버전 URL %>
        } else {
            joinForm.attr("action", "/common/joinStep_n02_g.asp"); <% 'PC 버전 URL %>
        }

        joinForm.append($('<input />', {type: 'hidden', name: 'S_SellMemTF', value:'1'}));
        joinForm.append($('<input />', {type: 'hidden', name: 'snsType', value:'naver'}));
        joinForm.append($('<input />', {type: 'hidden', name: 'snsToken', value:token}));
        joinForm.append($('<input />', {type: 'hidden', name: 'eMail', value:email}));
        if (name.length > 3) {
            joinForm.append($('<input />', {type: 'hidden', name: 'familyName', value:name.substring(0, 2)}));
            joinForm.append($('<input />', {type: 'hidden', name: 'givenName', value:name.substring(2)}));
        } else if (name.length > 2) {
            joinForm.append($('<input />', {type: 'hidden', name: 'familyName', value:name.substring(0, 1)}));
            joinForm.append($('<input />', {type: 'hidden', name: 'givenName', value:name.substring(1)}));
        } else {
            joinForm.append($('<input />', {type: 'hidden', name: 'familyName', value:""}));
            joinForm.append($('<input />', {type: 'hidden', name: 'givenName', value:name}));
        }

        joinForm.appendTo('body');
        
        joinForm.submit();
    }

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
                    } else {
                        history.back(-1);
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
        var joinForm = $('<form></form>');

        joinForm.attr("name", "joinForm");
        joinForm.attr("method", "post");
        
        if (navigator.userAgent.match(/Mobile|iP(hone|od)|BlackBerry|IEMobile|Kindle|NetFront|Silk-Accelerated|(hpw|web)OS|Fennec|Minimo|Opera M(obi|ini)|Blazer|Dolfin|Dolphin|Skyfire|Zune/)){
            joinForm.attr("action", "/m/common/joinStep_n02_g.asp"); <% 'Mobile 버전 URL %>
        } else {
            joinForm.attr("action", "/common/joinStep_n02_g.asp"); <% 'PC 버전 URL %>
        }

        joinForm.append($('<input />', {type: 'hidden', name: 'S_SellMemTF', value:'1'}));
        joinForm.append($('<input />', {type: 'hidden', name: 'snsType', value:'kakao'}));
        joinForm.append($('<input />', {type: 'hidden', name: 'snsToken', value:token}));
        joinForm.append($('<input />', {type: 'hidden', name: 'eMail', value:email}));
        if (name.length > 3) {
            joinForm.append($('<input />', {type: 'hidden', name: 'familyName', value:name.substring(0, 2)}));
            joinForm.append($('<input />', {type: 'hidden', name: 'givenName', value:name.substring(2)}));
        } else if (name.length > 2) {
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
</head>
<body>
</body>
</html>