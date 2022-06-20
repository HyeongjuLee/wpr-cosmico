// Javascript Calendar
//
// openCalendar([일자입력 Text폼], 'YYYY-MM-DD');
var isIE = (window.navigator.appName.indexOf("Explorer") != -1) ? true : false; // ie 여부

var calImgPath = "/m/images";
var calDateServerUrl = "/m/js/ajaxDate.asp";

var calLayerId = "layerCalendar";
var calWidth = 294;
var calHeight = 340;

var objCalendar = null;

var mode = '';
var target = null;
var targetYear = null;
var targetMonth = null;
var targetDay = null;

var calNowYear, calNowMonth, calNowDay;

var arrDayNum = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var arrWeekName = new Array('S', 'M', 'T', 'W', 'T', 'F', 'S');

var dateType = 'YYYY-MM-DD';

var calPosX = 0;
var calPosY = 0;



function calRegistEvent() {
	if (isIE) {
		document.attachEvent('onclick', hideCalendar);
	}
	else if (document.addEventListener) {
		document.addEventListener('click', hideCalendar, false);
	}
	else if (document.attachEvent) {
		document.attachEvent('click', hideCalendar);
	}
}

function calUnregistEvent() {
	if (isIE) {
		document.detachEvent('onclick', hideCalendar);
	}
	else if (document.removeEventListener) {
		document.removeEventListener('click', hideCalendar, false);
	}
	else if (document.detachEvent) {
		document.detachEvent('click', hideCalendar);
	}
}

function calSetZero(value) {
	value = "" + value;
	if (value.length == 1) value = "0"+value;
	return value;
}

function calReplaceAll(value, oldChar, newChar) {
	if (value == null || value.replace(/ /g, "") == "") return;
	else
	{
		var fromIdx = 0;
		var temp = "";
		for (var i=0, len=value.length; i<len; i++) {
			fromIdx = i;
			pos = value.indexOf(oldChar, fromIdx);
			if (pos != -1) {
				temp = value.substring(0,pos) + newChar + value.substring(pos+oldChar.length);
				value = temp;
				i = pos + newChar.length - 1;
			}
			else break;
		}
		return value;
	}
}

function calHover(e, isOn) {
	var e = window.event || e;
	var elm = (e.srcElement) ? e.srcElement : e.target;

	if (elm && elm.nodeName.toUpperCase() == "TD") {
		if (elm.id == '') return;
		elm.style.background = (isOn) ? '#E7E7E7' : '#FFFFFF';
	}
}

function calCheckDate(elm, value) {
	result = false;
	for (var i=0, len=elm.length; i<len; i++) {
		if (elm.options[i].value == value) {
			result = true;
			break;
		}
	}
	return result;
}


function calSelectDate(e, year, month) {
	var e = window.event || e;
	var elm = (e.srcElement) ? e.srcElement : e.target;

	if (elm && elm.nodeName.toUpperCase() == "TD") {
		if (elm.id == "") return;

		calInputDate(year, calSetZero(month), calSetZero(elm.id));
	}
}

function calInputDate(year, month, day) {
	var realYear, realMonth, realDay;

	if (year < 1900) year = 1900 + year;

	var realDate = this.dateType.toUpperCase();

	if (realDate.indexOf('YYYY') != -1) {
		realYear = year;
		realDate = calReplaceAll(realDate, 'YYYY', realYear);
	}
	else if (realDate.indexOf('YY') != -1) {
		realYear = year.toString().substr(2,2);
		realDate = calReplaceAll(realDate, 'YY', realYear);
	}

	if (realDate.indexOf('MM') != -1) {
		realMonth = calSetZero(month);
		realDate = calReplaceAll(realDate, 'MM', realMonth);
	}
	else if (realDate.indexOf('M') != -1) {
		realMonth = month;
		realDate = calReplaceAll(realDate, 'M', realMonth);
	}

	if (realDate.indexOf('DD') != -1) {
		realDay = calSetZero(day);
		realDate = calReplaceAll(realDate, 'DD', realDay);
	}
	else if (realDate.indexOf('D') != -1) {
		realDay = day;
		realDate = calReplaceAll(realDate, 'D', realDay);
	}

	if (this.mode == 'SEL') {
		if (!calCheckDate(this.targetYear, realYear) || !calCheckDate(this.targetMonth, realMonth) || !calCheckDate(this.targetDay, realDay)) {
			alert('선택 할 수 없는 일자입니다.');
		}
		else {
			this.targetYear.value = realYear;
			this.targetMonth.value = realMonth;
			this.targetDay.value = realDay;
		}
	}
	else {
		this.target.value = realDate;
 	}

	hideCalendar();
}

