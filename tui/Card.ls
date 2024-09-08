
  do ->

    { new-instance } = dependency 'primitive.Instance'
    { new-box } = dependency 'tui.Box'
    { new-grid } = dependency 'tui.Grid'
    { Obj } = dependency 'primitive.Type'
    { box-drawing-char: new-char, stroke-kind, new-stroke } = dependency 'unicode.BoxDrawing'
    { repeat-string, padl, padr } = dependency 'native.String'
    { maximum } = dependency 'native.Number'
    { outln } = dependency 'prelude.IO'

    #

    { none, single, double } = stroke-kind

    #

    max-captions-width = (card) ->

      { names } = card

      max-width = 0

      for name in names

        max-width = maximum max-width, name.length

      max-width

    #

    max-values-width = (card, object) ->

      { names } = card

      max-width = 0

      for name in names

        value = object[ name ]

        value-width = if value isnt 0 then value.length else 0

        max-width = maximum max-width, value-width

      max-width

    #

    card-frame-top = (card, captions-width, values-width) ->

      { frame: f, separator: s } = card

      nw = new-char none, f.n.stroke, f.w.stroke, none
      ne = new-char none, none, f.e.stroke, f.n.stroke

      n = new-char none, f.n.stroke, none, f.n.stroke

      top = repeat-string n, captions-width

      top += new-char none, f.n.stroke, s.stroke, f.n.stroke

      top += repeat-string n, values-width + 2

      [ nw, top, ne ] * ''

    #

    card-value-line = (card, name, captions-width, values-width, w, e) ->

      { object, separator: s } = card

      line = ''

      value = object[ name ]

      if value is void
        value = ''

      line += padl name, captions-width, ' '
      line += new-char s.stroke, none, s.stroke, none
      line += padr " #value ", values-width + 2

      [ w, line, e ] * ''

    card-values-lines = (card, captions-width, values-width) ->

      { frame: f, names } = card

      w = new-char f.w.stroke, none, f.w.stroke, none
      e = new-char f.e.stroke, none, f.e.stroke, none

      lines = []

      for name in names

        lines.push card-value-line card, name, captions-width, values-width, w, e

      lines

    card-frame-bottom = (card, captions-width, values-width) ->

      { frame: f, separator } = card

      sw = new-char f.w.stroke, f.s.stroke, none, none
      se = new-char f.e.stroke, none, none, f.s.stroke

      s = new-char none, f.s.stroke, none, f.s.stroke

      bottom = ''

      bottom += repeat-string s, captions-width
      bottom += new-char separator.stroke, f.s.stroke, none, f.s.stroke
      bottom += repeat-string s, values-width + 2

      [ sw, bottom, se ] * ''

    card-as-strings = (card) ->

      strings = []

      { object } = card

      captions-width = max-captions-width card
      values-width = max-values-width card, object

      strings = strings ++ [ card-frame-top card, captions-width, values-width ]
      strings = strings ++ card-values-lines card, captions-width, values-width
      strings = strings ++ [ card-frame-bottom card, captions-width, values-width ]

      strings

    #

    new-card = (names, types, widths, styles) ->

      frame = new-box <[ double single double single ]>

      separator = new-stroke single

      object = {}

      new-instance do

        frame: getter: -> frame

        separator: getter: -> separator

        names: getter: -> names
        types: getter: -> types
        widths: getter: -> widths
        styles: getter: -> styles

        object:
          getter: -> object
          setter: -> object := Obj it

        as-strings: member: -> card-as-strings @

        to-string: member: -> (@as-strings!) * '\n'

    {
      new-card
    }