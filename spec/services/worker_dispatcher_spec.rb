require "rails_helper"

describe WorkerDispatcher do
  describe "#run" do
    context "for a Ruby file" do
      it "runs LanguageWorker::Ruby" do
        file = double("File", filename: "foo.rb")
        pull_request = stub_pull_request(pull_request_files: [file])
        build = create(:build)
        repo_config = stub_repo_config
        worker = stub_worker("LanguageWorker::Ruby")

        WorkerDispatcher.run(pull_request, build)

        build_worker = build.build_workers.first
        expect(LanguageWorker::Ruby).to have_received(:new).
          with(build_worker, file, repo_config, pull_request)
        expect(worker).to have_received(:run)
      end

      context "when ruby is not enabled for the repo" do
        it "does not run the worker" do
          file = double("File", filename: "foo.rb")
          pull_request = stub_pull_request(pull_request_files: [file])
          build = create(:build)
          repo_config = stub_repo_config
          worker = stub_worker("LanguageWorker::Ruby", enabled?: false)

          WorkerDispatcher.run(pull_request, build)

          build_worker = build.build_workers.first
          expect(LanguageWorker::Ruby).to have_received(:new).
            with(build_worker, file, repo_config, pull_request)
          expect(worker).not_to have_received(:run)
        end
      end

      context "when have multiple files" do
        it "creates multiple build workers" do
          file = double("File", filename: "foo.rb")
          pull_request = stub_pull_request(pull_request_files: [file, file])
          build = create(:build)
          repo_config = stub_repo_config
          worker = stub_worker("LanguageWorker::Ruby")

          WorkerDispatcher.run(pull_request, build)

          first_build_worker = build.build_workers.first
          last_build_worker = build.build_workers.last
          expect(LanguageWorker::Ruby).to have_received(:new).
            with(first_build_worker, file, repo_config, pull_request)
          expect(LanguageWorker::Ruby).to have_received(:new).
            with(last_build_worker, file, repo_config, pull_request)
          expect(worker).to have_received(:run).twice
          expect(build.build_workers.count).to eq(2)
        end
      end
    end

    context "for a CoffeeScript file" do
      it "runs LanguageWorker::CoffeeScript" do
        file = double("File", filename: "foo.coffee.js")
        pull_request = stub_pull_request(pull_request_files: [file])
        build = create(:build)
        repo_config = stub_repo_config
        worker = stub_worker("LanguageWorker::CoffeeScript")

        WorkerDispatcher.run(pull_request, build)

        build_worker = build.build_workers.first
        expect(LanguageWorker::CoffeeScript).to have_received(:new).
          with(build_worker, file, repo_config, pull_request)
        expect(worker).to have_received(:run)
      end

      context "when CoffeeScript is not enabled for the repo" do
        it "does not run the worker" do
          file = double("File", filename: "foo.coffee.js")
          pull_request = stub_pull_request(pull_request_files: [file])
          build = create(:build)
          repo_config = stub_repo_config
          worker = stub_worker("LanguageWorker::CoffeeScript", enabled?: false)

          WorkerDispatcher.run(pull_request, build)

          build_worker = build.build_workers.first
          expect(LanguageWorker::CoffeeScript).to have_received(:new).
            with(build_worker, file, repo_config, pull_request)
          expect(worker).not_to have_received(:run)
        end
      end

      context "when file is not included" do
        it "does not run the worker" do
          file = double("File", filename: "foo.coffee.js")
          pull_request = stub_pull_request(pull_request_files: [file])
          build = create(:build)
          repo_config = stub_repo_config
          worker = stub_worker("LanguageWorker::CoffeeScript", file_included?: false)

          WorkerDispatcher.run(pull_request, build)

          build_worker = build.build_workers.first
          expect(LanguageWorker::CoffeeScript).to have_received(:new).
            with(build_worker, file, repo_config, pull_request)
          expect(worker).not_to have_received(:run)
        end
      end
    end

    context "for a JavaScript file" do
      it "runs LanguageWorker::CoffeeScript" do
        file = double("File", filename: "foo.js")
        pull_request = stub_pull_request(pull_request_files: [file])
        build = create(:build)
        repo_config = stub_repo_config
        worker = stub_worker("LanguageWorker::JavaScript")

        WorkerDispatcher.run(pull_request, build)

        build_worker = build.build_workers.first
        expect(LanguageWorker::JavaScript).to have_received(:new).
          with(build_worker, file, repo_config, pull_request)
        expect(worker).to have_received(:run)
      end

      context "when javascript is not enabled for the repo" do
        it "does not run the worker" do
          file = double("File", filename: "foo.js")
          pull_request = stub_pull_request(pull_request_files: [file])
          build = create(:build)
          repo_config = stub_repo_config
          worker = stub_worker("LanguageWorker::JavaScript", enabled?: false)

          WorkerDispatcher.run(pull_request, build)

          build_worker = build.build_workers.first
          expect(LanguageWorker::JavaScript).to have_received(:new).
            with(build_worker, file, repo_config, pull_request)
          expect(worker).not_to have_received(:run)
        end
      end

      context "when file is not included" do
        it "does not run the worker" do
          file = double("File", filename: "foo.js")
          pull_request = stub_pull_request(pull_request_files: [file])
          build = create(:build)
          repo_config = stub_repo_config
          worker = stub_worker("LanguageWorker::JavaScript", file_included?: false)

          WorkerDispatcher.run(pull_request, build)

          build_worker = build.build_workers.first
          expect(LanguageWorker::JavaScript).to have_received(:new).
            with(build_worker, file, repo_config, pull_request)
          expect(worker).not_to have_received(:run)
        end
      end
    end

    context "for a SCSS file" do
      it "runs LanguageWorker::Scss" do
        file = double("File", filename: "foo.scss")
        pull_request = stub_pull_request(pull_request_files: [file])
        build = create(:build)
        repo_config = stub_repo_config
        worker = stub_worker("LanguageWorker::Scss")

        WorkerDispatcher.run(pull_request, build)

        build_worker = build.build_workers.first
        expect(LanguageWorker::Scss).to have_received(:new).
          with(build_worker, file, repo_config, pull_request)
        expect(worker).to have_received(:run)
      end

      context "when SCSS is not enabled for the repo" do
        it "does not run the worker" do
          file = double("File", filename: "foo.scss")
          pull_request = stub_pull_request(pull_request_files: [file])
          build = create(:build)
          repo_config = stub_repo_config
          worker = stub_worker("LanguageWorker::Scss", enabled?: false)

          WorkerDispatcher.run(pull_request, build)

          build_worker = build.build_workers.first
          expect(LanguageWorker::Scss).to have_received(:new).
            with(build_worker, file, repo_config, pull_request)
          expect(worker).not_to have_received(:run)
        end
      end

      context "when file is not included" do
        it "does not run the worker" do
          file = double("File", filename: "foo.scss")
          pull_request = stub_pull_request(pull_request_files: [file])
          build = create(:build)
          repo_config = stub_repo_config
          worker = stub_worker("LanguageWorker::Scss", file_included?: false)

          WorkerDispatcher.run(pull_request, build)

          build_worker = build.build_workers.first
          expect(LanguageWorker::Scss).to have_received(:new).
            with(build_worker, file, repo_config, pull_request)
          expect(worker).not_to have_received(:run)
        end
      end
    end

    context "for an unsupported language" do
      it "runs the UnsupportedWorker and does nothing" do
        file = double("File", filename: "foo.unsupported")
        pull_request = stub_pull_request(pull_request_files: [file])
        build = create(:build)
        repo_config = stub_repo_config
        worker = stub_worker("LanguageWorker::Unsupported")

        WorkerDispatcher.run(pull_request, build)

        build_worker = build.build_workers.first
        expect(LanguageWorker::Unsupported).to have_received(:new).
          with(build_worker, file, repo_config, pull_request)
        expect(worker).to have_received(:run)
      end
    end
  end

  private

  def stub_pull_request(options = {})
    head_commit = double("Commit", file_content: "")
    defaults = {
      file_content: "",
      head_commit: head_commit,
      pull_request_files: [],
      repository_owner_name: "some_org"
    }

    double("PullRequest", defaults.merge(options))
  end

  def stub_repo_config(options = {})
    default_options = {
      enabled_for?: true,
      for: {},
      ignored_javascript_files: []
    }
    repo_config = double(
      "RepoConfig",
      default_options.merge(options)
    )
    allow(RepoConfig).to receive(:new).and_return(repo_config)

    repo_config
  end

  def stub_worker(name, options = {})
    default_options = {
      enabled?: true,
      file_included?: true,
      run: true,
      repo_config: stub_pull_request,
    }

    worker = double(
      name,
      default_options.merge(options)
    )
    allow(name.constantize).to receive(:new).and_return(worker)

    worker
  end
end
