type position = {
    int x,
    int y,
}

type posmap('b) = ordered_map(position, 'b, Order.default)
Map(position, Order.default) PosMap = Map_make(Order.default)

type wall =
    { w_no }
or  { w_l }
or  { w_lt }
or  { w_t }
or  { w_rt }
or  { w_r }
or  { w_rb }
or  { w_b }
or  { w_lb }
or  { w_lr }
or  { w_tb }

type robot_color =
    { black }
or  { green }
or  { yellow }
or  { red }
or  { blue }

type shape =
    { round }
or  { triangle }
or  { square }
or  { hexa }

type target = {
    shape shape,
    robot_color color,
}

type robot = {
    robot_color color,
    position pos,
}

type sub_board = {
    posmap(wall) sub_grid,
    posmap(target) targets,
}    

type game = {
    int width,
    int height,
    posmap(wall) grid,
    posmap(target) targets,
    list(target) target_stash,
    list(robot) robots,
    stringmap(int) scores,
}

type dir =
    { up }
or  { down }
or  { left }
or  { right }