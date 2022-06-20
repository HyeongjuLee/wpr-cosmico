/*한글*/

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


function AJ_deliveryFinish(intIDX,chgTD){
	$.ajax({
		type: "POST"
		,url: "order_chg_104.asp"
		,data: {
			 "intIDX"		: intIDX
			,"TDID"			: chgTD
		}
		//,contentType: "application/json; charset=utf-8"
		,dataType :"json"
		,success: function(data) {
			//var results = $.parseJSON(result);
			//alert(data[0].codes);
			switch (data[0].codes)
			{
			case "DBFINISH" :
				alert("수취확인 되었습니다");
				$("#"+chgTD).html(data[0].datas);
				break;
			default :
				alert(data[0].datas);
				break;
			}
			//$("#"+chgTD).html(data[0].datas);

		}
		,error:function(data) {
			alert("<%=LNG_AJAX_ERROR_MSG%> : "+data.status+" "+data.statusText+" "+data.responseText);
			//alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
		}
	});
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
						//alert("정상처리되었습니다.");
						alert("<%=LNG_SHOP_ORDER_LIST_JS01%>");
						document.location.reload();
						break;
					}
					case 'ERROR' : {
						//alert("DB처리중 에러가 발생하였습니다.\n에러 지속시 고객센터로 문의해주세요.");
						alert("<%=LNG_SHOP_ORDER_LIST_JS022>");
						document.location.reload();
						break;
					}
					case 'NOMATCHUSER' : {
						//alert("요청하신 주문자와 수취확인 주문자가 틀립니다.");
						alert("<%=LNG_SHOP_ORDER_LIST_JS03%>");
						document.location.reload();
						break;
					}
					default : {
						//alert("DB 처리중 예외상황이 발생하였습니다");
						alert("<%=LNG_SHOP_ORDER_LIST_JS04%>");
						document.location.reload();
						break;
					}
				}


				//alert(document.getElementById("innerMask").innerHTML);
			} else {
				//alert("ajax error");
					alert(request.responseText);
			}
		  }
		}
	request.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=utf-8");
	request.send(postParams);
	return;

}