# frozen_string_literal: true

class ApplicationService
  include ActiveModel::Validations

  def initialize(params)
    @params = params
  end

  attr_reader :result

  private

  attr_reader :params

  def merge_errors_from(object, prefix=nil)
    object.errors.messages.each do |key, errs|
      err_key = [prefix.presence, key.to_s].compact.join(".")
      add_errors(err_key, errs)
    end
    false
  end
end
