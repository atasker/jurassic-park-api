# frozen_string_literal: true

dinosaur_names = %w[jane stacey bob david sharon bill emmett steve joe
                    alan ian christie yvan kristen elliott robbie heidi]

def create_three_cages
  3.times do
    Cage.create
  end
end

create_three_cages

# Populate a cage with Herbivores
dinosaurs = Dinosaur.create([
                              { name: dinosaur_names.sample, species: Dinosaur::HERBIVORES.sample, cage_id: 1 },
                              { name: dinosaur_names.sample, species: Dinosaur::HERBIVORES.sample, cage_id: 1 },
                              { name: dinosaur_names.sample, species: Dinosaur::HERBIVORES.sample, cage_id: 1 }
                            ])

# Populate a cage with T-Rex's
dinosaurs = Dinosaur.create([
                              { name: dinosaur_names.sample, species: 'tyrannosaurus', cage_id: 2 },
                              { name: dinosaur_names.sample, species: 'tyrannosaurus', cage_id: 2 },
                              { name: dinosaur_names.sample, species: 'tyrannosaurus', cage_id: 2 }
                            ])

# Populate a cage with Megalosaurus's
dinosaurs = Dinosaur.create([
                              { name: dinosaur_names.sample, species: 'megalosaurus', cage_id: 3 },
                              { name: dinosaur_names.sample, species: 'megalosaurus', cage_id: 3 },
                              { name: dinosaur_names.sample, species: 'megalosaurus', cage_id: 3 }
                            ])
