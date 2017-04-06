class Institution < ApplicationRecord
  def display_created_at
    created_at.strftime("%d, %B %Y %H:%M %p")
  end
end
