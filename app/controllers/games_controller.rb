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
            p1_wins:0 ,
            p2_wins: 0,
            rounds:[]
        }.to_json)
        render json: { gameid: game_id, msg: "Game started! Players get ready" }, status: :created
    end

    #game play
    #post /games/:id/play
    def play

        game_id = params[:id]
        stored = InMemoryStore.get(game_id)

        if stored.nil? 
            render json: {msg: "game not found"}, status: :not_found
            return
        end

        gamedata = JSON.parse(stored,symbolize_names: true)

        #game end condition
        if gamedata[:cur_round] >=5 || gamedata[:p1_wins] ==3 ||gamedata[:p2_wins] ==3
            if  gamedata[:p1_wins]>gamedata[:p2_wins]
                game_winner = gamedata[:player1]
            elsif gamedata[:p2_wins]>gamedata[:p1_wins]
                game_winner = gamedata[:player2]
            else
                game_winner = "No winner!"
            end
            
            render json: {
                msg: "game over",
                winner: game_winner,
                score: {
                    p1: gamedata[:p1_wins],
                    p2: gamedata[:p2_wins]
                }
            }
            return
        end
        #game start
        p1_roll = rand(1..6)
        p2_roll = rand(1..6)
        winner = nil

        if p1_roll > p2_roll
            gamedata[:p1_wins]+=1
            winner = gamedata[:player1]
        elsif p2_roll > p1_roll
            gamedata[:p2_wins]+=1
            winner = gamedata[:player2]
        else 
             winner= "Draw" 
        end

        gamedata[:cur_round] +=1

        gamedata[:rounds] << {
                round:gamedata[:cur_round] ,
                p1_score: p1_roll,
                p2_score: p2_roll,
                winner: winner
        }

        #results stored and rendered
        InMemoryStore.set(game_id,gamedata.to_json)

        render json: {
            round:gamedata[:cur_round] ,
            p1_roll: p1_roll ,
            p2_roll: p2_roll ,
            winner: winner,
            score: {
                p1: gamedata[:p1_wins],
                p2: gamedata[:p2_wins]
            }
        }

      
        

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
