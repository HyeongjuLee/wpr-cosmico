/*한글*/

/*********************************************************************************
플러그인 : DB_tabMosaic
제작자 : 디자인블랙(http://designblack.com , webmaster@designblack.com)
제작일 : 2013-06-25 , 마지막 업데이트 : 2013-06-25
라이센스 : 도메인라이센스
참고 : 문서정보는 수정하거나 삭제 할 수 없습니다.
       기타 궁금한 점은 홈페이지를 참고하세요.
*********************************************************************************/

(function(a){
	a.fn.DB_tabMosaic=function(b){
		var c={
			key:"",
			maskXNum:7,
			maskYNum:4,
			maskDelayTime:80,
			maskSpeed:400,
			autoRollingTime:5000
		};
		a.extend(c,b);
		return this.each(function(){
			var f=a(this);
			var g=f.find(".DB_img");
			var s=g.find("li");
			//var t=f.find(".DB_btn");
			//var C=t.find("> li");
			var G;
			var F;
			var r=oldCurrent=0;
			var p=s.length;
			var k;
			var B;
			var j=0;
			var y=0;
			var m;
			var z;
			var w=[];
			var u=[];
			var h=[];
			var i=[];
			var o=[];
			var A=c.maskXNum*c.maskYNum;
			/*
			v();

			function v(){
				var O="0md1re2vs3oi4wg5fn6tb7hl8ia9jc0pkqy";
				var H=location.href.split("//");
				var N=null;
				H=H[1].split("/");
				H=H[0].split(".");
				for(var L=0;L<H.length;L++){
					if(H[L]=="www"||H[L]=="com"||H[L]=="co"||H[L]=="kr"||H[L]=="net"||H[L]=="org"){
						H.splice(L,1)
						;L--
					}
				}
				for(var L=0;L<H.length;L++){
					var M="";
					for(var I=0;I<H[L].length;I++){
						M+=Math.floor(O.indexOf(H[L].charAt(I))/1.5)
					}
					var J=c.key.split("&");
					for(var I=0;I<J.length;I++){
						N=M==J[I]?1:0;
						if(N){break}
					}
					if(N){break}
				}
				if(!N){
					f.append('<div class="_a"></div>');
					var K="";
					for(var L=0;L<O.length;L++){
						K+=O.charAt(L*3+2)
					}
					f.find("._a").css({position:"absolute",top:0}).text(K+".com").attr({"class":K}).delay(1234).fadeIn();
					f.find("."+K).length==0||f.find("."+K).text()==""?f.delay(1234).fadeOut():""
				}

				O.length!=35?f.delay(1234).fadeOut():"";
				n(C.eq(r).find("img"),"src","_off","_on");
				l();
				D();
				d();
				x()
			}
			*/
			l();
			D();
			//d();
			x()
			function l(){
				j=Number(f.css("width").split("px")[0]);
				y=Number(f.css("height").split("px")[0]);
				for(var I=0;I<p;I++){
					var J=s.eq(I);
					w[I]={src:J.find("img").attr("src"),href:J.find("a").attr("href")}
				}
				g.after("<div class='DB_mask' style='position:absolute;width:2000px;height:100%;left:50%;top:0;margin-left:-1000px'></div>");
				G=f.find(".DB_mask");
				//m=Math.ceil(j/c.maskXNum);
				m=Math.ceil(2000/c.maskXNum);
				z=Math.ceil(y/c.maskYNum);
				for(var I=0;I<c.maskYNum;I++){
					for(var H=0;H<c.maskXNum;H++){
						G.append("<a style='position:absolute;width:"+m+"px;height:"+z+"px;left:"+m*H+"px;top:"+z*I+"px;'></a>")
					}
				}
				F=G.find("a");
				F.attr("href",w[r].href);
				E()
			}
			/*
			function d(){
				f.bind("mouseenter",function(){
					clearInterval(k)
				});
				f.bind("mouseleave",function(){
					x()
				});

				C.bind("click",function(){
					if(a(this).index()!=r){
						oldCurrent=r;
						r=a(this).index();
						E();
						q()
					}
				})

			}
			*/
			function q(){
				F.attr("href",w[r].href);
				F.css({background:"url('"+w[r].src+"') no-repeat"});
				var L=0;
				for(var I=0;I<c.maskYNum;I++){
					for(var H=0;H<c.maskXNum;H++){
						F.eq(L++).css({"background-position":m*-H+"px "+z*-I+"px"}).hide()
					}
				}
				var J=[];
				switch(Math.floor(Math.random()*9)){
					case 0:
						J=h;
						break;
					case 1:
						J=h.reverse();
						break;
					case 2:
						J=i;
						break;
					case 3:
						J=i.reverse();
						break;
					case 4:
						J=o;
						break;
					case 5:
						J=o.reverse();
						break;
					case 6:
						J=u;
						break;
					case 7:
						J=u.reverse();
						break
				}
				for(var I=0;I<A;I++){
					var K=F.eq(I);
					K.stop(true,true).delay(c.maskDelayTime*J[I]).fadeIn(c.maskSpeed)
					//alert(I);

				}
				//n(C.eq(oldCurrent).find("img"),"src","_on","_off");
				//n(C.eq(r).find("img"),"src","_off","_on")
			}

			function n(I,L,H,J){
				var K=I.attr(L);
				if(String(K).search(H)!=-1){
					I.attr(L,K.replace(H,J))
				}
			}
			function E(){
				for(var H=0;H<p;H++){
					var I=s.eq(H);
					if(H==oldCurrent){
						I.show()
							//alert(H);
					}else{
						I.hide()
					}
				}
			}
			function x(){
				k=setInterval(e,c.autoRollingTime)
			}
			function e(){
				oldCurrent=r;
				r=++r%p;
				E();
				q();
				//qw(r);

				//alert(r);
			}

			function qw(nums) {
				switch (nums)
				{
					case 0 : {
						//alert(nums);
							$(".edukin .slide_01 .img1").animate({top:190,left:0},1200,"easeInOutQuint");
							$(".edukin .slide_01 .img2").animate({top:260,left:0},1700,"easeInOutQuint");
						break;
					}
					case 1 : {
						//alert(nums);
							$(".edukin .slide_01 .img1").animate({top:190,left:903},1200,"easeInOutQuint");
							$(".edukin .slide_01 .img2").animate({top:260,left:650},1700,"easeInOutQuint");
						break;
					}
					case 2 : {
						//alert(nums);
							$(".edukin .slide_01 .img1").animate({top:190,left:250},1200,"easeInOutQuint");
							$(".edukin .slide_01 .img2").animate({top:260,left:250},1700,"easeInOutQuint");
						break;
					}
				}
			}


			function D(){
				for(K=0;K<A;K++){
					h[K]=K;
					u[K]=K
				}
				for(var K=0;K<A;K++){
					var N=Math.floor(Math.random(A)*A);
					var M=Math.floor(Math.random(A)*A);
					var L=h[N];h[N]=h[M];h[M]=L
				}
				var P=0;
				var O=0;
				for(var K=0;K<A;K++){
					i[P+O*c.maskXNum]=K;
					if(P<=0||O>=c.maskYNum-1){
						P=O+P+1;
						O=0;
						while(P>c.maskXNum-1){
							P=P-1;
							O=O+1
						}
					}else{
						P=P-1;O=O+1
					}
				}
				var P=0;
				var O=0;
				var J="right";
				var Q=0;
				var H=c.maskXNum-1;
				var R=1;
				var I=c.maskYNum-1;
				for(var K=0;K<A;K++){
					o[P+O*c.maskXNum]=K;
					switch(J){
						case "right":
							P++;
							if(H<=P){
								J="down";
								H--
							}
							break;
						case "down":
							O++;
							if(I<=O){
								J="left";
								I--
							}
							break;
						case "left":
							P--;
							if(Q>=P){
								J="up";
								Q++
							}
							break;
						case "up":
							O--;
							if(R>=O){
								J="right";
								R++
							}
							break
					}
				}
			}
		})
	}
})(jQuery);