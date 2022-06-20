/**
	* Author : MC 심새 (ganer9r@naver.com)
	* Make Date : 2008-07-15
	* comment : 1줄 텍스트 롤링 스크립트
**/
var ScrollControl = function(objId,options){
	this.init(objId,options);
}

ScrollControl.prototype = {
	stage : {},
	options : {},
	isover : false,
	freeze : false,
	course : 'top',
	itimes : 0,
	top : 0,

	init : function(objId,options){
	this.setOptions(options);
	this.setStage(objId);
	this.setTrueData();

	this.move();
},
	setOptions : function(options){
	options.inteval = options.inteval || 50;
	options.freeze = options.freeze || 1000;
	options.height = parseInt(options.height, 10) || 20;
	options.style = options.style || 'scroll';
	options.line = options.line || 1;
	options.stopline = options.stopline || options.line;
	options.reverse = options.reverse || '';
	options.debug = options.debug || false;

	options.blockHeight = options.height * options.line;
	options.stopHeight = options.height * (options.stopline || options.line);


	// options.cMarginTop = options.cMarginTop || (options.height/2) * 0.3;
	options.cMarginTop = 0;
	options.cHeight = options.height - options.cMarginTop;
	options.freeze = (options.style == 'no-freeze') ? options.inteval : options.freeze;

	switch(options.style){
	case 'jump' : options.style = options.style; break;
	default : options.style = 'scroll'; break;
}


	this.course = options.start || 'top';
	this.options = options;
	},
	setTrueData : function(){
	var cObjs = this.stage.childNodes;
	var cObjLen = cObjs.length;
	var removes = [];

	for(var i=0;i<cObjs.length;i++){
	if(!cObjs[i].tagName){
	removes.push(cObjs[i]); //바로 삭제 시 데이터 꼬이는듯 하여 일단 킵함.
}else{
cObjs[i].style.margin = "0";

cObjs[i].style.marginTop = this.options.cMarginTop;
cObjs[i].style.height = this.options.cHeight+'px';
}
}

// 찾은 데이터를 삭제함.(FF의 경우 text 노드가 첨부됨.)
for(var i=0;i<removes.length;i++){
this.stage.removeChild(removes[i]);
}

if(!this.options.debug && cObjLen <= this.options.line ){
var attachLen = parseInt(this.options.line/cObjLen, 10);

for(var i=0; i<attachLen; i++){
for(var j=0; j<cObjLen; j++){
this.stage.appendChild( cObjs[j].cloneNode(true) );
}
}
}

},
setStage : function(objId){
var This = this;
this.stage = document.getElementById(objId);

this.stage.style.height = this.options.blockHeight+'px';
this.stage.style.padding = "0px";
this.stage.style.margin = "0px";

if(!this.options.debug)
this.stage.style.overflow = "hidden";


this.stage.onmouseover = function(){This.isover=true;}
this.stage.onmouseout = function(){This.isover=false;}

this.stage.scrollTop = 0; //파폭에서 리프래시 문제
},
setCourse : function(course){
if(this.course != 'down' && course == 'down' && this.stage.scrollTop <= 0){
this.changeChild();
this.stage.scrollTop = this.options.height;
}else if(course == 'top' && this.stage.scrollTop >= this.options.height){
if(this.options.reverse != 'all'){
this.changeChild(this.options.line);
this.stage.scrollTop = this.stage.scrollTop - this.options.stopHeight;
}
}

this.course = course;
if(this.itimes > 0){
window.clearTimeout(this.itimes);
this.move();
}
},
changeChild : function(count){
if(count == undefined){ count = this.stage.childNodes.length - 1;}

for(var i=0; i<count;i++ ){
this.stage.appendChild( this.stage.childNodes[0] ); // 항상 첫번째것을 뒤로 이동
}
},
actionTop : function(){
if(this.options.style == 'jump'){
this.changeChild(this.options.stopline);
this.stage.scrollTop = 0;
this.freeze = true;
}else{
this.top++;
this.stage.scrollTop++;

if( this.stage.scrollTop >= this.options.height ){
this.changeChild(1);
this.stage.scrollTop = this.stage.scrollTop - this.options.height;

//if문 안에 있는게 효율
if( this.top >= this.options.stopHeight ){
this.top = 0;
this.freeze = true;
if(this.options.reverse == 'top' || this.options.reverse == 'all') this.setCourse("down");
}
}
}
},
actionDown : function(){
if(this.options.style == 'jump'){
this.freeze = true;
for(var i=0; i<this.options.stopline;i++){
this.changeChild();
}
}else{
this.top--;
this.stage.scrollTop--;

if( this.stage.scrollTop <= 0 ){
this.changeChild();
this.stage.scrollTop = this.stage.scrollTop + this.options.height;

//Math.abs 로 구할 수 있지만, Math함수가 무거운 관계로 음수 처리함.(if문 안에 있는게 효율)
if( -(this.top) >= this.options.stopHeight ){
for(var i=1; i<this.options.stopline;i++){
this.changeChild();
}

this.top = this.top + this.options.stopHeight;
this.freeze = true;
}
}
}

if(this.freeze){
this.stage.scrollTop = this.options.stopHeight;
if(this.options.reverse == 'down' || this.options.reverse == 'all') this.setCourse("top");
}

},
move : function(){
this.itimes = 0;
if(!this.isover){
if(this.course == 'top') this.actionTop();
else this.actionDown();
}

var This = this;
if(this.freeze){ this.itimes = window.setTimeout(function(){This.move()}, this.options.freeze); }
else{ window.setTimeout(function(){This.move()}, this.options.inteval); }
this.freeze = false;
}

}


/* 사용법 Start*/
// var scroll = new ScrollControl('html element id',options);
//
// options 항목
// inteval : 재귀호출 시간 간격 1/1000초(기본값 50)
// freeze : 잠시 멈춰 있는 시간 간격 1/1000 초(기본값 1000)
// height : 객체 높이(기본값 20)
// cMarginTop : 자동으로 구해주나, 글자 크기와 객체 높이 등으로 인해, 의도한 높이가 나오지 않을 수 있기 때문에 사용자가 강제 입력함.
// line : 스크롤 line를 구함.(해당 객체의 높이는 line * height)가 됨.
// stopline : 기본값(line와 같음), stopline 정보에 따라 line와는 독립적으로 스크롤을 freeze 시킴.
// start : 기본값 'top', top,down 두 값이 있음.
// reverse : [ | all | top | down ]
// none - none가 아닌, 값이 없다는 뜻임. 실제값 string ''값
// all - 위, 아래에 모두 reverse를 시킴. 이 설정을 하는 경우 위아래로 왔다갔다 함.
// top - course가 top인 경우, setCourse('down')을 호출함
// down - course가 down인 경우, setCourse('top')을 호출함
// style : [ scroll | jump | s-jump | jump-s ]
// scroll - 기본 스크롤 및 setCourse 호출 시에도 스크롤 이동. [기본형]
// jump - 기본으로 다음 항목으로 점프 및 setCourse 호출 시에도 점프 이동.
//
/* 사용법 End */
