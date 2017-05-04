class Project < ActiveRecord::Base

  self.table_name = 'users'
  self.primary_key = 'id'

  has_attached_file :profile_image,
                    styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

  validates_attachment_content_type :profile_image, content_type: /\Aimage\/.*\z/
end
