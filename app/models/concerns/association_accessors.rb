module AssociationAccessors
  extend ActiveSupport::Concern

  EXCLUDED_PARAMS = ['id', 'created_at', 'updated_at']

  included do
    after_initialize :add_methods
  end

  def add_methods
    if !self.association_params.nil?
      self.association_params.each do |association, params|
        # Convert into a Class
        begin
          resource = association.to_s.classify.constantize
        rescue NameError => e
          # If this is not a model class
          raise "AssociatioAccessor error: #{association} is not a model"
        end
        # Loop through params and create setters and getters
        valid_params = params - EXCLUDED_PARAMS
        valid_params.each do |param|
          # Define getter
          self.class.send :define_method, param do
            value = nil
            if self.respond_to?(association)
              record = self.send(association)
              if !record.nil? and record.respond_to?(param)
                instance_variable_set "@#{param}", record[param]
              end
            end
            instance_variable_get "@#{param}"
          end

          # Define setter
          self.class.send :define_method, "#{param}=" do |arg|
            if self.respond_to?(association)
              record = self.send(association)
              if !record.nil? and record.respond_to?(param)
                record[param] = arg
                if record.valid? and record.save
                  instance_variable_set "@#{param}", arg
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
  end

end
