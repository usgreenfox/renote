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
  has_many :entities, dependent: :destroy

  validates :name, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end
  
  # ユーザーの全ノートを結合してLanguageに渡すことで
  # ユーザーのエンティティを取得する
  def self.entities_of(user)
    text_array = user.notes.pluck(:body)
    text = text_array.join
    Language::get_data(text)
  end

end