function calMakeContent(year, month, day) {
	var i, len;

	year = parseInt(year, 10);
	month = parseInt(month, 10);
	day = parseInt(day, 10);

	if (month == 0) { year = year - 1; month = 12; }
	else if (month == 13) { year = year + 1; month = 1; }

	// 윤년 확인
	if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) this.arrDayNum[1] = 29;

	var first = new Date(year, month-1, 1);
	firstday = first.getDay() + 1;
	var daysOfMonth = this.arrDayNum[month-1];

	if (day > daysOfMonth) day = daysOfMonth;

	var tag = "";
	tag += "<table cellpadding='2' cellspacing='0' border='0' style='background-color:#EFE7E7; border:solid 1px #CCCCCC; table-layout:fixed'>";
	tag += "<tr height='"+(this.calHeight-2)+"'><td align=center valign='top'>";

	tag += "<table cellpadding='0' cellspacing='0' border='0'>";
	tag += "<tr height='"+(this.calHeight-6)+"'><td align=center valign='top' style='background-color:#FFFFFF'>";

	tag += "<table cellspacing='0' cellpadding='0' border='0' onMouseOver='parent.calHover(event, true)' onMouseOut='parent.calHover(event, false)' onClick='parent.calSelectDate(event, "+year+","+month+")'>";
	tag += "<tr height='40'><td align='center' colspan='7'>";

	tag += "<table cellspacing='0' cellpadding='0' border='0' width='95%' align='center'><tr><td width='80%'>";
	tag += "<font style='font-weight:bold; vertical-align:middle;font-size:20px;'>";

//	tag += "<img src='"+this.calImgPath+"/btn_left.png' width='17' height='20' align='absmiddle' border='0' onClick='parent.showCalendar("+(year-1)+","+month+","+day+");' style='cursor:pointer'>"+year;
//	tag += "<img src='"+this.calImgPath+"/btn_right.png' width='17' height='20' align='absmiddle' border='0' onClick='parent.showCalendar("+(year+1)+","+month+","+day+");' style='cursor:pointer'>";
//	tag += "&nbsp;&nbsp;&nbsp;";
//	tag += "<img src='"+this.calImgPath+"/btn_left.png' width='17' height='20' align='absmiddle' border='0' onClick='parent.showCalendar("+year+","+(month-1)+","+day+");' style='cursor:pointer'>"+calSetZero(month);
//	tag += "<img src='"+this.calImgPath+"/btn_right.png' width='17' height='20' align='absmiddle' border='0' onClick='parent.showCalendar("+year+","+(month+1)+","+day+");' style='cursor:pointer'>";

	tag += "<a onClick='parent.showCalendar("+(year-1)+","+month+","+day+");' style='cursor:pointer'>◁ </a>"+year;
	tag += "<a onClick='parent.showCalendar("+(year+1)+","+month+","+day+");' style='cursor:pointer'> ▷</a>";
	tag += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	tag += "<a onClick='parent.showCalendar("+year+","+(month-1)+","+day+");' style='cursor:pointer'>◁ </a>"+calSetZero(month);
