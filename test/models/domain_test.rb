# == Schema Information
#
# Table name: domains
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  subdomain   :string           not null
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class DomainTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
