(function() {
  var defaults, root;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  root.Backstretch = (function() {
    function Backstretch(src, settings) {
      this.src = src;
      this.settings = settings != null ? settings : {};
      defaults(this.settings, {
        centeredX: true,
        centeredY: true,
        speed: 1.0
      });
      if (this.src) {
        this.container = document.createElement('div');
        this.container.id = 'backstretch';
        $(this.container).css({
          left: 0,
          top: 0,
          position: "fixed",
          overflow: "hidden",
          zIndex: -998
        });
        this.create_image();
        $('body').prepend(this.container);
        this.img.src = this.src;
      }
      $(window).resize(__bind(function() {
        return this.adjust();
      }, this));
      this;
    }
    Backstretch.prototype.create_image = function() {
      this.img = document.createElement("img");
      $(this.img).css({
        position: "relative",
        display: "none"
      }).load(__bind(function(event) {
        ($(this.container)).prepend(this.img);
        this.ratio = this.img.width / this.img.height;
        this.adjust();
        return ($(this.img)).fadeIn(this.settings.speed);
      }, this));
      return this;
    };
    Backstretch.prototype.change_source = function(src) {
      if (src !== this.img.src) {
        ($(this.img)).fadeOut(__bind(function() {
          ($(this.img)).remove();
          this.create_image();
          return this.img.src = src;
        }, this));
      }
      return this;
    };
    Backstretch.prototype.adjust = function() {
      var bgCSS, bgHeight, bgOffset, bgWidth, rootElement, _height, _width;
      rootElement = "onorientationchange" in window ? $(document) : $(window);
      _width = rootElement.width();
      _height = rootElement.height();
      bgCSS = {
        left: 0,
        top: 0
      };
      bgWidth = _width;
      bgHeight = bgWidth / this.ratio;
      if (bgHeight >= _height) {
        bgOffset = (bgHeight - _height) / 2;
        if (this.settings.centeredY) {
          $.extend(bgCSS, {
            top: "-" + bgOffset + "px"
          });
        }
      } else {
        bgHeight = _height + 10;
        bgWidth = bgHeight * this.ratio;
        bgOffset = (bgWidth - _width) / 2;
        if (this.settings.centeredX) {
          $.extend(bgCSS, {
            left: "-" + bgOffset + "px"
          });
        }
      }
      ($(this.img)).css({
        width: "" + bgWidth + "px",
        height: "" + bgHeight + "px"
      }).css(bgCSS);
      return this;
    };
    return Backstretch;
  })();
  defaults = (typeof _ !== "undefined" && _ !== null ? _.defaults : void 0) != null ? _.defaults : function(obj) {
    $.each(Array.prototype.slice.call(arguments, 1), function(source) {
      var prop, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = source.length; _i < _len; _i++) {
        prop = source[_i];
        _results.push(obj[prop] === null ? obj[prop] = source[prop] : void 0);
      }
      return _results;
    });
    return obj;
  };
}).call(this);
