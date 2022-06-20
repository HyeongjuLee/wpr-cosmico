
	function search_idcheck() {

		var ids = $("#memberName")
		var mails = $("#memberMail")
		var isCom = $("input[name=isCompany]:checked");
		//alert(isCom.val());

		if (ids.val() == '')
		{
			alert("이름을 입력하셔야합니다.");
			ids.focus();
			return false;
		}

		if (mails.val() == '')
		{
			alert("이메일을 입력하셔야합니다.");
			mails.focus();
			return false;
		}

		if (!checkEmail(mails.val())) {
			alert("메일주소를 정확하게 입력해 주세요.");
			mails.focus();
			return false;
		}


		$.ajax({
			type: "POST"
			,url: "member_search_id_ajax.asp"
			,data: {
				 "memberName"		: ids.val()
				,"memberMail"		: mails.val()
				,"isCom"			: isCom.val()
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				$("#login_alert").html(data);
				//loadings();

				//alert($("."+DivGoods).parent().tagName);


			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
	}



	function search_pwdcheck() {

		var ids = $("#memberId")
		var names = $("#memberName")
		var mails = $("#memberMail")
		var isCom = $("input[name=isCompany]:checked");
		//alert(isCom.val());

		if (memid.val() == '')
		{
			alert("아이디를 입력하셔야합니다.");
			memid.focus();
			return false;
		}

		if (ids.val() == '')
		{
			alert("이름을 입력하셔야합니다.");
			ids.focus();
			return false;
		}

		if (mails.val() == '')
		{
			alert("이메일을 입력하셔야합니다.");
			mails.focus();
			return false;
		}

		if (!checkEmail(mails.val())) {
			alert("메일주소를 정확하게 입력해 주세요.");
			mails.focus();
			return false;
		}


		$.ajax({
			type: "POST"
			,url: "member_search_pw_ajax.asp"
			,data: {
				 "memberName"		: ids.val()
				,"memberMail"		: mails.val()
				,"isCom"			: isCom.val()
				,"memberId"			: memid.val()
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				$("#login_alert").html(data);
				//loadings();

				//alert($("."+DivGoods).parent().tagName);


			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
	}
