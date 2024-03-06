# Stages
- build: This stage is responsible for building a Docker image using Kaniko.
- testing: This stage runs automated tests using a custom image that includes testing tools like Jest.
- deploy: This stage deploys the Docker image to a specified environment.

# Variables
- APPLICATION: Represents the name of the application, derived from the GitLab project name.
VERSION: Represents the version of the application, constructed using the environment (ENV) and the short SHA of the commit.
- IMAGE_FIX: Represents the Docker image URL for the application with env.
- IMAGE_BACKUP: Represents the Docker image URL for the application with the version.
- ECR_REPO: Represents the ECR repository URL for the application.
- ENV: Represents the environment (dev, staging, production) derived from the GitLab branch.

# Templates
## before_script_template
This template sets the ENV variable based on the GitLab branch.

## rules_template
This template defines rules for when jobs should be executed. In this case, the build, testing, and deploy jobs are configured to run only on the dev branch.

## assume_role_template
This template sets up the environment to assume a role using the provided OIDC token.

## tags_template
This template specifies tags(runner) for jobs, and in this case, it includes the dev tag.

## scipt_backend_template
This template defines the script for the build_image job. It uses Kaniko to build a Docker image and push it to the specified ECR repository.

## testing
This template defines the testing job, including the setup for running automated tests using Jest.

## deploy_template
This template defines the deploy job, which deploys the Docker image to the development server.

# Jobs
## build_image
This job builds the Docker image using Kaniko and pushes it to the specified ECR repository.

## unit_test
This job runs automated tests using Jest.

## deploy
This job deploys the Docker image to the development server, and it is dependent on the unit_test job.

# Notes
- The `extends` keyword is used to include templates and share configuration across jobs.
- The `needs` keyword in the deploy job ensures that it only runs after the unit_test job is successful.
- The usage of the `rules` keyword determines when a job should be executed based on the branch.