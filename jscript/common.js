	function chkTopSearch(f) {
		if (f.searchs.value=="")
		{
			alert("검색어를 입력해주세요");
			f.searchs.focus();
			return false;
		}

	}
	function chkSearchs(f) {
		if (f.searchs.value=="")
		{
			alert("검색어를 입력해주세요");
			f.searchs.focus();
			return false;
		}

	}
	function popBranch() {
		//alert("등록 폼 변경 중입니다. 2011년 09월 16일 10시 30분에 변경된 폼으로 오픈됩니다.");
		openPopup('/page/branchJoin.asp', 'pop_Branch', 'top=100px,left=200px,width=720,height=700,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');
	}

	function popBranch(idx) {
		//alert("등록 폼 변경 중입니다. ");
		openPopup('/branch/branchView.asp?code='+idx, 'pop_Branch', 'top=100px,left=200px,width=810,height=700,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');
	}
	function popBranch2(idx) {
		//alert("등록 폼 변경 중입니다. ");
		openPopup('/branch/branch2View.asp?code='+idx, 'pop_Branch', 'top=100px,left=200px,width=810,height=700,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');
	}

	function popOpening() {
		//alert("등록 폼 변경 중입니다. 2011년 09월 16일 10시 30분에 변경된 폼으로 오픈됩니다.");
		openPopup('/shop/page/opening.asp', 'pop_Opening', 'top=100px,left=200px,width=620,height=700,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');
	}
	function openReviewWrite(idv) {
		openPopup('ReviewWrite.asp?idv='+idv, 'openReviewWrite', 'top=100px,left=200px,width=790,height=600,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');
	}
	function open2_reviews(idv) {
		openPopup("/shop2/popReview.asp?idv="+idv, "popReview", 'top=150px,left=150px,width=790,height=600,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');

	}
	function popLogin() {
		openPopup('/common/bak_member_login.asp', 'top_login', 'top=100px,left=200px,width=100,height=100,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=no');
	}
//사업자회원로그인 (CS-Webid/Password)
	function popLogin2() {
		openPopup('/common/member_login2.asp', 'top_login', 'top=100px,left=200px,width=100,height=100,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=no');
	}
	function popID() {
		openPopup('/common/member_idsearch.asp', 'top_login', 'top=100px,left=200px,width=100,height=100,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=no');
	}
	function popPWD() {
		openPopup('/common/pop_pwdsearch.asp?m=com', 'top_login', 'top=100px,left=200px,width=100,height=100,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=no');
	}
	function popIdea() {
		openPopup('/shop/page/idea.asp', 'idea', 'top=100px,left=200px,width=426,height=427,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=no');
	}
	/* 우클릭 방지 */
		document.oncontextmenu=Function("return false");
		document.ondragstart=Function("return false");
		document.onselectstart=Function("return false");


	function fTrans(files,transPath) {
		location.href = "/trans/trans.asp?filename="+encodeURIComponent(files)+"&path="+encodeURIComponent(transPath);
	}

	function pop_indexMore(type) {
		if (type == 'block')
		{
			openPopup('/pop_index_block.asp', 'pop_Block', 'top=100px,left=200px,width=600,height=500,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');
		} else if (type == 'ranking')
		{
			openPopup('/pop_index_ranking.asp', 'pop_Ranking', 'top=100px,left=200px,width=600,height=500,resizable=no,status=no,toolbar=no,menubar=no,scrollbars=yes');
		} else {
			alert('존재하지 않는 값');
		}

	}



	function onlyMember() {

		 var msg = "회원전용 기능입니다. 로그인하시겠습니까?";
		 if(confirm(msg)){
			popLogin();
		 }

	}

	function message(msg) {
			alert(msg);
	}



	function onlyMemberLevel(level) {

		 var msg = level+"레벨 이상의 회원기능입니다. ";
			alert(msg);


	}

	function openLogin() {
		openPopup("/common/login.asp", "login", 200, 100, "left=200, top=200");
	}
	function openLogout() {
		openPopup("/common/logout.asp", "login", 200, 100, "left=200, top=200");
	}

	// 서치바
		function bgChg(f) {
		   if (f.value == '') {
			  f.style.backgroundImage = 'url(/images/index/login_ids_back.gif)';
			  f.style.backgroundRepeat = 'no-repeat';
		   }
		}

		function bgChgs(f) {
		   if (f.value == '') {
			  f.style.backgroundImage = 'url(/images/index/login_pwd_back.gif)';
			  f.style.backgroundRepeat = 'no-repeat';
		   }
		}

		function bgDel(f) {
			f.style.backgroundImage = 'none';
		}

		function chkSearch(f) {
			if (f.searchs.value=='')
			{
				alert("검색어가 없습니다.");
				f.searchs.focus();
				return false;
			}
		}



		function chkmlLogin(f) {
			if(!chkNull(f.mem_id, "\'아이디\'를 입력해 주세요")) return false;
			if(!chkNull(f.mem_pwd, "\'비밀번호\'를 입력해 주세요")) return false;
		}
		function bgChg1(f) {
		   if (f.value =='') {
			  f.style.backgroundImage = 'url(/images/share/leftLoginIdBg.gif)';
			  f.style.backgroundRepeat = 'no-repeat';
		   }
		}
		function bgChg2(f) {
		   if (f.value =='') {
			  f.style.backgroundImage = 'url(/images/share/leftLoginPwdBg.gif)';
			  f.style.backgroundRepeat = 'no-repeat';
		   }
		}



