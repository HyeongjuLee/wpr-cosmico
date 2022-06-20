
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
			},
			beforeSend: function(){
				$("#loading").css("display","block");
				$('.payment_blocker').show();
				$('.payment_detail').show();
			},
			complete : function(){
				$("#loading").css("display","none");
			},
			success: function(result) {
				//$("#payment_detail_body").html(result);
				$('#payment_detail_body_'+viewID).html(result);
			},
			error:function(result) {
				alert("<%=LNG_AJAX_ERROR_MSG%>"+result.status+" "+result.statusText);
				$("#loading").css("display","none");
			}
		});
	}



	//fixed Table
	function fixedTable(fix_cl,fix_cr,th_line) {
		//th_line : th 줄의 수
		if (typeof th_line === "undefined") {
			th_line = 1;
		}
		let fTbl_D_W = $("#fTbl_D").width();
		let fixedTable_W = $("#fixedTable").width();
		if (fTbl_D_W > fixedTable_W) {		//스크롤 확인
			let isData = $("#fixedTable td:first").attr("class");
			let fTbl_TH_len = ($('#fTbl_D th').length/th_line) -1;
			//console.log(fTbl_TH_len);

			fix_cr = fTbl_TH_len - fix_cr;
			//console.log(isData);
			if (isData != "notData") {		//고정컬럼 복제
				$("#fTbl_D tr.fixedTR").each(function(index) {
					//좌측고정
					let cloneTR = $("<tr></tr>");
					$(this).find('th:lt('+fix_cl+')').clone().appendTo(cloneTR);
					$(this).find('td:lt('+fix_cl+')').clone().appendTo(cloneTR);
					$("#fTbl_O").append(cloneTR);

					//우측고정
					let cloneTR2 = $("<tr></tr>")
					$(this).find('th:gt('+fix_cr+')').clone().appendTo(cloneTR2);
					$(this).find('td:gt('+fix_cr+')').clone().appendTo(cloneTR2);
					$("#fTbl_O2").append(cloneTR2);

					let theadTH = $("#fTbl_O").find('th').parents('tr');
					theadTH.remove();
					$("#fTbl_O").prepend('<thead>'+theadTH.html()+'</thead>');

					let theadTH2 = $("#fTbl_O2").find('th').parents('tr');
					theadTH2.remove();
					$("#fTbl_O2").prepend('<thead>'+theadTH2.html()+'</thead>');

				});
			}

		}
	}

	$(function(){
		$('.payment_blocker').on('click', function(){
			$('.payment_blocker').hide();
			$('#payment_detail_body').empty();
			$('.payment_detail').hide();
		});

		$(".icon-cancel").on('click', function(){
			$('.payment_blocker').hide();
			$('#payment_detail_body').empty();
			$('.payment_detail').hide();
		});

		//fixedTable 가로스크롤 확인
		$.fn.hasScrollBar = function() {
			return this.get(0).scrollWidth > this.width();
		}
	});

	//합계내역 스크롤
	$(window).resize(function() {
		let fixedTableSliderChk = $('#fixedTable .fixedTable_Default').hasScrollBar();
		if (fixedTableSliderChk) {
			$(".fixedTable_overCell, .fixedTable_overCell2").show();
		}else{
			$(".fixedTable_overCell, .fixedTable_overCell2").hide();
		}
	});

