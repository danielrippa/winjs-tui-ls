
  do ->

    { StrokeKind, CornerKind, corner-kind, new-stroke } = dependency 'unicode.BoxDrawing'
    { Tuple } = dependency 'primitive.Tuple'
    { new-instance } = dependency 'primitive.Instance'

    { sharp, rounded } = corner-kind

    new-box = (side-strokes) ->

      Tuple <[ Str Str Str Str ]> side-strokes

      [ n-stroke, e-stroke, s-stroke, w-stroke ] = side-strokes

      StrokeKind n-stroke ; StrokeKind e-stroke ; StrokeKind s-stroke ; StrokeKind w-stroke

      n = new-stroke n-stroke
      e = new-stroke e-stroke
      s = new-stroke s-stroke
      w = new-stroke w-stroke

      nw = ne = se = sw = sharp

      new-instance do

        n: getter: -> n
        e: getter: -> e
        s: getter: -> s
        w: getter: -> w

        nw:
          getter: -> nw
          setter: -> nw := CornerKind it

        ne:
          getter: -> ne
          setter: -> ne := CornerKind it

        se:
          getter: -> se
          setter: -> CornerKind it

        sw:
          getter: -> sw
          setter: -> sw := CornerKind it

    {
      new-box
    }