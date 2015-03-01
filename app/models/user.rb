class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  #all relations
  has_many :organization_user_relations, :dependent => :destroy
  has_many :organizations, :through => :organization_user_relations
  has_many :event_user_relations, :dependent => :destroy
  has_many :events, :through => :event_user_relations
  has_many :tickets, :dependent => :destroy

  #all validations
  validates :name, :presence => true 
end
