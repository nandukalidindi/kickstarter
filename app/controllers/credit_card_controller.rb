class CreditCardController < ApplicationController

  def new
    ActiveRecord::Base.connection.execute("INSERT INTO credit_cards(user_id, cc_number, is_default, is_enabled, created_at, updated_at) VALUES(#{current_user['id'].to_i}, '#{params[:number]}', '#{params[:is_default]}', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
  end

  def show
  end

  def index
  end

  def destroy
    ActiveRecord::Base.connection.execute("DELETE FROM credit_cards WHERE cc_number='#{params[:cc_number]}'")
  end
end
