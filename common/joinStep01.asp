<!--#include virtual="/_lib/strFunc.asp" -->
<%

	If webproIP <> "T" Then
		'Call ALERTS("준비중입니다.","back","")
	End If

	PAGE_SETTING = "COMMON"
	NO_MEMBER_REDIRECT = "F"

'	Response.Redirect "/common/joinStep_n02_g.asp"


	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "F"

	view = 4
	'sview = 1

	If DK_MEMBER_LEVEL > 0 Then
		Response.Redirect "/index.asp"
	End If



'	Select Case UCase(Lang)
'		Case "KR"
'			'joinStep02_c = "joinStep02.asp?cnd="&Lang			'(계좌인증)
'			joinStep02_c = "joinStep_n02c.asp?cnd="&Lang		'(New)
'		Case Else
'			joinStep02_c = "joinStep_n02_g.asp"
'	End Select

'일반판매원가입 전 국가 통합
	joinStep02_c = "joinStep_n02_g.asp"
	'joinStep02_c = "joinStep2.asp"

%>
<!--#include virtual="/_include/document.asp" -->
<link rel="stylesheet" type="text/css" href="/css/joinstep.css?" />
<script type="text/javascript">
	$(function(){
		<%Select Case LCase(DK_MEMBER_LNG_CODE)%>
		<%Case "kr" %>
		$('.sub-header-txt').append('<div class="join-header-txt"><p><%=LNG_SITE_TITLE%><%=LNG_JOIN_TEXT_01%></p></div>');
		<%Case "us" %>
		$('.sub-header-txt').append('<div class="join-header-txt"><p><%=LNG_JOIN_TEXT_01%></p></div>');
		<%End Select%>
	});
</script>
</head>
<body>
<!--#include virtual="/_include/header.asp" -->
<div id="join01" class="common joinstep">
	<div class="wrap">
		<h6><%=LNG_TEXT_JOIN_CONSUMER_MEMBER%></h6>
		<!-- <p><%=LNG_JOIN_TEXT_03%></p> -->
		<ul>
			<li><%=LNG_JOINSTEP01_TEXT01_1%></li>
			<li><%=LNG_JOINSTEP01_TEXT01_3%></li>
			<li><%=LNG_JOINSTEP01_TEXT01_2%></li>
		</ul>
		<a class="button" onclick="javascript: selectSellMemTF(1)" data-ripplet><%=LNG_TEXT_JOIN%></a>
	</div>
	<div class="wrap">
		<h6><%=LNG_TEXT_JOIN_BUSINESS_MEMBER%></h6>
		<!-- <p></p> -->
		<ul>
			<li><%=LNG_JOINSTEP01_TEXT02_1%></li>
			<li><%=LNG_JOINSTEP01_TEXT02_2%></li>
			<li><%=LNG_JOINSTEP01_TEXT02_3%></li>
		</ul>
		<a class="button" onclick="javascript: selectSellMemTF(0)" data-ripplet><%=LNG_TEXT_JOIN%></a>
		<!-- <a class="button account" onclick="javascript: selectSellMemTF(8)" data-ripplet>계좌인증</a> -->
	</div>


			<!-- <div class="sns_join_area" style="">
				<div class="joinStep_tit">
					<span class="tit"><%=LNG_SNS_JOIN_TEXT%></span>
				</div>

				<div class="infoBox ">
					<ul>
						<li>- <%=LNG_SNS_KAKAO%><%=LNG_SNS_JOIN_INFO1%><%=LNG_SNS_JOIN_INFO2%></li>
					</ul>
				</div>
				<div class="btnBox cleft">
					<span class="snsJoinBtn sns_join1"><a onclick="javascript: selectSellMemTF_KaKao(1)"><%=LNG_SNS_KAKAO%>-<%=LNG_TEXT_JOIN%></a></span>
					<span class="snsJoinBtn sns_join2"><a onclick="javascript: selectSellMemTF_KaKao(60)"><%=LNG_SNS_KAKAO%>-<%=LNG_TEXT_CLASS_P_60%></a></span>
					<span class="snsJoinBtn sns_join3"><a onclick="javascript: selectSellMemTF_KaKao(70)"><%=LNG_SNS_KAKAO%>-<%=LNG_TEXT_CLASS_P_70%></a></span>
				</div>
			</div> -->

</div>



<script>
	function selectSellMemTF(value) {
		var f = document.mfrm;
		f.S_SellMemTF.value = value

		if (value == 0)	{
			//f.action="joinStep02.asp";			//계좌인증 (or + 핸드폰인증)
			//f.action="joinStep_n01_m.asp";		//핸드폰인증 (or + 계좌인증)
		}

		f.submit();
	}

	function selectSellMemTF_KaKao(value) {
		//document.mfrm.S_SellMemTF.value = value;
		openPopup('/sns/kakaoJoin.asp?mst='+value, 'pop_Join', 'top=100px,left=200px,width=600,height=500,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');
	}

</script>
<form name="mfrm" method="post" action="joinStep_n02_g.asp">
<!-- <form name="mfrm" method="post" action="joinStep02.asp"> -->
	<input type="hidden" name="S_SellMemTF" value = "" readonly="readonly">
	<input type="hidden" name="sns_auth" value = "" readonly="readonly">
</form>

<!--#include virtual="/_include/copyright.asp" -->
