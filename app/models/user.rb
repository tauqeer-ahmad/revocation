class User < ApplicationRecord
  self.inheritance_column = :type_of
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :first_name, presence: { message: "First name field is required" }
  validates :last_name, presence: { message: "Last name field is required" }
  validates :email, presence: { message: "First name field is required" }

  def self.type_ofs
    %w(Administrator Teacher Student Parent Supervisor)
  end

  def name
    [first_name, last_name].join(' ')
  end

  def category
    self.type_of.downcase
  end
end
