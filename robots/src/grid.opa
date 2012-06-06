module Grid {

    private function of_lists(list(list(wall)) grid) {
        List.foldi(
            function(y, line, acc) {
                List.foldi(
                    function(x, wall, acc) {
                        [(~{x, y}, wall)|acc]
                    }, line, acc)
            }, grid, [])
            |> PosMap.From.assoc_list
    }

    private function rotate_wall(wall w) {
        match (w) {
            case { w_no } : {w_no}
            case { w_l } : {w_t}
            case { w_lt } : {w_rt}
            case { w_t } : {w_r}
            case { w_rt } : {w_rb}
            case { w_r } : {w_b}
            case { w_rb } : {w_lb}
            case { w_b } : {w_l}
            case { w_lb } : {w_lt}
            case { w_lr } : {w_tb}
            case { w_tb } : {w_lr}
        }
    }

    function rotate_clockwise(side_len, posmap(wall) g, nb_rotation) {
        if (nb_rotation == 0) g
        else {
            PosMap.To.assoc_list(g)
                |> List.map(
                    function((~{x, y}, wall)) {
                        ({x:side_len-1-y, y:x}, rotate_wall(wall))
                    }, _)
                |> PosMap.From.assoc_list
                |> rotate_clockwise(side_len, _, nb_rotation-1)
        }
    }

    test_grid = [
        [{w_lt}, {w_t}, {w_t}, {w_rt}],
        [{w_l}, {w_rb}, {w_l}, {w_r}],
        [{w_l}, {w_t}, {w_no}, {w_r}],
        [{w_lb}, {w_b}, {w_b}, {w_rb}],
    ] |> of_lists

    sub_grid_1 = [
        [{w_lt}, {w_rt}, {w_lt}, {w_t}, {w_tb}, {w_t}, {w_t}, {w_t}],
        [{w_l}, {w_b}, {w_no}, {w_r}, {w_lt}, {w_no}, {w_no}, {w_no}],
        [{w_l}, {w_rt}, {w_l}, {w_no}, {w_no}, {w_no}, {w_no}, {w_no}],
        [{w_l}, {w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_rb}, {w_l}],
        [{w_l}, {w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_t}, {w_no}],
        [{w_lb}, {w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_no}],
        [{w_lt}, {w_no}, {w_r}, {w_lb}, {w_no}, {w_no}, {w_no}, {w_b}],
        [{w_l}, {w_no}, {w_no}, {w_t}, {w_no}, {w_no}, {w_r}, {w_lt}],
    ] |> of_lists

    sub_grid_2 = [
        [{w_t}, {w_rt}, {w_lt}, {w_t}, {w_t}, {w_t}, {w_tb}, {w_rt}],
        [{w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_r}, {w_lt}, {w_r}],
        [{w_no}, {w_no}, {w_r}, {w_lb}, {w_no}, {w_no}, {w_no}, {w_r}],
        [{w_no}, {w_no}, {w_no}, {w_t}, {w_no}, {w_no}, {w_no}, {w_rb}],
        [{w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_rt}],
        [{w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_r}],
        [{w_b}, {w_no}, {w_b}, {w_no}, {w_no}, {w_rb}, {w_l}, {w_r}],
        [{w_rt}, {w_l}, {w_rt}, {w_l}, {w_no}, {w_t}, {w_no}, {w_r}],
    ] |> of_lists |> rotate_clockwise(8, _, 3)

    sub_grid_3 = [
        [{w_l}, {w_no}, {w_no}, {w_no}, {w_no}, {w_rt}, {w_lr}, {w_lb}],
        [{w_l}, {w_rb}, {w_l}, {w_no}, {w_no}, {w_no}, {w_no}, {w_t}],
        [{w_l}, {w_t}, {w_no}, {w_r}, {w_lb}, {w_no}, {w_no}, {w_no}],
        [{w_lb}, {w_no}, {w_no}, {w_no}, {w_t}, {w_no}, {w_no}, {w_no}],
        [{w_lt}, {w_no}, {w_no}, {w_no}, {w_no}, {w_b}, {w_no}, {w_no}],
        [{w_l}, {w_no}, {w_no}, {w_b}, {w_no}, {w_rt}, {w_l}, {w_no}, {w_no}],
        [{w_l}, {w_no}, {w_r}, {w_lt}, {w_no}, {w_no}, {w_no}, {w_no}],
        [{w_lb}, {w_b}, {w_b}, {w_b}, {w_b}, {w_b}, {w_rb}, {w_lb}],
    ] |> of_lists |> rotate_clockwise(8, _, 1)

    sub_grid_4 = [
        [{w_rb}, {w_l}, {w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_r}],
        [{w_t}, {w_no}, {w_no}, {w_no}, {w_r}, {w_lb}, {w_no}, {w_r}],
        [{w_no}, {w_no}, {w_no}, {w_no}, {w_no}, {w_t}, {w_no}, {w_r}],
        [{w_no}, {w_rb}, {w_l}, {w_no}, {w_no}, {w_no}, {w_no}, {w_rb}],
        [{w_no}, {w_t}, {w_no}, {w_no}, {w_no}, {w_no}, {w_b}, {w_rt}],
        [{w_no}, {w_no}, {w_b}, {w_no}, {w_no}, {w_no}, {w_rt}, {w_lr}],
        [{w_no}, {w_r}, {w_lt}, {w_no}, {w_no}, {w_no}, {w_no}, {w_r}],
        [{w_b}, {w_b}, {w_b}, {w_rb}, {w_lb}, {w_b}, {w_b}, {w_rb}],
    ] |> of_lists |> rotate_clockwise(8, _, 2)

    function create_random_grid() {
        sub_grids = [sub_grid_1, sub_grid_2, sub_grid_3, sub_grid_4]
            |> shuffle
        lt = List.unsafe_get(0, sub_grids)
        rt = List.unsafe_get(1, sub_grids)
            |> rotate_clockwise(8, _, 1)
            |> translate(_, 8, 0)
        rb = List.unsafe_get(2, sub_grids)
            |> rotate_clockwise(8, _, 2)
            |> translate(_, 8, 8)
        lb = List.unsafe_get(3, sub_grids)
            |> rotate_clockwise(8, _, 3)
            |> translate(_, 0, 8)
        PosMap.union(lt, rt)
            |> PosMap.union(_, rb)
            |> PosMap.union(_, lb)
    }

    function create_pic_grid() {
        lt = sub_grid_1
        rt = sub_grid_2
            |> rotate_clockwise(8, _, 1)
            |> translate(_, 8, 0)
        rb = sub_grid_4
            |> rotate_clockwise(8, _, 2)
            |> translate(_, 8, 8)
        lb = sub_grid_3
            |> rotate_clockwise(8, _, 3)
            |> translate(_, 0, 8)
        PosMap.union(lt, rt)
            |> PosMap.union(_, rb)
            |> PosMap.union(_, lb)
    }

}