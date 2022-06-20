	</div>
	</div>
	<div id="bottom_wrap" class="layout_wrap">
		<div class="bottom_menu" class="layout_inner">
			<ul>
				<li class="li01"><a href="/page/company.asp?view=1">회사소개</a></li>
				<li><a href="/cboard/board_list.asp?bname=notice">공지사항</a></li>
				<li><a href="/page/policy.asp?view=2">이용약관</a></li>
				<li><a href="/page/policy.asp?view=1">개인정보취급방침</a></li>
				<li><a href="/page/location.asp">찾아오시는길</a></li>
			</ul>
			<div class="bottom_btn">
				<a href="#"><img src="<%=IMG_SHARE%>/bottom_btn01.png" alt="" /></a>
				<a href="#"><img src="<%=IMG_SHARE%>/bottom_btn02.png" alt="" /></a>
			</div>
		</div>
		<div id="bottom" class="layout_inner">
			<div class="bottom_info">
				<p>
					<span class="span01"><%=LNG_COPYRIGHT_COMPANY%></span>
					<span><%=LNG_COPYRIGHT_CEO%></span>
					<span><%=LNG_COPYRIGHT_ADDRESS%></span>
				</p>
				<p>
					<span class="span01"><%=LNG_COPYRIGHT_BUSINESS_NUM%></span>
					<span><%=LNG_COPYRIGHT_TEL%></span>
					<span><%=LNG_COPYRIGHT_FAX%></span>
					<span><%=LNG_COPYRIGHT_EMAIL%></span>
				</p>
				<!--<p class="copyright">Copyright (c) CHECK LIVING co., ltd All rights reserved.</p>-->
			</div>
			<div class="bottom_bn">
				<a href="http://www.ftc.go.kr/" target="_blank"><img src="<%=IMG_SHARE%>/bottom_bn01.jpg" alt="" /></a>
				<a href="#" target="_blank"><img src="<%=IMG_SHARE%>/bottom_bn02.jpg" alt="" /></a>
			</div>
		</div>
	</div>



<%
'	print DK_MEMBER_ID
%>
<div id="floating2" style="position:absolute; z-index:1000;"><!--'include virtual="/_include/floating2.asp"--></div>
<script type="text/javascript">
<!--

if (document.getElementById("floating2")) {
	// 반드시 플로팅 기준객체(basisBody) 외부에서 설정
	var objFloating = new floating();
	objFloating.objBasis = document.getElementById("contain");
	objFloating.objFloating = document.getElementById("floating2");
	objFloating.time = 15;
	objFloating.marginLeft = 35;
	objFloating.marginTop = 150;//(document.body.clientHeight)-220;
	objFloating.init();
	objFloating.run();
}

//-->
</script>




<%	'========'오늘본상품 Floating ===========
	istoDayG = "F"
%>
<%If istoDayG = "T" Then%>
<div id="floating_toDayG" style="position:absolute; z-index:1000;"><!--#include virtual="/_include/floating_toDayG.asp"--></div>
<script type="text/javascript">

	if (document.getElementById("floating_toDayG")) {
		// 반드시 플로팅 기준객체(basisBody) 외부에서 설정
		var objFloating = new floating();
		objFloating.objBasis = document.getElementById("contain");
		objFloating.objFloating = document.getElementById("floating_toDayG");
		objFloating.time = 15;
		objFloating.marginLeft = 20;
		<%
			IF ISTOPMENU = "F" THEN
		%>
		objFloating.marginTop = 125;
		<%
			ELSE
		%>
		objFloating.marginTop = 180;
		<%
			END IF
		%>
		objFloating.init();
		objFloating.run();
	}

</script>
<%End If%>

<%
'암호화테스트
If webproIP = "T" Then
	enc ="123123"	'j5c5f4o+FLlMUDiaHn8djw==  , cGNjQTgrTyG5Nj5+9vVnXQ==		,,,Z0SPQ6DkhLd4eXxd0R+05w==
	If DKCONF_SITE_ENC = "T" Then
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If enc	<> "" Then enc	 = objEncrypter.Encrypt(enc)
		Set objEncrypter = Nothing
	End If
'	print enc&"<br>"



	dec ="vAuGFXzEolOtzGl+6DLxzw=="
	If DKCONF_SITE_ENC = "T" Then
		Set objEncrypter = Server.CreateObject ("Hyeongryeol.StringEncrypter")
			objEncrypter.Key = con_EncryptKey
			objEncrypter.InitialVector = con_EncryptKeyIV
			If dec	<> "" Then dec	 = objEncrypter.Decrypt(dec)
		Set objEncrypter = Nothing
	End If
	'print dec&"DD"


'<!--include virtual="/_lib/md5.asp" -->
'tttt = "hjtime07@nate.com123!@#!@#"
'RChar = XTEncrypt.MD5(tttt)
'print RChar

End If
%>
</body>
</html>
