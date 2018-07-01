class Wiki < ApplicationRecord
  belongs_to :user, optional: true
end
