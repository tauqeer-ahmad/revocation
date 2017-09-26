class AddNoticeableToNotices < ActiveRecord::Migration[5.0]
  def change
    add_reference :notices, :noticeable, polymorphic: true, index: true
  end
end
