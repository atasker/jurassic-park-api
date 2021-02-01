# frozen_string_literal: true

class Cage < ApplicationRecord
  # Default power_status is set to active.
  enum power_status: %i[down active]

  before_save :check_for_dinosaurs, if: :will_save_change_to_power_status?

  has_many :dinosaurs

  validates :maximum_capacity, presence: true

  def dinosaur_count
    self.dinosaurs.size
  end

  private

  def check_for_dinosaurs
    if self.down? && self.dinosaur_count > 0
      raise ExceptionHandler::CustomValidationError, 'Cannot be powered down if cage contains dinosaur(s).'
    end
  end
end
