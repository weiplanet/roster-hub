module V1p1
  class ApplicationController < ActionController::API
    before_action :doorkeeper_authorize!
    ORDER_VALUES = %w[desc asc].freeze

    protected

    def orderby_validvalue(param)
      orderby = param.nil? ? 'desc' : param.downcase
      ORDER_VALUES.include?(orderby) ? orderby : 'desc'
    end

    def indexbase(model_class)
      datas = model_class.all
      datas = indexbase_with_condition(model_class, datas)
      render json: datas
    end

    def indexbase_with_condition(model_class, datas)
      # sourcedId
      sourced_id = params[:sourcedId]
      datas = datas.where(sourcedId: sourced_id) unless sourced_id.nil?
      # filter
      filter_param = params[:filter]
      unless filter_param.nil?
        # filter_parm to url decode
        filtervalue = URI.decode_www_form_component(filter_param, enc=Encoding::UTF_8)
        # divide with logical operation
        logical = nil
        filtervalues = filtervalue.split(' AND ')
        logical = 'AND' if filtervalues.size > 1
        filtervalues = filtervalue.split(' OR ') if logical.nil?
        logical = 'OR' if filtervalues.size > 1
        where1 = predict_formula(filtervalues.first)
        where2 = predict_formula(filtervalues.last) unless logical.nil?
        datas = datas.where(where1[:criteria], where1[:value]) if logical.nil?
        datas = datas.where(where1[:criteria] + ' ' + logical + ' ' + where2[:criteria], where1[:value], where2[:value]) unless logical.nil?
      end
      # limit & offset
      limit = params[:limit].nil? ? LIMIT : params[:limit]
      offset = params[:offset].nil? ? OFFSET : params[:offset]
      # sort
      sort = params[:sort].nil? ? 'sourcedId' : params[:sort]
      sort = model_class.columns_hash[sort].nil? ? 'sourcedId' : sort
      # orderby
      orderby = orderby_validvalue(params[:orderby])
      datas.order(sort + ' ' + orderby).limit(limit).offset(offset)
    end

    private

    def predict_formula(str)
      filter_hash = predict_kind(str)
      value = filter_hash[:value]
      match = value.match(/\'(?<value>.+)\'/)
      value = match[:value] unless match.nil?
      case filter_hash[:ope]
      when '~' then
        criteria = filter_hash[:key] + ' like ?'
        return { criteria: criteria, value: '%' + value + '%' }
      else
        criteria = filter_hash[:key] + ' ' + filter_hash[:ope] + ' ? '
        return { criteria: criteria, value: value }
      end
    end

    def predict_kind(str)
      predicts = ['!=', '>=', '<=', '=', '>', '<', '~']
      predicts.each do |p|
        values = str.split(p)
        return { ope: p, key: values[0], value: values[1] } if values.size > 1
      end
    end
  end
end
