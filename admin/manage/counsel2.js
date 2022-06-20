/* Counsel */
	function counselView(idx) {
		var f = document.frm;
		f.intIDX.value = idx;
		f.action = 'counsel2_view.asp';
		f.submit();
	}
	function returnList() {
		var f = document.insFrm;
		f.action = 'counsel2_list.asp';
		f.submit();
	}

	function submitThisView() {
		var f = document.insFrm;
		f.MODE.value = 'MODIFY';
		f.action = 'counsel2_handler.asp';
		f.submit();

	}
	function delThisView() {
		var f = document.insFrm;
		f.MODE.value = 'DELETE';
		f.action = 'counsel2_handler.asp';
		f.submit();

	}