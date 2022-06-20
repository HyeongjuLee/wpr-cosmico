/*********************************************************************************
플러그인 : jquery.DB_navi2DV.js
제작자 : 디자인블랙 , http://designblack.com
업데이트 : 2013-07-04
라이센스 : 도메인라이센스
기타 : 문서정보는 삭제 할 수 없습니다.
*********************************************************************************/
(function(a){
	a.fn.DB_navi2DV=function(b){
		var c={key:"",pageNum:null,subNum:null,motionSpeed:500,delayTime:2000};
		a.extend(c,b);
		return this.each(function(){
			var m=a(this);
			var h=m.find(".LEFT_main");
			var f=m.find(".LEFT_main>ul>li");
			var j=h.length;
			var l=c.pageNum-1;
			var r=c.subNum-1;
			var g=l;
			var d=g;
			var p=r;
			var i;

				n();
				k()

			function n(){
				m.bind("mouseenter",function(){clearInterval(i)});
				m.bind("mouseleave",function(){i=setTimeout(e,c.delayTime)});
				h.bind("mouseenter keyup",function(){
					d=a(this).index();
					if(g!=d){o(a(this).find(">a>img"),"src","_off","_on")
					a(this).addClass("DB_select");}
					//a(this).addClass("");}									//ZJ 특이사항 : 메뉴클릭시 서브메뉴 테두리 영향 
				});
				h.bind("mouseleave",function(){
					if(g!=d){o(a(this).find(">a>img"),"src","_on","_off")}
					a(this).removeClass("DB_select");
				});
				h.bind("click keyup",function(){g=a(this).index();k()});
				f.bind("mouseenter",function(){p=a(this).index();o(a(this).find(">a>img"),"src","_off","_on")});
				f.bind("mouseleave",function(){if(r!=p||l!=d){o(a(this).find(">a>img"),"src","_on","_off")}})
			}

			function e(){d=g=l;k()}
			function k(){
				for(var s=0;s<j;s++){
					var u=h.eq(s);
					if(d==s){
						u.find(">ul").stop().slideDown(c.motionSpeed);
						u.find(">a").addClass("DB_select");o(u.find(">a>img"),"src","_off","_on");
						if(r>=0&&g==l){
							var t=u.find(">ul>li").eq(r);
							t.find(">a").addClass("DB_select2");
							o(t.find(">a>img"),"src","_off","_on")
						}
					}else{
						u.find(">ul").stop().slideUp(c.motionSpeed);
						u.find(">a").removeClass("DB_select");
						o(u.find(">a>img"),"src","_on","_off")
					}
				}
			}
			function o(t,w,s,u){
				var v=t.attr(w);
				if(String(v).search(s)!=-1){t.attr(w,v.replace(s,u))}
			}
		})
	}
})(jQuery);
