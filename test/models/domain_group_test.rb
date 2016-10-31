# == Schema Information
#
# Table name: domain_groups
#
#  id          :integer          not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class DomainGroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
