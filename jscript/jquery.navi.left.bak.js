/*********************************************************************************
플러그인 : jquery.DB_navi2DV.js
제작자 : 디자인블랙 , http://designblack.com
업데이트 : 2013-07-04
라이센스 : 도메인라이센스
기타 : 문서정보는 삭제 할 수 없습니다.
*********************************************************************************/
(function(a){
	a.fn.DB_navi2DV=function(b){
		var c={
			key:"",
			pageNum:null,
			subNum:null,
			motionSpeed:500,
			moveSpeed:0,
			delayTime:0,
			delayTime2:0,
			menuHeight:39
			};
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

			var q = a(this).find(".left_Follow");
			var z = h.position().top;
			//alert(z);
			lp();
			n();
			hh();
			k()

			//q.animate({"top":"50px"});
			function lp(){if(c.pageNum==null){q.hide()}else{q.show()}}

			function n(){
				m.bind("mouseenter",function(){clearInterval(i)});
				m.bind("mouseleave",function(){
					i=setTimeout(e,c.delayTime);
					if(c.pageNum==null){q.hide()}
				});

				h.bind("mouseenter keyup",function(){
					d=a(this).index();
					q.stop().show();
					if(g!=d){o(a(this).find(">a>img"),"src","_off","_on")}
					k();
					//var y = a(this).position().top;
						//alert(y);
					//	q.stop().animate({"top":y},c.moveSpeed,"easeOutBack")
				});
				h.bind("mouseleave",function(){
					//q.stop().show();hh();
					if(g!=d){o(a(this).find(">a>img"),"src","_on","_off")}
					if(c.pageNum==null){c.delayTime=0}
					//k();

				});
				h.bind("click keyup",function(){g=a(this).index();q.stop().show();k('overs');});

				f.bind("mouseenter",function(){p=a(this).index();o(a(this).find(">a>img"),"src","_off","_on")});
				f.bind("mouseleave",function(){if(r!=p||l!=d){o(a(this).find(">a>img"),"src","_on","_off");}})
			}

			function e(){d=g=l;k()}
			function k(ttyy){
				for(var s=0;s<j;s++){
					var u=h.eq(s);
					if(d==s){
						//if (ttyy == 'overs')
						//{
							u.find(">ul").stop().slideDown(c.motionSpeed);
							u.find(">a").addClass("DB_select");

							o(u.find(">a>img"),"src","_off","_on");
							if(r>=0&&g==l){
								var t=u.find(">ul>li").eq(r);
								t.find(">a").addClass("DB_select");
								o(t.find(">a>img"),"src","_off","_on")
							}
						/*}else{
							u.find(">a").addClass("DB_select");

							o(u.find(">a>img"),"src","_off","_on");
							if(r>=0&&g==l){
								var t=u.find(">ul>li").eq(r);
								t.find(">a").addClass("DB_select");
								o(t.find(">a>img"),"src","_off","_on")
							}

						}*/
						var y = u.position().top;
						//alert(y);
						q.stop().animate({"top":y},c.moveSpeed,"easeOutBack")

						//	alert(z+c.menuHeight*s);

					}else{
						//if (ttyy == 'overs') {
							u.find(">ul").stop().slideUp(c.motionSpeed);
							u.find(">a").removeClass("DB_select");
							o(u.find(">a>img"),"src","_on","_off");
						//} else {
						//	o(u.find(">a>img"),"src","_on","_off");
						//}
						//q.stop(true,true).animate({"top":"150px"},c.moveSpeed,"easeOutBack")
						//alert(pp+c.menuHeight*s);

					}

				}

			}
			function hh(){
				for(var rr=0;rr<j;rr++){
					var ss=f.eq(rr);
					if(d==rr){
						q.stop().animate({"top":z+c.menuHeight*rr},c.moveSpeed,"easeOutBack")
					}else{
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
