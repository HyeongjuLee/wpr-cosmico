	function thisGoodsCart(nums,modes) {
		//alert(modes);
		var eavalue = document.getElementById('oxea'+nums).value;
		var idvalue = document.getElementById('oxid'+nums).value;
		if (eavalue == '') { alert('수량값이 없습니다.2');}
		if (idvalue == '') { alert('상품코드값이 없습니다.2');}

		if (modes == 'delall') {
			if (confirm("전체 삭제하시겠습니까?")) {
				chg_cart(1,1,modes);		
			}
		}else{
			if (eavalue < 1){				
				alert('수량값은 1 이상입니다.');
				chg_cart(1,idvalue,modes);
			} else {
				if (modes == 'delete') {
					if (confirm("삭제하시겠습니까?")) {
						chg_cart(eavalue,idvalue,modes);		
					} else {					
					}
				}else{
					chg_cart(eavalue,idvalue,modes);		
				}	
			//	chg_cart(eavalue,idvalue,modes);		
			}

		}

	}


	function chg_cart(mode1,mode2,mode3) {
		createRequest();
		var url = 'cart_ajax.asp';
		//alert(mode3);
		postParams = "eavalue=" + mode1;
		postParams += "&idvalue=" + mode2;
		postParams += "&modes=" + mode3;

		request.open("POST",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					//var newContentSplit = newContent.split("||")
					//alert(newContent);
					//document.getElementById("product_area").innerHTML = newContent;
					//alert(newContent);
					alert('정상처리되었습니다.');
					document.location.reload();
				} else {
					alert("ajax error2");
				}
			  }
			}
		request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
		request.send(postParams);
		return;
	}

	//직하선 소비자구매
	function thisGoodsCart4down(nums,modes) {
		var eavalue = document.getElementById('oxea'+nums).value;
		var idvalue = document.getElementById('oxid'+nums).value;
		if (eavalue == '') { alert('수량값이 없습니다.2');}
		if (idvalue == '') { alert('상품코드값이 없습니다.2');}

		if (eavalue < 1){
			alert('수량값은 1 이상입니다.2');			
			chg_cart4down(1,idvalue,modes);
		} else {
			chg_cart4down(eavalue,idvalue,modes);		
		}
	}


	function chg_cart4down(mode1,mode2,mode3) {
		createRequest();
		var url = 'cart_4down_ajax.asp';
		//alert(mode3);
		postParams = "eavalue=" + mode1;
		postParams += "&idvalue=" + mode2;
		postParams += "&modes=" + mode3;

		request.open("POST",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					//var newContentSplit = newContent.split("||")
					//alert(newContent);
					//document.getElementById("product_area").innerHTML = newContent;
					//alert(newContent);
					document.location.reload();
				} else {
					alert("ajax error2");
				}
			  }
			}
		request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
		request.send(postParams);
		return;
	}


