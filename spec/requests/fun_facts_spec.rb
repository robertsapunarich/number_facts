# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'FunFact API', type: :request do
  describe 'GET /fun_fact?number=N' do
    it 'returns a fun fact' do
      get '/fun_facts', params: { question: 'Tell me a fun fact about the number 10' }

      expect(response).to have_http_status(200)
      response_body = JSON.parse(response.body)
      puts response_body
      expect(response_body['message']).to be_present
    end

    it 'fails gracefully when a number is not provided' do
      get '/fun_facts', params: { question: 'Tell me a fun fact about the number' }

      expect(response).to have_http_status(200)
      response_body = JSON.parse(response.body)
      puts response_body
      expect(response_body['message']).to be_present
    end
  end
end
