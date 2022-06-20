/* Counsel */
	function counselView(idx,lng) {
		var f = document.frm;
		f.intIDX.value = idx;
		f.action = 'counsel_view.asp?nc='+lng;
		f.submit();
	}
	function returnList(lng) {
		var f = document.insFrm;
		f.action = 'counsel_list.asp?nc='+lng;
		f.submit();
	}

	function submitThisView(lng) {
		var f = document.insFrm;
		f.MODE.value = 'MODIFY';
		f.action = 'counsel_handler.asp?nc='+lng;
		f.submit();

	}
	function delThisView(lng) {
		var f = document.insFrm;
		f.MODE.value = 'DELETE';
		f.action = 'counsel_handler.asp?nc='+lng;
		f.submit();

	}