function layer_close(divid)
{
	document.getElementById(divid).style.visibility="hidden";
}
function layer_open(divid)
{
	document.getElementById(divid).style.visibility="visible";
}



	// IE6 용 PNG 스크립트
		function setPng24(obj){
			obj.width=obj.height=1;
			obj.className=obj.className.replace(/\bpng24\b/i,'');
			obj.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+obj.src+"',sizeMethod='image');"
			objsrc='';
			return '';
		}

	// 테이블 열고 닫기
		function toggle_content(f_menu)
		{
			 if (document.getElementById(f_menu).style.display == "table-row")
			 {
				  document.getElementById(f_menu).style.display = "none"
			 }
			 else
			 {
			  document.getElementById(f_menu).style.display = "table-row"
			 }
		 }
		function reviewOnOff(trname)
		{
			 if (document.getElementById(trname).style.display == "table-row")
			 {
				  document.getElementById(trname).style.display = "none"
			 }
			 else
			 {
			  document.getElementById(trname).style.display = "table-row"
			 }
		 }

	// 팝업 ##################################################
		function openPopup(theURL, winName, width, height, remFeatures) {
			var features = "";
			if (typeof winName == "undefined") winName = "";
			if (typeof width != "undefined") features += ((features) ? "," : "")+"width="+width;
			if (typeof height != "undefined") features += ((features) ? "," : "")+"height="+height;
			if (typeof remFeatures != "undefined") features += ((features) ? "," : "")+remFeatures;
			if (features.indexOf("status") < 0) features += ",status=yes";

			var popup = window.open(theURL, winName, features);
			popup.focus();

			return popup;
		}
	// 팝업 - 팝업창 사이즈 조정 ##################################################

		function resizePopupWindow(width, height) {
			var strAgent = navigator.userAgent.toLowerCase();
			var bIE7 = (strAgent.indexOf("msie 8.0") != -1);
			window.resizeTo(width+10, height+(bIE7 ? 69 : 49));
		}


	// 이미지 롤오버
		function MM_swapImgRestore()
		{
		  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
		}

		function MM_findObj(n, d) { //v4.01
		  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
			d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
		  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
		  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
		  if(!x && d.getElementById) x=d.getElementById(n); return x;
		}

		function MM_swapImage() { //v3.0
		  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
		   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
		}
	// 게시판용
		function pagegoto(PG,recordcnt)
		{
			document.frm.PAGE.value=PG;
			document.frm.submit();
		}
		function ReviewPageGo(PG,recordcnt)
		{
			alert(PG);
			document.frm.PAGE2.value=PG;
			document.frm.submit();
		}

