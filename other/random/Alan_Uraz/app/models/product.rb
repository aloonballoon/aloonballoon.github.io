class Product < ApplicationRecord
  
  validates :title, :description, :price, presence: true
  
  belongs_to :user 
  
  has_many :comments 
  
end