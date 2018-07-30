require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe 'CSRF protection' do
    it 'protects from forgery' do
      strategy = ApplicationController.new.forgery_protection_strategy
      expect(strategy).not_to be_nil
    end
  end
end
