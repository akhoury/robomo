class CcUser < ActiveRecord::Base
  validates_presence_of :user
  validates_uniqueness_of :user_id, :scope => :ticket_id

  belongs_to :user
  belongs_to :ticket
end
