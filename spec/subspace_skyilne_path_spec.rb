require_relative 'spec_helper'

require_relative '../structure/util/read_util.rb'

require_relative '../subspace_skyline_path.rb'

EDGE_PATH = './test-data/test-edge.txt'.freeze
NODE_PATH = './test-data/test-node.txt'.freeze

test_edges = File.read(EDGE_PATH)
test_nodes = File.read(NODE_PATH)

SUB_1_2_PATHS = {:p0_1_2_4_5=>[13.0, 4.0], :p0_1_4_5=>[12.0, 3.0], :p0_3_4_5=>[14.0, 3.0], :p0_6_7_5=>[20.0, 3.0]}

describe SubspaceSkylinePath do
  let(:ssp) { SubspaceSkylinePath.new(raw_edges: test_edges, raw_nodes: test_nodes) }

  describe '#set_subspace_attrs' do
    context 'when subspace postions are [0, 2]' do
      it 'first edge attrs should be [10, 1]' do
        ssp.set_subspace_attrs([0, 2])
        target_edge = ssp.edges.first
        expect(target_edge.attrs).to eq([10, 1])
      end

      it 'last edge attrs should be [5, 1]' do
        ssp.set_subspace_attrs([0, 2])
        target_edge = ssp.edges.last
        expect(target_edge.attrs).to eq([5, 1])
      end
    end
  end

  describe '#get_all_paths' do
    context 'when subspace postions are [1, 2]' do
      it 'sholud list all of paths and attributes' do
        ssp.set_subspace_attrs([1, 2])
        all_paths = ssp.get_all_paths(src_id: 0, dst_id: 5)
        expect(all_paths).to eq(SUB_1_2_PATHS)
      end
    end
  end

  describe '#query_subspace_skyline_path' do
    context 'when subspace is full space' do
      context 'and from 0 to 5' do
        it 'should be found two skyline path(0_1_4_5, 0_6_7_5)' do
          ssp.set_subspace_attrs([0, 1, 2])
          result = ssp.query_subspace_skyline_path(src_id: 0, dst_id: 5)
          expect(result).to eq({:p0_1_4_5=>[40.0, 12.0, 3.0], :p0_6_7_5=>[36.0, 20.0, 3.0]})
        end
      end
    end
  end


end
