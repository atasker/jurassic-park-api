# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Cage specs', type: :request do
  let!(:cage) { Cage.create }
  let(:cage_id) { cage.id }

  describe 'GET /api/v1/cages' do
    before { get '/api/v1/cages' }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns all cages' do
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json.size).to eq(1)
    end
  end

  describe 'GET /api/v1/cages/:id' do
    before { get "/api/v1/cages/#{cage_id}" }

    context 'when record exists' do
      it 'returns the desired cage' do
        json = JSON.parse(response.body)
        expect(json).not_to be_empty
        expect(json['cage']['id']).to eq(cage_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when record does not exist' do
      let(:cage_id) { 999 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it "returns 'Couldn't find Cage with id=999" do
        expect(response.body).to match(/Couldn't find Cage/)
      end
    end
  end

  describe 'POST /api/v1/cages' do
    context 'when the request is valid' do
      before { post '/api/v1/cages', params: { maximum_capacity: 14, power_status: 'active' } }

      it 'creates a cage' do
        json = JSON.parse(response.body)
        expect(json['maximum_capacity']).to eq(14)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v1/cages', params: { power_status: 'five' } }

      it 'returns status code 500' do
        expect(response).to have_http_status(500)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/is not a valid power_status/)
      end
    end
  end

  describe 'PUT /api/v1/cages/:id' do
    context 'when the record exists' do
      before { put "/api/v1/cages/#{cage_id}", params: { maximum_capacity: 10 } }

      it 'updates the cage' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204 (no content)' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when powering down an occupied cage' do
      let!(:dinosaur) { Dinosaur.create(name: 'oscar', species: 'ankylosaurus', cage_id: cage_id) }

      before { put "/api/v1/cages/#{cage_id}", params: { power_status: 'down' } }

      it "returns 'Cannot be powered down if cage contains dinosaur(s).'" do
        expect(response.body).to match(/Cannot be powered down/)
      end
    end
  end
end