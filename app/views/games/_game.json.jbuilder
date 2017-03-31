json.extract! game, :id, :challenger_id, :opponent_id, :active, :canvas_state, :title, :created_at, :updated_at
json.url game_url(game, format: :json)