require 'rails_helper'

RSpec.describe ImageUrl, :type => :model do
  it { should belong_to(:image) }
  it { should belong_to(:product) }
end
