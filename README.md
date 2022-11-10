# api-platform-gcp-template
Template to deploy api-platform to GCP during the demo session

### Disclaimer

This template is solely for demonstration purposes. Do not use this code in production as it's not secured for production workloads.
This template is meant to get a basic understanding on how API-Platform can be deployed to Google Cloud Platform.

## Preparation

1. Open a command line terminal
2. Run: `symfony check:requirements` to validate if you can skaffold the API on your local machine
2. Create a new repository from template: [Template](https://github.com/daanheikens/api-platform-gcp-template)
2. Authenticate gcloud to your GCP project: `gcloud auth application-default login`
3. Install google cloud build in Github: [Install Cloud Build](https://github.com/marketplace/google-cloud-build)
4. Connect the Github repository in Cloud Build on Google Cloud Platform
    - Navigate to [Cloud Build](https://console.cloud.google.com/cloud-build/triggers)
    - Enable the Cloud Build API (if asked for)
    - Click on: Connect Repository
    - Follow the steps and connect your repository (do not create a trigger)

## Deploy the CI/CD, network and database
1. Modify tfvars file:
   - Rename the `example.tfvars.tpl` file to `terraform.tfvars`
   - Replace the placeholders with your variables
2. Apply network, ci-cd and database before creating the app. (this could take approximately 15 min)
   - `terraform plan -var-file=example.tfvars -target=module.ci-cd -target=module.network -target=module.sql`
   - `terraform apply -var-file=example.tfvars -target=module.ci-cd -target=module.network -target=module.sql`
3. After it's done, Terraform will output the database ip. Replace the placeholder on line 18 in `cloudbuild.yaml` with this IP address.

# Let's build the application

1. Open a command line terminal
2. Create project: run `symfony new cars-api`
3. Navigate to `cars-api`
4. Add API-platform: run `symfony composer require api`
5. Startup the database: run `cd .. && docker-compose up -d`
6. Navigate back to `cars-api`
7. Install the maker bundle: `composer require symfony/maker-bundle --dev`
8. Run `php bin/console make:entity --api-resource` to create a new entity. Fill in anything as you like.
9. Run migrations to create the table:
   - run: `php bin/console make:migration` and then `php bin/console doctrine:migrations:migrate`
10. Run serve to test your application: `symfony serve`
11. Test by creating an entity through Swagger (url found in cli output)

## Deploy the application

1. Push code to trigger a build, (this is the initial image)
2. Verify that a build has succeeded by checking the Cloud Build Dashboard
3. Apply terraform in a whole
   - `terraform plan -var-file=example.tfvars`
   - `terraform apply -var-file=example.tfvars`
5. Finished! Test by running `curl <cloud-run-url>/api/cars` (please note that there might be a delay on the first request as of the Cold Start of cloud run)
