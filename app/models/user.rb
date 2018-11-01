class User < ApplicationRecord
  include PgSearch



  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :events, foreign_key: 'owner_id'
  has_many :sign_ups
  has_many :attending, through: :sign_ups, source: :event

  mount_uploader :image, AvatarUploader

  acts_as_commontator

  pg_search_scope :search_full_text, against: [
    [:name, 'A'],
    [:email, 'B']
  ], using: {
    tsearch: { prefix: true }
  }

  has_friendship

  include DeviseTokenAuth::Concerns::User
  before_save -> { skip_confirmation! }

  def requesting? user
    self.pending_friends.include? user
  end

  private

  def skip_confirmation!
    confirmed_at = Time.now
  end


end
