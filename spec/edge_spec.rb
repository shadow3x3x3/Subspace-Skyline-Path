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

      describe 'set 9' do
        it 'attrs should be raise ArgumentError' do
          expect{ edge.set_subspace(9) }.to raise_error(ArgumentError)
        end
      end

      describe 'set [0, 9]' do
        it 'attrs should be raise ArgumentError' do
          expect{ edge.set_subspace([0, 9]) }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe '#set_max_attrs' do
    context 'in postions [0, 3]' do
      it 'max_attrs should be [1, 4]' do
        edge.set_max_attrs([0, 3])
        expect(edge.max_attrs).to eq([1, 4])
      end

      it 'norm_attrs should be [2, 3]' do
        edge.set_max_attrs([0, 3])
        expect(edge.norm_attrs).to eq([2, 3])
      end

      describe 'and set min postions 2' do
        it 'min_attrs should be [3]' do
          edge.set_min_attrs(2)
          expect(edge.min_attrs).to eq([3])
        end

        it 'norm_attrs should be [2]' do
          edge.set_max_attrs([0, 3])
          edge.set_min_attrs([2])
          expect(edge.norm_attrs).to eq([2])
        end
      end
    end
  end

end
