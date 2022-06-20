$(document).ready(function(){
	$("ul > li:last-child > a").addClass("minusbottom").removeClass("minus");
	$("a.minusbottom").parent().addClass("uls");

	$("li:has(ul) > a.minus").addClass("plus").remove("minus");
	$("li:has(ul) > a.minusbottom").addClass("plusbottom").remove("minusbottom");

});

function nextChild(ids) {

	if ($("#"+ids).has("ul").length == true)
	{
		var cul = $("#"+ids+" > ul");
		var cfc = $("#"+ids+" > a:first-child")
		if (cul.css("display") == "none")
		{
			cul.css("display","block");
			if (cfc.hasClass("minus2")){cfc.removeClass("minus2");}
			if (cfc.hasClass("minusbottom2")){cfc.removeClass("minusbottom2");}
			if (cfc.hasClass("plus")){cfc.addClass("minus2");}
			if (cfc.hasClass("plusbottom")){cfc.addClass("minusbottom2");}

		}else{
			cul.css("display","none");
			cfc.removeClass("minus2 minusbottom2 plus2 plusbottom2")

		}
	}


}
function dateReset() {
	var f = document.chkBox;
	f.SDATE.value = "";
	f.EDATE.value = "";
}

function allToggleH() {
	$("#tree .onoff").css({"display":"none"});
	$("#tree a").removeClass("minus2 minusbottom2 plus2 plusbottom2");

	}


function allToggleB() {
	$("#tree .onoff").css({"display":"block"});
	$("#tree a").each(function(index) {
		if ($(this).hasClass("plus")){$(this).addClass("plus2 minus2");}
		if ($(this).hasClass("plusbottom")){$(this).addClass("plusbottom2 minusbottom2");}
		if ($(this).hasClass("minus")){$(this).addClass("minus2");}
		if ($(this).hasClass("minusbottom")){$(this).addClass("minusbottom2");}

	});

}

function aaa(){

	$("#leftMenu").slideUp("fast",function(){
		$("#treeview").css({"left":"0px"});
		$("#leftOn").css({"display":"inline-block"});
		$("#leftOff").css({"display":"none"});

	});

}

function bbb(){
	$("#leftMenu").slideDown("fast",function(){
		$("#treeview").css({"left":"320px"});
		$("#leftOn").css({"display":"none"});
		$("#leftOff").css({"display":"inline-block"});

	});
}

$(document).ready(function() {
	$("#searchName").keydown(function(evt) {
		if ((evt.keyCode) && (evt.keyCode == 13))
		{
			searchName();
		}
	});
});

function resetTxt() {
	$("span.mname").parent().removeClass("red tweight bgyellow");
	$("#prev_next").css("display","none");

	$("html,body").animate({scrollTop:0},300)
}
function searchName() {
	var sn = $("#searchName");
	var snv = sn.val();

	if (snv == '')
	{
		alert("찾으실 이름을 입력해주세요");
		sn.focus();
	}
	var dpnoneCnt = 0
	$("ul").css("display", function(index,value) {
		if (value == "none")
		{
			dpnoneCnt += 1;
		}
	});
	//alert(dpnoneCnt);
	if (dpnoneCnt > 0)
	{
		if (confirm("회원 검색시에는 \'그룹도 모두펼치기\'을 한 후에 하셔야합니다.\n\n지금 그룹도를 모두 펼치시겠습니까?"))
		{
			allToggleB();
		}
	} else {
		var span_mname_cont = $("span.mname:contains('"+snv+"')")
		//alert(span_mname_cont.length);
		if (span_mname_cont.length > 1)
		{
			$("#prev_next").css("display","");
		}
		else if (span_mname_cont.length == 0)
		{
			$("#prev_next").css("display","none");
			alert("검색된 회원이 없습니다.");
			return;
		} else {
			$("#prev_next").css("display","none");
		}

		$("span.mname").parent().removeClass("red tweight bgyellow");
		$("span.mname:contains('"+snv+"')").parent().addClass("red tweight bgyellow");
		var ts = $("span.mname:contains('"+snv+"')").eq(0).parent().parent().offset();
		//alert(ts);
		var moveTop = ts.top - 100;
		$("html,body").animate({scrollTop:moveTop},300);


	}

}

function nextTxt() {
	var sct = $("html").scrollTop() || $("body").scrollTop();
	var nowScrollTop = sct+100;
	//alert(nowScrollTop);

	$("span.bgyellow").each(function(){
		var ts = $(this).offset();
		var moveTop = ts.top;
		//alert(moveTop+"/"+nowScrollTop);
		if (moveTop > nowScrollTop)
		{
			$("html,body").animate({scrollTop:(moveTop - 100)},300);
			return false;
		}
	});


}


function prevTxt() {
	var sct = $("html").scrollTop() || $("body").scrollTop();
	var nowScrollTop = sct+100;
	$($("span.bgyellow").get().reverse()).each(function(){
		var ts = $(this).offset();
		var moveTop = ts.top;
		if (moveTop < nowScrollTop)
		{
			$("html,body").animate({scrollTop:(moveTop - 100)},300);
			return false;
		}
	});

}