<!--

function viewInDiv(lineNum,className,orderIDX) {
	$(".inDiv"+lineNum).css({"display":"none"});
	$("."+className+lineNum).css({"display":"block"});
	if (className == 'DivGoods')
	{
		chg_GoodsInfo("tbody"+lineNum,orderIDX,lineNum);
	}

}
function hiddInDiv(lineNum) {
	$(".inDiv"+lineNum).css({"display":"none"});
}



function loadings() {
	var loadingBar = $("#loadingPro");
	var loadProg = $("#loadProg");
	var dHeight = $(document).height();
	var wHeight = $(window).height();
	var sHeight = $(document).scrollTop();
	//alert(sHeight);
	loadingBar.css("height",dHeight+"px");
	loadProg.css({"top":wHeight/2+sHeight-150+"px","left":"50%","margin-left":"-80px"});
	loadingBar.toggle();
}

function chg_GoodsInfo(tBodyID,orderIDX,lineNum) {
	loadings();

	$.ajax({
		type: "POST"
		,url: "order_list_goods_ajax.asp"
		,data: {
			 "orderIDX"		: orderIDX
			,"tBodyID"		: tBodyID
			,"Ri"			: lineNum
		}
		//,contentType: "application/json; charset=utf-8"
		,success: function(data) {
			$("#"+tBodyID).html(data);
			loadings();

			//alert($("."+DivGoods).parent().tagName);


		}
		,error:function(data) {
			alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
		}
	});

}



function thisfrm(f) {
	if (f.dtod.disabled == true || f.dtodDate.disabled == true || f.dtodnum.disabled == true)
	{
		alert("배송정보를 입력할 수 없습니다.\n배송중비중인 상품이 아닙니다...");
		return false;
	} else {
		if (f.dtod.value == "date")
			{
				if (f.dtodDate.value=="")
				{
					alert("배송일자만 입력하실 때는 배송일자를 반드시 입력해야합니다.\n입력형식은 2010-10-20 형식으로 입력하셔야 합니다...");
					f.dtodDate.focus();
					return false;
				}
			} else {
				if (f.dtod.value=="")
				{
					alert("배송업체를 선택해주세요...");
					f.dtod.focus();
					return false;

				}
				if (f.dtodnum.value=="")
				{
					alert("배송정보를 기입해주세요...");
					f.dtodnum.focus();
					return false;

				}

			}
	}
	var tBodyID = f.tBodyID.value;
	var uptBodyID = f.uptBodyID.value;
	var orderIDX = f.orderIDX.value;
	var Ri = f.Ri.value;
	var DtoD_Date = f.dtodDate.value;
	var DtoD_Com = f.dtod.value;
	var DtoD_Num = f.dtodnum.value;
	var ChgIDX = f.ChgIDX.value;

	if (confirm("해당 물품의 배송장을 등록하시겠습니까? \n\n동일판매자의 물건의 모든 배송장이 등록됩니다...")) {
		loadings();
		$.ajax({
			type: "POST"
			,url: "order_list_ajax_chg_Delivery.asp"
			,data: {
				 "intIDX"		: orderIDX
				,"DtoD_Date"	: DtoD_Date
				,"DtoD_Com"		: DtoD_Com
				,"DtoD_Num"		: DtoD_Num
				,"ChgIDX"		: ChgIDX			}
			//,async : false
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				//alert("dd");
				if (data == 'THIS')
				{
					alert("배송정보가 등록되었습니다");
					viewInDiv(Ri,'DivGoods',orderIDX);

				} else {
					$("#"+uptBodyID).html(data);
					alert("배송정보가 등록되었습니다.\n\n해당 주문번호에 해당하는 모든 주문의 배송정보가 입력되었습니다\n\n진행상태를 변경해주세요...");

				}
				loadings();
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				loadings();
			}
		});
	}
	return false;

}

function goCancelBtn(uidx) {

	openPopup("chgCancel.asp?idv="+uidx, "chgCancel", 100, 100, "left=200, top=200");

}


