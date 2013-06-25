define [
  'jquery'
  'underscore'
  'backbone'
  'misc/angle'
  'text!templates/clock.html'
], ($, _, Backbone, Angle, clockTemplate) ->

  # A visual representation of the clock. 
  # This class includes a lot of calculation, but since it's got nothing to do with the 
  # logic of the application, I decided to put it here.
  class ClockView extends Backbone.View

    constructor: (params) ->
      # The scla of the clock in percent of the size
      # @type {number}
      @scale = params.scale or 1
      
      # Syncs the hands of the clock with the current local time when true.
      # Starts with zero/twelve otherwise.
      # @type {number}
      @sync = if params.sync? then params.sync else false

      # The color for drawing the work peried slices
      # @type {string}
      @workColor = '#8ac3e9'
      
      # The color for drawing the free peried slices
      # @type {string}
      @freeColor = '#6496b4'

      super params

    # Binds Methods to various change events.
    # Sets initial values to properties and renders the clock.
    # Also caches the jQuery objects that are needed frequently.
    initialize: ->
      @resize = _.throttle(@resize, 50)
      $(window).bind('resize', @resize)

      @model.bind('change:syncSecond', @rotateHands)
      @model.bind('change:workTime', @draw)
      @model.bind('change:freeTime', @draw)
      @model.bind('change:isBreak', @redraw)
      @model.bind('reset', @redraw)

      # The angle where to start drawing the circles.
      # @type {Angle}
      @initialAngle = @calculateCurrentAngle()

      @render()

      @$secondHand = @$('.second-hand').first()
      @$minuteHand = @$('.minute-hand').first()
      @$hourHand = @$('.hour-hand').first()
      @rotateHands()

    # Calculates and returns the current angle of the minute hand in the model.
    # The current angle is the angle of the real time minute-hand on synced clocks.
    # However, in order to point to 12 o'clock a offset of 3/2 pi is required.
    # @returns {!Angle} The current angle of the minute hand in radians.
    calculateCurrentAngle: () =>
      currentAngle = Angle.initRadians(1.5*Math.PI)

      if @sync
        second = @model.get('syncSecond')
        minute = @model.get('syncMinute')
      else
        second = @model.get('unsyncSecond')
        minute = @model.get('unsyncMinute')

      return currentAngle.add(Angle.initMinutes(minute + second/60))

    # Like draw, but updates the initial angle first.
    redraw: () =>
      @initialAngle = @calculateCurrentAngle()
      @draw()

    # The pre-compiled underscore template for the clock
    template: _.template(clockTemplate)

    # Renders the clock from the template and adjusts the diameter.
    render: =>
      @$el.html(@template(@model.toJSON()))
      @resize()

    # Sets the diameter of the clock and the height the hands.
    # Also resets the width and height attributes of the canvas element.
    # Further the font-size for the numbers on the clock is determined.
    # Since a change in size also effects the slices in the canvas they have to be redrawn.
    resize: =>
      @size = size = @calculateSize(@scale)
      
      @$el.width(size).height(size)
      @$('.hand').height(size)
      @$('.slices').first().attr('width':size, 'height':size)
      
      fontSize = Math.round(size*.1)
      @$('.number').css(
        fontSize: fontSize
        marginTop: -(fontSize/2)
      )

      fontSize = Math.round(size*.08)
      @$('.clock-name').css(
        fontSize: fontSize
      )

      fontSize = Math.round(size*.019)
      @$('.tag-line, .by').css(
        fontSize: fontSize
      )

      @draw()
      
    # This function is similar to the render function.
    # While the render function constructs the basic clock elements with HTML.
    # this function only "draws" the time slices which represent work- and free time on a 
    # canvas element.
    # Delegates to composeSlices and drawSlice.
    draw: =>
      slices = @composeSlices()

      canvas = @$('.slices').first()
      c = canvas[0].getContext('2d')

      c.clearRect(0, 0, @size, @size )

      for slice in slices
        @drawSlice(c, slice)

    # Composes an array with data required to draw the time slices on the clock
    # The slices will always draw a full circle, but the last slice will be cropped.
    # @returns {!Array<Object>} An array containing the data required for drawing the slices 
    composeSlices: ->
      slices = []
      workTime = @model.get('workTime')
      freeTime = @model.get('freeTime')
      size = @size

      n = 0
      sumTime = 0
      alternate = @model.get('isBreak')

      while sumTime < 60
        if alternate
          sumTime += freeTime
          n++
        else
          sumTime += workTime
          n++
        alternate = !alternate

      offsetAngle = Angle.initRadians(@initialAngle.getRadians())
      radius = size/2
      alternate = @model.get('isBreak')

      for i in [0..n-1]
        t = if alternate then freeTime else workTime
        endAngle = offsetAngle.add(Angle.initSeconds(t))

        completeCircle = @initialAngle.add(Angle.initDegrees(360))
        if endAngle.compareTo(completeCircle) > 0
          endAngle = completeCircle

        slices.push(
          radius: radius
          startAngle: offsetAngle
          endAngle: endAngle
          isBreak: alternate
        )
        radius *= 0.68

        offsetAngle = endAngle
        alternate = !alternate

      return slices

    # Calculates the size of the app depending on the window size.
    # The size is also the diameter of the clock and is set to fit the screen.
    # @param {number} scale 
    # @returns {number} The desired size/diameter of the clock in pixels
    calculateSize: (scale) =>
      width = $('.c50').width()
      height = $(window).height()
    
      size = if (width <= height) then width else height
      size = Math.floor(size*scale)
    
      return size

    # Draws a single slice on a given 2d-context width the specified data
    # @param {!CanvasRenderingContext2D} c A 2d-context of a canvas element.
    # @param {!Object} slice The data required to draw the slice.
    drawSlice: (c, slice) =>
      size = @size
      startX = size/2
      startY = size/2
      radius = slice.radius
      startAngle = slice.startAngle.getRadians()
      endAngle = slice.endAngle.getRadians()
      
      color = if slice.isBreak then @freeColor else @workColor
      sliceGradient = c.createLinearGradient(0, 0, size/2, size/2)
      sliceGradient.addColorStop(0, '#eee')
      sliceGradient.addColorStop(1, color)

      c.beginPath()
      c.moveTo(startX, startY)
      c.arc(startX, startY, radius, startAngle, endAngle, false)
      c.lineTo(startX, startY)
      c.closePath()
      c.fillStyle = sliceGradient
      c.fill()

    # Makes the clock go round.
    # Calculates the angles of the hands from the model data and moves them accordingly.
    rotateHands: =>
      if @sync
        second = @model.get('syncSecond')
        minute = @model.get('syncMinute')
        hour = @model.get('syncHour')
      else
        second = @model.get('unsyncSecond')
        minute = @model.get('unsyncMinute')
        hour = @model.get('unsyncHour')

      secondAngle = Angle.initSeconds(second)
      minuteAngle = Angle.initMinutes(minute + second/60)
      hourAngle = Angle.initHours(hour + minute/60 + second/3600)

      @rotateHand(@$secondHand, secondAngle)
      @rotateHand(@$minuteHand, minuteAngle)
      @rotateHand(@$hourHand, hourAngle)

    # Helper function that sets the cross-browser css styles.
    # @param {Object} $hand A jQuery object that points to the hand to be moved.
    # @param {Angle} angle The new angle of the hand in degrees.
    rotateHand: ($hand, angle) =>
      $hand.css(
        '-moz-transform': "rotate(#{ angle })"
        '-webkit-transform': "rotate(#{ angle })"
        '-o-transform': "rotate(#{ angle })"
        '-ms-transform': "rotate(#{ angle })"
        '-transform': "rotate(#{ angle })"
      )

  return ClockView
