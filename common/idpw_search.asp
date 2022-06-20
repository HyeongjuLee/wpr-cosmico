<!--#include virtual = "/_lib/strFunc.asp"-->
<%
	PAGE_SETTING = "COMMON"

	ISLEFT = "F"
	ISSUBTOP = "T"
	ISSUBVISUAL = "F"
	view = 2

	If DK_MEMBER_LEVEL > 0 Then Response.Redirect "/index.asp"

%>
<!--#include virtual = "/_include/document.asp"-->
<script type="text/javascript">

	function nextFocus() {
		var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;

		if (keyCode == 13){
			document.frms.mem_pwd.focus();
			return false;
		}

	}
	function frmChkid(f){
		if(!chkNull(f.mem_name, "<%=LNG_JS_NAME%>")) return false;
		if(!chkNull(f.mem_email, "<%=LNG_JS_EMAIL%>")) return false;
		if (!checkEmail(f.mem_email.value)) {
			alert("<%=LNG_JS_EMAIL_CONFIRM%>");
			f.mem_email.focus();
			return false;
		}


		var isCom  = $("input[name=isCompany]:checked").length;
		//alert(isCom);

		if (isCom == 0)
		{
			isComapnyVal = "F"
		} else {
			isComapnyVal = "T"
		}


		var ajaxTF = "false";
		$.ajax({
			type: "POST"
			,async : false
			,url: "ajax_idpw.asp"
			,data: {
				 "mem_name"		: f.mem_name.value
				,"mem_email"	: f.mem_email.value
				,"isCompany"	: isComapnyVal
			}
			,success: function(newContent) {
				//var json = $.parseJSON(newContent);
				$("#ajax_content1").html(newContent);
				$("#ajax_content1").css({"border":"1px solid #ccc"});

			}
			,error:function(newContent) {
				alert("<%=LNG_AJAX_ERROR_MSG%>");
			}

		});
		if (ajaxTF != "true")
		{
			doubleSubmit = false;
			return false;
		}

	}

	function frmChkpwd(f){
		//alert("본사로 문의해주세요.");
		//$('form[name=frm2s] .input-wrap').find('p').text('본사로 문의해주세요.');
		return false;


		if(!chkNull(f.mem_id, "<%=LNG_JS_ID%>")) return false;
		if(!chkNull(f.mem_name, "<%=LNG_JS_NAME%>")) return false;
		if(!chkNull(f.mem_email, "<%=LNG_JS_EMAIL%>")) return false;
		if (!checkEmail(f.mem_email.value)) {
			alert("<%=LNG_JS_EMAIL_CONFIRM%>");
			f.mem_email.focus();
			return false;
		}

		var isCom2 = $("input[name=isCompany2]:checked").length;
		//alert(isCom2);

		if (isCom2 == 0)
		{
			isComapnyVal = "F"
		} else {
			isComapnyVal = "T"
		}

		var ajaxTF = "false";
		$.ajax({
			type: "POST"
			,async : false
			,url: "ajax_idpw_pwd.asp"
			,data: {
				 "mem_name"	: f.mem_name.value
				,"mem_email"	: f.mem_email.value
				,"mem_id"		: f.mem_id.value
				,"isCompany"	: isComapnyVal
			}
			,success: function(newContent) {
				//var json = $.parseJSON(newContent);
				$("#ajax_content2").html(newContent);
				$("#ajax_content2").css({"border":"1px solid #ccc"});

			}
			,error:function(newContent) {
				alert("<%=LNG_AJAX_ERROR_MSG%> "+jsonData.status+" "+jsonData.statusText+" "+jsonData.responseText);
			}

		});
		if (ajaxTF != "true")
		{
			doubleSubmit = false;
			return false;
		}

	}


</script>
</head>
<body>
<!--#include virtual = "/_include/header.asp"-->
<div id="idpw" class="common">
	<div class="wrap">
		<h6><%=LNG_MEMBER_IDPW_TEXT04%></h6>
		<p><%=LNG_MEMBER_IDPW_TEXT05%></p>
		<form name="frms" method="post" action="" onsubmit="return frmChkid(this);">
			<input type="hidden" name="isCompany" checked="checked" />

			<div class="input-wrap">
				<label>
					<span><%=LNG_TEXT_NAME%></span>
					<input type="text" name="mem_name" maxlength="30" tabindex="1" onkeydown="return nextFocus();" value />
				</label>
				<label>
					<span><%=LNG_TEXT_EMAILAD%></span>
					<input type="text" name="mem_email" maxlength="32" tabindex="2" value />
				</label>
				<input class="button" type="submit" value="<%=LNG_MEMBER_IDPW_TEXT09%>" tabindex="3" data-ripplet />
			</div>
		</form>
		<p id="ajax_content1"></p>
	</div>

	<script type="text/javascript">
		$('.input-wrap input').focus(function(){
			$(this).parent('label').addClass('focus');
		});
		$('.input-wrap input').blur(function(){
			$(this).parent('label').removeClass('focus');
		});

		$(document).on('keyup change', '.input-wrap input', function(){
			if ($(this).val()) {
				$(this).parent('label').addClass('key');
			} else {
				$(this).parent('label').removeClass('key');
			}
		});
	</script>

	<div class="wrap">
		<h6><%=LNG_MEMBER_IDPW_TEXT10%></h6>
		<!-- <p><%=LNG_MEMBER_IDPW_TEXT11%></p> -->
		<form name="frm2s" method="post" action="" onsubmit="return frmChkpwd(this);">
			<input type="hidden" name="isCompany2" checked="checked" />
			<div class="input-wrap">
				<!-- <div class="input">
					<input type="text" name="mem_id" maxlength="30" tabindex="4" onkeydown="return nextFocus();" value placeholder="<%=LNG_TEXT_ID%>" />
				</div>
				<div class="input">
					<input type="text" name="mem_name" maxlength="32" tabindex="5" value placeholder="<%=LNG_TEXT_NAME%>" />
				</div>
				<div class="input">
					<input type="text" name="mem_email" maxlength="32" tabindex="6" value placeholder="<%=LNG_TEXT_EMAILAD%>" />
				</div> -->
				<!-- <input class="button" type="submit" value="<%=LNG_MEMBER_IDPW_TEXT09%>" tabindex="7" />
				<p></p> -->
				<p class="text-box">본사로 문의 바랍니다.</p>
			</div>
		</form>
		<p id="ajax_content2"></p>
	</div>
</div>
<!--#include virtual = "/_include/copyright.asp"-->
