module Ordering
  extend ActiveSupport::Concern

  included do
    validate :valid_child_ordering #, :valid_published_entry_ordering

    ####
    # Scopes
    ####
    # This scope will order based on the parent's [child]_ordering attribute
    scope :ordering_scope, -> (parent) {
      # Table name needed for query clarification
      table = self.table_name
      # The attribute in the parent that holds the ordering
      ordering_attribute = "#{parent.class::ORDERING_CHILD.underscore}_ordering"
      # The order query string
      ordering = ''
      # Check the parent truly has the ordering_attribute
      if parent.attribute_present?(ordering_attribute.to_sym)
        parent.send(ordering_attribute).each do |a|
          # Split for attribute:direction
          val, dir = a.split(':')
          ordering += "#{table}.#{val} #{dir} NULLS LAST,"
        end
      end
      # Remove ending comma
      order(ordering.chomp(','))
    }
  end

  ####
  # Validations
  ####
  # Menu Ordering values are valid
  def valid_child_ordering
    # If ORDERING_CHILD exists and is a class
    # if self.class::ORDERING_CHILD.present?()
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
      # Valid attributes for ordering
      if self.class.const_defined?(:ADDITIONAL_ORDER_ATTRIBUTES)
        valid_orderings = child_resource.column_names - ['id'] + self.class::ADDITIONAL_ORDER_ATTRIBUTES
      else
        valid_orderings = child_resource.column_names - ['id']
      end
      # Check if attribute exists
      if attribute_present?(ordering_attribute.to_sym)
        # Loop and check that array
        self.send(ordering_attribute).each do |m|
          val = m.split(':')[0]
          if !valid_orderings.include?(val)
            errors.add(ordering_attribute.to_sym, "#{val} is not a valid menu ordering value")
          end
        end
      end
    end
  end

  # Published Entry Ordering values are valid
  # def valid_published_entry_ordering
  #   if attribute_present?(:published_entry_ordering)
  #     if self.class.const_defined?(:PUBLISHED_ENTRY_PARENTS)
  #       valid_orderings = PublishedEntry.column_names - ['id'] + self.class::PUBLISHED_ENTRY_PARENTS
  #     else
  #       valid_orderings = PublishedEntry.column_names - ['id']
  #     end
  #     published_entry_ordering.each do |m|
  #       val = m.split(':')[0]
  #       if !valid_orderings.include?(val)
  #         errors.add(:published_entry_ordering, "#{val} is not a valid published entry ordering value")
  #       end
  #     end
  #   end
  # end

end
