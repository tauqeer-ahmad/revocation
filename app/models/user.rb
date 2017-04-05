class User < ApplicationRecord
  self.inheritance_column = :type_of
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def self.type_ofs
    %w(Administrator Teacher Student Parent Supervisor)
  end
end
