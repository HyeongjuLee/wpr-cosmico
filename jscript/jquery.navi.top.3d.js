(function(a) {
    a.fn.DB_navi3D = function(b) {
        var c = {
            key: "",
            depth1: null,
            depth2: null,
            depth3: null,
            delayTime: 500
        };
        a.extend(c, b);
        return this.each(function() {
            var i = a(this);
            var l = i.find(".DB_1D");
            var g = i.find(".DB_2D");
            var d = i.find(".DB_3D");
            var p = fix1 = c.depth1 - 1;
            var n = fix2 = c.depth2 - 1;
            var m = fix3 = c.depth3 - 1;
            var e = 0;
            var f = false;
            r();

            function r() {
                j();
                p = fix1;
                n = fix2;
                m = fix3;
                h()
            }

            function j() {
                i.bind("mouseenter", function() {
                    f = true;
                    clearTimeout(e)
                });
                i.bind("mouseleave", function() {
                    f = false;
                    p = fix1;
                    n = fix2;
                    m = fix3;
                    e = setTimeout(h, c.delayTime)
                });
                l.bind("mouseenter keyup", function() {
                    f = true;
                    p = a(this).index();
                    s()
                });
                l.bind("mouseleave", function() {
                    if (a(this).index() != fix1) {
                        n = null;
                        q()
                    }
                });
                g.bind("mouseenter keyup", function() {
                    n = a(this).index();
                    q()
                });
                g.bind("mouseleave", function() {
                    if (a(this).index() != fix2) {
                        m = null;
                        o()
                    }
                });
                d.bind("mouseenter keyup", function() {
                    m = a(this).index();
                    o()
                });
                d.bind("mouseleave", function() {})
            }

            function h() {
                s();
                q();
                o()
            }

            function s() {
                var v = l;
                for (var t = 0; t < v.length; t++) {
                    var u = v.eq(t);
                    if (t == p) {
                        u.addClass("DB_select");
                        if (f) {
                            u.find(">ul").show()
                        } else {
                            u.find(">ul").hide()
                        }
                        k(u.find(">a>img"), "src", "_off", "_on")
                    } else {
                        u.removeClass("DB_select").find(">ul").hide();
                        k(u.find(">a>img"), "src", "_on", "_off")
                    }
                }
            }

            function q() {
                var v = l.eq(p).find(".DB_2D");
                for (var t = 0; t < v.length; t++) {
                    var u = v.eq(t);
                    if (t == n) {
                        u.addClass("DB_select").find(">ul").show()
                    } else {
                        u.removeClass("DB_select").find(">ul").hide()
                    }
                }
            }

            function o() {
                var u = l.eq(p).find(".DB_2D").eq(n).find(".DB_3D");
                for (var t = 0; t < u.length; t++) {
                    var v = u.eq(t);
                    if (t == m) {
                        v.addClass("DB_select").find(">ul").show()
                    } else {
                        v.removeClass("DB_select").find(">ul").hide()
                    }
                }
            }

            function k(u, x, t, v) {
                var w = u.attr(x);
                if (String(w).search(t) != -1) {
                    u.attr(x, w.replace(t, v))
                }
            }
        })
    }
})(jQuery);