(function(a) {
    a.fn.DB_slideStepMove = function(b) {
        var c = {
            key: "",
            motionDirection: "x",
            moveDistance: 1000,
            moveSpeed: 300,
            autoRollingTime: 5000,
            random: false
        };
        a.extend(c, b);
        return this.each(function() {
            var i = a(this);
            var g = i.find(".bM_moveSet");
            var t = g.find(">li");
            var s = i.find(".bM_nextBtn");
            var h = i.find(".bM_prevBtn");
            var n = i.find(".bM_pageSet");
            var y = n.length;
            if (y) {
                var w = n.find(".bM_currentPage");
                var k = n.find(".bM_totalPage");
                var u = 0
            }
            var o = t.length;
            var r = 0;
            if (c.random) {
                r = -Math.floor(Math.random() * o)
            }
            var q = "next";
            var x = [];
            var j = 1;
            var l;
            v();

            function v() {

                d();
                f();
                e();
                m()
            }

            function d() {
                for (var A = 0; A < o; A++) {
                    var B = t.eq(A);
                    x[A] = B;
                    x[A].data("pos", c.moveDistance * A);
                    if (c.motionDirection == "y") {
                        B.css({
                            "position": "absolute",
                            "top": c.moveDistance * A
                        });
                        if (A == 0) {
                            g.css("top", c.moveDistance * r)
                        }
                    } else {
                        B.css({
                            "position": "absolute",
                            "left": c.moveDistance * A
                        });
                        if (A == 0) {
                            g.css("left", c.moveDistance * r)
                        }
                    }
                }
                for (var A = 0; A < Math.abs(r); A++) {
                    if (c.motionDirection == "y") {
                        var z = x[o - 1].data("pos") + c.moveDistance;
                        x[0].data("pos", z);
                        x[0].css({
                            top: z
                        });
                        x.push(x.shift())
                    } else {
                        var z = x[o - 1].data("pos") + c.moveDistance;
                        x[0].data("pos", z);
                        x[0].css({
                            left: z
                        });
                        x.push(x.shift())
                    }
                }
                g.css({
                    position: "absolute"
                })
            }

            function f() {
                i.bind("mouseenter", function() {
                    clearInterval(l)
                }).bind("mouseleave", function() {
                    e()
                });
                s.bind("click", function() {
                    if (j) {
                        j = 0;
                        q = "next";
                        p()
                    }
                });
                h.bind("click", function() {
                    if (j) {
                        j = 0;
                        q = "prev";
                        p()
                    }
                })
            }

            function p() {
                if (c.motionDirection == "y") {
                    if (q == "next") {
                        r--
                    } else {
                        r++;
                        var z = x[0].data("pos") - c.moveDistance;
                        x[o - 1].data("pos", z);
                        x[o - 1].css({
                            top: z
                        });
                        x.unshift(x.pop())
                    }
                    g.stop().animate({
                        top: c.moveDistance * r
                    }, c.moveSpeed, function() {
                        j = 1;
                        if (q == "next") {
                            var A = x[o - 1].data("pos") + c.moveDistance;
                            x[0].data("pos", A);
                            x[0].css({
                                top: A
                            });
                            x.push(x.shift())
                        }
                        m()
                    })
                } else {
                    if (c.motionDirection == "x") {
                        if (q == "next") {
                            r--
                        } else {
                            r++;
                            var z = x[0].data("pos") - c.moveDistance;
                            x[o - 1].data("pos", z);
                            x[o - 1].css({
                                left: z
                            });
                            x.unshift(x.pop())
                        }
                        g.stop().animate({
                            left: c.moveDistance * r
                        }, c.moveSpeed, function() {
                            j = 1;
                            if (q == "next") {
                                var A = x[o - 1].data("pos") + c.moveDistance;
                                x[0].data("pos", A);
                                x[0].css({
                                    left: A
                                });
                                x.push(x.shift())
                            }
                            m()
                        })
                    } else {
                        if (q == "next") {
                            r--;
                            var z = x[o - 1].data("pos") + c.moveDistance;
                            x[0].data("pos", z);
                            x[0].css({
                                left: z
                            });
                            x.push(x.shift())
                        } else {
                            r++;
                            var z = x[0].data("pos") - c.moveDistance;
                            x[o - 1].data("pos", z);
                            x[o - 1].css({
                                left: z
                            });
                            x.unshift(x.pop())
                        }
                        g.css({
                            left: c.moveDistance * r
                        });
                        j = 1;
                        m()
                    }
                }
            }

            function e() {
                l = setInterval(p, c.autoRollingTime)
            }

            function m() {
                if (y) {
                    if (q == "next") {
                        u = u == o ? 1 : ++u
                    } else {
                        u = u == 1 ? o : --u
                    }
                    w.text(u);
                    k.text(o)
                }
            }
        })
    }
})(jQuery);