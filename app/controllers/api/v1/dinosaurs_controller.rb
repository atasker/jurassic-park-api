module Api
  module V1
    class DinosaursController < ApplicationController
      before_action :set_dinosaur, only: [:show, :update]

      def index
        @dinosaurs = Dinosaur.all
        json_response(@dinosaurs)
      end

      def show
        json_response(@dinosaur)
      end

      def create
        @dinosaur = Dinosaur.create!(dinosaur_params)
        json_response(@dinosaur, :created)
      end

      def update
        @dinosaur.update!(dinosaur_params)
        head :no_content
      end

      private

      def dinosaur_params
        params.permit(:name, :species, :cage_id)
      end

      def set_dinosaur
        @dinosaur = Dinosaur.find(params[:id])
      end
    end
  end
end