require 'test_helper'

class GraphCycleTest < ActionController::TestCase
  include GraphCycle

  test 'check cycle with shopify data set' do
    graph = { 1 => [3], 2 => [4], 3 => [5], 4 => [6], 5 => [1], 6 => [] }

    answer = check_cycle(graph)

    assert_equal [[1, 3, 5]], answer
  end

  test 'check cycle with no cycle' do
    graph = { 1 => [3], 2 => [4], 3 => [5], 4 => [6], 5 => [2], 6 => [] }

    answer = check_cycle(graph)

    assert_equal [], answer
  end

  test 'check cycle with two cycles' do
    graph = { 1 => [3], 2 => [4], 3 => [5], 4 => [6], 5 => [1], 6 => [4] }

    answer = check_cycle(graph)

    assert_equal [[1, 3, 5], [4, 6]], answer
  end

  test 'check cycle with three cycles' do
    graph = { 1 => [3], 2 => [4], 3 => [5], 4 => [6], 5 => [1], 6 => [4], 7 => [2],
      8 => [9], 9 => [10, 11], 10 => [8], 11 => [9] }

    answer = check_cycle(graph)

    assert_equal [[1, 3, 5], [4, 6], [8, 9, 10, 11]], answer
  end
end
