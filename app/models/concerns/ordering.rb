#######
# Ordering Concern
#
# Purpose: Allow a "parent" model to contain desired ordering if its has_many
# "children".
#
# Requirements:
# The "parent" model should have an attribute called
# {child}_ordering. Replace {child} with the name of the model. This is a
# priority array (first value take precedence). The values should be in the form
# {attribute}:{direction=asc|dsc}. This states which attribute to order by and
# whether to be ascending or descending. Each attribute must be an attribute of
# the child model (verified in :valid_child_ordering). Values that are not
# attributes of the child can be explicitly specified (more later).
# The parent model will also contain a class variable ORDERING_CHILD which will
# contain the name of the "child" model.
# Optionally the parent can have the class variable ADDITIONAL_ORDER_ATTRIBUTES
# populated with an array of strings that are additional accepted attributes for
# the {child}_ordering attribute. However if this is done the child model will
# need to write its own :ordering_scope to handle the additional attributes.
#
# Example:
# A menu has_many pages (thus page belongs_to menu). The menu will have
# an attribute called page_ordering and a class variable ORDERING_CHILD = "Page".
########

module Ordering
  extend ActiveSupport::Concern

  included do
    validate :valid_child_ordering

    ####
    # Constants
    ####
    # Setup a list of valid attributes for self.ORDERING_CHILD
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
  # Checks that Ordering values are valid
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
          val,order = m.split(':')
          order = order || 'asc'
          if !self.class.VALID_CHILD_ORDERING_ATTRIBUTES.include?(val)
            errors.add(ordering_attribute.to_sym, "#{val} is not a valid #{self.class::ORDERING_CHILD} ordering value")
          end
          if !(order.downcase == 'asc' || order.downcase == 'desc')
            errors.add(ordering_attribute.to_sym, "#{order} is not a valid #{self.class::ORDERING_CHILD} ordering direction")
          end
        end
      end
    end
  end

end
