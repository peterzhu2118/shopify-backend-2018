require 'set'
require 'tsort'

module GraphCycle
  extend ActiveSupport::Concern

  def get_menus(graph, parents)
    cycles = find_cycles(graph)

    nodes_in_cycle = cycles.flatten

    menu = { valid_menus: [], invalid_menus: [] }

    parents.each do |parent|
      children = dfs_traverse_children(graph, parent, Set.new)

      if nodes_in_cycle.include? parent
        menu[:invalid_menus] << { root_id: parent, children: children }
      else
        menu[:valid_menus] << { root_id: parent, children: children }
      end
    end

    return menu
  end



  def find_cycles(graph)
    each_node = lambda {|&b| graph.each_key(&b) }
    each_child = lambda {|n, &b| graph[n].each(&b) }

    strongly_connected_components = TSort.strongly_connected_components(each_node, each_child)

    answer = Array.new

    strongly_connected_components.each do |component|
      answer << component if component.size > 1
    end

    answer
  end

  private

  def dfs_traverse_children(graph, curr_node, visited)
    children = Set.new

    child_nodes = graph[curr_node]

    child_nodes.each do |child|
      unless visited.include? child
        visited << child
        children += dfs_traverse_children(graph, child, visited)
      end
    end

    children += child_nodes

    return children.to_a.sort
  end



=begin
  def find_cycles(graph)
    visited_nodes = Set.new

    visit_stack = Array.new

    curr_node = (graph.keys - visited_nodes.to_a).first

    cycles = Set.new

    while !curr_node.nil? do
      visited_nodes << curr_node
      visit_stack << curr_node

      children = graph[curr_node] || []

      next_iteration = false

      children.each do |child|
        # If this child node has been visited before
        if visited_nodes.include? child
          # If this child node has been visited in the stack then this is a cycle
          if visit_stack.include? child
            cycles << visit_stack.to_a.sort
          else
            next
          end
        else # If this child node has not been visited before, visit it
          curr_node = child

          next_iteration = true

          break
        end
      end

      next if next_iteration

      # No more children to visit
      # Move up in stack if not empty
      if visit_stack.size >= 2
        visit_stack.pop
        prev_node = visit_stack.pop

        curr_node = prev_node
      else
        visit_stack.clear

        unvisited_nodes = (graph.keys - visited_nodes.to_a)

        # If no more unvisited nodes then computation is over
        if unvisited_nodes.empty?
          break
        else # Otherwise, start from first unvisited node
          curr_node = unvisited_nodes.first
        end
      end
    end

    return cycles.to_a
  end
=end
end
