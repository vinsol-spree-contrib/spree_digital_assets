module Spree
  class Folder < Spree::Base
    acts_as_nested_set dependent: :restrict_with_error

    has_many :digital_assets, dependent: :restrict_with_error

    validates :name, presence: true
    validates :name, uniqueness: { case_sensitive: false }
  end
end
