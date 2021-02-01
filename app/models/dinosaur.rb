# frozen_string_literal: true
class Dinosaur < ApplicationRecord
  before_validation :normalize_species
  before_save :ensure_active_cage
  before_save :check_maximum_capacity, if: :will_save_change_to_cage_id?
  before_save :check_compatible_species, if: :will_save_change_to_cage_id?

  belongs_to :cage

  CARNIVORES = %w(tyrannosaurus velociraptor spinosaurus megalosaurus)
  HERBIVORES = %w(brachiosaurus stegosaurus ankylosaurus triceratops)
  SPECIES = CARNIVORES + HERBIVORES

  validates :name, presence: true
  validates :species, presence: true, inclusion: { in: SPECIES }

  private

  def normalize_species
    self.species = species.downcase
  end

  def ensure_active_cage
    cage = Cage.find(self.cage_id)
    if cage.down?
      raise ExceptionHandler::CustomValidationError, 'Cannot be added to cage that is powered down.'
    end
  end

  def check_maximum_capacity
    cage = Cage.find(self.cage_id)
    current_inhabitant_count = Dinosaur.where(cage_id: self.cage_id).size
    if cage.maximum_capacity == current_inhabitant_count
      raise ExceptionHandler::CustomValidationError, 'Cage at maximum capacity.'
    end
  end

  # Accepts ActiveRecord::Relation of Dinosaur objects.
  # Returns Array of corresponding types, e.g ['carnivore', 'herbivore'].
  def get_type(dinosaur_objects)
    Array(dinosaur_objects).map do |d|
      CARNIVORES.include?(d.species) ? 'carnivore' : 'herbivore'
    end
  end

  def check_compatible_species
    current_inhabitants = Dinosaur.where(cage_id: self.cage_id)
    dinosaur_type = get_type(self).first
    dinosaur_species = self.species
    if current_inhabitants.size > 0
      if dinosaur_type == 'herbivore'
        current_types = get_type(current_inhabitants)
        if current_types.include?('carnivore')
          raise ExceptionHandler::CustomValidationError, 'Herbivores cannot be in the same cage as Carnivores.'
        end
      else
        current_unique_species = current_inhabitants.map(&:species).uniq
        if current_unique_species.first != dinosaur_species
          raise ExceptionHandler::CustomValidationError, 'Carnivores can only be in a cage with Dinosaurs of the same species.'
        end
      end
    end
  end
end
