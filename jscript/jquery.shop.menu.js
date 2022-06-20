(function($) {
    $.fn.d_navi2DLine = function(z) {
        var A = {
            key: '',
            pageNum: null,
            subVisible: false,
            motionType: 'none',
            motionSpeed: 200,
            lineSpeed: 150,
            delayTime: 0
        };
        $.extend(A, z);
        return this.each(function() {
            var p = $(this);
            var q = p.find('.mainLi');
            var r = q.find('.subUL>li');
            var t = q.length;
            if (A.pageNum > 0) {
                var u = A.pageNum - 1
            }
            var v = u;
            var w;
            var x = false;
            var y = q.css('margin-right').slice(0, -2) * 1;
                setMouseEvent();
                setAnimation()



            function setMouseEvent() {
                p.bind('mouseenter', function() {
                    clearTimeout(w)
                });
                p.bind('mouseleave', function() {
                    w = setTimeout(setAnimation, A.delayTime)
                });
                q.bind('mouseenter keyup', function() {
                    x = true;
                    v = $(this).index();
                    setAnimation()
                });
                q.bind('mouseleave', function() {
                    x = false;
                    v = u
                });
                r.bind('mouseenter keyup', function() {
                    setAnimation()
                });
                r.bind('mouseleave', function() {
                    var a = $(this).parents('.d_main').index()
                })
            }

            function setAnimation() {
                for (var i = 0; i < t; i++) {
                    var a = q.eq(i);
                    if (v == i) {
                        if (A.subVisible || x) {
                            switch (A.motionType) {
                                case 'fade':
                                    a.find('>ul').stop(true, true).fadeIn(A.motionSpeed);
                                    break;
                                case 'slide':
                                    a.find('>ul').stop(true, true).slideDown(A.motionSpeed);
                                    break;
                                default:
                                    a.find('>ul').show()
                            }
                        } else {
                            a.find('>ul').hide()
                        }
                        a.addClass('on');
                        setReplace(a.find('>a>img'), 'src', '_off', '_on')
                    } else {
                        switch (A.motionType) {
                            case 'fade':
                                a.find('>ul').stop(true, true).fadeOut(A.motionSpeed / 2);
                                break;
                            case 'slide':
                                a.find('>ul').stop(true, true).slideUp(A.motionSpeed / 2);
                                break;
                            default:
                                a.find('>ul').hide()
                        }
                        a.removeClass('on');
                        setReplace(a.find('>a>img'), 'src', '_on', '_off')
                    }
                }
            }

            function setReplace(a, b, c, d) {
                var e = a.attr(b);
                if (String(e).search(c) != -1) {
                    a.attr(b, e.replace(c, d))
                }
            }
        })
    }
})(jQuery);