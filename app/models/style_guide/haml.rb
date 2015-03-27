module StyleGuide
  class Haml < Base
    DEFAULT_CONFIG_FILENAME = "haml.yml"

    def violations_in_file(file)
      require "haml_lint"
      require "haml_lint/options"

      @file = file
      runner = build_runner
      report = runner.run(options)

      report.lints.map do |violation|
        line = file.line_at(violation.line)

        Violation.new(
          filename: file.filename,
          line: line,
          line_number: violation.line,
          messages: [violation.message],
          patch_position: line.patch_position,
        )
      end
    end

    private

    attr_reader :file

    def build_runner
      HamlLint::Runner.new
    end

    def options
      HamlLint::Options.new.parse(options_args)
    end

    def options_args
      ["--config", default_config_file, file.filename]
    end

    def default_config_file
      DefaultConfigFile.new(
        DEFAULT_CONFIG_FILENAME,
        repository_owner_name
      ).path
    end
  end
end
