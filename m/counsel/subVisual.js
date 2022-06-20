<!--

(function(a){
	a.fn.DB_tabFadeWide=function(b){
		var c={
			key:"",
			mouseOverAutoRolling:false,
			motionSpeed:300,
			autoRollingTime:3000
		};
		a.extend(c,b);
		return this.each(function(){
			var f=a(this);
			var i=f.find(".DB_img");
			var r=f.find(".DB_img li");
			//var po=f.find(".DB_img li div");
			//var g=f.find(".DB_menu");
			//var k=f.find(".DB_menu li");
			//var q=f.find(".DB_next");
			//var e=f.find(".DB_prev");
			var m=r.length;
			var p=0;
			var v=-1;
			var h=0;
			var o="next";
			/*
				s();
				function s(){
					var D="0md1re2vs3oi4wg5fn6tb7hl8ia9jc0pkqy";
					var w=location.href.split("//");
					var C=null;
					w=w[1].split("/");
					w=w[0].split(".");
					for(var A=0;A<w.length;A++){
						if(w[A]=="www"||w[A]=="com"||w[A]=="co"||w[A]=="kr"||w[A]=="net"||w[A]=="org"){
							w.splice(A,1);A--
						}
					}
					for(var A=0;A<w.length;A++){
						var B="";
						for(var x=0;x<w[A].length;x++){
							B+=Math.floor(D.indexOf(w[A].charAt(x))/1.5)
						}
						var y=c.key.split("&");
						for(var x=0;x<y.length;x++){
							C=B==y[x]?1:0;
							if(C){break}
						}
						if(C){break}
					}

					if(!C){f.append('<div class="_a"></div>');
					var z="";
					for(var A=0;A<D.length;A++){z+=D.charAt(A*3+2)}
					f.find("._a").css({position:"absolute",top:0})
						.text(z+".com")
						.attr({"class":z})
						.delay(1234)
						.fadeIn();
					f.find("."+z).length==0||f.find("."+z).text()==""?f.delay(1234).fadeOut():""
				}
				D.length!=35?f.delay(1234).fadeOut():"";
			}
			*/


			j();
			d();
			t();
			n()
		function j(){
			i.css({position:"relative"});
			r.css({position:"absolute"});
			for(var w=0;w<m;w++){
				if(w==p){
					r.eq(w).show()
				}else{
					r.eq(w).hide()
				}
			}
		}
		function d(){
			f.bind("mouseenter",function(){
				if(!c.mouseOverAutoRolling){
					clearInterval(h)
				}
			});
			f.bind("mouseleave",function(){
				if(!c.mouseOverAutoRolling){t()}
			});
			/*
			k.bind("mouseenter",function(){
				p=a(this).index();
				n()
			});

			e.bind("mouseenter",function(){
				l(a(this).find("img"),"src","_off","_on")
			}).bind("mouseleave",function(){
				l(a(this).find("img"),"src","_on","_off")
			}).bind("click",function(){
				o="prev";
				u()
			});

			q.bind("mouseenter",function(){
				l(a(this).find("img"),"src","_off","_on")
			}).bind("mouseleave",function(){
				l(a(this).find("img"),"src","_on","_off")
			}).bind("click",function(){
				o="next";
				u()
			})
			*/
		}
		function u(){
			if(o=="next"){
				p=++p%m
			}else{
				p=(p==0)?m-1:--p%m
			}
			n()
		}
		function t(){
			h=setInterval(u,c.autoRollingTime)
		}
		function n(){
			//qe(p);
			r.eq(v)
				.stop(true,true)
				.fadeOut(c.motionSpeed)

				//alert(v);
			;

			r.eq(p)
				.stop(true,true)
				.fadeIn(c.motionSpeed)

				//qe(p);
				//alert(p);
			;
			qw(p);
			/*
			l(k.eq(v).find("img"),"src","_on","_off");
			l(k.eq(p).find("img"),"src","_off","_on");

			k.eq(v).removeClass("DB_select");
			k.eq(p).addClass("DB_select");
			v=p;
			*/
		}
		function l(x,A,w,y){
			var z=x.attr(A);
			if(String(z).search(w)!=-1){
				x.attr(A,z.replace(w,y))
			}
		}

		function qw(nums) {
			var wrapWidth = $("#subVisual").width();
			switch (nums)
			{
					case 0 : {
						//alert(nums);
							$(".counsel .slide_01 .img1").animate({top:127},1200,"easeInOutQuint");
							$(".counsel .slide_01 .img2").animate({top:215},1700,"easeInOutQuint");
						break;
					}
					case 1 : {
						//alert(nums);
							$(".counsel .slide_01 .img1").animate({top:180},1200,"easeInOutQuint");
							$(".counsel .slide_01 .img2").animate({top:264},1700,"easeInOutQuint");
						break;
					}

			}
		}





	}
)}
})(jQuery);


//-->

