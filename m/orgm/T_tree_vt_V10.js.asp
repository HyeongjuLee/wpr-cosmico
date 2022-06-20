<script type="text/javascript">

	$(document).ready(function() {
		$("#cCenter").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cCenter]");
			if (check1)	{ $(".view01").css({"display":"block"}); thisInput.val('1'); } else { $(".view01").css({"display":"none"}); thisInput.val(''); }
		});

		$("#cNomInfo").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cNomInfo]");
			if (check1)	{ $(".view02").css({"display":"block"}); thisInput.val('1'); } else { $(".view02").css({"display":"none"}); thisInput.val(''); }
		});

		$("#cPeriodPV").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cPeriodPV]");
			if (check1)	{ $(".view03").css({"display":"block"}); thisInput.val('1'); } else { $(".view03").css({"display":"none"}); thisInput.val(''); }
		});
		$("#cGrade").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cGrade]");
			if (check1)	{ $(".view04").css({"display":"block"}); thisInput.val('1'); } else { $(".view04").css({"display":"none"}); thisInput.val(''); }
		});
		$("#cShopURL").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cShopURL]");
			if (check1)	{ $(".view05").css({"display":"block"}); thisInput.val('1'); } else { $(".view05").css({"display":"none"}); thisInput.val(''); }
		});
		$("#cPeriodUnderPV").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cPeriodUnderPV]");
			if (check1)	{ $(".view06").css({"display":"block"}); thisInput.val('1'); } else { $(".view06").css({"display":"none"}); thisInput.val(''); }
		});

		$("#cReqTF2").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cReqTF2]");
			if (check1)	{ $(".view07").css({"display":"block"}); thisInput.val('1'); } else { $(".view07").css({"display":"none"}); thisInput.val(''); }
		});
		$("#cDirCustomerPV").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cDirCustomerPV]");
			if (check1)	{ $(".view08").css({"display":"block"}); thisInput.val('1'); } else { $(".view08").css({"display":"none"}); thisInput.val(''); }
		});
		$("#cAllCustomerPV").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cAllCustomerPV]");
			if (check1)	{ $(".view09").css({"display":"block"}); thisInput.val('1'); } else { $(".view09").css({"display":"none"}); thisInput.val(''); }
		});
		$("#cOverAllPV").click(function() {
			var check1 = $(this).is(":checked");
			var thisInput = $("form[name=sfrm] input[name=cOverAllPV]");
			if (check1)	{ $(".view10").css({"display":"block"}); thisInput.val('1'); } else { $(".view10").css({"display":"none"}); thisInput.val(''); }
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
		/*$("#cZoom").change(function(event) {
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
					//alert("10% �̸����� ���� �� �����ϴ�.");
					alert("<%=LNG_TEXT_CANNOT_REDUCED_LESS_10%>");
					break;
				default :
					//alert("�ùٸ� ���� �ƴմϴ�. ���ΰ�ħ ���ּ���");
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
					//alert("100% �̻����� �ø� �� �����ϴ�");
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
					//alert("�ùٸ� ���� �ƴմϴ�. ���ΰ�ħ ���ּ���");
					alert("<%=LNG_TEXT_NOT_A_VALID_VALUE%>\n<%=LNG_STRTEXT_TEXT02%>");
					break;
			}
		});


		$("#search_period").ready(function(){
			var T_Display = $("#search_period").css("display");
			//alert(T_Display);
			if (T_Display == "block") {
				//$("#etcBtn").text("��ɴݱ�");
				$("#etcBtn").text("<%=LNG_TEXT_FUNCTION_CLOSE%>");
			} else {
				//$("#etcBtn").text("��ɿ���");
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
			var url			= $(this).closest("p").find("input[name=mi_url]").val();
			var Grade_Name	= $(this).closest("p").find("input[name=mi_Grade_Name]").val();
			var webID		= $(this).closest("p").find("input[name=mi_webID]").val();

			fnMemberInfo(mbid1,mbid2,mname,regTime,center,vname,vid,meap,url,Grade_Name,webID);
		});

/*
	//	$("#chart .jOrgChart>table").css({"zoom":"0.2"});
	//	$("#chart .node-cell div").css({"display":"none"});
		$("#chart p").text("");
		$("#chart a").text("");
		$("#chart .node-cell div").text("");
	//	$("#chart .node-cell div").css({"height":"160px","width":"160px"});
		var hheight = $(".jOrgChart").height() / 100 * 20;
		var wwwidth = $(".jOrgChart").width() / 100 * 20;
		console.log(hheight);
		console.log(wwwidth);
		$("body").css({"width":$(".jOrgChart").width()+"px"});
		$(".jOrgChart > table").css({"width":$(".jOrgChart").width()+"px"});

		//console.log(ofs);
*/



	});

	function sFrmSubmit(sid1,sid2){
		var f = document.sfrm;
		f.sid1.value = sid1;
		f.sid2.value = sid2;
		f.submit();
	}


	function fnCheckSearch() {
		$("#search_period").toggle();
		var T_Display = $("#search_period").css("display");
		//alert(T_Display);
		if (T_Display == "block") {
			//$("#etcBtn").text("��ɴݱ�");
			$("#etcBtn").text("<%=LNG_TEXT_FUNCTION_CLOSE%>");
		} else {
			//$("#etcBtn").text("��ɿ���");
			$("#etcBtn").text("<%=LNG_TEXT_FUNCTION_OPEN%>");
		}
	}

	//vt �߰�!!
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
					tree_favorite(mbid,'DEL_LIST')		//����Ʈ ���� �߰�
					return false;
				} else {
					alert(jsonData.resultMsg);
					return false;
				}
			}
			,error:function(data) {
				//alert("������ ���� �� ������ �߻��߽��ϴ�.");
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
					////alert(jsonData.resultMsg);			//����
					//location.reload();
					if (mode == 'ADD') {
						alert(jsonData.resultMsg);			//�߰�
						$(".node-cell .fa"+mbid).addClass("ofv").removeClass("nfv").attr("href","javascript:tree_favorite(\'"+mbid+"',\'DEL\')");
					} else if (mode == 'DEL') {
						alert(jsonData.resultMsg);			//�߰�
						$(".node-cell .fa"+mbid).addClass("nfv").removeClass("ofv").attr("href","javascript:tree_favorite(\'"+mbid+"',\'ADD\')");
					//�߰�(����Ʈ���� ���� �� ������ ��  ���ã��ǥ�� ����
					} else if (mode == 'DEL_LIST' ) {
						//alert(jsonData.resultMsg);		//�̹� �����Ǿ��ų� ���ã�� ���� ���� ȸ���Դϴ�. �˸� ����!!
						$(".node-cell .fa"+mbid).addClass("nfv").removeClass("ofv").attr("href","javascript:tree_favorite(\'"+mbid+"',\'ADD\')");
					}
					return false;
				} else {
					alert(jsonData.resultMsg);
					return false;
				}
			}
			,error:function(data) {
				//alert("������ ���� �� ������ �߻��߽��ϴ�.");
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
						//innerHtml += '<td><a href="javascript:sFrmSubmit(\''+jsonData.FaData[i].Fa_mbid1+'\',\''+jsonData.FaData[i].Fa_mbid2+'\');"><%=LNG_TEXT_SELECT%></a></td>'
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
					//innerHtml += '<td colspan=\'4\' class=\'notData\'>�ش��̸����� �˻��� ���� ȸ���� �����ϴ�</td>';
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
				//alert("������ ���� �� ������ �߻��߽��ϴ�.");
				alert("<%=LNG_CS_CART_AJAX_ALERT05%>");
			}
		});
	}
	function fnMemberInfo(mbid1,mbid2,mname,regTime,center,vname,vid,meap,url,Grade_Name, webID) {
		$("#ModalScrollable3").modal('show');
		//$("#ModalScrollableTitle3").text(mname+' ���� ��Ÿ����');
		$("#ModalScrollableTitle3").text("<%=LNG_TEXT_MEMBER_OTHER_INFOS%> : "+mname);

		$("#hidden_mbid1").val(mbid1);
		$("#hidden_mbid2").val(mbid2);
		$("#hidden_mname").val(mname);
		$("#hidden_regTime").val(regTime);
		$("#hidden_center").val(center);
		$("#hidden_vname").val(vname);
		$("#hidden_vid").val(vid);
		$("#hidden_meap").val(meap);
		$("#hidden_url").val(url);
		$("#hidden_webID").val(webID);
		$("#hidden_Grade_Name").val(Grade_Name);		//�߰�


		$("td.view_mbid1").text($("#hidden_mbid1").val() + '-'+ $("#hidden_mbid2").val());
		$("td.view_mname").text($("#hidden_mname").val());
		$("td.view_regTime").text($("#hidden_regTime").val());
		$("td.view_center").text($("#hidden_center").val());
		$("td.view_meap").text($("#hidden_meap").val());
		$("td.view_vname").text($("#hidden_vname").val());
		$("td.view_vid").text($("#hidden_vid").val());
		$("td.view_webID").text($("#hidden_webID").val());
		$("td.view_Grade_Name").text($("#hidden_Grade_Name").val());		//�߰�

		fnMemberInfo1();
		//fnMemberInfo2();



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

	function fnMemberInfo2() {
		var loading1 = '<div class="width100 purloading1" id="purloading2"><p><img src="/images_kr/159.gif" alt="" /></p><p style="margin-top:10px;"><%=LNG_TEXT_DATA_LOADING%></p></div>';
		$("#PURCHASE2").html(loading1);

		var sdate = $("#SDATE2").val();
		var mbid1 = $("#hidden_mbid1").val();
		var mbid2 = $("#hidden_mbid2").val();
		var mname = $("#hidden_mname").val();
		//return false;
		var data = {
			 "mbid1"	: mbid1
			,"mbid2"	: mbid2
			,"mname"	: mname
			,"sdate"	: sdate
		}

		$.ajax({
			 method : "POST"
			,url : "T_tree_vt_V10_UD_PUR2_AJAX.asp"
			,async: true
			,data : data
			,success: function(xhrData) {
				$("#PURCHASE2").html(xhrData);

			}
			,error:function(xhrData) {
				alert("<%=LNG_CS_CART_AJAX_ALERT05%>");
			}
		});


	}

</script>