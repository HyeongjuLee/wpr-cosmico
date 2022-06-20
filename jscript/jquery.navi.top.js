(function(a){a.fn.top_menu_uls=function(b){
	var c={key:"",pageNum:null,subNum:null,subVisible:true,motionType:"none",motionSpeed:200,delayTime:0};

	a.extend(c,b);
	return this.each(function(){
		var l=a(this);
		var d=l.find(".DB_main");
		var f=d.find(".DB_sub>li");
		var h=d.length;
		var k=c.pageNum-1;
		var q=c.subNum-1;
		var e=k;
		var o=q;
		var g;
		var i=false;
			m();
			j()

		function m(){
			l.bind("mouseenter",function(){clearTimeout(g)});l.bind("mouseleave",function(){g=setTimeout(j,c.delayTime)});
			d.bind("mouseenter keyup",function(){i=true;e=a(this).index();if(e!=k){o=null}j()});
			d.bind("mouseleave",function(){i=false;if(e!=k){o=q}e=k});f.bind("mouseenter keyup",function(){o=a(this).index();j()});
			f.bind("mouseleave",function(){var r=a(this).parents(".DB_main").index();if(r==k){o=q}else{o=null}}
		)}

		function j(){
			for(var t=0;t<h;t++){
				var r=d.eq(t);
				if(e==t){
					if(c.subVisible||i){
						switch(c.motionType){
							case"fade":r.find(">ul").stop(true,true).fadeIn(c.motionSpeed);
								break;
							case"slide":r.find(">ul").stop(true,true).slideDown(c.motionSpeed);
								break;
							default:r.find(">ul").show()
						}
					}else{
						r.find(">ul").hide()
					}
					r.addClass("DB_select");
					n(r.find(">a>img"),"src","_off","_on");
					for(var s=0;s<r.find(">ul>li").length;s++){
						var u=r.find(">ul>li").eq(s);
						if(o==s){n(u.find(">a>img"),"src","_off","_on");
							u.addClass("DB_select")
						}else{
							u.removeClass("DB_select");
							n(u.find(">a>img"),"src","_on","_off")
						}
					}
				}else{
					switch(c.motionType){
						case"fade":r.find(">ul").stop(true,true).fadeOut(c.motionSpeed/2);
							break;
						case"slide":r.find(">ul").stop(true,true).slideUp(c.motionSpeed/2);
							break;
						default:r.find(">ul").hide()
					}
					r.removeClass("DB_select");
					n(r.find(">a>img"),"src","_on","_off")
				}
			}
		}

		function n(s,v,r,t){
			var u=s.attr(v);
			if(String(u).search(r)!=-1){
				s.attr(v,u.replace(r,t))
			}
		}
	}
)}})(jQuery);