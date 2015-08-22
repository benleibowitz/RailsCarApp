class AddImageToCars < ActiveRecord::Migration
  def change
  	add_column :cars, :image_file_name, :string
  	add_column :cars, :image_content_type, :string
  	add_column :cars, :image_file_size, :integer
  	add_column :cars, :image_updated_at, :datetime
  end
end
