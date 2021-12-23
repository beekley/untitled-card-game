require 'squib'
require 'game_icons'

data = Squib.csv file: 'cardData/items.csv'

# Generate item cards.
item_fronts = Squib::Deck.new cards: data.nrows, layout: 'src/ship.yml' do
  # Card layout.
  background color: 'white'
  rect layout: 'cut'
  rect layout: 'safe' 
  text str: "last built: #{Time.now}", layout: 'build'
  svg data: data['icon'].map{|x|
      GameIcons.get(x).recolor(fg: '333', bg: 'FFF').string
    },
    layout: 'art'

  # Descriptive elements.
  text str: data['title'], layout: 'title'
  text str: data['abilities'], layout: 'abilities'
  text str: data['description'], layout: 'description'
  # We have to use `map` here to combine the "power" column with the "toughness" column.
  text str: data['power'].map.with_index { |x, i|
      # "power/toughness".
      "#{x}/#{data['toughness'][i]}"
    },
    layout: 'statline'

  # Slots.
  text str: data['deck'].map { |x|
      if x == 'x'
        'deck'
      end
    },
    layout: 'bonus1'
  text str: data['hold'].map { |x|
      unless x.empty?
        "hold\n(inactive)"
      end
    },
    layout: 'bonus2'
  # Types.
  text str: data['common'].map { |x|
      unless x.empty?
        'common'
      end
    },
    layout: 'bonus3'
  text str: data['military'].map { |x|
      unless x.empty?
        'military'
      end
    },
    layout: 'bonus4'
  text str: data['arcane'].map { |x|
      unless x.empty?
        'arcane'
      end
    },
    layout: 'bonus5'

  # TODO: break these out to a helper function and separate by rake command.
  save_png prefix: 'item_', dir: '_output/items'
  # TTS maximum size.
  save_sheet prefix: 'item_sheet_', dir: '_output/tts', columns: 10, rows: 7
end