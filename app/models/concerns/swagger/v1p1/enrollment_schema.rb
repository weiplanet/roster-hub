module Swagger::V1p1::EnrollmentSchema
  extend ActiveSupport::Concern
  include Swagger::Blocks

  included do
    swagger_schema :Enrollment do
      key :required, %i[sourcedId classSourcedId schoolSourcedId userSourcedId role primary]
      property :sourcedId do
        key :description, 'Source Identifier'
        key :type, :string
      end
      property :status do
        key :description, 'not used'
      end
      property :dateLastModified do
        key :description, 'not used'
      end
      property :classSourcedId do
        key :description, 'Link to the class. Class sourcedId'
        key :type, :string
      end
      property :schoolSourcedId do
        key :description, 'Link to the school. Org sourcedId'
        key :type, :string
      end
      property :userSourcedId do
        key :description, 'Link to the enrolled user. User sourcedId'
        key :type, :string
      end
      property :role do
        key :description, 'Enrollment role'
        key :type, :string
        key :enum, %w[administrator aide guardian parent proctor relative student teacher]
      end
      property :primary do
        key :description, 'Applicable only to teachers. Only one teacher should be designated as the primary teacher for a class in the period defined by the begin/end dates.'
        key :type, :boolean
      end
      property :beginDate do
        key :description, 'not used'
      end
      property :endDate do
        key :description, 'not used'
      end
      if METADATA[:enrollments]
        property :metadata do
          key :type, :object
          METADATA[:enrollments].each do |k, v|
            property k do
              key :description, v[:description] if v[:description]
              key :type, v[:type] if v[:type]
            end
          end
        end
      end
    end

    swagger_schema :EnrollmentInput do
      key :required, %i[sourcedId classSourcedId schoolSourcedId userSourcedId role primary]
      property :status do
        key :description, 'not used'
      end
      property :dateLastModified do
        key :description, 'not used'
      end
      property :classSourcedId do
        key :description, 'Link to the class. Class sourcedId'
        key :type, :string
      end
      property :schoolSourcedId do
        key :description, 'Link to the school. Org sourcedId'
        key :type, :string
      end
      property :userSourcedId do
        key :description, 'Link to the enrolled user. User sourcedId'
        key :type, :string
      end
      property :role do
        key :description, 'Enrollment role'
        key :type, :string
        key :enum, %w[administrator aide guardian parent proctor relative student teacher]
      end
      property :primary do
        key :description, 'Applicable only to teachers. Only one teacher should be designated as the primary teacher for a class in the period defined by the begin/end dates.'
        key :type, :boolean
      end
      property :beginDate do
        key :description, 'not used'
      end
      property :endDate do
        key :description, 'not used'
      end
      if METADATA[:enrollments]
        property :metadata do
          key :type, :object
          METADATA[:enrollments].each do |k, v|
            property k do
              key :description, v[:description] if v[:description]
              key :type, v[:type] if v[:type]
            end
          end
        end
      end
    end
  end
end