// 즐겨찾기 추가 ##################################################
// 예) <a href="javascript:;" onClick="addFavorites('홈페이지', 'http://www.homepage.com');">즐겨찾기 등록</a>
function addFavorites(title, url) {
	if (document.all) { // IE
		window.external.AddFavorite(url, title);
	}
	else if (window.sidebar) { // Firefox
		window.sidebar.addPanel(title, url, "");
	}
	else { // Opera, Safari ...
		alert("현재 브라우져에서는 이용할 수 없습니다.");
		return;
	}
}
//<![CDATA[
function _addFavorite(title, url) {
	if (window.sidebar) {
		// 파이어폭스(Firefox)
		window.sidebar.addPanel(title, url, "");
	}
	else if(window.opera && window.print) {
		// 오페라(Opera)
		var elem = document.createElement('a');
		elem.setAttribute('href', url);
		elem.setAttribute('title', title);
		elem.setAttribute('rel', 'sidebar');
		elem.click();
	}
	else if(document.all) {
		// 인터넷익스플로러(IE)
		window.external.addFavorite(url, title);
	}
	else {
		alert("CTRL + D 를 눌러 즐겨찾기에 추가해주세요.");
		return;
    }
}
//]]>


// 시작페이지 설정 ##################################################
// 예) <a href="javascript:;" onClick="setStartPage(this, 'http://www.homepage.com');">시작페이지로</a>
function setStartPage(obj, url) {
	if (document.all && window.external) { // IE
		obj.style.behavior = "url(#default#homepage)";
		obj.setHomePage(url);
	}
	else { // Firefox, Opera, Safari ...
		alert("현재 브라우져에서는 이용할 수 없습니다.");
		return;
    }
}


// 플로팅 설정
function floating() {
	this.isIE = (document.all) ? true : false;

	this.objBasis = null;									// 플로팅 기준객체
	this.objFloating = null;								// 플로팅 객체
	this.timer = null;										// 타임 객체

	this.speed = 7;										// 미끄러지는속도 : 작을수록 빠름
	this.time = 10;											// 빠르기 : 작을수록 부드러움
	this.isMove = true;									// 이동여부

	this.initTop;												// 초기 TOP 위치 : 설정시 해당위치에서 marginTop 위치로 미끄러져 온다. 예) -1000

	this.bodyMargin = { left : 0, top : 0 };		// BODY MARGIN

	this.left;
	this.top;

	this.marginLeft;
	this.marginTop;

	this.init = function() {
		var self = this;

		if (!this.isIE) this.speed *= 1.2;

		if (this.objFloating) {
			this.marginLeft = (typeof this.marginLeft == "undefined") ? 0 : parseInt(this.marginLeft, 10);

			if (this.objBasis) {
				this.marginTop = (typeof this.marginTop == "undefined") ? this.getOffset(this.objBasis).top : parseInt(this.marginTop, 10);

				this.left = parseInt(this.objBasis.clientWidth, 10) + this.marginLeft;
				this.top = this.marginTop;

				this.objFloating.style.left = (this.getOffset(this.objBasis).left + this.left) + "px";
				this.objFloating.style.top = ((typeof this.initTop == "undefined") ? this.top : this.initTop) + "px";
				this.objFloating.style.display = "";

				this.addEvent(window, 'resize', function() { self.resize(); });
			}
			else {
				this.marginTop = (typeof this.marginTop == "undefined") ? 0 : parseInt(this.marginTop, 10);

				this.top = this.getOffset(this.objFloating).top + this.marginTop;

				this.objFloating.style.marginLeft = this.marginLeft + "px";
				this.objFloating.style.top = this.top + "px";

				this.objFloating.style.display = "";
			}
		}
	}

	this.run = function() {
		var self = this;

		if (!this.objFloating) return;

		var floatingTop = (this.objFloating.style.top) ? parseInt(this.objFloating.style.top, 10) : this.objFloating.offsetTop;
		var docTop = (document.documentElement.scrollTop || document.body.scrollTop) + this.top;
		var moveTop = Math.ceil(Math.abs(floatingTop - docTop) / this.speed);

		if (floatingTop < docTop) {
			this.objFloating.style.top = (floatingTop + moveTop) + "px";
		}
		else {
			this.objFloating.style.top = (floatingTop - moveTop) + "px";
		}

		this.timer = setTimeout(function () { self.run() }, this.time);
	}

	this.move = function() {
		if (this.isMove) {
			this.isMove = false;
			clearTimeout(this.timer);
			this.objFloating.style.top = this.top + "px";
		}
		else {
			this.isMove = true;
			this.run();
		}
	}

	this.resize = function() {
		if (this.objFloating) this.objFloating.style.left = (this.getOffset(this.objBasis).left + this.left) + "px";
	}

	this.getOffset = function(obj) {
		var objOffset = { left : 0, top : 0 };
		var objOffsetParent = obj.offsetParent;

		objOffset.left = parseInt(obj.offsetLeft, 10);
		objOffset.top = parseInt(obj.offsetTop, 10);

		while (objOffsetParent) {
			objOffset.left += parseInt(objOffsetParent.offsetLeft, 10);
			objOffset.top += parseInt(objOffsetParent.offsetTop, 10);

			objOffsetParent = objOffsetParent.offsetParent;
		}

		return objOffset;
	}

	this.addEvent = function(obj, evt, exec) {
		if (window.attachEvent) obj.attachEvent('on'+evt, exec);
		else if (window.addEventListener) obj.addEventListener(evt, exec, false);
		else obj['on'+evt] = exec;
	}
}


