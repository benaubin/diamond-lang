require 'helper'
include DiamondLang

describe Helpers::Block do
  context "with no nbt data" do
    (0..2).each do |data_value|
      context "with a data value of #{data_value}" do
        %w[stone sand wood].each do |id|
          context "with an id of #{id}" do
            subject(:block) {Helpers::Block.new id, data_value}
            it "is #{id}" do
              expect(block.id).to eq(id)
            end
            it "has a data value of #{data_value}" do
              expect(block.data_value).to eq(data_value)
            end
            it "converts to a string" do
              expect(block.to_s).to eq("#{id} #{data_value}")
            end
            it "converts to a string with a replace method" do
              expect(block.to_s(:replace)).to eq("#{id} #{data_value} replace")
            end
            context "when converted to falling sand" do
              subject(:falling_sand) {block.to_falling_sand}

              it {is_expected.to be_a(Helpers::FallingSand)}

              it "is a FallingSand entity" do
                expect(falling_sand.id).to eq("FallingSand")
              end
              it "has a block id of stone" do
                expect(falling_sand.data[:Block]).to eq(id)
              end
              it "has a time of 1" do
                expect(falling_sand.data[:Time]).to eq(1)
              end
            end
          end
        end
      end
    end
  end
end
