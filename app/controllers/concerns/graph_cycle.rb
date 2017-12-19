require 'set'
require 'tsort'

module GraphCycle
  extend ActiveSupport::Concern

  def check_cycle(graph)
    each_node = lambda {|&b| graph.each_key(&b) }
    each_child = lambda {|n, &b| graph[n].each(&b) }

    strongly_connected_components = TSort.strongly_connected_components(each_node, each_child)

    answer = Array.new

    strongly_connected_components.each do |component|
      answer << component if component.size > 1
    end

    answer
  end
end
