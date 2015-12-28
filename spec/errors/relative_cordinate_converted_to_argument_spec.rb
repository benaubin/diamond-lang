require 'helper'
include DiamondLang

describe Errors::RelativeCordinateConvertedToArgument do
  subject(:error) {Errors::RelativeCordinateConvertedToArgument.new}
  context "with the default message" do
    subject(:message) {error.message}
    it {is_expected.to eq("A relative cordinate was converted to an argument.")}
  end
end
