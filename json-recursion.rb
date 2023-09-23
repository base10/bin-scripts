# I'd like to figure out recursion around transforming deep data structures
# efficiently.
# in this case, I'd like to take a list of nested parameters and make them safe
# for use with JSON


    def json_safe_sendgrid_params
      sendgrid_params.each_with_object({}) |key, value, safe_params| do
        # I want to recurse over data structures and spit out stringified hashes
        # or arrays. I think that just means calling json_safe_element until I
        # reach a string or integer


      end

      p safe_params

      safe_params
    end

    def json_safe_element(element)
      element.to_s
    end
