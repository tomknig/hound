require "spec_helper"

describe StyleGuide::Haml do
  describe "#violations_in_file" do
    context "with default configuration" do
      describe "for implicit %div violation" do
        it "returns violations" do
          expect(violations).to include(
            "`%div.some-class` can be written as `.some-class` since `%div` is implicit"
          )
        end
      end
    end
  end

  private

  def violations
    style_guide = build_style_guide(nil)
    style_guide.violations_in_file(build_file("")).flat_map(&:messages)
  end

  def build_style_guide(config = nil)
    repo_config = double("RepoConfig", enabled_for?: true, for: config)
    repository_owner_name = "ralph"
    StyleGuide::Haml.new(repo_config, repository_owner_name)
  end

  def build_file(text)
    filename = Rails.root.join("spec/support/fixtures/div.haml")
    line = double("Line", content: "blah", number: 1, patch_position: 2)
    double("CommitFile", content: text, filename: filename, line_at: line)
  end
end
