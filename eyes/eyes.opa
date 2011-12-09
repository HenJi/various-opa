import stdlib.web.canvas

eye1 = {
  x(w) = w/3
  y(h) = h/2
  w(w) = w/10
  h(h) = h/3

  border_color = Color.black
  border_width = 10.
  
  ball_color = Color.red
  ball_radius = 20
}

eye2 = {
  x(w) = 2*w/3
  y(h) = h/2
  w(w) = w/10
  h(h) = h/3

  border_color = Color.black
  border_width = 10.
  
  ball_color = Color.red
  ball_radius = 20
}

ellipsis_radius(h:int, w:int, theta):int =
  hh = Int.to_float(h)
  ww = Int.to_float(w)
  cos = Math.cos(theta)
  cos = if cos < 0. then -cos else cos
  Float.to_int(hh / (1. - (1. - hh/ww)*cos))

@client draw_eye_frame(ctx, eye, w, h) =
  ww = eye.w(w)
  hh = eye.h(h)

  // Mode 1
  // do Canvas.save(ctx)
  // do Canvas.set_stroke_style(ctx, {color=eye.border_color})
  // do Canvas.set_line_width(ctx, eye.border_width)
  // do Canvas.translate(ctx, eye.x(w), eye.y(h))
  // do Canvas.begin_path(ctx)
  // do Canvas.move_to(ctx, 0, -hh)
  // do Canvas.quadratic_curve_to(ctx, ww, -hh, ww, 0)
  // do Canvas.quadratic_curve_to(ctx, ww, hh, 0, hh)
  // do Canvas.quadratic_curve_to(ctx, -ww, hh, -ww, 0)
  // do Canvas.quadratic_curve_to(ctx, -ww, -hh, -0, -hh)
  // do Canvas.stroke(ctx)
  // do Canvas.restore(ctx)

  // Mode 2
  // do Canvas.save(ctx)
  // do Canvas.translate(ctx, eye.x(w), eye.y(h))
  // do Canvas.scale(ctx, Int.to_float(ww)/Int.to_float(hh), 1.)
  // do Canvas.begin_path(ctx)
  // do Canvas.arc(ctx, 0, 0, hh, 0., 2.*Math.PI, true)
  // do Canvas.restore(ctx)

  // do Canvas.save(ctx)
  // do Canvas.set_stroke_style(ctx, {color=eye.border_color})
  // do Canvas.set_line_width(ctx, eye.border_width)
  // do Canvas.stroke(ctx)
  // do Canvas.restore(ctx)

  // Mode 3
  pts = 60
  r(angle) = ellipsis_radius(hh, ww, angle)
  next(i) =
    angle = Int.to_float(2*i) * Math.PI / Int.to_float(pts)
    do Canvas.rotate(ctx, angle)
    do Canvas.line_to(ctx, r(angle),0)
    do Canvas.rotate(ctx, -angle)
    i+1

  do Canvas.save(ctx)
  do Canvas.set_stroke_style(ctx, {color=eye.border_color})
  do Canvas.set_line_width(ctx, eye.border_width)
  do Canvas.translate(ctx, eye.x(w), eye.y(h))
  do Canvas.begin_path(ctx)
  do Canvas.move_to(ctx, ww, 0)
  _ = for(0, next, (i->i < pts))
  do Canvas.line_to(ctx, ww, 0)
  do Canvas.stroke(ctx)
  do Canvas.restore(ctx)

  void

@client draw_eye_ball(ctx, eye, w, h, x, y) =
  eye_x = eye.x(w)
  eye_y = eye.y(h)
  xx = x - eye_x
  yy = y - eye_y

  rr = Math.sqrt_f(Int.to_float(xx*xx+yy*yy))
  theta = Math.asin(Int.to_float(yy)/rr)

  max_radius =
    ellipsis_radius(eye.h(h), eye.w(w), theta) - 2*eye.ball_radius
  r = Int.min(max_radius, Float.to_int(rr))
  theta =
    if xx > 0 then theta
    else Math.PI - theta

  do Canvas.save(ctx)
  do Canvas.set_fill_style(ctx, {color=eye.ball_color})
  do Canvas.translate(ctx, eye_x, eye_y)
  do Canvas.rotate(ctx, theta)
  do Canvas.begin_path(ctx)
  do Canvas.arc(ctx, r, 0, eye.ball_radius, 0., 2.*Math.PI, true)
  do Canvas.fill(ctx)
  do Canvas.restore(ctx)
  void

@client handler(ctx, event) =
  height = Dom.get_outer_height(#content)
  width = Dom.get_outer_width(#content)
  x = event.mouse_position_on_page.x_px
  y = event.mouse_position_on_page.y_px

  do Canvas.clear_rect(ctx, 0, 0, width, height)
  do draw_eye_frame(ctx, eye1, width, height)
  do draw_eye_ball(ctx, eye1, width, height, x, y)
  do draw_eye_frame(ctx, eye2, width, height)
  do draw_eye_ball(ctx, eye2, width, height, x, y)

  void

@client resize() =
  height = Dom.get_outer_height(#content)
  width = Dom.get_outer_width(#content)
  do Dom.set_property_unsafe(#content, "height", "{height}")
  do Dom.set_property_unsafe(#content, "width", "{width}")
  void

@client init() =
  match Canvas.get(#content) with
  | {none} -> void
  | {some=canvas} ->
    ctx = Canvas.get_context_2d(canvas) |> Option.get
    do resize()
    _ = Dom.bind(Dom.select_window(), {resize}, (_ -> resize()))
    _ = Dom.bind(#content, {mousemove}, handler(ctx, _))
    void

body() =
  <>
    <canvas onready={_ -> init()}
            width="100" height="100"
            class="fullscreen" id="content">
      You can't see canvas, upgrade your browser!
    </canvas>
    <div id="debug"/>
  </>

server = one_page_server("eyes", body)

css = css
  .fullscreen {
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
    width: 100%;
    height: 100%;
  }
