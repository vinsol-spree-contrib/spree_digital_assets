require 'spec_helper'

describe Spree::DigitalAsset, :type => :model do

  it { is_expected.to have_attached_file(:attachment) }

  describe 'Associations' do
    it { is_expected.to belong_to(:folder) }
  end

  describe 'Valdations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:attachment) }
  end

end
