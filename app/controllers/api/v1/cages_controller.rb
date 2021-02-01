# frozen_string_literal: true
module Api
  module V1
    class CagesController < ApplicationController
      before_action :set_cage, only: [:show, :update]

      def index
        @cages = Cage.all
        json_response(@cages.as_json(methods: :dinosaur_count))
      end

      def show
        json_response({
          "cage": @cage,
          "dinosaurs": @cage.dinosaurs
        })
      end

      def create
        @cage = Cage.create!(cage_params)
        json_response(@cage, :created)
      end

      def update
        @cage.update!(cage_params)
        head :no_content
      end

      private

      def cage_params
        params.permit(:maximum_capacity, :power_status)
      end

      def set_cage
        @cage = Cage.find(params[:id])
      end

    end
  end
end