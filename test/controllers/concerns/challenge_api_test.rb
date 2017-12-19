require 'test_helper'
require 'rest-client'

class ChallengeApiTest < ActionController::TestCase
  include ChallengeApi

  test 'json parse returns adjacency list and parents' do
    json = IO.read("#{Rails.root}/test/controllers/concerns/sample_api_response.json")

    adjacency_list, parents = parse_json(json)

    assert_equal adjacency_list,  { 1 => [3], 2 => [4], 3 => [5], 4 => [6], 5 => [1], 6 => [] }
    assert_equal parents, [ 1, 2 ]
  end

  test 'get single page graph should call correct URL' do
    url = "http://example.com/test"

    response = mock()
    response.expects(:code).returns(200)
    response.stubs(:body)

    RestClient.expects(:get).with(url).returns(response).once

    stubs(:parse_json)

    get_single_page_graph(url)
  end

  test 'get single page graph should call parse json' do
    json_body = mock()

    response = mock()
    response.stubs(:code).returns(200)
    response.expects(:body).returns(json_body).once

    RestClient.stubs(:get).with(anything).returns(response)

    expects(:parse_json).with(json_body).once

    get_single_page_graph("")
  end
end
