  function chgCate1s() {
	var cate1value = $('#cate1').val();
	var dropdownSet = $('#cate2');
	if (cate1value.length == 0) {
	  dropdownSet.attr("disabled",true);
	  dropdownSet.emptySelect();
	}
	else {
	  dropdownSet.attr("disabled",false);
	  $.getJSON(
		'getcate.asp?mode=category2',
		{style:cate1value},
		function(data){
		  dropdownSet.loadSelect(data);
		  $("#cate2 option[value='<%=CATEGORYS2%>']").attr("selected","selected");
		}

	  );

	}
  }


function checkOptionKind(vies) {
	var f = document.w_form;

		if (vies == "T") {
			document.getElementById("optionDispT").style.display = "";
		}
		else {
			document.getElementById("optionDispT").style.display = "none";
		}
	}
function openCate(codes,method) {
	openPopup("popCate.asp?code="+codes+"&method="+method, "Zipcode", 100, 100, "left=200, top=200");
}

function modCate(f) {
	if (f.strCateName.value == '')
	{
		alert("카테고리명이 없습니다.");
		return false;
	}
	f.action = 'Cate_Modify.asp';
	f.submit();
}

function cateIn(f) {
	if (f.CateName.value == '')
	{
		alert("카테고리명이 없습니다.");
		f.CateName.focus();
		return false;
	}
}

function delok(uidx){
	var f = document.delFrm;

	if (confirm("카테고리를 삭제하시겠습니까? \n\n\※ 하위 카테고리도 모두 삭제되게 됩니다.※\n\n\※ 해당 카테고리에 있는 모든 상품은 삭제된 상품리스트로 이동되게 됩니다※")) {
		f.intIDX.value = uidx;
		f.submit();

	}
}
function sortUp(uidx){
	var f = document.sortFrm;

		f.mode.value = 'up';
		f.intIDX.value = uidx;
		f.submit();

	}


function sortDown(uidx){
	var f = document.sortFrm;

		f.mode.value = 'down';
		f.intIDX.value = uidx;
		f.submit();

	}
