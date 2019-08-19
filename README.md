# Ruby Up!

The goal of this project is to automate the update of the used ruby version in multiple GitHub repositories.

At the moment this is mostly a proof of concept and has a few rough edges.<br>
Regarding security it is recommended to run this only on a machine which is only reachable by you (best your local machine).

## Architecture

### Platform (Web UI)

This part of the application allows to manage the repositories which are updated and shows the status of the corresponding update jobs.

### Worker (Sidekiq / Docker API)

The worker is triggered by the creation of jobs in the Web UI and performs the following steps:

* Create new build docker container using the target Ruby version (pre-req.).
* Checks out the repository using the configured SSH private-key.
* Switches to a new local branch
* Replaces the Ruby version in the configured list of files
* Runs `bundle install`
* Commits the change
* Creates a Pull Request using the configured GitHub API Key


## Setup

See the included `install.sh`. It can setup a complete deployment on a (empty) docker swarm.

## Licence

The application is available as open source under the terms of the MIT License.
