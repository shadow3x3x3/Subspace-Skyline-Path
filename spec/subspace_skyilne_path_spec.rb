require_relative 'spec_helper'

require_relative '../structure/util/read_util.rb'

require_relative '../subspace_skyline_path.rb'

EDGE_PATH = './test-data/test-edge.txt'.freeze

test_edges = File.read(EDGE_PATH)

describe SubspaceSkylinePath do
  let(:subspace_skyline_path) { SubspaceSkylinePath.new(raw_edges: test_edges) }

  describe '#set_subspace_attrs' do
    context 'when postions are [0, 2]' do


      it 'first edge attrs should be [10, 1]' do
        subspace_skyline_path.set_subspace_attrs([0, 2])
        target_edge = subspace_skyline_path.edges.first
        expect(target_edge.attrs).to eq([10, 1])
      end

      it 'last edge attrs should be [5, 1]' do
        subspace_skyline_path.set_subspace_attrs([0, 2])
        target_edge = subspace_skyline_path.edges.last
        expect(target_edge.attrs).to eq([5, 1])
      end
    end
  end


end
