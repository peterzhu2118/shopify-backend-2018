class ShopifyChallengeController < ApplicationController
  include GraphCycle
  include ChallengeApi

  def index
  end

  BASE_URL = "https://backend-challenge-summer-2018.herokuapp.com/challenges.json"

  def create
    id = params[:id].to_i

    unless [ 1, 2 ].include? id
      flash[:error] = "Invalid selection"
      render :index, status: :internal_server_error
      return
    end

    url = "#{BASE_URL}?id=#{id}"

    num_pages = get_num_pages(url)

    urls = Array.new

    (1..num_pages).each { |p| urls << "#{url}&page=#{p}"}

    adjacency_list, parents = get_menu_graph(urls)

    @menu = get_menus(adjacency_list, parents)

    render :show
  end

  def show
    byebug
  end
end
