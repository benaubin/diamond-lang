require 'helper'
include DiamondLang

describe Errors::TooSmall do
  subject(:error) {Errors::TooSmall.new}
  context "with the default message" do
    subject(:message) {error.message}
    it {is_expected.to eq("Could not fit all commands in the area you selected.")}
  end
end
