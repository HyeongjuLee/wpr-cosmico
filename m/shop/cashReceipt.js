function receiptHandler(e) {
	//alert("dd");
	var receiptInfoVal = $("input[name=receiptInfoTF]:checked").val();
	if (receiptInfoVal == "T") {
		$("#receiptInfo").css({"display":""});
	} else {
		$("#receiptInfo").css({"display":"none"});
	}
}

function receiptPTHandler(e) {
	var receiptPTypeVal = $("select[name=receiptPType]").val();

	switch (receiptPTypeVal) {
		case "hpNum" : {
			$("ul.hpNum").css({"display":"inline-block"});
			$("ul.ssNum").css({"display":"none"});
			$("ul.CdNum").css({"display":"none"});
			break;
		}
		case "ssNum" : {
			$("ul.hpNum").css({"display":"none"});
			$("ul.ssNum").css({"display":"inline-block"});
			$("ul.CdNum").css({"display":"none"});
			break;
		}
		case "CdNum" : {
			$("ul.hpNum").css({"display":"none"});
			$("ul.ssNum").css({"display":"none"});
			$("ul.CdNum").css({"display":"inline-block"});
			break;
		}
	}
}
function receiptTypeHandler(e) {
	var receiptTypeVal = $("input[name=receiptType]:checked").val();
	if (receiptTypeVal == "P") {
		$("div.ReceiptP").css({"display":""});
		$("div.ReceiptC").css({"display":"none"});
	} else {
		$("div.ReceiptP").css({"display":"none"});
		$("div.ReceiptC").css({"display":""});
	}
}


$(document).ready(function() {
	$("input[name=receiptInfoTF]").on("click",receiptHandler);
	$("select[name=receiptPType]").change(receiptPTHandler);
	$("input[name=receiptType]").on("click",receiptTypeHandler);
});