function goCancelUBtn(uidx,tBodyID,Ri) {
	if (confirm("해당 물품(그룹)을 '취소완료' 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 물품(그룹)을 '취소완료' 상태로 변경합니다...")) {
		loadings();
		$.ajax({	
			type: "POST"
			,url: "order_list_ajax_chg_UCancel.asp"
			,data: {
				 "intIDX"		: uidx,
				 "Ri"			: Ri
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				if (data == 'MISS')
				{
					viewInDiv(Ri,'DivGoods',uidx);
					alert("상품 중 배송정보가 없는 상품이 존재합니다.");

				} else {
					$("#"+tBodyID).html(data);
					alert("상태정보가 변경되었습니다.");
					
				}
								loadings();

			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				loadings();
			}
		});
	}
}

function go101Btn(uidx,tBodyID,Ri) {
	if (confirm("해당 물품(그룹)을 '결제완료' 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 물품(그룹)을 '결제완료' 상태로 변경합니다...")) {
		loadings();
		$.ajax({
			type: "POST"
			,url: "order_list_ajax_chg_101_MACCO.asp"		////// 직판 /////
			,data: {
				 "intIDX"		: uidx,
				 "Ri"			: Ri
			}
			//,contentType: "application/json; charset=utf-8"
			/* 수정전
			,success: function(data) {
					$("#"+tBodyID).html(data);
					alert("상태정보가 변경되었습니다.");
				loadings();
			}
			*/

			,success: function(data) {

					//alert(data);
					s = data.split("&&&&&&");
					switch (s[0])
					{
					case "Y","D" :
						alert(s[1]);
						alert("상태정보가 변경되었습니다.");
						break;
					case "N" :
						alert(s[1]);
						break;
					case "Z" :
						alert("상태정보가 변경되었습니다.");
						break;
					}

					$("#"+tBodyID).html(s[2]);

				loadings();
			}

			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				loadings();
			}
		});
	}
}
function go102Btn(uidx,tBodyID,Ri) {
	if (confirm("해당 물품(그룹)을 '배송완료(배송중)' 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 물품(그룹)을 '배송완료(배송중)' 상태로 변경합니다...")) {
		loadings();
		$.ajax({
			type: "POST"
			,url: "order_list_ajax_chg_102.asp"
			,data: {
				 "intIDX"		: uidx,
				 "Ri"			: Ri
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				if (data == 'MISS')
				{
					viewInDiv(Ri,'DivGoods',uidx);
					alert("상품 중 배송정보가 없는 상품이 존재합니다.");

				} else {
					$("#"+tBodyID).html(data);
					alert("상태정보가 변경되었습니다.");

				}
					loadings();

			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				loadings();
			}
		});
	}
}
function go103Btn(uidx,tBodyID,Ri) {
	if (confirm("해당 물품(그룹)을 '수취확인 (거래완료)' 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 물품(그룹)을 '수취확인 (거래완료)' 상태로 변경합니다...")) {
		loadings();
		$.ajax({
			type: "POST"
			,url: "order_list_ajax_chg_103.asp"
			,data: {
				 "intIDX"		: uidx,
				 "Ri"			: Ri
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				//alert("dd");
				$("#"+tBodyID).html(data);
				alert("상태정보가 변경되었습니다.");
				loadings();

			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				loadings();
			}
		});
	}
}

function back100Btn(uidx,tBodyID,Ri) {
	if (confirm("해당 물품(그룹)을 '입금확인전' 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 물품(그룹)을 '배송준비중' 상태로 변경합니다...")) {
		loadings();
		$.ajax({
			type: "POST"
			,url: "order_list_ajax_chg_100b.asp"
			,data: {
				 "intIDX"		: uidx,
				 "Ri"			: Ri
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				//alert("dd");
				$("#"+tBodyID).html(data);
				alert("상태정보가 변경되었습니다.");

				loadings();
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				loadings();
			}
		});
	}
}


function back101Btn(uidx,tBodyID,Ri) {
	if (confirm("해당 물품(그룹)을 '배송준비중(입금확인)' 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 물품(그룹)을 '배송준비중' 상태로 변경합니다...")) {
		loadings();
		$.ajax({
			type: "POST"
			,url: "order_list_ajax_chg_101b.asp"
			,data: {
				 "intIDX"		: uidx,
				 "Ri"			: Ri
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				//alert("dd");
				$("#"+tBodyID).html(data);
				alert("상태정보가 변경되었습니다.");
				loadings();
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				loadings();
			}
		});
	}
}
function back102Btn(uidx,tBodyID,Ri) {
	if (confirm("해당 물품(그룹)을 '배송완료(배송중)' 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 물품(그룹)을 '배송완료(배송중)' 상태로 변경합니다...")) {
		loadings();
		$.ajax({
			type: "POST"
			,url: "order_list_ajax_chg_102b.asp"
			,data: {
				 "intIDX"		: uidx,
				 "Ri"			: Ri
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				//alert("dd");
				$("#"+tBodyID).html(data);
				alert("상태정보가 변경되었습니다.");
				loadings();
			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				loadings();
			}
		});
	}
}




