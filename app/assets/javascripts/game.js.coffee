# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# palette colors 

colors = ['yellow', 'cornflowerblue', 'crimson', 'darkseagreen', 'black', 'white']

clickX = new Array
clickY = new Array
clickDrag = new Array
clickColor = new Array
context = new Object
curColor = new Object
curColorIndex = undefined
paint = undefined
mobile = undefined
lastStrokeClickCount = 0

addClick = (x, y, dragging) ->
  lastStrokeClickCount += 1
  clickX.push x
  clickY.push y
  clickDrag.push dragging
  clickColor.push curColor
  document.getElementById("game_clickX").value = clickX;
  document.getElementById("game_clickY").value = clickY;
  document.getElementById("game_clickDrag").value = clickDrag;
  document.getElementById("game_clickColor").value = clickColor;
  return
  
safeSplice = (array) ->
  array.splice(-lastStrokeClickCount)
  return

removeLastStroke = ->
  safeSplice clickX
  safeSplice clickY
  safeSplice clickDrag
  safeSplice clickColor
  redraw()
  return

redraw = ->
  context.clearRect 0, 0, context.canvas.width, context.canvas.height
  # Clears the canvas
  context.strokeStyle = '#df4b26'
  context.lineJoin = 'round'
  context.lineWidth = 5
  #console.log(clickDrag)
  console.log(clickX)
  #console.log(clickY)
  #console.log(clickColor)
  i = 0
  while i < clickX.length
    context.beginPath()
    if clickDrag[i] and i
      context.moveTo clickX[i - 1], clickY[i - 1]
    else
      context.moveTo clickX[i] - 1, clickY[i]
    context.lineTo clickX[i], clickY[i]
    context.closePath()
    context.strokeStyle = clickColor[i]
    context.stroke()
    i++
  return

ready = ->
  canvasDiv = document.getElementById('canvasDiv')
  if window.innerWidth > 768
    canvasWidth = 500
    canvasHeight = 500
  else 
    canvasWidth = 275
    canvasHeight = 275
  canvas = document.createElement('canvas')
  canvas.addEventListener 'scrollstart', ((e) ->
    e.preventDefault()
    return
   ), false
  canvas.setAttribute 'width', canvasWidth
  canvas.setAttribute 'height', canvasHeight
  canvas.setAttribute 'id', 'canvas'
  console.log(canvasDiv)
  canvasDiv.appendChild canvas
  if typeof G_vmlCanvasManager != 'undefined'
    canvas = G_vmlCanvasManager.initElement(canvas)
  context = canvas.getContext('2d')
  toolbar = document.getElementById("toolbar")
  swatches = toolbar.children
  swatches[i].style.backgroundColor = colors[i] for i in [0..colors.length-1]
  console.log(swatches)
  curColorIndex = 0
  curColor = colors[curColorIndex]
  
  # desktop draw registration functions 
  
  $('#canvas').mousedown (e) ->
    if screen.width >= 768
      # console.log 'mousedown'
      mouseX = e.pageX - (@offsetLeft)
      mouseY = e.pageY - (@offsetTop)
      paint = true
      lastStrokeClickCount = 0
      addClick e.pageX - (@offsetLeft), e.pageY - (@offsetTop)
      redraw()
    return
  $('#canvas').mousemove (e) ->
    # console.log 'mousemove', e
    if paint and screen.width >= 768
      addClick e.pageX - (@offsetLeft), e.pageY - (@offsetTop), true
      console.log
      redraw()
    return
  $('#canvas').mouseup (e) ->
    if screen.width >= 768
      paint = false
    return
  $('#canvas').mouseleave (e) ->
    # console.log 'mouseleave'
    paint = false
    return
    
  # mobile draw registration functions
  
  leftMargin = (screen.width-275)/2 # 275 = width of mobile canvas
  topMargin = 52 # navbar height (including padding)
  
  canvas.addEventListener 'touchmove', (e) ->
    e.preventDefault
    console.log e.touches[0].clientX
    if paint
      addClick e.touches[0].clientX - leftMargin, e.touches[0].clientY - topMargin, true
      redraw()
    return
  canvas.addEventListener 'touchstart', (e) ->
    # console.log e.touches[0].clientX
    # console.log 'start'
    mobile = true
    console.log 'touchstart', e
    touchX = e.touches[0].clientX - leftMargin
    touchY = e.touches[0].clientY - topMargin
    console.log touchX, touchY, leftMargin, topMargin
    paint = true
    lastStrokeClickCount = 0
    addClick touchX, touchY
    redraw()
    return
  canvas.addEventListener 'touchend', (e) ->
    console.log 'end'
    paint = false
    return
    
  $('.color').mousedown (e) ->
    last = document.getElementById((curColorIndex+1).toString())
    curColorIndex = e.currentTarget.id-1
    curColor = colors[curColorIndex]
    # modify e.currentTarget.style or provide some indicator
    if last != e.currentTarget
      console.log('remove last indicator')
      # remove indicator with last.style
    return
  
  $('#undo').mousedown (e) ->
    removeLastStroke()
    return
  $('#clear').mousedown (e) ->
    context.clearRect 0, 0, context.canvas.width, context.canvas.height
    clickX = []
    clickY = []
    clickDrag = []
    clickColor = []
    return
  $('#download').mousedown (e) ->
    link = document.createElement('a')
    link.download = 'my_artwork.png'
    link.href = canvas.toDataURL('image/png')
    link.click()
    return
  $('#facebook').mousedown (e) ->
    FB.ui {
      method: 'share'
      href: 'https://art-draw-web-bluyam.c9.io/welcome/index'
    }, (response) ->
  paint = undefined
  
  if document.getElementById("game_clickX").value != ""
    # if mobile width, decrease points to appropriate factor
    # if desktop width and was mobile (values do not exceed 275) increase by appropriate factor
    clickX = document.getElementById("game_clickX").value.split(',').map((item) ->
      parseInt item, 10
    )
    clickY = document.getElementById("game_clickY").value.split(",").map((item) ->
      parseInt item, 10
    )
    clickDrag = document.getElementById("game_clickDrag").value.split(",")
    clickColor = document.getElementById("game_clickColor").value.split(",")
    console.log 'oldclickX', clickX
    xBig = clickX.find(exceedsSmallSquareBounds)
    yBig = clickY.find(exceedsSmallSquareBounds)
    if (xBig or yBig) and $(window).width() < 768
      # scale down
      console.log 'scale down'
      clickX = clickX.map((item) ->
        item * 275/500
      )
      clickY = clickY.map((item) ->
        item * 275/500
      )
    console.log 'newclickX', clickX;
    console.log clickY;
    console.log clickDrag;
    console.log clickColor;
    redraw()

exceedsSmallSquareBounds = (e) ->
  e > 275
  
$(document).ready(ready)
$(document).on('page:load', ready);
