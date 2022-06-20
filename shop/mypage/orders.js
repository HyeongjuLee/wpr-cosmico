function chgDate(sdate,nDate) {
	var SDATE = $("#SDATE");
	var EDATE = $("#EDATE");

	var nowDate = nDate;

	if (sdate != '')
	{
		EDATE.val(nowDate);
		SDATE.val(sdate);


	} else {
		EDATE.val('');
		SDATE.val('');
	}
}


function orderFinish(orderIDX) {
	createRequest();
	var url = 'orderChg.asp';


	postParams = "orderNum=" + orderIDX;
	postParams += "&mode=" + 'finish';


	request.open("POST",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				//var newContentSplit = newContent.split("||")
				//alert(newContent);
				//document.getElementById("select2nd").innerHTML = newContent;
				//$("#cate2 > option[value='<%=IN_CATE2%>']").attr("selected",true);
				switch (newContent)
				{
					case 'FINISH' : {
						alert("정상처리되었습니다.");
						document.location.reload();
						break;
					}
					case 'ERROR' : {
						alert("DB처리중 에러가 발생하였습니다.\n에러 지속시 고객센터로 문의해주세요.");
						document.location.reload();
						break;
					}
					case 'NOMATCHUSER' : {
						alert("요청하신 주문자와 수취확인 주문자가 틀립니다.");
						document.location.reload();
						break;
					}
					default : {
						alert("DB 처리중 예외상황이 발생하였습니다");
						document.location.reload();
						break;
					}
				}


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