(function($) {
    $.fn.DB_slideLogoMove = function(x) {
        var y = {
            key: '',
            moveSpeed: 40,
            overMoveSpeed: 15,
            dir: 'left'
        };
        $.extend(y, x);
        return this.each(function() {
            var p = $(this);
            var q = p.find('.DB_imgSet');
            var r = q.find('>li');
            var s = p.find('.DB_prev');
            var t = p.find('.DB_next');
            var u = 0;
            var v = r.length;
            var w = 0;
            init();

            function init() {

                setCss();
                setMouseEvent();
                setEnterFrame(y.moveSpeed)
            };

            function setCss() {
                q.css({
                    'position': 'absolute'
                });
                for (var i = 0; i < v; i++) {
                    q.append(r.eq(i).clone())
                }
            }

            function setMouseEvent() {
                q.bind('mouseenter', function() {
                    clearInterval(u)
                }).bind('mouseleave', function() {
                    setEnterFrame(y.moveSpeed)
                });
                t.bind('mouseenter', function() {
                    y.dir = 'left';
                    clearInterval(u);
                    setEnterFrame(y.overMoveSpeed)
                }).bind('mouseleave', function() {
                    clearInterval(u);
                    setEnterFrame(y.moveSpeed)
                });
                s.bind('mouseenter', function() {
                    y.dir = 'right';
                    clearInterval(u);
                    setEnterFrame(y.overMoveSpeed)
                }).bind('mouseleave', function() {
                    clearInterval(u);
                    setEnterFrame(y.moveSpeed)
                })
            }

            function setEnterFrame(a) {
                u = setInterval(setAnimation, a)
            }

            function setAnimation() {
                var a = q.outerWidth() / 2;
                switch (y.dir) {
                    case 'left':
                        q.css("left", w--);
                        if (Math.abs(w) >= a) {
                            w = 0
                        };
                        break;
                    case 'right':
                        q.css("left", w++);
                        if (w >= 0) {
                            w = -a
                        };
                        break
                }
            }
        })
    }
})(jQuery);