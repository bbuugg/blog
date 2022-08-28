---
title: 在使用editormd富文本编辑器时使用懒加载
date: 2020-07-09 21:06:39
tags:
---

# 一、以下为怎么解决编辑器输出懒加载问题
&gt; 因为懒加载使用的的原理是先给img标签一个非src的属性，例如`data-original = 'http://.jpg'` ，属性的值为图片地址，然后在网页滚动的时候将可见区域的图片添加`src`属性或将其`src`属性值改为`data-original`的值，这样完成懒加载。

但是`editormd`的图片解析规则直接将其输出src属性，不能完成懒加载，因此我们需要修改源代码

## 首先找到editormd\lib\marked.min.js

搜索`Renderer.prototype.image`并将`&lt;img src= `改为 `&lt;img data-original=`或者你的自定义属性
这样可以在显示的时候实现懒加载，但是我们在编辑的时候又需要预览图片，而解析出来的img没有src属性，所以不能正常预览。

## 于是我们可以找到editormd\editormd.min.js 文件

搜索类似于`l.pageBreak`这样的关键字，然后添加一串代码

```javascript
l.image = function (e,i,o) {
        var out = '&lt;img src=&quot;' + e + '&quot; alt=&quot;' + o + '&quot;';
        if (i) {
            out += ' title=&quot;' + i + '&quot;'
        }
        out += this.options.xhtml ? &quot;/&gt;&quot; : &quot;&gt;&quot;;
        return out
}
```
刷新页面就会看到效果啦，既能实现懒加载， 又能在编辑的时候预览。

# 二、以下为懒加载部分

1. 先将需要懒加载的图片的`src`属性改为`data-original` ，属性值不变

