module TestHelpers
  module Rails
    module EnvHelper
      def with_env_vars(vars)
        original = ENV.to_hash
        # vars.each { |k, v| ENV[k] = v }
        vars.each { |k, v| ENV[k.to_s] = v }

        begin
          yield
        ensure
          ENV.replace(original)
        end
      end
    end
  end
end
