module Board {

    sub_board_1 = {
        sub_grid: Grid.sub_grid_1,
        targets: Targets.targets_1,
    }

    sub_board_2 = {
        sub_grid: Grid.sub_grid_2,
        targets: Targets.targets_2,
    }

    sub_board_3 = {
        sub_grid: Grid.sub_grid_3,
        targets: Targets.targets_3,
    }

    sub_board_4 = {
        sub_grid: Grid.sub_grid_4,
        targets: Targets.targets_4,
    }

    private function rotate_clockwise(side_len, board, nb_rotation) {{
        sub_grid: Grid.rotate_clockwise(side_len, board.sub_grid, nb_rotation),
        targets: Targets.rotate_clockwise(side_len, board.targets, nb_rotation),
    }}

    private function translate_board(board, dx, dy) {{
        sub_grid: translate(board.sub_grid, dx, dy),
        targets: translate(board.targets, dx, dy),
    }}

    private function merge(p1, p2, p3, p4) {
        PosMap.union(p1, p2)
            |> PosMap.union(_, p3)
            |> PosMap.union(_, p4)
    }

    private function correct_bonus(grid, targets) {
        bonus_pos = PosMap.fold(
            function(pos, target, res) {
                if (target.color == {black}) some(pos)
                else res
            }, targets, none)
        match (bonus_pos) {
        case {none}: grid
        case {some:~{x, y}}:
            match (PosMap.get(~{x, y}, grid)) {
            case {some:{w_rt}}: PosMap.add({~x, y:y-1}, {w_b}, grid)
            case {some:{w_rb}}: PosMap.add({x:x+1, ~y}, {w_l}, grid)
            case {some:{w_lb}}: PosMap.add({~x, y:y+1}, {w_t}, grid)
            case {some:{w_lt}}: PosMap.add({x:x-1, ~y}, {w_r}, grid)
            default: grid
            }
        }
    }

    function merge_boards(b1, b2, b3, b4) {
        grid = merge(b1.sub_grid, b2.sub_grid, b3.sub_grid, b4.sub_grid)
        targets = merge(b1.targets, b2.targets, b3.targets, b4.targets)
        grid = correct_bonus(grid, targets)
        (grid, targets)
    }

    function create_random_board() {
        sub_grids = [sub_board_1, sub_board_2, sub_board_3, sub_board_4]
            |> shuffle
        lt = List.unsafe_get(0, sub_grids)
        rt = List.unsafe_get(1, sub_grids)
            |> rotate_clockwise(8, _, 1)
            |> translate_board(_, 8, 0)
        rb = List.unsafe_get(2, sub_grids)
            |> rotate_clockwise(8, _, 2)
            |> translate_board(_, 8, 8)
        lb = List.unsafe_get(3, sub_grids)
            |> rotate_clockwise(8, _, 3)
            |> translate_board(_, 0, 8)
        merge_boards(lt, rt, rb, lb)
    }

}