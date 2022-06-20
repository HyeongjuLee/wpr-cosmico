/* 한글 */

function toggle(elmId) {
	var objLayer = document.getElementById(elmId);

	if (objLayer.style.display == "block") {

		objLayer.style.display="none";
	}
	else {
		objLayer.style.display="block";
	}
}
function chgDate() {
	var f = document.schFrm;
	f.submit();
}
/*
edukin
function lectureControl(loca) {
	openPopup("lectureControl.asp?loca="+loca, "Lectures", 915, 500, "left=200, top=200,scrollbars=yes");
}
*/


//home,cs scheduler
function scheduleControl(stype) {
	//openPopup("scheduleControl.asp", "schedule", 915, 500, "left=200, top=200,scrollbars=yes");
	//openPopup("scheduleControl.asp?stype="+stype, "schedule", 915, 500, "left=200, top=200,scrollbars=yes");
	openPopup("scheduleControl.asp?"+stype, "schedule", 915, 500, "left=200, top=200,scrollbars=yes");
}