// 숫자와 하이픈만 입력가눙
function inputNmberN_() {
	if ( ((event.keyCode < 48) || (57 < event.keyCode)) && (45 != event.keyCode) ){	event.returnValue=false;}
}





	function setCookie( name, value, expiredays )
	{
		var todayDate = new Date();
		todayDate.setDate( todayDate.getDate() + expiredays );
		document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
	}
	function getCookie(name){
		var Found = false
		var start, end
		var i = 0

		while(i<= document.cookie.length) {
			start = i
			end = start +name.length

			if(document.cookie.substring(start, end)== name) {
				Found = true
				break
			}
				i++
			}

			if(Found == true) {
				start = end + 1
				end = document.cookie.indexOf(";",start)
				if(end < start)
				end = document.cookie.length
				return document.cookie.substring(start, end)
			}
			return ""
		}
function deleteCookie(cookieName){
    var expireDate = new Date();
    expireDate.setDate(expireDate.getDate() - 1);
    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
}



/*
	focus_next_input
	onkeyup="focus_next_input(this)"
*/
function focus_next_input(me){
	if (me.value.length != me.maxLength){
		return;
	}
	var elements = me.form.elements;
	for (var i=0, numElements=elements.length; i<numElements; i++) {
		if (elements[i]==me){
			break;
		}
	}
	elements[i+1].focus();
}

//현재 페이지 이름
function getPageName(){
	var pageName = "";
	var tempPageName = window.location.href;
	var strPageName = tempPageName.split("/");
	pageName = strPageName[strPageName.length-1].split("?")[0];
	return pageName;
}

//현 페이지 주소 처리 querystring 포함
function thisPageUrl(){
	let thisPageUrl = "";
	thisPageUrl = location.pathname+location.search;
	return thisPageUrl;
}

//모바일 경로  '/m/'
function mob_path() {
	let mob_path = "";
	mob_path = thisPageUrl().substr(0,3);
	if (mob_path == "/m/") {
		mob_path = "/m";
	}else{
		mob_path = "";
	}
	return mob_path;
}

	/* alert + txt alert */
	function alert2(msg, id, result) {  	 //result t/f
		alert(msg);
		if (result == "T") {
			$(id).text(msg).addClass("blue2").removeClass("red2");
		}else{
			$(id).text(msg).addClass("red2").removeClass("blue2");
		}
	}
	/* txt alert fo json */
	function alertTxt(msg, id, result) {  	 //result t/f
		if (result == "T") {
			$(id).text(msg).addClass("blue2").removeClass("red2");
		}else{
			$(id).text(msg).addClass("red2").removeClass("blue2");
		}
	}

	/* left str cut */
	function left(s,c){
		return s.substr(0,c);
	}
	/* right str cut */
	function right(s,c){
		return s.substr(-c);
	}
