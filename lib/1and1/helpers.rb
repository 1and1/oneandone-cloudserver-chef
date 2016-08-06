module Oneandone
  module Helpers
    def split_delimited_input(input)
      return [] if input.nil?

      if input.is_a? String
        input.strip!

        delimiter = ','
        # Knife is reading --option value1,value2 as "value1 value2"
        # on Windows PowerShell interface
        delimiter = ' ' if input.include? ' '

        values = input.split(delimiter)
        values
      else
        # return array of whatever
        [input]
      end
    end

    def validate(param, msg)
      if param.nil? || param.empty?
        ui.error("You must supply #{msg}!")
        exit 1
      end
    end
  end
end
