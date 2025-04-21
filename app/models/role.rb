class Role < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def self.valid_roles
    pluck(:name)
  end
end
