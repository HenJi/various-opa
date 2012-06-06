function shuffle(l) {
    recursive function aux(l, s, res) {
        if (s < 1) res
        else {
            i = Random.int(s)
            (elt, l) = List.extract(i, l)
            aux(l, s-1, [Option.get(elt) | res])
        }
    }
    aux(l, List.length(l), [])
}

function translate(posmap g, dx, dy) {
    PosMap.To.assoc_list(g)
        |> List.map(
            function((~{x, y}, wall)) {
                ({x:x+dx, y:y+dy}, wall)
            }, _)
        |> PosMap.From.assoc_list
}