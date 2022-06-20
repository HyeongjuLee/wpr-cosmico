(function(a){
	a.fn.DB_tabArrowSlideMove=function(b){
		var c={
			 motionType:"fade"
			,motionSpeed:300
			,autoRollingTime:3000
			,menuVisible:true
			,overRolling:false
			,random:false
		};
		a.extend(c,b);
		return this.each(function(){
			var h=a(this);
			var l=h.find(".visual_img");
			var v=l.find("> li");
			var j=h.find(".visual_menu");
			var n=j.find("> li");
			var A=h.find(".visual_dir");
			var u=h.find(".visual_next");
			var g=h.find(".visual_prev");
			var f=v.length;
			var t=0;
			if(c.random){t=Math.floor(Math.random()*f)}
			var p=0;
			var k=0;
			var s="next";
			var w=true;
			var e=false;
			var i=v.width();
			var z=v.height();
			x();
			function x(){

				m();
				d();
				y()
			}

			function m(){
				if(c.menuVisible==false){
					j.hide();
					A.hide();
					o.hide()
				}
				for(var D=0;D<f;D++){
					var C=v.eq(D);
					switch(c.motionType){
						case"x":C.css({left:i*D});
							break;
						case"y":C.css({top:z*D});
							break;
						default:if(D==t){
								C.show()
							}else{
								C.hide()
							}
					}
				}
				q(n.eq(p).find("img"),"src","_on","_off");
				q(n.eq(t).find("img"),"src","_off","_on");
				n.eq(p).removeClass("DB_select");
				n.eq(t).addClass("DB_select");
				p=t
			}
			function d(){
				h.bind("mouseenter",function(){
					if(c.overRolling==false&&w==true){clearInterval(k)}
					if(c.menuVisible==false){
						j.show();
						A.show();
						o.show()
					}
				});
				h.bind("mouseleave",function(){
					if(c.overRolling==false&&w==true){y()}
					if(c.menuVisible==false){
						j.hide();
						A.hide();
						o.hide()
					}
				});
				n.bind("mouseenter",function(){
					var C=a(this).index();
					if(C>t){s="next"}else{s="prev"}
					if(t!=C){t=C;r()}
				});
				A.bind("mouseenter",function(){
					e=true;
					q(a(this).find("img"),"src","_off","_on")
				});
				A.bind("mouseleave",function(){
					e=false;
					q(a(this).find("img"),"src","_on","_off")
				});
				//u.bind("click",function(){s="next";B()});
				//g.bind("click",function(){s="prev";B()});
				u.bind("click",function(){s="next";B()});
				g.bind("click",function(){s="prev";B()});
			}

			function B(){
				if(w||e){
					if(s=="next"){t=++t%f}else{t=(t==0)?f-1:--t%f}
					r()
				}
			}
			function y(){k=setInterval(B,c.autoRollingTime)}
			function r(){
				var C=v.eq(p);
				var D=v.eq(t);
				if(c.motionType=="fade"){
					C.stop(true,true).fadeOut(c.motionSpeed);
					D.stop(true,true).fadeIn(c.motionSpeed)
				}else{
					if(c.motionType=="x"){
						if(s=="next"){
							C.stop().css("left",0).animate({left:-i},c.motionSpeed);
							D.stop().css("left",i).animate({left:0},c.motionSpeed)
						}else{
							C.stop().css("left",0).animate({left:i},c.motionSpeed);
							D.stop().css("left",-i).animate({left:0},c.motionSpeed)
						}
					}else{
						if(c.motionType=="y"){
							if(s=="next"){
								C.stop().css("top",0).animate({top:-z},c.motionSpeed);
								D.stop().css("top",z).animate({top:0},c.motionSpeed)
							}else{
								C.stop().css("top",0).animate({top:z},c.motionSpeed);
								D.stop().css("top",-z).animate({top:0},c.motionSpeed)
							}
						}else{
							C.hide();
							D.show()
						}
					}
				}
				q(n.eq(p).find("img"),"src","_on","_off");
				q(n.eq(t).find("img"),"src","_off","_on");
				n.eq(p).removeClass("DB_select");
				n.eq(t).addClass("DB_select");
				p=t
			}

			function q(D,G,C,E){
				var F=D.attr(G);
				if(String(F).search(C)!=-1){
					D.attr(G,F.replace(C,E))
				}
			}
		})
	}
})(jQuery);