//	tag += "월<a onClick='parent.showCalendar("+year+","+(month+1)+","+day+");' style='cursor:pointer'> ▷</a>";
	tag += "<a onClick='parent.showCalendar("+year+","+(month+1)+","+day+");' style='cursor:pointer'> ▷</a>";

	tag += "</font>";

	tag += "</td><td width='20%' align='right'>";

	tag += "<span style='font-size:14px; font-weight:bold; color:CC0000; text-decoration:none; cursor:pointer' onClick='parent.showCalendar("+this.calNowYear+","+this.calNowMonth+","+this.calNowDay+");' >Today</span>";

	tag += "</td></tr></table>";

	tag += "</td></tr>";

	tag += "<tr height='42' bgcolor='#F4F4F4' align='center'>";
	tag += "<td width='42' style='color:#FF0000;'>"+this.arrWeekName[0]+"</td>";
	tag += "<td width='42' style='color:#000000;'>"+this.arrWeekName[1]+"</td>";
	tag += "<td width='42' style='color:#000000'>"+this.arrWeekName[2]+"</td>";
	tag += "<td width='42' style='color:#000000'>"+this.arrWeekName[3]+"</td>";
	tag += "<td width='42' style='color:#000000'>"+this.arrWeekName[4]+"</td>";
	tag += "<td width='42' style='color:#000000'>"+this.arrWeekName[5]+"</td>";
	tag += "<td width='42' style='color:#0000FF'>"+this.arrWeekName[6]+"</td>";
	tag += "</tr><tr height='42'>";

	var column = 0;
	for (i=1; i<firstday; i++) {
		tag += "<td align='center' style='font-size:16px;' width='42'></td>";
		++column;
	}

	for (i=1; i<=daysOfMonth; i++) {
		if (year == this.calNowYear && month == this.calNowMonth && i == this.calNowDay) {
			tag += "<td align='center' style='color:#CE0000; font-weight:bold; cursor:pointer'";
		}
		else if (column == 0) {
			tag += "<td align='center' style='color:#FF0000; cursor:pointer'";
		}
		else if (column ==6) {
			tag += "<td align='center' style='color:#0000FF; cursor:pointer'";
		}
		else {
			tag += "<td align='center' style='cursor:pointer'";
		}

		tag += " id='"+i+"'>"+i+"</td>";

		++column;

		if (column == 7 && i < daysOfMonth) {
			tag += "</tr><tr height='42'>";
			column = 0;
		}
	}

	if (column > 0 && column < 7) {
		for (i=1, len=7-column; i<=len ; i++)
			tag += "<td align='center' style='font-size:16px;'></td>";
	}

	tag += "</td></tr></table>";
	tag += "</td></tr></table>";

	return tag;
}

function calGetServerDate() {
	calAjax.execute(this.calDateServerUrl, "", calSetDate);
}

function calSetDate(req) {
	var value = req.responseText;

	if (value.replace(/ /g, "") == "") {
		var nowDate = new Date();
		this.calNowYear = nowDate.getYear();
		this.calNowMonth = calSetZero(nowDate.getMonth()+1);
		this.calNowDay = calSetZero(nowDate.getDate());

		if (this.calNowYear < 1900) this.calNowYear = this.calNowYear + 1900;
	}
	else {
		var arrDate = value.split('-');
		this.calNowYear = arrDate[0];
		this.calNowMonth = calSetZero(arrDate[1]);
		this.calNowDay = calSetZero(arrDate[2]);
	}

	var year = this.calNowYear;
	var month = this.calNowMonth;
	var day = this.calNowDay;

	var aDate = (this.mode == 'SEL') ? this.targetYear.value+'-'+this.targetMonth.value+'-'+this.targetDay.value : this.target.value;
	var aDateType = this.dateType.toUpperCase();

	if (aDate.length == aDateType.length) {
		if (aDateType.indexOf('YYYY') != -1) {
			year = aDate.substr(aDateType.indexOf('YYYY'), 4);
		}
		else if (aDateType.indexOf('YY') != -1) {
			year = aDate.substr(aDateType.indexOf('YY'), 2);
		}

		if (aDateType.indexOf('MM') != -1) {
			month = aDate.substr(aDateType.indexOf('MM'), 2);
		}
		else if (aDateType.indexOf('M') != -1) {
			month = aDate.substr(aDateType.indexOf('M'), 1);
		}

		if (aDateType.indexOf('DD') != -1) {
			day = aDate.substr(aDateType.indexOf('DD'), 2);
		}
		else if (aDateType.indexOf('D') != -1) {
			day = aDate.substr(aDateType.indexOf('D'), 1);
		}
	}

	showCalendar(year, month, day);
}


function checkCalendarLayer() {
	if (!objCalendar) {

		var objDiv = document.createElement('DIV');
		objDiv.id = this.calLayerId;
		objDiv.style.position = "absolute";
		objDiv.style.left = "0px";
		objDiv.style.zIndex = 100;
		objDiv.style.display = "none";

			var objIfrm = document.createElement("iframe");
			objIfrm.setAttribute("id", this.calLayerId+"Body");
			objIfrm.setAttribute("scrolling", "no");
			objIfrm.setAttribute("frameBorder", "0");
			objIfrm.setAttribute("marginWidth", "0");
			objIfrm.setAttribute("marginHeight", "0");
		//	objIfrm.style.width = '100%';
		//	objIfrm.style.height = '100%';
			objIfrm.style.width = this.calWidth+'px';
			objIfrm.style.height = this.calHeight+'px';

		objDiv.appendChild(objIfrm);

		document.body.appendChild(objDiv);

		objCalendar = objDiv;
	}
}

