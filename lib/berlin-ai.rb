require 'sinatra'
require 'yajl/json_gem'

%w(game map node).each do |file|
  require File.expand_path( File.dirname( __FILE__ ) ) + "/ai/#{file}"
end

# Tell Sinatra to use ai file as root file
set :app_file, $0

post '/' do
  begin
    # Check if it's one of the four Berlin keywords
    if ['ping', 'turn', 'game_start', 'game_over'].include? params[:action]
      game = Berlin::AI::Game.create_or_update params[:action], params[:infos], params[:map], params[:state]

      if ['ping', 'turn'].include? params[:action]
        return game.turn_moves.to_json
      end
    else
      p params.inspect
    end

    # For every other type of request, respond with 200 OK
    200
  rescue Exception => e
    p e.inspect
    p e.backtrace
    
    # Internal server error
    500
  end
end
