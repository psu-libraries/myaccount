# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Errors', type: :request do
  context 'when GET to errors route' do
    describe 'not found' do
      before (:all) { get '/404' }

      it 'has http status 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'redirects to customized not_found error page' do
        expect(response.body).to include '<h4>The page you were looking for doesn\'t exist.</h4>'
      end
    end

    describe 'internal server error' do
      before (:all) { get '/500' }

      it 'has http status 500' do
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'redirects to customized internal_server_error error page' do
        expect(response.body).to include '<h4>We\'re sorry, but something went wrong.</h4>'
      end
    end
  end

  context 'when POST to errors route' do
    describe 'not found' do
      before (:all) { post '/404' }

      it 'has http status 404' do
        expect(response).to have_http_status(:not_found)
      end

      it 'redirects to customized not_found error page' do
        expect(response.body).to include '<h4>The page you were looking for doesn\'t exist.</h4>'
      end
    end

    describe 'internal server error' do
      before (:all) { post '/500' }

      it 'has http status 500' do
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'redirects to customized internal_server_error error page' do
        expect(response.body).to include '<h4>We\'re sorry, but something went wrong.</h4>'
      end
    end
  end
end
