class Redactor2Rails::Picture < Redactor2Rails::Asset
  mount_uploader :data, Redactor2RailsImageUploader, :mount_on => :data_file_name

  def url_content
    url(:content)
  end
end
