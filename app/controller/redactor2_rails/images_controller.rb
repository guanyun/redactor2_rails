class Redactor2Rails::ImagesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :redactor2_authenticate_user!

  def create
    file_param = params[:file] || params[:upload]
    if file_param.is_a?(Array)
      image_files = file_param.map do |file|
        { data: Redactor2Rails::Http.normalize_param(file, request) }
      end
      images = Redactor2Rails.image_model.create(image_files)
      response = images.map do |image|
        {"file-#{image.id}" => { id: image.id, url: image.url } }
      end
      render json: response
    else
      image = Redactor2Rails.image_model.create(data: Redactor2Rails::Http.normalize_param(file_param, request))
      render json: { id: image.id, url: image.url }
    end
  end

  private

  def redactor2_authenticate_user!
    if Redactor2Rails.image_model.new.has_attribute?(Redactor2Rails.devise_user)
      super
    end
  end
end
