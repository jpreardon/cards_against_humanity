# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :game, optional: true

  has_many :card_players, -> { order(:position) }, dependent: :destroy
  has_many :cards, through: :card_players
  has_many :submissions, dependent: :destroy

  before_create :set_token
  before_create :set_random_seed

  acts_as_list scope: :game

  validates :name, presence: true

  def to_s
    name
  end

  def winning_submissions_for(game)
    submissions.joins(:round).where(rounds: { game_id: game }).where(won: true)
  end

  def reset_random_seed!
    set_random_seed
    save!
  end

  private

  def set_token
    self.token = SecureRandom.base64
  end

  def set_random_seed
    self.random_seed = Random.new_seed
  end
end
