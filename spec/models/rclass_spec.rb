# == Schema Information
#
# Table name: rclasses
#
#  id               :integer          not null, primary key
#  sourcedId        :string
#  status           :string
#  dateLastModified :datetime
#  title            :string
#  courseSourcedId  :string
#  classCode        :string
#  classType        :string
#  schoolSourcedId  :string
#  termSourcedIds   :string
#  periods          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe Rclass, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
