#
# ApplicationRecord abstract model for all other models to inherit from
#
# Note: This is also useful for future Rails 5 convention where
#       ApplicationRecord is built in automatically.
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

end
