module Ordering
  extend ActiveSupport::Concern

  included do
    validate :valid_child_ordering #, :valid_published_entry_ordering

    ####
    # Constants
    ####
    def self.VALID_CHILD_ORDERING_ATTRIBUTES
      if self.const_defined?(:ORDERING_CHILD)
        # Get the child model
        begin
          child_resource = self::ORDERING_CHILD.classify.constantize
        rescue NameError => e
          throw "ORDERING CHILD ERROR: #{self::ORDERING_CHILD} is not a valid Model"
          return
        end
        # Valid attributes for ordering
        if self.const_defined?(:ADDITIONAL_ORDER_ATTRIBUTES)
          return child_resource.column_names - ['id'] + self::ADDITIONAL_ORDER_ATTRIBUTES
        else
          return child_resource.column_names - ['id']
        end
      end
    end

    ####
    # Scopes
    ####
    # This scope will order based on the parent's [child]_ordering attribute
    scope :ordering_scope, -> (parent) {
      # Table name needed for query clarification
      table = self.table_name
      # The order query string
      ordering = ''
      # Ensure parent is passed and the class has ORDERING_CHILD
      if parent.present? and parent.class.const_defined?(:ORDERING_CHILD)
        # The attribute in the parent that holds the ordering
        ordering_attribute = "#{parent.class::ORDERING_CHILD.underscore}_ordering"
        # Check the parent truly has the ordering_attribute
        if parent.attribute_present?(ordering_attribute.to_sym)
          parent.send(ordering_attribute).each do |a|
            # Split for attribute:direction
            val, dir = a.split(':')
            ordering += "#{table}.#{val} #{dir} NULLS LAST,"
          end
        end
      end
      # Remove ending comma
      order(ordering.chomp(','))
    }
    ####
    # END Scopes
    ####
  end

  ####
  # Validations
  ####
  # Menu Ordering values are valid
  def valid_child_ordering
    # If ORDERING_CHILD exists and is a class
    if self.class.const_defined?(:ORDERING_CHILD)
      # Build the attribute for ordering
      ordering_attribute = "#{self.class::ORDERING_CHILD.underscore}_ordering"
      # Get the child model
      begin
        child_resource = self.class::ORDERING_CHILD.classify.constantize
      rescue NameError => e
        errors.add(ordering_attribute.to_sym, "#{self.class::ORDERING_CHILD} is not a valid Model")
        return
      end
      # Check if attribute exists and VALID_CHILD_ORDERING_ATTRIBUTES exists
      if attribute_present?(ordering_attribute.to_sym) and self.class.VALID_CHILD_ORDERING_ATTRIBUTES.present?
        # Loop and check that array
        self.send(ordering_attribute).each do |m|
          val = m.split(':')[0]
          if !self.class.VALID_CHILD_ORDERING_ATTRIBUTES.include?(val)
            errors.add(ordering_attribute.to_sym, "#{val} is not a valid menu ordering value")
          end
        end
      end
    end
  end

end
