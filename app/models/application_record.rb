#
# ApplicationRecord abstract model for all other models to inherit from
#
# Note: This is also useful for future Rails 5 convention where
#       ApplicationRecord is built in automatically. All models will
#       inherit from ApplicationRecord instead of ActiveRecord::Base
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

end
