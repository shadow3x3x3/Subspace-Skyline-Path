require_relative 'spec_helper'

require_relative '../structure/edge.rb'


describe Edge do
  let(:edge) { Edge.new([0, 3, 4, 1, 2, 3, 4]) }

  describe '#initialize' do
    it 'id should be 0' do
      expect(edge.id).to eq(0)
    end

    it 'src, dst should be 3, 4' do
      expect(edge.src).to eq(3)
      expect(edge.dst).to eq(4)
    end

    it 'attrs should be [1, 2, 3, 4]' do
      expect(edge.attrs).to eq([1, 2, 3, 4])
    end

    it 'dist should be 1.0' do
      expect(edge.dist).to eq(1.0)
    end
  end

  describe '#set_subspace' do
    context 'when we set subspace postions' do
      describe 'set [0, 3]' do
        it 'attrs should be [1, 4]' do
          edge.set_subspace([0, 3])
          expect(edge.attrs).to eq([1, 4])
        end
      end

      describe 'set [0, 1, 2]' do
        it 'attrs should be [1, 2, 3]' do
          edge.set_subspace([0, 1, 2])
          expect(edge.attrs).to eq([1, 2, 3])
        end
      end

      describe 'set [0, 2, 1]' do
        it 'attrs should be [1, 2, 3]' do
          edge.set_subspace([0, 2, 1])
          expect(edge.attrs).to eq([1, 2, 3])
        end
      end
    end
  end
end