2. 引入以下js
```javascript
(function ($, window, document, undefined) {
    var $window = $(window);
    $.fn.lazyload = function (options) {
        var elements = this;
        var $container;
        var settings = {
            threshold: 0,
            failure_limit: 0,
            event: &quot;scroll&quot;,
            effect: &quot;show&quot;,
            container: window,
            data_attribute: &quot;original&quot;,
            skip_invisible: true,
            appear: null,
            load: null,
            placeholder: &quot;data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC&quot;
        };

        function update() {
            var counter = 0;
            elements.each(function () {
                var $this = $(this);
                if (settings.skip_invisible &amp;&amp; !$this.is(&quot;:visible&quot;)) {
                    return;
                }
                if ($.abovethetop(this, settings) || $.leftofbegin(this, settings)) {
                } else if (!$.belowthefold(this, settings) &amp;&amp; !$.rightoffold(this, settings)) {
                    $this.trigger(&quot;appear&quot;);
                    counter = 0;
                } else {
                    if (++counter &gt; settings.failure_limit) {
                        return false;
                    }
                }
            });
        }

        if (options) {
            if (undefined !== options.failurelimit) {
                options.failure_limit = options.failurelimit;
                delete options.failurelimit;
            }
            if (undefined !== options.effectspeed) {
                options.effect_speed = options.effectspeed;
                delete options.effectspeed;
            }
            $.extend(settings, options);
        }
        $container = (settings.container === undefined || settings.container === window) ? $window : $(settings.container);
        if (0 === settings.event.indexOf(&quot;scroll&quot;)) {
            $container.bind(settings.event, function () {
                return update();
            });
        }
        this.each(function () {
            var self = this;
            var $self = $(self);
            self.loaded = false;
            if ($self.attr(&quot;src&quot;) === undefined || $self.attr(&quot;src&quot;) === false) {
                if ($self.is(&quot;img&quot;)) {
                    $self.attr(&quot;src&quot;, settings.placeholder);
                }
            }
            $self.one(&quot;appear&quot;, function () {
                if (!this.loaded) {
                    if (settings.appear) {
                        var elements_left = elements.length;
                        settings.appear.call(self, elements_left, settings);
                    }
                    $(&quot;&lt;img /&gt;&quot;).bind(&quot;load&quot;, function () {
                        var original = $self.attr(&quot;data-&quot; + settings.data_attribute);
                        $self.hide();
                        if ($self.is(&quot;img&quot;)) {
                            $self.attr(&quot;src&quot;, original);
                        } else {
                            $self.css(&quot;background-image&quot;, &quot;url('&quot; + original + &quot;')&quot;);
                        }
                        $self[settings.effect](settings.effect_speed);
                        self.loaded = true;
                        var temp = $.grep(elements, function (element) {
                            return !element.loaded;
                        });
                        elements = $(temp);
                        if (settings.load) {
                            var elements_left = elements.length;
                            settings.load.call(self, elements_left, settings);
                        }
                    }).attr(&quot;src&quot;, $self.attr(&quot;data-&quot; + settings.data_attribute));
                }
            });
            if (0 !== settings.event.indexOf(&quot;scroll&quot;)) {
                $self.bind(settings.event, function () {
                    if (!self.loaded) {
                        $self.trigger(&quot;appear&quot;);
                    }
                });
            }
        });
        $window.bind(&quot;resize&quot;, function () {
            update();
        });
        if ((/(?:iphone|ipod|ipad).*os 5/gi).test(navigator.appVersion)) {
            $window.bind(&quot;pageshow&quot;, function (event) {
                if (event.originalEvent &amp;&amp; event.originalEvent.persisted) {
                    elements.each(function () {
                        $(this).trigger(&quot;appear&quot;);
                    });
                }
            });
        }
        $(document).ready(function () {
            update();
        });
        return this;
    };
    $.belowthefold = function (element, settings) {
        var fold;
        if (settings.container === undefined || settings.container === window) {
            fold = (window.innerHeight ? window.innerHeight : $window.height()) + $window.scrollTop();
        } else {
            fold = $(settings.container).offset().top + $(settings.container).height();
        }
        return fold &lt;= $(element).offset().top - settings.threshold;
    };
    $.rightoffold = function (element, settings) {
        var fold;
        if (settings.container === undefined || settings.container === window) {
            fold = $window.width() + $window.scrollLeft();
        } else {
            fold = $(settings.container).offset().left + $(settings.container).width();
        }
        return fold &lt;= $(element).offset().left - settings.threshold;
    };
    $.abovethetop = function (element, settings) {
        var fold;
        if (settings.container === undefined || settings.container === window) {
            fold = $window.scrollTop();
        } else {
            fold = $(settings.container).offset().top;
        }
        return fold &gt;= $(element).offset().top + settings.threshold + $(element).height();
    };
    $.leftofbegin = function (element, settings) {
        var fold;
        if (settings.container === undefined || settings.container === window) {
            fold = $window.scrollLeft();
        } else {
            fold = $(settings.container).offset().left;
        }
        return fold &gt;= $(element).offset().left + settings.threshold + $(element).width();
    };
    $.inviewport = function (element, settings) {
        return !$.rightoffold(element, settings) &amp;&amp; !$.leftofbegin(element, settings) &amp;&amp; !$.belowthefold(element, settings) &amp;&amp; !$.abovethetop(element, settings);
    };
    $.extend($.expr[&quot;:&quot;], {
        &quot;below-the-fold&quot;: function (a) {
            return $.belowthefold(a, {threshold: 0});
        }, &quot;above-the-top&quot;: function (a) {
            return !$.belowthefold(a, {threshold: 0});
        }, &quot;right-of-screen&quot;: function (a) {
            return $.rightoffold(a, {threshold: 0});
        }, &quot;left-of-screen&quot;: function (a) {
            return !$.rightoffold(a, {threshold: 0});
        }, &quot;in-viewport&quot;: function (a) {
            return $.inviewport(a, {threshold: 0});
        }, &quot;above-the-fold&quot;: function (a) {
            return !$.belowthefold(a, {threshold: 0});
        }, &quot;right-of-fold&quot;: function (a) {
            return $.rightoffold(a, {threshold: 0});
        }, &quot;left-of-fold&quot;: function (a) {
            return !$.rightoffold(a, {threshold: 0});
        }
    });
})(jQuery, window, document);
```

3. 在需要懒加载的页面添加`$(&quot;img&quot;).lazyload({effect: &quot;fadeIn&quot;});` 前提是你的页面已经引入`jquery`