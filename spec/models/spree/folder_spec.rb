require 'spec_helper'

describe Spree::Folder, :type => :model do

  describe 'Associations' do
    it { is_expected.to have_many(:digital_assets).dependent(:destroy) }
  end

  describe 'Valdations' do
    it { is_expected.to validate_presence_of(:name) }
  end

end
