
  do ->

    { new-box } = dependency 'tui.Box'
    { StrokeKind, new-stroke } = dependency 'unicode.BoxDrawing'
    { new-instance } = dependency 'primitive.Instance'

    new-grid = (strokes) ->

      frame = new-box strokes

      columns = []
      rows = []

      new-instance do

        frame: getter: -> frame

        add-column: member: (stroke, weight) -> columns.push new-stroke stroke, weight

        add-row: member: (stroke, weight) -> row.push new-stroke stroke, weight

        columns: getter: -> columns
        rows: getter: -> rows

    {
      new-grid
    }