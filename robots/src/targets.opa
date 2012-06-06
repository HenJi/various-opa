module Targets {

    private function of_list(l) {
        List.map(function((x, y, shape, color)) { (~{x, y}, ~{shape, color}) }, l)
            |> PosMap.From.assoc_list
    }

    function rotate_clockwise(side_len, posmap(target) g, nb_rotation) {
        if (nb_rotation == 0) g
        else {
            PosMap.To.assoc_list(g)
                |> List.map(
                    function((~{x, y}, v)) {
                        ({x:side_len-1-y, y:x}, v)
                    }, _)
                |> PosMap.From.assoc_list
                |> rotate_clockwise(side_len, _, nb_rotation-1)
        }
    }

    test_targets = [
        (1, 1, {round}, {red}),
        (1, 2, {square}, {black}),
    ] |> of_list

    targets_1 = [
        (4, 1, {round}, {red}),
        (1, 2, {triangle}, {green}),
        (6, 3, {hexa}, {yellow}),
        (3, 6, {square}, {blue}),
    ] |> of_list

    targets_2 = [
        (6, 1, {triangle}, {red}),
        (3, 2, {hexa}, {blue}),
        (5, 6, {round}, {green}),
        (2, 7, {square}, {yellow}),
    ] |> of_list |> rotate_clockwise(8, _, 3)

    targets_3 = [
        (5, 0, {square}, {black}),
        (1, 1, {round}, {blue}),
        (4, 2, {square}, {green}),
        (5, 5, {hexa}, {red}),
        (3, 6, {triangle}, {yellow}),
    ] |> of_list |> rotate_clockwise(8, _, 1)

    targets_4 = [
        (5, 1, {triangle}, {blue}),
        (1, 3, {round}, {yellow}),
        (6, 5, {square}, {red}),
        (2, 6, {hexa}, {green}),
    ] |> of_list |> rotate_clockwise(8, _, 2)

    test_target_stash = PosMap.To.val_list(test_targets)

    function create_pic_targets() {
        lt = targets_1
        rt = targets_2
            |> rotate_clockwise(8, _, 1)
            |> translate(_, 8, 0)
        rb = targets_4
            |> rotate_clockwise(8, _, 2)
            |> translate(_, 8, 8)
        lb = targets_3
            |> rotate_clockwise(8, _, 3)
            |> translate(_, 0, 8)
        PosMap.union(lt, rt)
            |> PosMap.union(_, rb)
            |> PosMap.union(_, lb)
    }

}