#
# OO Backstretch
# Version 1.0
#
# An adaptation of jQuery Backstretch that allows for crossfading images with an object-oriented API.
# http://srobbin.com/jquery-plugins/jquery-backstretch/
#
# Add a dynamically-resized background image to the page
#
# Copyright (c) 2011 Scott Robbin (srobbin.com), Austin Bales (austinbales.com)
# Dual licensed under the MIT and GPL licenses.
#

root = exports ? this

class root.Backstretch
  constructor: (@src, @settings = {}) ->

    defaults @settings,
      centeredX: true    #  Should we center the image on the X axis?
      centeredY: true    #  Should we center the image on the Y axis?
      speed: 1.0         #  fadeIn speed for background after image loads (e.g. "fast" or 500)

    if @src
      # Prepend image, wrapped in a DIV, with some positioning and zIndex voodoo
      @container = document.createElement 'div'
      @container.id = 'backstretch'

      $(@container).css({left: 0, top: 0, position: "fixed", overflow: "hidden", zIndex: -998})
      @create_image()
      $('body').prepend @container
      @img.src = @src

    $(window).resize =>
      @adjust()

    this # for chaining

  create_image: ->
    @img = document.createElement("img")
    $(@img).css({position: "relative", display: "none"})
           .load (event) =>
             ($ @container).prepend @img
             @ratio = @img.width / @img.height
             # Internet Explorer doesn't seem to be able to detect proper width until after the element
             # is set with display:block`d. The jQuery solution for this is different.
             # if Prototype.Browser.IE
             #   @img.appear({duration:@settings.speed, after: => @adjust()})
             # else
             @adjust()
             ($ @img).fadeIn(@settings.speed)
    this

  change_source: (src) ->
    # If the source is the same, don't bother.
    if src != @img.src
      ($ @img).fadeOut =>
        ($ @img).remove() # Removing and re-adding the element prevents a racy flicker in IE.
        @create_image()
        @img.src = src
    this

  adjust: ->
    rootElement = if ("onorientationchange" of window) then $(document) else $(window) # hack to acccount for iOS position:fixed shortcomings

    _width = rootElement.width()
    _height = rootElement.height()

    bgCSS = {left:0, top:0}
    bgWidth = _width
    bgHeight = bgWidth / @ratio

    # Make adjustments based on image ratio
    # Note: Offset code provided by Peter Baker (http://ptrbkr.com/). Thanks, Peter!
    if bgHeight >= _height
      bgOffset = (bgHeight - _height) / 2
      if @settings.centeredY
        $.extend(bgCSS, {top: "-#{bgOffset}px"})
    else
      bgHeight = _height + 10
      bgWidth = bgHeight * @ratio
      bgOffset = (bgWidth - _width) / 2
      if @settings.centeredX
        $.extend bgCSS, {left: "-#{bgOffset}px"}
    ($ @img).css({width: "#{bgWidth}px"; height:"#{bgHeight}px"}).css(bgCSS)
    this

# If you're using underscore, then pull in _.defaults,
# otherwise, recreate it.
defaults = if _?.defaults? then _.defaults else (obj) ->
  $.each Array::slice.call(arguments, 1), (source) ->
    for prop in source
      obj[prop] = source[prop] if obj[prop] is null
  obj