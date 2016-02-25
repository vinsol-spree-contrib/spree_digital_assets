module Spree
  class Folder < Spree::Base
    acts_as_nested_set dependent: :destroy
    has_many :digital_assets, dependent: :destroy

    validates :name, presence: true


  end
end
