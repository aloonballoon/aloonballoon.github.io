require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:product) }
  it { should belong_to(:author) }
  it { should validate_presence_of(:body) }
  it 'should validate that :product cannot be empty/falsy' do
    should validate_presence_of(:product).with_message(/must exist/)
  end
  it 'should validate that :author cannot be empty/falsy' do
    should validate_presence_of(:author).with_message(/must exist/)
  end
end