function showCalendar(year, month, day) {
	checkCalendarLayer();

	var objIfrm = objCalendar.firstChild;
	var objDoc = objIfrm.contentWindow.document;
	objDoc.open();
	objDoc.write("<html><head>");
	objDoc.write("<style type='text/css'>");
	objDoc.write("html { overflow:hidden; background-color:#000;}");
	objDoc.write("body { overflow:hidden; }");
	objDoc.write("td { font-family:'tahoma'; font-size:16px; }");
	objDoc.write("</style>");
	objDoc.write("</head><body bgcolor='#000000' style='margin:0;'>"+calMakeContent(year, month, day)+"</body></html>");
	objDoc.close();

	objCalendar.style.left = this.calPosX+"px";
	objCalendar.style.top = this.calPosY+"px";


	objCalendar.style.display = "";

	calRegistEvent();
}

function hideCalendar() {
	calUnregistEvent();
	objCalendar.style.display = "none";
}



function openCalendar(e, elm, dateType) {
	var e = window.event || e;

	this.mode = '';
	this.target = (elm.nodeType==1) ? elm : document.getElementById(elm);
	this.dateType = dateType;
/*
	this.calPosX = (isIE) ? parseInt(document.body.scrollLeft, 10) + parseInt(e.clientX, 10) : parseInt(e.pageX, 10);
	this.calPosY = (isIE) ? parseInt(e.clientY, 10) + parseInt(document.body.scrollTop, 10) : parseInt(e.pageY, 10);
	if (isIE && parseInt(document.body.scrollTop, 10) == 0) this.calPosY += parseInt(document.documentElement.scrollTop, 10);

*/
	this.calPosX = ($(window).width()/2)-(calWidth/2);
//	this.calPosY = ($(document).height()/2)-(calHeight/2)+$(document).scrollTop();
	this.calPosY = $(document).scrollTop() + ($(window).height()/2) - (calHeight/2);



	calGetServerDate();
}


function openCalendarSelect(e, elmYear, elmMonth, elmDay, dateType) {
	this.mode = 'SEL';
	this.targetYear = (elmYear.nodeType==1) ? elmYear : document.getElementById(elmYear);
	this.targetMonth = (elmMonth.nodeType==1) ? elmMonth : document.getElementById(elmMonth);
	this.targetDay = (elmDay.nodeType==1) ? elmDay : document.getElementById(elmDay);
	this.dateType = dateType;

	this.calPosX = parseInt(e.clientX, 10);
	this.calPosY = parseInt(e.clientY, 10);

	calGetServerDate();
}


/* AJAX Request */
var calAjax = new Object();
calAjax.xmlHttpReq = null;

calAjax.execute = function(url, params, returnExec) {
	calAjax.xmlHttpReq = calGetXmlHttpRequest();
	if (calAjax.xmlHttpReq) {
		url += ((url.indexOf('?') >= 0) ? '&' : '?') + "rnd="+Math.random();

		calAjax.xmlHttpReq.onreadystatechange = function() {
			if (calAjax.xmlHttpReq.readyState == 4) {
				returnExec(calAjax.xmlHttpReq);
				calAjax.xmlHttpReq = null;
			}
		}

		calAjax.xmlHttpReq.open('GET', url, true);
		calAjax.xmlHttpReq.send(params);
	}
}

function calGetXmlHttpRequest() {
	if (window.XMLHttpRequest) {
		// Create XMLHttpRequest object in non-Microsoft browsers
		return new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		// Create XMLHttpRequest via MS ActiveX
		try {
			// Try to create XMLHttpRequest in later versions
			// of Internet Explorer
			return new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e1) {
			// Failed to create required ActiveXObject
			try {
				// Try version supported by older versions
				// of Internet Explorer
				return new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e2) {
				// Unable to create an XMLHttpRequest with ActiveX
			}
		}
	}
	else {
		return null;
	}
}

/* 추가 */
function chgDate(sdate,nDate) {
	let SDATE = $("#SDATE");
	let EDATE = $("#EDATE");
	let nowDate = nDate;

	if (sdate != '')
	{
		EDATE.val(nowDate);
		SDATE.val(sdate);
	} else {
		EDATE.val('');
		SDATE.val('');
	}
}

