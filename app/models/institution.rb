class Institution < ApplicationRecord
  SECTORS = %w(public private)
  LEVELS = %w(high middle primary olevel alevel)
  include AASM

  has_many :administrators
  has_many :teachers
  has_many :klasses
  has_many :subjects

  aasm :requires_lock => true, :column => 'status' do
    state :pending, :initial => true
    state :active, :locked

    event :pending do
      transitions :to => :pending
    end

    event :active do
      transitions :from => [:pending, :locked], :to => :active
    end

    event :locked do
      transitions :from => [:pending, :active], :to => :locked
    end
  end

  validates :name, presence: { message: "Name field is required" }
  validates :location, presence: { message: "Location field is required" }
  validates :city, presence: { message: "City must be selected" }
  validates :country, presence: { message: "Country must be selected" }
  validates :sector, presence: { message: "Sector must be selected" }

  def display_created_at
    created_at.strftime("%d, %B %Y %H:%M %p")
  end

  def display_status
    status.to_s.capitalize
  end

  def country_name
    country_code = ISO3166::Country[country]
    country_code.translations[I18n.locale.to_s] || country_code.name
  end
end
