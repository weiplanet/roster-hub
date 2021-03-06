module V1p1
  class CoursesController < V1p1::ApplicationController
    include Swagger::V1p1::CoursesApi

    def school
      relations = Course.where(orgSourcedId: params[:schoolSourcedId])
      relations = indexbase_with_condition(relations)
      render_json('Course', relations)
    end

    private

    def strong_params
      params.require(:course).permit(:status, :dateLastModified, :schoolYearSourcedId, :title, :courseCode, :grades, :orgSourcedId, :subjects, :subjectCodes)
    end
  end
end
