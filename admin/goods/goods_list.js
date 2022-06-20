
function chgThisAsc(data,idx) {
	var f = document.frm;
	var d = document.getElementById(data);
	var m = document.getElementById("max_number");
	if (confirm('순서를 변경하시겠습니까? \n\n입력하신 순서보다 높은 번호는 순서가 1칸씩 밀리게 됩니다.'))
	{
		//alert(d.value);
		if (d.value == '')
		{
			alert("순번을 입력해주세요");
			d.focus();
			return false;
		} else {
			if (parseInt(d.value,10) > parseInt(m.value,10))
			{
				alert("최대값을 벗어났습니다\n\n현재 입력할 수 있는 최대값은 "+m.value+" 입니다.");
				d.focus();
				return false;
			} else {
				f.intSort.value = d.value;
				f.intIDX.value = idx;
				//f.strNationCode.value = Na_code;
				f.action = 'goods_list_asc_chg.asp';
				f.submit();
			}
		}
	} else {
		f.action = '';
		return false;
	}


}