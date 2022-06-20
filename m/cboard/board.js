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

function rreplychk(f)
{
	if (f.strContent.value=='')
	{
		alert("내용이 비어있습니다.");
		f.strContent.focus();
		return false;
	}
}

function ChkvFrm(f) {
	if (f.strPass.value=='')
	{
		alert("작성시 입력한 암호를 입력해주세요");
		f.strPass.focus();
		return false;
	}
}

function secretSubmit()
{
	//alert('dd');

	var f = document.sfrm;
	var bname = f.bname.value;
	var ty = f.ty.value;
	var idx = f.idx.value;
	//alert(bname);
	//alert(ty);
	//alert(idx);

	f.action = 'board_view.asp?bname='+bname+'&num='+idx+'&ty='+ty;
	f.submit();
//	alert(f.action.value);

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


	function pagegoto(PG,recordcnt)
	{
		document.frm.PAGE.value=PG;
		//document.frm.pagingCLICK.value="T";
		document.frm.submit();
	}

	function pagegotoMove(PG,recordcnt)
	{
		document.frm.PAGE.value=PG;
		document.frm.pagingCLICK.value="T";
		document.frm.submit();
	}


	function chgDomain(chgType) {
		var f = document.frm;
		f.PAGE.value = 1;
		f.qnaDomain.value = chgType;
		f.submit();

	}

/*
	function thisDeChk1() {
		var f = document.ifrm;

		if (f.firstChk.value == 'T')
		{
			f.firstChk.value = 'F';
			f.content1.value = "";
			f.content1.style.fontSize = "1em";
		}




	}

	 function frmCheck(form){
 		if(!chkNull(form.strName, "\'작성자\'를 입력해 주세요")) return false;
		if(!chkNull(form.strSubject, "\'제목\'을 입력해 주세요")) return false;
		if(!chkNull(form.strPass, "\'비밀번호\'를 입력해 주세요")) return false;
		if(!chkNull(form.content1, "\'내용\'을 입력해 주세요")) return false;
		var word = form.strName.value;

		var swear_words_arr = new Array("에듀킨"  ,"EDUKIN"  ,"애듀킨"  ,"admin"  ,"administrator"  ,"관리자"  ,"운영자"  ,"어드민"  ,"주인장"  ,"webmaster"  ,"웹마스터"  ,"sysop"  ,"시삽"  ,"시샵"  ,"manager"  ,"매니저"  ,"메니저"  ,"su"  ,"guest"  ,"게스트");
		orgword = word.toLowerCase();
		awdrgy = 0;
		while (awdrgy <= swear_words_arr.length - 1) {
			if (orgword.indexOf(swear_words_arr[awdrgy]) > -1) {
				alert(swear_words_arr[awdrgy] + "은(는) 사용할 수 없는 작성자명입니다.");
				form.strName.focus();
				return false;
			}
		awdrgy++;
		}

	}
*/
	function mfrmCheck(modes){
		var f = document.ifrm;
		f.mode.value = modes;


		if (f.mode.value =='basic')
		{
			alert("\'수정/삭제 시에는 수정/삭제하기 버튼\'을 클릭해 주세요");
			return false;
		}
		if(!chkNull(f.mode, "\'수정/삭제 시에는 수정/삭제하기 버튼\'을 클릭해 주세요")) return false;
		if(!chkNull(f.strPass, "\'비밀번호\'를 입력해 주세요")) return false;

		if (f.mode.value =='MODIFY')
		{
			var bname = f.strBoardName.value;
			var ty = f.ty.value;
			var idx = f.idx.value;

			f.action = 'board_modify.asp?bname='+bname+'&num='+idx+'&ty='+ty;

			f.submit();

		}
		if (f.mode.value =='DELETE')
		{
			var bname = f.strBoardName.value;
			var ty = f.ty.value;
			var idx = f.idx.value;

			f.action = 'boardHandler.asp';

			f.submit();

		}
	}

