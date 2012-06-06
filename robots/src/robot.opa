client game_ref = Reference.create(Robot.demo_game())

module Robot {

    test_bots = [
        { color:{red}, pos:{x:1, y:0} },
        { color:{black}, pos:{x:3, y:3} },
        { color:{blue}, pos:{x:6, y:7} },
        { color:{yellow}, pos:{x:9, y:10} },
        { color:{green}, pos:{x:0, y:15} },
    ]

    function game demo_game() {
        width = 16
        height = 16
        (grid, targets) = Board.create_random_board()
        target_stash = PosMap.To.val_list(targets) |> shuffle
        robots = test_bots
        scores = StringMap.empty
        ~{width, height, grid, targets, target_stash, robots, scores}
    }

    function apply_move(~{x, y}, dir) {
        match (dir) {
        case {up}: {~x, y:y-1}
        case {down}: {~x, y:y+1}
        case {left}: {x:x-1, ~y}
        case {right}: {x:x+1, ~y}
        }
    }

    function check_wall(wall wall, dir dir) {
        t_walls = [{w_t}, {w_lt}, {w_rt}]
        b_walls = [{w_b}, {w_lb}, {w_rb}]
        l_walls = [{w_l}, {w_lt}, {w_lb}]
        r_walls = [{w_r}, {w_rt}, {w_rb}]
        match (dir) {
        case {up}: List.mem(wall, t_walls)
        case {down}: List.mem(wall, b_walls)
        case {left}: List.mem(wall, l_walls)
        case {right}: List.mem(wall, r_walls)
        }
    }

    function check_robot(robots, pos, dir) {
        pos = apply_move(pos, dir)
        List.fold(
            function(r, res) {
                if (r.pos == pos) true
                else res
            }, robots, false)
    }

    client function refresh_robot(bot) {
        s_color = Pages.bot_color_to_string(bot.color)        
        st = [{left:{px:bot.pos.x*40}}, {top:{px:bot.pos.y*40}}]        
        Dom.set_style(#{"bot_{s_color}"}, st)
    }

    client function check_target(robot, game) {
        match (PosMap.get(robot.pos, game.targets)) {
        case {none}: void
        case {some:t}:
            if (t.color == robot.color || t.color == {black}) {
                target_stash = List.tail(game.target_stash)
                set_cur_target(target_stash)
                Reference.set(game_ref, {game with ~target_stash})
            } else void
        }
    }

    client function move(color, dir dir, _) {
        game = Reference.get(game_ref)
        (robot, robots1) = List.extract_p(function(r){r.color == color}, game.robots)
        recursive function aux(pos) {
            wall = PosMap.get(pos, game.grid) ? {w_no}
            if (check_wall(wall, dir)) pos
            else if (check_robot(robots1, pos, dir)) pos
            else aux(apply_move(pos, dir))
        }
        match (robot) {
        case {some:r}:
            new_pos = aux(r.pos)
            r1 = {r with pos:new_pos}
            robots = [r1|robots1]
            Reference.set(game_ref, {game with ~robots})
            game = Reference.get(game_ref)
            moved_robot = List.head(game.robots)
            refresh_robot(moved_robot)
            check_target(moved_robot, game)
        case {none}: void
        }
    }

    client function set_cur_target(ts) {
        if (ts == []) #cur_target = "END OF GAME"
        else {
            t = List.head(ts)
            len = List.length(ts) - 1
            img = Pages.target_img(t)
            #cur_target =
              <>
                <img class="target_pic" src={img} alt="current_target" />
                {len} left
              </>
        }
    }

    client function init_game(game, _) {
        set_cur_target(game.target_stash)
        Reference.set(game_ref, game)
    }

}