//관리자주문취소 → 입금확인 전 상태로 변경
function backc100Btn(uidx,tBodyID,Ri) {
	if (confirm("해당 주문취소건을 신규주문상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 주문은 신규주문(입금확인전)상태로 변경합니다...")) {
		loadings();
		$.ajax({
			type: "POST"
			,url: "order_list_ajax_chg_100b_Cancel.asp"
			,data: {
				 "intIDX"		: uidx,
				 "Ri"			: Ri
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				//alert();
				$("#"+tBodyID).html(data);
				alert("상태정보가 변경되었습니다.");
				loadings();

			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				loadings();
			}
		});
	}
}
//관리자주문취소 → 입금확인  상태로 변경
function backc101Btn(uidx,tBodyID,Ri) {
	if (confirm("해당 주문취소건을 입금확인 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 주문을 입금확인(배송준비중)상태로 변경합니다...")) {
		loadings();
		$.ajax({
			type: "POST"
			,url: "order_list_ajax_chg_101b_Cancel.asp"
			,data: {
				 "intIDX"		: uidx,
				 "Ri"			: Ri
			}
			//,contentType: "application/json; charset=utf-8"
			,success: function(data) {
				//alert();
				$("#"+tBodyID).html(data);
				alert("상태정보가 변경되었습니다.");
				loadings();

			}
			,error:function(data) {
				alert("ajax 처리 중 에러가 발생하였습니다.ERROR CODE : "+data.status+" "+data.statusText+" "+data.responseText);
				loadings();
			}
		});
	}
}




//goBackCancel104
function backc102Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문취소건을 배송완료 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 주문을 배송완료(배송중)상태로 변경합니다...")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=backc102';
		f.submit();

	}
}

/*
function goCancelBtn(uidx) {

	openPopup("chgCancel.asp?idv="+uidx, "chgCancel", 100, 100, "left=200, top=200");

}
function goCancelUBtn(uidx) {

	openPopup("chgUCancel.asp?idv="+uidx, "chgCancel", 100, 100, "left=200, top=200");

}

function go101Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문에 대해서 입금을 확인하셨습니까?? \n\n확인을 누르시면 해당 주문을 입금확인(배송준비중)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=go101';
		f.submit();

	}
}

function go102Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문에 대해서 배송을 하셨습니까? \n\n확인을 누르시면 해당 주문을 배송완료(거래완료)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=go102';
		f.submit();

	}
}
function go103Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문에 대해서 거래완료상태로 변경하시겠습니까?")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=go103';
		f.submit();

	}
}


function goCancelBtn(uidx) {

	openPopup("chgCancel.asp?idv="+uidx, "chgCancel", 100, 100, "left=200, top=200");

}

function back100Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문을 신규주문(입금확인전) 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 주문을 신규주문(입금확인전) 상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=back100';
		f.submit();

	}
}
function back101Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문을 입금확인 상태로 롤백하시겠습니까? \n\n확인을 누르시면 해당 주문을 입금확인(배송준비중)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=back101';
		f.submit();

	}
}


function back102Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문을 배송완료 상태로 롤백 하시겠습니까? \n\n확인을 누르시면 해당 주문을 배송완료(배송중)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=back102';
		f.submit();

	}
}



function backc100Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문취소건을 신규주문상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 주문은 신규주문(입금확인전)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=backc100';
		f.submit();

	}
}
function backc101Btn(uidx) {
	var f = document.chgFrm;

	if (confirm("해당 주문취소건을 입금확인 상태로 변경하시겠습니까? \n\n확인을 누르시면 해당 주문을 입금확인(배송준비중)상태로 변경합니다.")) {
		f.intIDX.value = uidx;
		f.target = 'hidden';
		f.action='orderStatusHandler.asp?mode=backc101';
		f.submit();

	}
}
*/



//-->
