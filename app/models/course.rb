# == Schema Information
#
# Table name: courses
#
#  id               :integer          not null, primary key
#  sourcedId        :string
#  status           :string
#  dateLastModified :datetime
#  title            :string
#  courseCode       :string
#  orgSourcedId     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Course < ApplicationRecord
end
