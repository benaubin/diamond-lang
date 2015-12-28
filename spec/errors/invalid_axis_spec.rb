require 'helper'
include DiamondLang

describe Errors::InvalidAxis do
  %w[i w a].each do |axis|
    context "with the invalid axis being #{axis}" do
      subject(:message) {Errors::InvalidAxis.new(axis).message}
      it {is_expected.to eq("A cordinate was created with an axis of #{axis}, which isn't in: [x, y, z]")}
    end
  end
end
