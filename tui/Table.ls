
  do ->

    { StrList } = dependency 'primitive.StrList'
    { new-box } = dependency 'unicode.Box'
    { new-grid } = dependency 'unicode.Grid'
    { Bool, Obj, primitive-type: p } = dependency 'primitive.Type'
    { new-instance } = dependency 'primitive.Instance'
    { box-drawing-char: new-char, stroke-kind } = dependency 'unicode.BoxDrawing'
    { map-items } = dependency 'native.Array'
    { repeat-string, padc, padr, padl } = dependency 'native.String'
    { maximum } = dependency 'native.Number'

    #

    { none, single, double } = stroke-kind

    #

    header-top = (table, widths) ->

      { header }  = table

      header

        nw = new-char none, ..n.stroke, ..w.stroke, none
        ne = new-char none, none, ..e.stroke, ..n.stroke

        n = new-char none, ..n.stroke, none, ..n.stroke

      top = ''

      for width, index in widths

        top += repeat-string n, width + 2

        if index isnt widths.length - 1

          { stroke } = table.columns[index]

          char = new-char none, header.n.stroke, stroke, header.n.stroke

          top += char

      [ nw, top, ne ] * ''

    header-bottom = (table, widths) ->

      { header: h, grid-frame: g } = table

      sw = new-char h.w.stroke, h.s.stroke, g.w.stroke, none
      se = new-char h.e.stroke, none, g.e.stroke, h.s.stroke

      s = new-char none, h.n.stroke, none, h.n.stroke

      bottom = ''

      for width, index in widths

        bottom += repeat-string s, width + 2

        if index isnt widths.length - 1

          { stroke } = table.columns[index]

          char = new-char stroke,h.n.stroke, stroke, h.n.stroke

          bottom += char

      [ sw, bottom, se ] * ''

    header-titles = (table, widths) ->

      { header } = table

      header

        w = new-char ..w.stroke, none, ..w.stroke, none
        e = new-char ..e.stroke, none, ..e.stroke, none

      titles = ''

      for width, index in widths

        title = table.column-titles[index]

        titles += padc title, width + 2

        if index isnt widths.length - 1

          { stroke } = table.columns[index]

          titles += new-char stroke, none, stroke, none

      [ w, titles, e ] * ''

    header-as-strings = (table, widths) ->

      strings = []

      strings.push header-top table, widths
      strings.push header-titles table, widths
      strings.push header-bottom table, widths

      strings

    row-as-string = (table, row, widths) ->

      line = ''

      { column-titles, grid-frame:g, columns, types } = table

      w = new-char g.w.stroke, none, g.w.stroke, none

      e = new-char g.e.stroke, none, g.e.stroke, none

      for key, index in column-titles

        type = types[ index ]

        value = row[ key ]

        width = widths[ index ]

        value = switch type

          | p.Num => padl value, width

          else padr value, width

        line += " #value "

        if index isnt columns.length - 1

          { stroke } = columns[index]

          char = new-char stroke, none, stroke, none

          line += char

      [ w, line, e ] * ''

    rows-as-strings = (table, widths) ->

      strings = []

      for row in table.rows => strings.push row-as-string table, row, widths

      strings

    #

    max-column-width = (table, column-index) ->

      key = table.column-titles[ column-index ]

      max-width = key.length

      for object in table.rows

        value = object[key]

        max-width = maximum max-width, value.length

      max-width

    #

    normalize-widths = (table) ->

      { widths: table-widths } = table

      widths = []

      for table-width, index in table-widths

        width = if table-width is -1
          max-column-width table, index
        else
          table-width

        widths.push width

      widths

    #

    bottom-as-string = (table, widths) ->

      bottom = ''

      { grid-frame: g, columns } = table

      se = new-char g.e.stroke, none, none, g.s.stroke
      sw = new-char g.w.stroke, g.s.stroke, none, none

      s = new-char none, g.s.stroke, none, g.s.stroke

      for width, index in widths

        bottom += repeat-string s, width + 2

        if index isnt columns.length - 1

          { stroke } = columns[index]

          char = new-char stroke, g.s.stroke, none, g.s.stroke

          bottom += char


      [ sw, bottom, se ] * ''

    #

    table-as-strings = (table) ->

      strings = []

      widths = normalize-widths table

      strings = strings ++ header-as-strings table, widths

      strings = strings ++ rows-as-strings table, widths

      strings = strings ++ [ bottom-as-string table, widths ]

      strings

    #

    new-table = (column-titles, types, widths, styles) ->

      StrList column-titles ; StrList types ; StrList widths ; StrList styles

      widths = [ (Number width) for width in widths ]

      header = new-box <[ double single double single ]>
      grid = new-grid <[ double single double single ]>

      for til column-titles.length => grid.add-column single

      rows = []

      new-instance do

        header: getter: -> header

        column-titles: getter: -> column-titles

        types: getter: -> types

        widths: getter: -> widths

        styles: getter: -> styles

        grid-frame: getter: -> grid.frame

        columns: getter: -> grid.columns

        rows: getter: -> rows

        add-row: member: (row) -> rows.push Obj row

        as-strings: member: -> table-as-strings @

        to-string: member: -> (@as-strings!) * '\n'

    {
      new-table
    }