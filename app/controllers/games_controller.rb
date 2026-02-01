class GamesController < ApplicationController
    skip_before_action :verify_authenticity_token
    #game start
    #POST /games
    #req : {p1name: , p2name: }
    # +ve resp : {gameid: , msg : "game started"}
    # -ve resp : common errors : player name missing, gameid not generated 
    def create
        player1 = game_params[:player1]
        player2 = game_params[:player2] 

        if player1.blank? || player2.blank?
            render json: {error: "Player names cannot be empty"}, status: :bad_request
            return
        end

        game_id = SecureRandom.hex(4) 

        #using inmemorystore
        InMemoryStore.set(game_id, {
            player1: player1,
            player2: player2,
            cur_round: 0,
            rounds: []
        }.to_json)

        render json: { gameid: game_id, msg: "Game started" }, status: :created
    end

    #game play
    #post /games/:id/round
    def play
    end

    # view current game score through redis
    # get /games/:id
    def show
    end

    # view history of games played - stored in DB
    # get /games
    def index
    end

    private

    def game_params
        params.require(:game).permit(:player1,:player2)
    end
end
