module HasOrdering
  extend ActiveSupport::Concern

  # Before any action check that current user is known
  included do
    before_action :set_ordering_scopes, only: [:index]
  end
  
  # set the ordering scope found in the Ordering model concern
  def set_ordering_scopes
    # get_resources() from default_api_actions concern
    resource_name, resource_id, parent_name, parent_id = get_resources()
    # Rescue block in case resource_name is not a model class
    begin
      resource_model = resource_name.classify.constantize
    rescue NameError => e
      puts "\n\nInvalid resource: #{resource_name}", error: "#{e}\n\n"
      Rails.logger.debug "\n\nInvalid resource: #{resource_name}", error: "#{e}\n\n"
      @errors[:msg] = "Invalid resource: #{resource_name}"
    end

    # Rescue block in case parent_name is not a model class
    begin
      parent_model = parent_name.classify.constantize
    rescue NameError => e
      puts "\n\n#{resource_name.classify}: Invalid parent: #{parent_name}", error: "#{e}\n\n"
      Rails.logger.debug "\n\n#{resource_name.classify}: Invalid parent: #{parent_name}", error: "#{e}\n\n"
      @errors[:msg] = "#{resource_name.classify}: Invalid parent: #{parent_name}"
    end

    # Get the parent for parameters
    parent = parent_model.where("id = ?", parent_id).take
    @scopes = @scopes || []
    # Check there is a model, it responds to ordering_scope, and that the parent record exists
    if resource_model.present? && resource_model.respond_to?(:ordering_scope) && parent.present?
      @scopes.push({scope: :ordering_scope, params: [parent]})
    end
  end

end
