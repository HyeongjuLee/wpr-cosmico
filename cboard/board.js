/* 회원 - 메모 */
function openScrap(idv) {
	openPopup("board_scrap.asp?idv="+idv, "scrap", 100, 100, "left=200, top=200");
}
function openAlert(idv) {
	openPopup("board_alert.asp?idv="+idv, "alert", 100, 100, "left=200, top=200");
}
function openVote(idv) {
	openPopup("board_vote.asp?idv="+idv, "vote", 100, 100, "left=200, top=200");
}

function rreplyView(f_menu)
{
	if (document.getElementById(f_menu).style.display == "block"){
		document.getElementById(f_menu).style.display = "none";
	}else{
		$("div[name^='replysT").css("display","none");
		document.getElementById(f_menu).style.display = "block";
	}
 }

function reInArea_View(f_menu)
{
	if (document.getElementById(f_menu).style.display == ""){
		document.getElementById(f_menu).style.display = "none";
	}else{
		$("td[name^='reInArea").css("display","none");
		document.getElementById(f_menu).style.display = "";
	}
 }

function viewMiniMemo(id,idx,e)
{
    obj = document.getElementById(id);//레이어 오브젝트
    st = (document.documentElement.scrollTop + document.body.scrollTop); //문서의 세로 스크롤바 위치
    sl = (document.documentElement.scrollLeft + document.body.scrollLeft); //문서의 가로 스크롤바 위치

    ex=e.clientX+sl; //가로좌표
    ey=e.clientY+st; //세로좌표

//	alert(ex);
//	alert(ey);

	createRequest();
	var url = 'memInfo.asp?idx='+idx;

	request.open("GET",url,true);
	request.onreadystatechange = function ChgContent() {
		if(request.readyState == 4){    // 요청응답상태가 4인지 확인해주고
			if(request.status == 200){     // HTTP상태가 완료인지 체크해줍니다.
				var newContent = request.responseText;
				document.getElementById(id).innerHTML = newContent;
		}
	  }
	}
	request.send(null);


    obj.style.left = ex+'px'; //레이어 가로위치 수정
    obj.style.top =  ey+'px'; //레이어 세로위치 수정
    obj.style.visibility = "visible";


}
function viewPass(id,idx,bnames,e)
{
    obj = document.getElementById(id);//레이어 오브젝트
    st = (document.documentElement.scrollTop + document.body.scrollTop); //문서의 세로 스크롤바 위치
    sl = (document.documentElement.scrollLeft + document.body.scrollLeft); //문서의 가로 스크롤바 위치

	ex=e.clientX+sl; //가로좌표
    ey=e.clientY+st; //세로좌표

//	alert(ex);
//	alert(ey);

    obj.style.left = ex+'px'; //레이어 가로위치 수정
    obj.style.top =  ey+'px'; //레이어 세로위치 수정
    obj.style.visibility = "visible";

	var f = document.vfrm;
	f.action = 'board_view.asp?bname='+bnames+'&num='+idx;

}

	function idBlock(idx) {
		var f = document.memInfo;

		var msg = "해당 아이디를 차단(로그인금지처리)하시겠습니까? \n\n복구는 관리자페이지 회원관리에서 하셔야합니다.";

		 if(confirm(msg)){
			f.idx.value = idx;
			f.MODE.value = 'BLOCKID';
			f.target = 'hiddenFrame';
			f.submit();
		 } else {
			f.idx.value = '';
			f.MODE.value = '';
			f.target = '';

		 }

	}

	function ipBlock(idx) {
		var f = document.memInfo;

		var msg = "해당 아이피를 차단하시겠습니까? \n\n복구는 관리자페이지 회원관리에서 하셔야합니다.";

		 if(confirm(msg)){
			f.idx.value = idx;
			f.MODE.value = 'BLOCKIP';
			f.target = 'hiddenFrame';
			f.submit();
		 } else {
			f.idx.value = '';
			f.MODE.value = '';
			f.target = '';

		 }

	}

	function chkMoveFrm(f) {

		var i,len;
		var selCnt = 0;



		if (typeof f.mchk.length == "undefined") {
			if (f.mchk.checked) ++selCnt;
		}
		else {
			for (i=0, len=f.mchk.length; i<len; i++) {
				if (f.mchk[i].checked) ++selCnt;
			}
		}

		if (selCnt == 0) {
			alert("이동하실 게시물을 선택해 주세요.");
			return false;
		}



		openPopup("/hiddens.asp", "MoveContent", 100, 100, "left=200, top=200");

		f.target = "MoveContent";
		f.submit();
	}



	function SelectAlls() {
		var f = document.moveFrm;
		if (f.checklist.checked) {
			f.checklist.checked = false;
		} else {
			f.checklist.checked = true;
		}
		SelectAll();
	}


	function SelectAll(){
		var f = document.moveFrm;
		if(f.checklist.checked){
			if (typeof f.mchk.length == "undefined") {
				f.mchk.checked = true;
			}
			else {
				for (i=0, len=f.mchk.length; i<len; i++) {
					f.mchk[i].checked = true;
				}
			}
		}
		else{
			if (typeof f.mchk.length == "undefined") {
				f.mchk.checked = false;
			}
			else {
				for (i=0, len=f.mchk.length; i<len; i++) {
					f.mchk[i].checked = false;
				}
			}
		}
	}

