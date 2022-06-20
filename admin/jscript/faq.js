	function faqs(f) {
		if(chkEmpty(f.mode)) {
			alert("등록상태가 정상적이지 않습니다.");
			f.mode.focus();
			return false;
		}


		if(chkEmpty(f.strSubject)) {
			alert("질문을 입력해주세요.");
			f.strSubject.focus();
			return false;
		}
		if(chkEmpty(f.strContent)) {
			alert("내용을 입력해주세요.");
			f.strContent.focus();
			return false;
		}


		if(confirm("저장하시겠습니까?")){
			return true;
		 }else{
			return false;
		 }



	}
