<%
	'If webproIP <> "T" Then Response.Redirect "/ready/index.asp"			'업체요청 2022-05-16 15:48~ 16:29

	mobileChk = Request.cookies("mobileCheck")

	If mobileChk = "OK" Then
	Else
		dim u,b,v
		set u=Request.ServerVariables("HTTP_USER_AGENT")
		set b=new RegExp
		set v=new RegExp
		b.Pattern="(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( 'os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino"
		v.Pattern="1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s ')|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez'([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( '|\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( 'g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v ')|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio'|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft'|ny)|sp(01|h\-|v\-|v ')|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|'98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-"
		b.IgnoreCase=true
		v.IgnoreCase=true
		b.Global=true
		v.Global=true
		'if b.test(u) or v.test(Left(u,4)) then response.redirect(HTTPS&"://"&"www."&MAIN_DOMAIN&"/m") end if
		if b.test(u) or v.test(Left(u,4)) then response.redirect(HTTPS&"://"&MAIN_DOMAIN&"/m") end If
	End If
%>



<%
	'■모바일만 + 관리자		'/common/ad_login.asp
	IF CONST_MOBILE_ONLY = "T" Then

		If DK_MEMBER_TYPE = "ADMIN" Then
			Response.Redirect "/admin"
		Else
			If PAGE_SETTING <> "ADMIN_LOGIN" Then		'/common/ad_login.asp
				Response.Redirect "/m"
			End If
		End If

	End If
%>
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="Imagetoolbar" content="no" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="Robots" content="index,follow">
<meta name="keywords" content="<%=strShopKeyword%>" />
<meta name="description" content="<%=strShopDescription%>" />
<meta property="og:type" content="website">
<meta property="og:title" content="<%=LNG_SITE_TITLE%>">
<meta property="og:description" content="">
<title><%=LNG_SITE_TITLE%></title>
<script type="text/javascript" src="/jscript/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/jscript/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript" src="/jscript/jquery.easing.1.3.js"></script>
<script type="text/javascript" src="/jscript/jquery.navi.left.js"></script>
<script type="text/javascript" src="/jscript/common.js?"></script>
<script type="text/javascript" src="/jscript/check.js?"></script>
<script type="text/javascript" src="/jscript/ajax.js"></script>
<script type="text/javascript" src="/jscript/openPopup.js"></script>
<script type="text/javascript" src="/jscript/jquery-ui.min_custom_draggable.js"></script>
<script type="text/javascript" src="/jscript/jquery.selectric.js"></script>
<script type="text/javascript" src="/jscript/ripplet-declarative.min.js"></script><!--클릭 시 물결 효과-->
<script type="text/javascript" src="/jscript/jquery-ui-1.13.0.custom/jquery-ui.min.js"></script>
<!-- <script type="text/javascript" src="/datepicker/air-datepicker.js"></script> -->
<link rel="stylesheet" href="/jscript/jquery-ui-1.13.0.custom/jquery-ui.min.css">
<!-- <link rel="stylesheet" href="/datepicker/air-datepicker.css"> -->

<!-- <script type="text/javascript" src="/datepicker/jquery-ui.js"></script>
<script type="text/javascript" src="/datepicker/jquery-datepicker.js"></script>
<link rel="stylesheet" href="/datepicker/jquery-ui.css">
<link rel="stylesheet" href="/datepicker/jquery-datepicker.css"> -->

<link href="/css/a_BtnCss.css?" rel="stylesheet">
<link href="/css/fontawesome.5.12.1.css" rel="stylesheet"><!--load all styles -->
<link rel="stylesheet" href="/fontello/css/icon-font.css?">
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard-dynamic-subset.css?" />
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard.css?" />

<%Select Case UCase(DK_MEMBER_NATIONCODE)%>
<%Case Else%>
<link rel="stylesheet" href="/css/NotoSansKR.css?">
<link rel="stylesheet" href="/css/Roboto.css?">
<%End Select%>
<!-- <script type="text/javascript" src="/jscript/placeholders.min.js"></script> -->
<!-- <link rel="shortcut icon" href="<%=VIR_PATH("favicon")%>/<%=DKCONF_FAVICON%>" /> -->

<link rel="stylesheet" href="/css/common2.css?" />
<link rel="stylesheet" href="/css/header.css?">
<%If Left(PAGE_SETTING,4) = "SHOP" Then %>
<link rel="stylesheet" href="/css/shop_style.css?" />
<link rel="stylesheet" href="/css/shop_style_<%=LCase(DK_MEMBER_LNG_CODE)%>.css?" /><%'언어선택%>
<link rel="stylesheet" href="/css/style.css?" />
<%Else%>
<link rel="stylesheet" href="/css/style.css?" />
<link rel="stylesheet" href="/css/style_<%=LCase(DK_MEMBER_LNG_CODE)%>.css?" /><%'언어선택%>

	<%If PAGE_SETTING = "MYOFFICE" Then %>
		<link rel="stylesheet" href="/css/style_left_M.css?" />
	<%Else%>
		<link rel="stylesheet" href="/css/style_left.css?" />
	<%End If%>

<%End If%>

<script>
	$(document).ready(function() {
		//hidden readonly
		$("input[type='hidden']").attr("readonly",true);
		$("input[type='hidden ']").attr("readonly",true);
	});

</script>
