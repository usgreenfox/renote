class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :notes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :fav_notes, through: :bookmarks, source: :note
  has_many :reminds, dependent: :destroy

  validates :name, presence: true
  
  def self.from_omniauth(access_token)
    data = access_token.information
    user = 
end
