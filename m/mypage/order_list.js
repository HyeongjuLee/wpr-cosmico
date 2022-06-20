function chgDate(sdate,nDate) {
	var SDATE = $("#SDATE");
	var EDATE = $("#EDATE");

	var nowDate = nDate;

	if (sdate != '')
	{
		EDATE.val(nowDate);
		SDATE.val(sdate);


	} else {
		EDATE.val('');
		SDATE.val('');
	}
}