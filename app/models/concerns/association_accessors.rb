module AssociationAccessors
  extend ActiveSupport::Concern

  EXCLUDED_ATTRS = ['id', 'creator_id', 'created_at', 'updated_at']

  included do
    after_initialize :add_methods, :set_attributes
  end

  def add_methods
    if self.respond_to?(:association_attributes) && !self.association_attributes.nil?
      self.association_attributes.each do |association, attributes|
        # Convert into a Class
        begin
          resource = association.to_s.classify.constantize
        rescue NameError => e
          # If this is not a model class
          puts "\n\nAssociationAccessor error: #{association} is not a model\n\n"
          Rails.logger.info "\n\nAssociationAccessor error: #{association} is not a model\n\n"
          raise "AssociationAccessor error: #{association} is not a model"
        end

        # If this is not :belongs_to association then ignore
        if self.class.reflect_on_association(association).macro != :belongs_to
          puts "\n\nAssociationAccessor error: #{association} is not a belongs_to association\n\n"
          Rails.logger.info "\n\nAssociationAccessor error: #{association} is not a belongs_to association\n\n"
          raise "AssociationAccessor error: #{association} is not a belongs_to association"
          next
        end

        # Loop through attributes and create setters and getters
        valid_attributes = attributes - EXCLUDED_ATTRS
        valid_attributes.each do |attribute|
          # Define getter
          self.send :define_singleton_method, attribute do
            # Get the association record
            record = self.send(association)
            # record = _get_association association, resource
            if !record.nil? and record.respond_to?(attribute)
              instance_variable_set "@#{attribute}", record[attribute]
            end
            instance_variable_get "@#{attribute}"
          end
          
          # Define setter
          self.send :define_singleton_method, "#{attribute}=" do |arg|
            # Get the association record
            record = self.send(association)
            # record = _get_association association, resource
            if !record.nil? and record.respond_to?(attribute)
              record[attribute] = arg
              if record.valid? and record.save
                instance_variable_set "@#{attribute}", arg
                return true
              else
                return false
              end
            end
          end
        end
      end
    end
  end

  def set_attributes
    if self.respond_to?(:send_attributes) && !self.send_attributes.nil?
      valid_attributes = self.send_attributes - EXCLUDED_ATTRS
      obj = {}
      valid_attributes.each do |attribute|
        if self.respond_to?(attribute)
          obj = obj.merge(attribute.to_sym => self.send(attribute))
        end
      end
      self.send :define_singleton_method, 'attributes' do
        super().merge(obj)
      end
    end
  end

  private

  def _get_association(association, resource)
    if self.respond_to?(association)
      # Skip callbacks to avoid infinite loop
      if resource.included_modules.include?(AssociationAccessors)
        resource.skip_callback(:initialize, :after, :add_methods)
        resource.skip_callback(:initialize, :after, :set_attributes)
      end
      record = self.send(association)
      # Reset callbacks
      if resource.included_modules.include?(AssociationAccessors)
        resource.set_callback(:initialize, :after, :add_methods)
        resource.set_callback(:initialize, :after, :set_attributes)
      end
    end
    record
  end

end
