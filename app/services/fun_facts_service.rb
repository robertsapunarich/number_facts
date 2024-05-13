# frozen_string_literal: true

class FunFactsService
  attr_reader :user_query, :client, :number, :fact

  def initialize(user_query)
    @user_query = user_query
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def run
    response =
      client.chat(
        parameters: build_params
      )

    message = response.dig('choices', 0, 'message')

    return unless message['role'] == 'assistant' && message['tool_calls']

    function_name = message.dig('tool_calls', 0, 'function', 'name')
    args =
      JSON.parse(
        message.dig('tool_calls', 0, 'function', 'arguments'),
        { symbolize_names: true }
      )

    case function_name
    when 'get_fact_from_numbers_api'
      get_fact_from_numbers_api(**args)
    end
  end

  private

  def build_params
    {
      model: 'gpt-3.5-turbo',
      messages: [
        {
          "role": 'user',
          "content": user_query
        }
      ],
      tools: [
        {
          type: 'function',
          function: {
            name: 'get_fact_from_numbers_api',
            description: 'Get a fun fact about a number',
            parameters: {
              type: :object,
              properties: {
                number: {
                  type: 'integer',
                  description: 'The number to get a fun fact about'
                }
              },
              required: ['number']
            }
          }
        }
      ],
      tool_choice: {
        type: 'function',
        function: {
          name: 'get_fact_from_numbers_api'
        }
      }
    }
  end

  def get_fact_from_numbers_api(number:)
    response = HTTParty.get("http://numbersapi.com/#{number}")
    response.body
    @number = number
    @fact = response.body
  end
end
