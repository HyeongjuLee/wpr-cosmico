
	// + SELLCODE, slvl
	function underPurchase_ajax_view_N(MBID1,MBID2,SDATE,EDATE,SELLCODE,sLvl,viewID,ajax_page,ajax_url){
		$("#loading").css("display","block");
		//console.log(SELLCODE);
		$.ajax({
			type: "POST"
			,url: ajax_url
			,data: {
				 "MBID1"		: MBID1
				,"MBID2"		: MBID2
				,"SDATE"		: SDATE
				,"EDATE"		: EDATE
				,"SELLCODE"		: SELLCODE
				,"sLvl"		: sLvl
				,"PAGE"			: ajax_page
				,"viewID"		: viewID
				,"ajax_url"		: ajax_url
			}
			,success: function(result) {
				$("#"+viewID).html(result);
				$("#loading").css("display","none");
			}
			,error:function(result) {
				//alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+result.status+" "+result.statusText);
				alert("ajax error! .ERROR CODE : "+result.status+" "+result.statusText);
				$("#loading").css("display","none");
			}
		});
	}


	// 통합형
	function chgUnderPurchaseN(value) {
		let SDATE = ''
		let EDATE = ''
		let UnderID1
		let UnderID2
		let UnderName
		let SELLCODE
		let sLvl
		let ajax_url = "";

		SDATE = $("#SDATE").val();
		EDATE = $("#EDATE").val();
		UnderID1 = $("#UnderID1").val();
		UnderID2 = $("#UnderID2").val();
		UnderName = $("#UnderName").val();
		SELLCODE = $("#SELLCODE").val();
		sLvl = $("#sLvl").val();

		let ch = $("#buy").height();

		$("#loadings").show().css({"height": ch+"px"});
		$("#loadings_lmenu").show();

		$.ajax({
			type: "POST",
			url: "underPurchase_ajax.asp",
			data : {
				"SDATE"	: SDATE,
				"EDATE"	: EDATE,
				"UnderID1"	: UnderID1,
				"UnderID2"	: UnderID2,
				"UnderName"	: UnderName,
				"SELLCODE" : SELLCODE,
				"sLvl" : sLvl,
				"iniValue" : value
			},
			success: function(data) {
				$("#AjaxPurchaseContent").html(data);
				$("#loadings").hide();
			}
			,error:function(data) {
				alert("<%=LNG_AJAX_ERROR_MSG%> : "+data.status+" "+data.statusText+" "+data.responseText);
			}
		});
	}


	//No F5
	function noEvent() {
		if (event.keyCode == 116) {
			event.keyCode= 2;
			return false;
		}
			else if(event.ctrlKey && (event.keyCode==78 || event.keyCode == 82))
		{
			return false;
		}
	}
	document.onkeydown = noEvent;

