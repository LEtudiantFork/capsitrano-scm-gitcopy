load File.expand_path('../tasks/gitcopy.rake', __FILE__)

require 'capistrano/scm'

set_if_empty :repo_path, -> { "/tmp/#{fetch(:application)}-repository" }

class Capistrano::GitCopy < Capistrano::SCM

  # execute git with argument in the context
  #
  def git(*args)
    args.unshift :git
    context.execute(*args)
  end

  module DefaultStrategy

    def test
      test! " [ -f #{repo_path}/HEAD ] "
    end

    def check
      git :'ls-remote --heads', repo_url
    end

    def clone
      if (depth = fetch(:git_shallow_clone))
        git :clone, '-b', fetch(:branch), '--depth', depth, '--no-single-branch', repo_url, repo_path
      else
        git :clone, '-b', fetch(:branch), repo_url, repo_path
      end
    end

    def update
      # Note: Requires git version 1.9 or greater
      if (depth = fetch(:git_shallow_clone))
        git :fetch, '--depth', depth, 'origin', fetch(:branch)
      else
        git :remote, :update
      end
    end

    def fetch_revision
      context.capture(:git, "--git-dir=#{repo_path}/.git rev-parse --short HEAD")
    end

    def local_tarfile
      "#{fetch(:tmp_dir)}/#{fetch(:application)}-#{fetch(:current_revision).strip}.tar.gz"
    end

    def remote_tarfile
      "#{fetch(:tmp_dir)}/#{fetch(:application)}-#{fetch(:current_revision).strip}.tar.gz"
    end

    def release
      `tar -C  #{repo_path} -zcvf #{local_tarfile} --exclude .git --exclude \"*.log\" .`
    end
  end 

end
