<script type="text/javascript">

	$(document).ready(function() {
		$("#cCenter").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cCenter]");
			if (check1)	{ $(".cCenter").css({"display":"block"}); thisInput.val('1'); } else { $(".cCenter").css({"display":"none"}); thisInput.val(''); }
		});
		//후원인 정보
		$("#cSaveInfo").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cSaveInfo]");
			if (check1)	{ $(".cSaveInfo").css({"display":"block"}); thisInput.val('1'); } else { $(".cSaveInfo").css({"display":"none"}); thisInput.val(''); }
		});

		$("#cPeriodPV").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cPeriodPV]");
			if (check1)	{ $(".cPeriodPV").css({"display":"block"}); thisInput.val('1'); } else { $(".cPeriodPV").css({"display":"none"}); thisInput.val(''); }
		});

		$("#cPeriodCV").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cPeriodCV]");
			if (check1)	{ $(".cPeriodCV").css({"display":"block"}); thisInput.val('1'); } else { $(".cPeriodCV").css({"display":"none"}); thisInput.val(''); }
		});

		$("#cPeriodDownPV").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cPeriodDownPV]");
			if (check1)	{ $(".cPeriodDownPV").css({"display":"block"}); thisInput.val('1'); } else { $(".cPeriodDownPV").css({"display":"none"}); thisInput.val(''); }
		});

		$("#cPeriodDownCV").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cPeriodDownCV]");
			if (check1)	{ $(".cPeriodDownCV").css({"display":"block"}); thisInput.val('1'); } else { $(".cPeriodDownCV").css({"display":"none"}); thisInput.val(''); }
		});

		$("#cGrade").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cGrade]");
			if (check1)	{ $(".cGrade").css({"display":"block"}); thisInput.val('1'); } else { $(".cGrade").css({"display":"none"}); thisInput.val(''); }
		});

		$("#cCPoint").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cCPoint]");
			if (check1)	{ $(".cCPoint").css({"display":"block"}); thisInput.val('1'); } else { $(".cCPoint").css({"display":"none"}); thisInput.val(''); }
		});

    $("#cShopURL").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cShopURL]");
			if (check1)	{ $(".cShopURL").css({"display":"block"}); thisInput.val('1'); } else { $(".cShopURL").css({"display":"none"}); thisInput.val(''); }
		});

		//판매원,소비자
		$("#cSellMemTF").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cSellMemTF]");
			if (check1)	{ $(".cSellMemTF").css({"display":"block"}); thisInput.val('1'); } else { $(".cSellMemTF").css({"display":"none"}); thisInput.val(''); }
		});

		$("#sNameSearch").keypress(function(event) {
			if (event.which == 13) {
				event.preventDefault();
				//alert($(this).val());
				fnUnderSearch($(this).val());
			}
		});
		$("#sNameSearchBtn").click(function(event) {
			event.preventDefault();
			//alert($("#sNameSearch").val());
			fnUnderSearch($("#sNameSearch").val());
		});

		$("#cLvl").change(function(event) {
			event.preventDefault();
			$("form[name=sfrm] input[name=cLvl]").val($(this).val());
			$("form[name=sfrm]").submit();

		});
		/*
    $("#cZoom").change(function(event) {
			event.preventDefault();
			$("form[name=sfrm] input[name=cZoom]").val($(this).val());
			$("form[name=sfrm]").submit();

		});
		*/
		$("#viewM").click(function(e) {
			var nowView = $("#nowView").val();
			var sFrm = $("form[name=sfrm]");
			var cZoom = $("form[name=sfrm] input[name=cZoom]");

			switch (nowView) {
				case "100%" :
					cZoom.val(70);
					sFrm.submit();
					break;
				case "70%" :
					cZoom.val(50);
					sFrm.submit();
					break;
				case "50%" :
					cZoom.val(30);
					sFrm.submit();
					break;
				case "30%" :
					cZoom.val(10);
					sFrm.submit();
					break;
				case "10%" :
					//alert("10% 미만으로 줄일 수 없습니다.");
					alert("<%=LNG_TEXT_CANNOT_REDUCED_LESS_10%>");
					break;
				default :
					//alert("올바른 값이 아닙니다. 새로고침 해주세요");
					alert("<%=LNG_TEXT_NOT_A_VALID_VALUE%>\n<%=LNG_STRTEXT_TEXT02%>");
					break;
			}
		});
		$("#viewP").click(function(e) {
			var nowView = $("#nowView").val();
			var sFrm = $("form[name=sfrm]");
			var cZoom = $("form[name=sfrm] input[name=cZoom]");

			switch (nowView) {
				case "100%" :
					//alert("100% 이상으로 늘릴 수 없습니다");
					alert("<%=LNG_TEXT_CANNOT_INCREASE_ABOVE_100%>");
					break;
				case "70%" :
					cZoom.val(100);
					sFrm.submit();
					break;
				case "50%" :
					cZoom.val(70);
					sFrm.submit();
					break;
				case "30%" :
					cZoom.val(50);
					sFrm.submit();
					break;
				case "10%" :
					cZoom.val(30);
					sFrm.submit();
					break;
				default :
					//alert("올바른 값이 아닙니다. 새로고침 해주세요");
					alert("<%=LNG_TEXT_NOT_A_VALID_VALUE%>\n<%=LNG_STRTEXT_TEXT02%>");
					break;
			}
		});



		$("#search_period").ready(function(){
			var T_Display = $("#search_period").css("display");
			//alert(T_Display);
			if (T_Display == "block") {
				//$("#etcBtn").text("기능닫기");
				$("#etcBtn").text("<%=LNG_TEXT_FUNCTION_CLOSE%>");
			} else {
				//$("#etcBtn").text("기능열기");
				$("#etcBtn").text("<%=LNG_TEXT_FUNCTION_OPEN%>");
			}
		});

		$("input[name=memInfo], a.memInfoBtn").click(function(event){
			event.preventDefault();
			var mbid1		= $(this).closest("p").find("input[name=mi_mbid1]").val();
			var mbid2		= $(this).closest("p").find("input[name=mi_mbid2]").val();
			var mname		= $(this).closest("p").find("input[name=mi_mname]").val();
			var regTime		= $(this).closest("p").find("input[name=mi_regTime]").val();
			var center		= $(this).closest("p").find("input[name=mi_center]").val();
			var vname		= $(this).closest("p").find("input[name=mi_vname]").val();
			var vid			= $(this).closest("p").find("input[name=mi_vid]").val();
			var meap		= $(this).closest("p").find("input[name=mi_meap]").val();
			var meac		= $(this).closest("p").find("input[name=mi_meac]").val();
			var url			= $(this).closest("p").find("input[name=mi_url]").val();
			var Grade_Name	= $(this).closest("p").find("input[name=mi_Grade_Name]").val();
			var webID		= $(this).closest("p").find("input[name=mi_webID]").val();

			fnMemberInfo(mbid1,mbid2,mname,regTime,center,vname,vid,meap,meac,url,Grade_Name,webID);
		});


	});

	function sFrmSubmit(sid1,sid2){
		<%If Not IS_LIMIT_LEVEL Then %>
			var f = document.sfrm;
			f.sid1.value = sid1;
			f.sid2.value = sid2;
			f.submit();
		<%End IF%>
	}


	function fnCheckSearch() {
		$("#search_period").toggle();
		var T_Display = $("#search_period").css("display");
		//alert(T_Display);
		if (T_Display == "block") {
			//$("#etcBtn").text("기능닫기");
			$("#etcBtn").text("<%=LNG_TEXT_FUNCTION_CLOSE%>");
			let SL2_h =$(".SearchLayer2").height() + 20;
			$("#treeArea").css("padding-top", SL2_h+"px");
		} else {
			//$("#etcBtn").text("기능열기");
			$("#etcBtn").text("<%=LNG_TEXT_FUNCTION_OPEN%>");
			$("#treeArea").css("padding-top", "60px");
		}
	}

	function fnFaDel(mbid1,mbid2) {
		var mode = "DEL";
		var mbid = mbid1 + mbid2;
		var data = {
			 "mbid"	: mbid
			,"mode"	: mode
		}

		$.ajax({
			 method : "POST"
			,url : "T_tree_vt_V10_FA_AJAX.asp"
			,async: false
			,data : data
			,success: function(xhrData) {
				jsonData = $.parseJSON(xhrData);
				if (jsonData.result == 'SUCCESS') {
					alert(jsonData.resultMsg);
					fnFaList();
					tree_favorite(mbid,'DEL_LIST')		//리스트 삭제 추가
					return false;
				} else {
					alert(jsonData.resultMsg);
					return false;
				}
			}
			,error:function(data) {
				//alert("데이터 저장 중 에러가 발생했습니다.");
				alert("<%=LNG_CS_CART_AJAX_ALERT05%>");
			}
		});


	}

	function tree_favorite(mbid,mode) {

		var data = {
			 "mbid"	: mbid
			,"mode"	: mode
		}

		$.ajax({
			 method : "POST"
			,url : "T_tree_vt_V10_FA_AJAX.asp"
			,async: false
			,data : data
			,success: function(xhrData) {
				jsonData = $.parseJSON(xhrData);
				if (jsonData.result == 'SUCCESS') {
					////alert(jsonData.resultMsg);			//삭제
					//location.reload();
					if (mode == 'ADD') {
						alert(jsonData.resultMsg);			//추가
						$(".node-cell .fa"+mbid).addClass("ofv").removeClass("nfv").attr("href","javascript:tree_favorite(\'"+mbid+"',\'DEL\')");
					} else if (mode == 'DEL') {
						alert(jsonData.resultMsg);			//추가
						$(".node-cell .fa"+mbid).addClass("nfv").removeClass("ofv").attr("href","javascript:tree_favorite(\'"+mbid+"',\'ADD\')");
					//추가(리스트에서 삭제 시 조직도 내  즐겨찾기표식 삭제
					} else if (mode == 'DEL_LIST' ) {
						//alert(jsonData.resultMsg);		//이미 삭제되었거나 즐겨찾기 되지 않은 회원입니다. 알림 삭제!!
						$(".node-cell .fa"+mbid).addClass("nfv").removeClass("ofv").attr("href","javascript:tree_favorite(\'"+mbid+"',\'ADD\')");
					}
					return false;
				} else {
					alert(jsonData.resultMsg);
					return false;
				}
			}
			,error:function(data) {
				//alert("데이터 저장 중 에러가 발생했습니다.");
				alert("<%=LNG_CS_CART_AJAX_ALERT05%>");
			}
		});
	}

	function fnFaList() {
		$("#ModalScrollable1").modal('show');
		$.ajax({
			 method : "POST"
			,url : "T_tree_vt_V10_FA_LIST_AJAX.asp"
			,async: false
			,success: function(xhrData) {
				jsonData = $.parseJSON(xhrData);
				if (jsonData.result == 'SUCCESS') {
					//$("#TableGrid1 tbody tr").empty();
					//alert(jsonData.resultMsg);
					var innerHtml = "";
					for(var i=0;i<jsonData.FaData.length;i++){
						innerHtml += '<tr class=\"modalCategory1\">';
						innerHtml += '<td>'+jsonData.FaData[i].Fa_mbid1+'-'+jsonData.FaData[i].Fa_mbid2+'</td>';
						//innerHtml += '<td>'+jsonData.FaData[i].Fa_Webid+'</td>'
						innerHtml += '<td>'+jsonData.FaData[i].Fa_name+'</td>'
						innerHtml += '<td><a class="blue" href="javascript:sFrmSubmit(\''+jsonData.FaData[i].Fa_mbid1+'\',\''+jsonData.FaData[i].Fa_mbid2+'\');">[<%=LNG_TEXT_SELECT%>]</a> '
						innerHtml += '<a class="red" href="javascript:fnFaDel(\''+jsonData.FaData[i].Fa_mbid1+'\',\''+jsonData.FaData[i].Fa_mbid2+'\');">[<%=LNG_BTN_DELETE%>]</a></td>'
						innerHtml += '</tr>';
					}
					$("#TableGrid1 tbody tr").empty();
					$("#TableGrid1 tbody").append(innerHtml);
				} else if (jsonData.result == 'NOTDATA') {
					innerHtml += '<tr class=\"modalCategory1\">';
					innerHtml += '<td colspan=\'4\' class=\'notData\'><%=LNG_TEXT_NO_FAVORITE_MEMBERS%></td>';
					innerHtml += '</tr>';

					$("#TableGrid1 tbody tr").empty();
					$("#TableGrid1 tbody").append(innerHtml);

				} else {
					alert(jsonData.resultMsg);
					return false;
				}
			}
			,error:function(xhrData) {
				alert("<%=LNG_CS_CART_AJAX_ALERT05%>");
			}
		});



	}


	function fnUnderList() {
		$("#ModalScrollable2").modal('show');
	}

	function fnUnderSearch(sNameData) {
		if (sNameData == ""){
			alert("<%=LNG_TEXT_INPUT_SEARCH_WORD%>");
			$("#sNameSearch").focus();
			return false;
		}

		var data = {
			 "sNameSearch"	: sNameData
		}
		$.ajax({
			 method : "POST"
			,url : "T_tree_vt_V10_UD_LIST_AJAX.asp"
			,async: false
			,data : data
			,success: function(xhrData) {
				jsonData = $.parseJSON(xhrData);
				if (jsonData.result == 'SUCCESS') {
					//$("#TableGrid1 tbody tr").empty();
					//alert(jsonData.resultMsg);
					var innerHtml = "";
					for(var i=0;i<jsonData.FaData.length;i++){
						innerHtml += '<tr class=\"modalCategory1\">';
						innerHtml += '<td>'+jsonData.FaData[i].Fa_mbid1+'-'+jsonData.FaData[i].Fa_mbid2+'</td>';
						//innerHtml += '<td>'+jsonData.FaData[i].Fa_Webid+'</td>'
						innerHtml += '<td>'+jsonData.FaData[i].Fa_name+'</td>'
						innerHtml += '<td><a href="javascript:sFrmSubmit(\''+jsonData.FaData[i].Fa_mbid1+'\',\''+jsonData.FaData[i].Fa_mbid2+'\');"><%=LNG_TEXT_SELECT%></a></td>'

						innerHtml += '</tr>';
					}
					$("#TableGrid2 tbody tr").empty();
					$("#TableGrid2 tbody").append(innerHtml);
				} else if (jsonData.result == 'NOTDATA') {
					innerHtml += '<tr class=\"modalCategory1\">';
					//innerHtml += '<td colspan=\'4\' class=\'notData\'>해당이름으로 검색된 하위 회원이 없습니다</td>';
					innerHtml += '<td colspan=\'4\' class=\'notData\'><%=LNG_AJAX_TREE_SS_V2_TEXT01%></td>';
					innerHtml += '</tr>';

					$("#TableGrid2 tbody tr").empty();
					$("#TableGrid2 tbody").append(innerHtml);

				} else {
					alert(jsonData.resultMsg);
					return false;
				}
			}
			,error:function(xhrData) {
				//alert("데이터 저장 중 에러가 발생했습니다.");
				alert("<%=LNG_CS_CART_AJAX_ALERT05%>");
			}
		});
	}

	function fnMemberInfo(mbid1,mbid2,mname,regTime,center,vname,vid,meap,meac,url,Grade_Name, webID) {
		$("#ModalScrollable3").modal('show');
		//$("#ModalScrollableTitle3").text(mname+' 님의 기타정보');
		$("#ModalScrollableTitle3").text("<%=LNG_TEXT_MEMBER_OTHER_INFOS%> : "+mname);

		$("#hidden_mbid1").val(mbid1);
		$("#hidden_mbid2").val(mbid2);
		$("#hidden_mname").val(mname);
		$("#hidden_regTime").val(regTime);
		$("#hidden_center").val(center);
		$("#hidden_vname").val(vname);
		$("#hidden_vid").val(vid);
		$("#hidden_meap").val(meap);
   	$("#hidden_meac").val(meac);
		$("#hidden_url").val(url);
		$("#hidden_webID").val(webID);
		$("#hidden_Grade_Name").val(Grade_Name);		//추가


		$("td.view_mbid1").text($("#hidden_mbid1").val() + '-'+ $("#hidden_mbid2").val());
		$("td.view_mname").text($("#hidden_mname").val());
		$("td.view_regTime").text($("#hidden_regTime").val());
		$("td.view_center").text($("#hidden_center").val());
		$("td.view_meap").text($("#hidden_meap").val());
    $("td.view_meac").text($("#hidden_meac").val());
		$("td.view_vname").text($("#hidden_vname").val());
		$("td.view_vid").text($("#hidden_vid").val());
		$("td.view_webID").text($("#hidden_webID").val());
		$("td.view_Grade_Name").text($("#hidden_Grade_Name").val());		//추가

		fnMemberInfo1();



	}

	function fnMemberInfo1() {
		var loading1 = '<div class="width100 purloading1" id="purloading1"><p><img src="/images_kr/159.gif" alt="" /></p><p style="margin-top:10px;"><%=LNG_TEXT_DATA_LOADING%></p></div>';
		$("#PURCHASE1").html(loading1);

		var sdate = $("#SDATE1").val();
		var edate = $("#EDATE1").val();
		var mbid1 = $("#hidden_mbid1").val();
		var mbid2 = $("#hidden_mbid2").val();
		var mname = $("#hidden_mname").val();

		var data = {
			 "mbid1"	: mbid1
			,"mbid2"	: mbid2
			,"mname"	: mname
			,"sdate"	: sdate
			,"edate"	: edate
		}

		$.ajax({
			 method : "POST"
			,url : "T_tree_vt_V10_UD_PUR1_AJAX.asp"
			,async: true
			,data : data
			,success: function(xhrData) {
				$("#PURCHASE1").html(xhrData);

			}
			,error:function(xhrData) {
				alert("<%=LNG_CS_CART_AJAX_ALERT05%>");
			}
		});


	}

</script>