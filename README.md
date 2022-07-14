# README

## Using Template

Steps to use template:

* Use Template button at top of this repo

* git clone to local development machine

* Rename databases/redis etc. from knowe to `your app name`

* If npm < 7.1 rerun `bin/rails javascript:install:esbuild`

* Run `bundle update`

* Run `rails db:create db:migrate`

* Run `rails dev:cache` (for stimulus reflex)

* Add remote original knowe: 
  * `git remote add knowe git@github.com:john-hamnavoe/knowe.git`

## Merging Changes from Template

Merge changes from template:

* `git fetch knowe`

* `git merge knowe/main --allow-unrelated-histories`

* `rails db:migrate` (to apply new database changes)

First time probably need to do some merges to get the right change to database name etc.

## Running application 

* `foreman start -f procfile.dev`   

