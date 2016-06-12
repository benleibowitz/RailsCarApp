class Asset < ActiveRecord::Base
	belongs_to :car

	has_attached_file :image
	validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
	validates_attachment_size :image, :less_than => 5.megabytes

	validates :image, :presence => true

end
