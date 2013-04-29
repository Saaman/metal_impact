class ReviewsController < ApplicationController

  include ContributableHelper

  load_and_authorize_resource
  skip_load_resource :only => :create
  respond_to :html

  def new
    @review = Review.new
    respond_with @review
  end

  def edit
    @review = review.find(params[:id])
    check_for_existing_contribution @review
    respond_with @review
  end

  def create
    @review = Album.new
    create_or_update_review(params, "new")
  end

  def update

    @review = review.find(params[:id])
    create_or_update_review(params, "edit")
  end

  private

    def create_or_update_review(params, template)

      @review.attributes = params[:review].slice :body, :score, :reviewer, :product

      if @review.contribute(current_user, can?(:bypass_contribution, @review))
        make_flash_for_contribution @review
        respond_with @review
      else
        respond_with @review do |format|
          format.html { render template }
        end
      end
    end
end
