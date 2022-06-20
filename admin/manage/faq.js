// FAQ 기본설정 입력 S
	$(document).ready(function() {
		$("button.configDataModify").click(function(event) {
			event.preventDefault();
			var upDom = $(this).closest("tr");

			var intIDX			= upDom.find("input[name=intIDX]");
			var strGroup		= upDom.find("input[name=strGroup]");
			var	strCateCode		= upDom.find("input[name=strCateCode]");
			var	isUse			= upDom.find("select[name=isUse]");
			var	mainVar			= upDom.find("input[name=mainVar]");
			var	SubVar			= upDom.find("input[name=SubVar]");
			var	sViewVar		= upDom.find("input[name=sViewVar]");
			var	ORI_strGroup	= upDom.find("input[name=ORI_strGroup]");
			var	intViewLevel	= upDom.find("select[name=intViewLevel]");

			if (intIDX.val() ==''){alert('값이 올바르지 않습니다.'); return false;}
			if (strGroup.val() ==''){alert('그룹명이 올바르지 않습니다.'); strGroup.focus(); return false;}
			if (strCateCode.val() ==''){alert('출력위치가 올바르지 않습니다.'); strCateCode.focus(); return false;}

			var modFrm = $("form[name=modFrm");
			$(modFrm).find("input[name=MODE]").val('MODIFY');
			$(modFrm).find("input[name=intIDX]").val(intIDX.val());
			$(modFrm).find("input[name=strGroup]").val(strGroup.val());
			$(modFrm).find("input[name=strCateCode]").val(strCateCode.val());
			$(modFrm).find("input[name=isUse]").val(isUse.val());
			$(modFrm).find("input[name=mainVar]").val(mainVar.val());
			$(modFrm).find("input[name=SubVar]").val(SubVar.val());
			$(modFrm).find("input[name=sViewVar]").val(sViewVar.val());
			$(modFrm).find("input[name=ORI_strGroup]").val(ORI_strGroup.val());
			$(modFrm).find("input[name=intViewLevel]").val(intViewLevel.val());

			modFrm.submit();
		});
		$("button.configDataDelete").click(function(event) {
			event.preventDefault();

			var upDom = $(this).closest("tr");
			var intIDX		= upDom.find("input[name=intIDX]");
			var strGroup	= upDom.find("input[name=strGroup]");

			if (intIDX.val() ==''){alert('값이 올바르지 않습니다.'); return false;}

			var modFrm = $("form[name=modFrm");
			$(modFrm).find("input[name=MODE]").val('DELETE');
			$(modFrm).find("input[name=strGroup]").val(strGroup.val());
			$(modFrm).find("input[name=intIDX]").val(intIDX.val());

			modFrm.submit();
		});


		$("select.cate_sel_type").change(function(event) {
			event.preventDefault();
			$("form[name=selectFrm]").submit();

		});

		$(".faq_list div").addClass("hide");
		$(".faq_list h3").click(function(){
			if ($(this).next("div").hasClass("hide"))
			{
				$(this).next("div").removeClass("hide")
				.siblings("div").addClass("hide");
			} else {
				$(this).next("div").addClass("hide")
				.siblings("div").addClass("hide");
			}

		});


	});


	function chkRegConfig(f) {

		if (f.strGroup.value == ""){
			alert("FAQ 그룹을 입력해주세요.");
			f.strTitle.focus();
			return false;
		}

		if (f.strCateCode.value == ""){
			alert("FAQ 출력위치를 입력해주세요.");
			f.strCateCode.focus();
			return false;
		}
	}
// FAQ 기본설정 입력 E


// 카테고리 등록 체크
	function ChkCateIns(f) {

		if (f.strTitle.value == ""){
			alert("카테고리명을 입력해주세요.");
			f.strTitle.focus();
			return false;
		}
	}

// 카테고리 보임/숨김 설정
	function chgViewTF(nowViewStat,idx) {
		var f = document.modFrm;
		f.MODE.value = 'VIEWCHG';
		f.intIDX.value = idx;
		f.values.value = nowViewStat;
		f.submit();
	}
// 카테고리 업/다운
	function sortUp(nums,idx) {

		if (nums < 1 ) {
			alert("더 이상 올릴 수 없습니다")
		} else {
			var f = document.modFrm;
			f.MODE.value = 'SORTUP';
			f.intIDX.value = idx;
			f.submit();
		}
	}
	function sortDown(nums,idx,maxnums) {

		if (nums >= maxnums ) {
			alert("더 이상 내릴 수 없습니다")
		} else {
			var f = document.modFrm;
			f.MODE.value = 'SORTDOWN';
			f.intIDX.value = idx;
			f.submit();
		}
	}
// 카테고리 삭제
	function cateDelete(idx) {
		var f = document.modFrm;
		var msg = "삭제하시겠습니까? \n\n카테고리 삭제 시 해당 카테고리로 등록된 FAQ 가 모두 삭제처리됩니다.";

		if(confirm(msg)){
			f.MODE.value = 'DELETE';
			f.intIDX.value = idx;
			f.submit();
		}

	}
// 카테고리 수정
	function cateModify(idx,inputName) {
		var f = document.modFrm;
		var inputValue = document.getElementById(inputName);

		f.MODE.value = 'MODIFY';
		f.intIDX.value = idx;
		f.values.value = inputValue.value;
		f.submit();


	}



// 입력
	function chkSubmitFaq(f) {
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);

		if(chkEmpty(f.intCate)) {
			alert("카테고리를 선택해주세요.");
			f.intCate.focus();
			return false;
		}

		if(chkEmpty(f.strSubject)) {
			alert("질문을 입력해주세요.");
			f.strSubject.focus();
			return false;
		}
		if(chkEmpty(f.strContent)) {
			alert("내용을 입력해주세요.");
			oEditors[0].exec("FOCUS", []);
			return false;
		}

		if (checkDataImages(f.strContent.value)) {
			alert("문자형이미지(드래그 이미지)는 사용할 수 없습니다.");
			return false;
		}

		if(confirm("저장하시겠습니까?")){
			return true;
		 }else{
			return false;
		 }



	}


// FAQ 삭제
	function faqDelete(idx) {
		var f = document.modFrm;
		var msg = "삭제하시겠습니까?";

		if(confirm(msg)){
			f.MODE.value = 'DELETE';
			f.intIDX.value = idx;
			f.submit();
		}

	}