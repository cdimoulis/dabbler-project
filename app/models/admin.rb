class Admin < ApplicationRecord

  devise :database_authenticatable, :registerable, :recoverable,
         :trackable, :validatable, :lockable, :timeoutable


end
