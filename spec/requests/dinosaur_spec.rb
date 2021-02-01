# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dinosaur specs', type: :request do
  let!(:cage) { Cage.create }
  let!(:dinosaur) { Dinosaur.create(name: 'dave', species: 'tyrannosaurus', cage_id: cage.id) }
  let(:dinosaur_id) { dinosaur.id }

  describe 'GET /api/v1/dinosaurs' do
    before { get '/api/v1/dinosaurs' }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns all dinosaurs' do
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end
  end

  describe 'GET /api/v1/dinosaurs/:id' do
    before { get "/api/v1/dinosaurs/#{dinosaur_id}" }

    context 'when record exists' do
      it 'returns the desired dinosaur' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json['name']).to eq(dinosaur.name)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when record does not exist' do
      let(:dinosaur_id) { 999 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it "returns the message 'Couldn't find Dinosaur with id=999" do
        expect(response.body).to match(/Couldn't find Dinosaur/)
      end
    end
  end

  describe 'POST /api/v1/dinosaurs' do
    context 'when the request is valid' do
      before { post '/api/v1/dinosaurs', params: { name: 'sam', species: 'tyrannosaurus', cage_id: cage.id } }

      it 'creates a dinosaur named sam' do
        json = JSON.parse(response.body)
        expect(json['name']).to eq('sam')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the species is unsupported' do
      before { post '/api/v1/dinosaurs',
        params: { name: 'invalid_dino',
                  species: 'unsupported_species',
                  cage_id: cage.id } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Species is not included in the list/)
      end
    end
  end

  describe 'PUT /api/v1/dinosaurs/:id' do
    context 'when the record exists' do
      before { put "/api/v1/dinosaurs/#{dinosaur_id}", params: { name: 'jane' } }

      it 'updates the dinosaur' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204 (no content)' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when adding a dinosaur to a powered down cage' do
      let!(:powered_down_cage) { Cage.create(power_status: 'down') }

      before { put "/api/v1/dinosaurs/#{dinosaur_id}", params: { cage_id: powered_down_cage.id } }

      it "returns 'Cannot be added to cage that is powered down.'" do
        expect(response.body).to match(/cage that is powered down/)
      end
    end

    context 'when adding a herbivore to a cage with carnivores' do
      let!(:herbivore_cage) { Cage.create }
      let!(:carnivore_cage) { Cage.create }
      let!(:carnivore) { Dinosaur.create(name: 'carny', species: 'spinosaurus', cage_id: carnivore_cage.id) }
      let!(:herbivore) { Dinosaur.create(name: 'herby', species: 'triceratops', cage_id: herbivore_cage.id) }

      before { put "/api/v1/dinosaurs/#{herbivore.id}", params: { cage_id: carnivore_cage.id } }

      it "returns 'Herbivores cannot be in the same cage as Carnivores'" do
        expect(response.body).to match(/Herbivores cannot be in the same cage/)
      end
    end

    context 'when adding a carnivore to a cage with a carnivore of a different species' do
      let!(:cage_for_velociraptor) { Cage.create }
      let!(:velociraptor) { Dinosaur.create(name: 'sharon', species: 'velociraptor', cage_id: cage_for_velociraptor.id) }

      before { put "/api/v1/dinosaurs/#{velociraptor.id}", params: { cage_id: cage.id } }

      it "returns 'Carnivores can only be in a cage with Dinosaurs of the same species'" do
        expect(response.body).to match(/with Dinosaurs of the same species/)
      end
    end

    context 'when adding a dinosaur to a cage that has reached maximum capacity' do
      let!(:cage_max_one) { Cage.create(maximum_capacity: 1) }
      let!(:lonely_dinosaur) { Dinosaur.create(name: 'terry', species: 'tyrannosaurus', cage_id: cage_max_one.id) }

      before { put "/api/v1/dinosaurs/#{dinosaur_id}", params: { cage_id: cage_max_one.id } }

      it "returns 'Cage at maximum capacity'" do
        expect(response.body).to match(/Cage at maximum capacity/)
      end
    end
  end
end