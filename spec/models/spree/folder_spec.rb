require 'spec_helper'

describe Spree::Folder, type: :model do

  describe 'Associations' do
    it { is_expected.to have_many(:digital_assets).dependent(:restrict_with_error) }
  end

  describe 'Valdations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

end
