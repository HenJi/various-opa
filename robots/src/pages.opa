module Pages {

    function pic(wall w) {
        file =
            match (w) {
            case { w_no } : "no_wall"
            case { w_l } : "wall_l"
            case { w_lt } : "wall_lt"
            case { w_t } : "wall_t"
            case { w_rt } : "wall_rt"
            case { w_r } : "wall_r"
            case { w_rb } : "wall_rb"
            case { w_b } : "wall_b"
            case { w_lb } : "wall_lb"
            case { w_lr } : "wall_lr"
            case { w_tb } : "wall_tb"
            }
        <span class="wall_wrap">
          <img class="wall_pic" src="/resources/img/{file}.png" />
        </span>
    }

    function draw_grid(width, height, grid) {
        <div id="grid">{
            for((0, <></>),
                function((y, acc)) {
                    (y+1,
                     <>{acc}
                       <div class="grid_line">{
                           for((0, <></>),
                               function((x, acc)) {
                                   (x+1,
                                    <>
                                      {acc}
                                      {pic(PosMap.get(~{x, y}, grid) ? {w_no})}
                                    </>)
                               }, function((i, _)) {i < width}) |> _.f2
                       }<div class="clear" /></div>
                     </>)
                }, function((j, _)) {j < height}) |> _.f2
        }</div>
    }

    function bot_color_to_string(robot_color c) {
        match (c) {
        case  { black }: "black"
        case  { green }: "green"
        case  { yellow }: "yellow"
        case  { red }: "red"
        case  { blue }: "blue"
        }
    }

    function target_img(target t) {
        sh =
            match (t.shape) {
            case {round}: "round"
            case {triangle}: "tri"
            case {square}: "square"
            case {hexa}: "hexa"
            }
        col =
            match (t.color) {
            case  { black }: "bonus"
            case  { green }: "green"
            case  { yellow }: "yellow"
            case  { red }: "red"
            case  { blue }: "blue"
            }
        "/resources/img/t_{sh}_{col}.png"
    }

    function draw_targets(targets) {
        function draw_target(pos, t, acc) {
            st = "left: {pos.x*40}px; top: {pos.y*40}px"
            img = target_img(t)
            <>
              {acc}
              <span class="target_wrap" style="{st}">
                <img class="target_pic" src="{img}" alt="target"/>
              </span>
            </>
        }
        PosMap.fold(draw_target, targets, <></>)
    }

    function draw_bot(robot) {
        s_color = bot_color_to_string(robot.color)
        st = "left: {robot.pos.x*40}px; top: {robot.pos.y*40}px"
        <span id="bot_{s_color}" class="bot_wrap" style="{st}">
          <img class="bot_pic" src="/resources/img/bot_{s_color}.png" alt="{s_color} robot" />
        </span>
    }

    function bot_color_to_bootstrap(robot_color c) {
        match (c) {
        case  { black }: "btn-inverse"
        case  { green }: "btn-success"
        case  { yellow }: "btn-warning"
        case  { red }: "btn-danger"
        case  { blue }: "btn-primary"
        }
    }

    function draw_controls(color) {
        cl = bot_color_to_bootstrap(color)
        <div class="color-line btn-toolbar">
          <div class="btn-group">
            <a class="btn {cl}" onclick={Robot.move(color, {up}, _)}>&uarr;</a>
            <a class="btn {cl}" onclick={Robot.move(color, {down}, _)}>&darr;</a>
            <a class="btn {cl}" onclick={Robot.move(color, {left}, _)}>&larr;</a>
            <a class="btn {cl}" onclick={Robot.move(color, {right}, _)}>&rarr;</a>
          </div>
        </div>
    }

    function draw_gamezone(game) {
        width = game.width
        height = game.height
        robots = game.robots
        grid = game.grid
        colors = List.map(_.color, robots) |> List.unique_list_of
        <div id="gamezone" onready={Robot.init_game(game, _)}>
          {draw_grid(height, width, grid)}
          {draw_targets(game.targets)}
          {List.map(draw_bot, robots)}
          <div id="cur_target" />
          <div id="control_area">
            {List.map(draw_controls, colors)}
          </div>
        </div>
    }

    function home() {
        game = Robot.demo_game()
        <div class="container">
          <h1>Robots</h1>
          {draw_gamezone(game)}
        </div> |> Resource.styled_page(
            "Robot", ["/resources/bootstrap.css"],  _)
    }

}