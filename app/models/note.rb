class Note < ApplicationRecord
  belongs_to :user

  default_scope { order(created_at: :desc) }

  SAMPLE_COLORS =  %w(#FF5CB8 #00A1D7 #DEF050 #FFD234 #EB016E)
end
