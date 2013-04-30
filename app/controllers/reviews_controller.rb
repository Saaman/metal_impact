class ReviewsController < ApplicationController

  include ContributableHelper

  load_and_authorize_resource
  skip_load_resource :only => :create
  respond_to :html
  layout false

  def new
    @review = Review.new params.slice :product_id, :product_type
    respond_with @review, layout: false
  end

  def edit
    @review = review.find(params[:id])
    check_for_existing_contribution @review
    respond_with @review
  end

  def create
    @review = build_review(Review.new(params[:review].slice :product_id, :product_type), params)

    if @review.contribute(current_user, can?(:bypass_contribution, @review))
      make_flash_for_contribution @review
    end

    respond_with @review
  end

  def update
    @review = review.find(params[:id])
    create_or_update_review(params, "edit")
  end

  private

    def build_review(review, params)
      review.attributes = params[:review].slice :body, :score
      review.reviewer = current_user
      return review
    end
end
