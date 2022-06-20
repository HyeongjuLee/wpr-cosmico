<!--#include virtual = "/_lib/strFunc.asp"-->
<%

	pageMode =  gRequestTF("m",True)
	backURL =  gRequestTF("backURL",False)

	If LCase(pageMode) = "m" Then
		goToURLs ="/m"
	Else
		goToURLs = "/"
	End If
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
<title><%=BACKWORD(DKRS_GoodsName)%> : <%=SQL_SUBMALL_TITLE%></title>
<script type="text/javascript" src="/jscript/jquery-1.10.2.min.js"></script>
<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
<style>
	body {padding:0px; margin:0px;}
	.top_logo {margin:10px 0px 0px 0px; padding-bottom:10px; border-bottom:1px solid #555555}
	.top_logo .img {width:100%; max-width:303px;text-align:center; margin:0px auto;}
	.content {padding:30px 0px 30px 0px;}
	.design6 {background-color: #333333; border:1px solid #ffffff; border-radius: 3px; color:#fff !important;font-weight:normal;}
	.input_submit_b {display: inline-block; padding: 15px 20px; vertical-align: middle; cursor: pointer; line-height:1;}
	.bottom {position:absolute; width:200px; bottom:30px; left:50%; margin-left:-100px;}
</style>
</head>
<body>
<div style="text-align:center;">
	<div class="top_logo"><div class="img"><img src="sns_logo.png" width="100%" alt="" /></div></div>
	<div class="content">
		<a id="custom-login-btn" href="javascript:loginWithKakao()"><img src="//mud-kage.kakao.com/14/dn/btqbjxsO6vP/KPiGpdnsubSq3a0PHEGUK1/o.jpg" width="300"/></a>
	</div>
	<div class="bottom"><a href="javascript:window.close();" class="input_submit_b design6">닫기</a></div>
</div>
<script type='text/javascript'>
	//<![CDATA[
	// 사용할 앱의 JavaScript 키를 설정해 주세요.
    Kakao.init('<%=KAKAO_AUTHKEY%>');
	var doubleClick;
	doubleClick = false;
	function loginWithKakao() {
	// 로그인 창을 띄웁니다.
		//alert("a");
		if (doubleClick) {
			alert("카카오서버와 통신중입니다. 잠시만 기다려주세요");
			return false;
		} else {
			doubleClick = true;
			Kakao.Auth.login({
				success: function(authObj) {
					// 로그인 성공시, API를 호출합니다.
					Kakao.API.request({
						url: '/v2/user/me',
						success: function(res) {
							goSession(JSON.stringify(res.id));
							doubleClick = false;
						},
						fail: function(error) {
							alert(JSON.stringify(error));
							doubleClick = false;
						}
					});
				},
				fail: function(err) {
					alert(JSON.stringify(err));
					doubleClick = false;
				}
			});
		}
	};

	function goSession(sid) {
		//alert("b");
		//console.log(sid);
		$.ajax({
			type: "POST"
			,async : false
			,url: "/SNS/kakaoJoinSession.asp"
			,data: {
				 "uid"		: sid

			}
			,success: function(data) {
				var jsonData = $.parseJSON(data);
				//alert(jsonData.statusCode);
				switch (jsonData.statusCode) {
					case '0000' :
						//alert(jsonData.message);
							alert('등록된 회원이 아닙니다. 회원가입창으로 이동합니다');
							//window.location.href = 'http://<%=ThisDomain%>.<%=MAIN_DOMAIN%>/SNS/kakaoSession.asp?ec='+jsonData.result;
							doubleClick = false;
							window.opener.location.href = '<%=goToURLs%>/common/joinStep01.asp';
							self.close();
						break;
					case '9999' :
							//console.log('b');
							doubleClick = false;
							alert(jsonData.result);
							self.close();
						break;
					case '9998' :
							//console.log('b');
							//alert(jsonData.result);
							$.ajax({
								type: "POST"
								,async : false
								,url: "/SNS/kakaoLoginSession.asp"
								,data: {
									 "uid"		: sid
								}
								,success: function(data2) {
									var jsonData2 = $.parseJSON(data2);
									//alret(jsonData2.statusCode);
									//alert(jsonData2.siteA);
									//alert(jsonData2.siteD);
									//return false;
									switch (jsonData2.statusCode) {
										case '0000' :
											//alert(jsonData.message);
											//alert(jsonData.message);
												//window.location.href = 'http://<%=ThisDomain%>.<%=MAIN_DOMAIN%>/SNS/kakaoSession.asp?ec='+jsonData.result;
												doubleClick = false;
												window.opener.location.href = '<%=goToURLs%>?pm=dv&backUrl=<%=server.urlEncode(backURL)%>';
												self.close();
											break;
										case '8888' :
											//alert(jsonData.message);
											//alert(jsonData.message);
												//window.location.href = 'http://<%=ThisDomain%>.<%=MAIN_DOMAIN%>/SNS/kakaoSession.asp?ec='+jsonData.result;
												alert(jsonData2.result);
												doubleClick = false;
												window.opener.location.href = "<%=HTTPS%>://"+jsonData2.siteD+".<%=MAIN_DOMAIN%>";
												self.close();
											break;
										default :
											doubleClick = false;
											alert(jsonData2.result);
											self.close();
									}
								},error:function(data2) {
									//loadings();
									alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data2.status+" "+data2.statusText+" "+data2.responseText);
									doubleClick = false;
								}

							});
							self.close();
						break;
					case '9997' :
							//console.log('b');
							doubleClick = false;
							alert(jsonData.result);
							self.close();
						break;
					default :
						doubleClick = false;
						alert(jsonData.result);
						self.close();
				}
			}
			,error:function(data) {
				//loadings();
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				doubleClick = false;
			}
		});

	}


//]]>
</script>
</body>
</html>