class ResponseRole < ApplicationRecord
  belongs_to :response
  belongs_to :role
end
