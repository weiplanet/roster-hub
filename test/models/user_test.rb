# == Schema Information
#
# Table name: users
#
#  sourcedId        :string           not null, primary key
#  status           :string
#  dateLastModified :datetime
#  enabledUser      :boolean
#  orgSourcedIds    :string
#  role             :string
#  username         :string
#  userIds          :string
#  givenName        :string
#  familyName       :string
#  middleName       :string
#  identifier       :string
#  email            :string
#  sms              :string
#  phone            :string
#  agentSourcedIds  :string
#  grades           :string
#  password         :string
#  metadata         :text
#  application_id   :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
