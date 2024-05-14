class AiAssistant

  attr_reader :client

  def initialize
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def chat(user_query)
    client.chat(
      parameters: build_params(user_query)
    )
  end

  private
  
  def build_params(user_query)
    {
      model: 'gpt-3.5-turbo',
      messages: build_messages(user_query),
      tools: define_tools,
      tool_choice: 'required'
    }
  end

  def build_messages(user_query)
    [
      {
        "role": 'system',
        "content": "Tell the user to provide a number if they don't provide one."
      },
      {
        "role": 'user',
        "content": user_query
      }
    ]
  end

  def define_tools
    [
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
      },
      {
        type: 'function',
        function: {
          name: 'return_message_from_system',
          description: 'Return a message from the the OpenAI system in the event it has insufficient information to respond to the user query',
          parameters: {
            type: :object,
            properties: {
              message: {
                type: 'string',
                description: 'The message to return to the user'
              }
            }
          }
        }
      }
    ]
    end
end
