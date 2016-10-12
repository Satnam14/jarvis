class MainController < ApplicationController

  def get_cards_by_priority
    # discover the magic function
  end

  def change_list_priority
    lists = List.all
    subject_list = lists.detect { |list| list[:id] == params[:list_id] }
    previous_list = lists.detect { |list| list[:order] == params[:order] }
    affected_lists = lists.select do |list|
      list[:order] < subject_list[:order] &&
      list[:order] >= previous_list[:order]
    end

    first_result = subject_list.update(order: params[:order])
    second_result = affected_lists.update_all("order = order + 1")

    if first_result && second_result
      render json: List.all
    else
      render json: first_result.errors.full_messages if first_result == false
      render json: second_result.errors.full_messages if second_result == false
    end
  end

  def get_lists_priority
    @lists = List.where(archived: false).order(:priority)
    render json: @lists
  end
end
