# frozen_string_literal: true

class FunFactsService
  attr_reader :user_query, :ai_assistant, :fact

  def initialize(user_query)
    @user_query = user_query
    @ai_assistant = AiAssistant.new
  end

  def run
    response = ai_assistant.chat(user_query)

    message = ai_assistant.get_message(response)

    function_name = function_name_from_message(message)
    args = args_from_message(message)

    case function_name
    when 'get_fact_from_numbers_api'
      get_fact_from_numbers_api(**args)
    when 'return_message_from_system'
      return_message_from_system(**args)
    end
  end

  private

  def args_from_message(message)
    JSON.parse(
      message.dig('tool_calls', 0, 'function', 'arguments'),
      { symbolize_names: true }
    )
  end
  
  def function_name_from_message(message)
    message.dig('tool_calls', 0, 'function', 'name')
  end

  def return_message_from_system(message:)
    assign_fact(message)
  end

  def get_fact_from_numbers_api(number:)
    response = HTTParty.get("http://numbersapi.com/#{number}")
    response.body
    assign_fact(response.body)
  end

  def assign_fact(fact)
    @fact = fact
  end
end
