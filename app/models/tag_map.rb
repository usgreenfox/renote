class TagMap < ApplicationRecord
  belongs_to :note
  belongs_to :tag
end
