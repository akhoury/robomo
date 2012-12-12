class Asset < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :post

  has_attached_file :content,
    :styles => { :medium => "300x300>", :thumb => "100x100>" },
    :default_style => :thumb,
    :whiny_thumbnails => true
  # NOTE: i need to be after has_attached_file
  before_post_process :image?

  def image?
    !(content_content_type =~ /^image.*/).nil?
  end
end
