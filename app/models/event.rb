class Event < ApplicationRecord
  include PgSearch

  validates :address, presence: true

  acts_as_votable
  acts_as_commontable
  acts_as_mappable #auto_geocode: true
  belongs_to :owner, class_name: "User", required: true
  mount_uploaders :contents, ContentUploader
  has_many :sign_ups
  has_many :attending, through: :sign_ups, source: :user


  pg_search_scope :search_full_text, against: [
    [:name, 'A'],
    [:description, 'B']
  ], using: {
    tsearch: { prefix: true }
  }
end
