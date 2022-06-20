	function thisGoodsCart(nums) {		
		var eavalue = document.getElementById('oxea'+nums).value;
		var idvalue = document.getElementById('oxid'+nums).value;

		if (eavalue == '') { alert('수량값이 없습니다.');}
		if (idvalue == '') { alert('상품코드값이 없습니다.');}

		if (eavalue < 1){
			alert('수량값은 1 이상입니다.');			
		} else {
			chg_cart(eavalue,idvalue);			
		}
	}

/*
	function chg_cart(mode1,mode2) {

				alert(3)
		createRequest();
		var url = 'cart_ajax.asp';
		//alert(mode1);
		postParams = "eavalue=" + mode1;
		postParams += "&idvalue=" + mode2;
		postParams += "&modes=regist";

		request.open("POST",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					//var newContentSplit = newContent.split("||")
					//alert(newContent);
					//document.getElementById("product_area").innerHTML = newContent;
					alert(newContent);
					location.href="/buy/cart.asp"		//성공시 카트로 이동
				} else {
					alert("ajax error");
				}
			  }
			}
		request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
		request.send(postParams);
		return;
	}
*/

		
	function chg_cart(mode1,mode2) {
		//console.log(mode1);		//F12 확인
		//console.log(mode2);
		$.ajax({
			type: "POST"
			,url: "cart_ajax.asp"
			,data: {
				  "modes"		: "regist"
				 ,"eavalue"		: mode1
				 ,"idvalue"		: mode2
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				alert(data);
				location.href="/m/buy/cart.asp"		//성공시 카트로 이동
			}
			,error:function(data) {
				alert("ajax error");
			}
		});
	}

	
	//직하선 소비자구매
	function thisGoodsCart4down(nums) {
		var eavalue = document.getElementById('oxea'+nums).value;
		var idvalue = document.getElementById('oxid'+nums).value;
		if (eavalue == '') { alert('수량값이 없습니다2.');}
		if (idvalue == '') { alert('상품코드값이 없습니다2.');}

		if (eavalue < 1){
			alert('수량값은 1 이상입니다.2');			
		} else {
			chg_cart4down(eavalue,idvalue);			
		}
	}

	
	function chg_cart4down(mode1,mode2) {
		createRequest();
		var url = 'cart_4down_ajax.asp';
		//alert(mode1);
		postParams = "eavalue=" + mode1;
		postParams += "&idvalue=" + mode2;
		postParams += "&modes=regist";

		request.open("POST",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					//var newContentSplit = newContent.split("||")
					//alert(newContent);
					//document.getElementById("product_area").innerHTML = newContent;
					alert(newContent);
				} else {
					alert("ajax error");
				}
			  }
			}
		request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
		request.send(postParams);
		return;
	}