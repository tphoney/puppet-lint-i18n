require 'pry'

PuppetLint.new_check(:check_i18n) do
  TRANSLATE_FUNCTION = "tstr"
  STRINGY = Set[:STRING, :SSTRING, :DQPRE]
  FUNCTIONS_TO_BE_DECORATED = Set['warning', 'fail']
  def check
    tokens.select { |token|
      FUNCTIONS_TO_BE_DECORATED.include?(token.value) && is_function?(token) && message_not_decorated?(token)
    }.each do |token|
      function = token.value
      non_decorated_message = token.next_token.next_token.value
      notify :warning, {
               :message => "'#{function}' messages should be decorated: eg #{TRANSLATE_FUNCTION}(#{non_decorated_message})",
               :line => token.line,
               :column => token.column,
               :token => token,
             }
    end
  end

  def fix(problem)
    binding.pry
  end

  def is_function?(suspected_function)
    suspected_function.type == :FUNCTION_NAME || suspected_function.type == :NAME
  end

  def message_not_decorated?(token)
    # the next token is the openning round brace so grab the next
    suspected_i18n_function = token.next_token.next_token
    suspected_i18n_function.value != TRANSLATE_FUNCTION
  end

end
