class Project < ActiveRecord::Base
  self.inheritance_column = :_type_custom

  self.table_name = 'projects'
  self.primary_key = 'id'

  has_attached_file :project_image,
                    styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
                    
  validates_attachment_content_type :project_image, content_type: /\Aimage\/.*\z/
end
