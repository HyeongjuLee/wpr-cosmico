
	function pay_ajax_view(MODES,EDATE,viewID,ajax_page,ajax_url){
		$("#loading").css("display","block");
		$.ajax({
			type: "POST"
			,url: ajax_url
			,data: {
				 "MODES"		: MODES
				,"EDATE"		: EDATE
				,"PAGE"			: ajax_page
				,"viewID"		: viewID
				,"ajax_url"		: ajax_url
			}
			/*
			,beforeSend: function(){
				$("#loading").css("display","block");
				$('.payment_blocker').show();
				$('.payment_detail').show();
			}
			*/
			,success: function(result) {
				$("#"+viewID).html(result);
				$("#loading").css("display","none");
				//$("#payment_detail_body").html(result);

			}
			,error:function(result) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+result.status+" "+result.statusText);
				$("#loading").css("display","none");
			}
		});
	}
