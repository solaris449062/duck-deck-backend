class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'
  
  get "/characters" do
    Character.all.to_json
  end

  patch "/characters" do
    character_all = Character.all
    character_all.each do |character|
      character.update(
      current_energy: params[:current_energy],
      current_HP: params[:current_HP],
      shield: params[:shield]
      )
    end
    character_all.to_json
  end

  get "/characters/:id" do
    Character.find(params[:id]).to_json
  end

  patch "/characters/:id" do
    character = Character.find(params[:id])
    character.update(
      current_energy: params[:current_energy],
      current_HP: params[:current_HP],
      shield: params[:shield]
    )
    character.to_json
  end

  get "/cards" do
    Card.all.to_json
  end

  get "/play_card/:id" do
    card = Card.find(params[:id])
    player = Character.all[0]
    enemy = Character.all[1]
    characters = Character.all


    if player.current_energy - card.cost >= 0
      card.play(player, enemy)
    end
    characters.to_json

  end

  get "/end_turn" do
    card_all = Card.all
    player = Character.all[0]
    enemy = Character.all[1]
    characters = Character.all

    # reset the enemy's shield to 0
    enemy.update(shield: 0)

    # reset the player's energy to maximum after the end of the turn
    player.update(current_energy: player.max_energy)

    # enemy plays the card until its energy is depleted
    while enemy.current_energy > 0
      card = card_all[rand(0..(card_all.length - 1))]
      card.play(enemy, player)
      puts "while loop ran"
    end

    # reset the enemy's energy to maximum after the end of the turn
    enemy.update(current_energy: enemy.max_energy)

    # reset the player's shield to 0
    player.update(shield: 0)


    characters.to_json

  end

  # patch "/characters" do
  #   Character.reset
  # end



end
