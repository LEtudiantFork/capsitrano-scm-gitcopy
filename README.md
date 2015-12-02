[ capistrano-scm-gitcopy ](https://github.com/xuwupeng2000/capsitrano-scm-gitcopy)
===================

## Changes included in this fork

This fork doesn't change the copy strategy but the clone method (who could be better with a git-clean and pull request after first deploy than rm and clone the repo each time). The Gem capistrano-scm-gitcopy work with a mirror repository who included all branch, tags and references like has the remote repository with a specific directory structure and files : branches, COMMIT_EDITMSG, config, description, gitweb, HEAD, hooks/, index, info/, logs/, objects/, ORIG_HEAD, packed-refs, refs/.

In our case, it was important to build assets and models (php) of our cloneproject after  of a specific project branch (set in conf or passed by command line) via hooks. With a mirror repository it was impossible.

In a simple way, the Gem clone a specific branch of the define repository without the --mirror option. With this strategy you can execute different tasks like build assets, models, etc on the temporary deploy project folder with a hook before deploy:update task. The folder contain only your project file. 

After that, nothing change !


## A copy strategy for Capistrano 3

This Gem is inspired by and based on https://github.com/xuwupeng2000/capsitrano-scm-gitcopy.
Thank xuwupeng2000 and wercker so much.

This will make Capistrano tar the a specific git branch, upload it to the server(s) and then extract it in the release directory.

There is `sub_directory` option. 
When specified, onthe the subtree of the checked-out repository will be deployed. 
This is useful when the rails application is not at the root of the repository.

Requirements
============

Machine running Capistrano:

- Capistrano 3
- tar

Servers:

- mktemp
- tar
- ruby

Installation
============

First make sure you install the capistrano-scm-gitcopy by adding it to your `Gemfile`:

    gem "capistrano-scm-gitcopy"

Then switch the `:scm` option to `:gitcopy` in `config/deploy.rb`:

    set :scm, :gitcopy
    
Finally, DO NOT ADD `require 'capistrano/gitcopy'` to `Capfile` because `capistrano/setup` already loads the scm module with the :scm value you specified.


Usage
============

```bash
  cap uat deploy -s branch=(your release branch)
  ```
