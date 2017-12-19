require 'rest-client'

module ChallengeApi
  extend ActiveSupport::Concern

  def get_num_pages(url)
    response = RestClient.get(url)

    unless response.code == 200
      return nil
    end

    parsed_json = JSON.parse(response.body)

    pages = (parsed_json['pagination']['total']/parsed_json['pagination']['per_page'] .to_f).ceil
  end


  def get_menu_graph(urls)
    adjacency_list = Hash.new

    parents = Array.new

    urls.each do |url|
      curr_adjacency_list, curr_parents = get_single_page_graph(url)

      adjacency_list.merge!(curr_adjacency_list){ |key,oldval,newval| oldval | newval }

      parents |= curr_parents
    end

    return adjacency_list, parents
  end

  private

  def get_single_page_graph(url)
    response = RestClient.get(url)

    unless response.code == 200
      return nil
    end

    return parse_json(response.body)
  end


  def parse_json(json)
    parsed_json = JSON.parse(json)

    items = parsed_json['menus']

    adjacency_list = Hash.new

    parents = Array.new

    items.each do |item|
      id = item['id']
      children = item['child_ids']

      parents << id if item['parent_id'].nil?

      adjacency_list[id] = children
    end

    return adjacency_list, parents
  end
end
