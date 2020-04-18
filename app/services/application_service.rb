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
      errs.each {|err| errors.add(err_key, err) }
    end
    false
  end
end
