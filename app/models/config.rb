require "yaml"
require "erb"

class Config
  YAML_FILE = 'application.yml'

  class << self
    def [](key)
      stash.dig(*key.split('.'))
    end
    alias_method :get, :[]

    private

    def stash
      @stash ||= load
    end

    def load
      return {} unless File.exist?(YAML_FILE)

      YAML.load(ERB.new(File.read(YAML_FILE)).result) || {}
    rescue Psych::SyntaxError => e
      raise "YAML syntax error occurred while parsing #{YAML_FILE}. Error: #{e.message}"
    end
  end
end
