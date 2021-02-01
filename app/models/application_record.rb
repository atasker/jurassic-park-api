# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Clean up the outputted json by redacting created_at & updated_at.
  def serializable_hash(options = {})
    options[:except] ||= []
    options[:except] << :created_at
    options[:except] << :updated_at
    super(options)
  end
end
