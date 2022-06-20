	function chg_product(mode1,mode2) {
		createRequest();
		var url = 'product_chg_ajax.asp';

		postParams = "mode1=" + mode1;
		postParams += "&mode2=" + mode2;

		request.open("POST",url,true);
		request.onreadystatechange = function ChgContent() {
			if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
				if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
					var newContent = request.responseText;
					//var newContentSplit = newContent.split("||")
					//alert(newContent);
					document.getElementById("product_area").innerHTML = newContent;
					//alert(document.getElementById("innerMask").innerHTML);
				} else {
					alert("ajax error");
				}
			  }
			}
		request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
		request.send(postParams);
		return;
	}