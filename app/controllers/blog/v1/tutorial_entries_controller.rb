class Blog::V1::TutorialEntriesController < Blog::V1::BlogController
  include HasCreator
  include PageRecords
  include DateRange

  before_action :require_login, only: [:create, :update, :destroy]

  respond_to :json


  protected

  def permitted_params
    params.require(:tutorial_entry).permit(:author_id, :domain_id, :entry_id,
                                            :image_url, :notes, :tags, :data)
  end
end
