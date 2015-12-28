require 'helper'
include DiamondLang

describe Errors::InvalidCoordinateValue do
  %w[5f ~!2!].each do |value|
    context "with the invalid value being #{value}" do
      subject(:message) {Errors::InvalidCoordinateValue.new(value).message}
      it {is_expected.to eq("#{value} isn't a valid coordinate.")}
    end
  end
end
