#!/bin/bash

# Display an error message
function showError() {
    echo "Error: $1"
    exit 1
}

# Deploy the application based on environment and version
function deployApplication() {
    environment=$1
    version=$2

    # Check if the environment is valid
    case $environment in
        "dev" | "staging" | "prod")
            ;;
        *)
            showError "Invalid environment. Valid environments are: dev, staging, prod."
            ;;
    esac

    # Confirmation prompt
    read -p "Do you want to deploy version $version to $environment environment? (y/n): " confirm
    if [ "$confirm" != "y" ]; then
        echo "Deployment canceled."
        exit 0
    fi

    # Connect to the appropriate server based on the environment
    case $environment in
        "dev")
            server="server-dev"
            ;;
        "staging")
            server="server-staging"
            ;;
        "prod")
            server="server-prod"
            ;;
    esac

    echo "Connecting to $server..."

    # Transfer application files to the server (replace with your file transfer command)
        scp -r docker-compose-example.yml user@$server:/docker-compose-example.yml

    # Perform any necessary setup or configuration steps
    echo "Performing setup and configuration on $server..."
        # ssh user@$server '
        #     #command 1
        #     #command 2   
        # '

        ssh user@server "
              set -e;
              cp /docker-compose-example.yml /docker-compose-$environment.yml;
              sed -i s/tag_app/'$version'/g docker-compose-$environment.yml;
              cat docker-compose-$environment.yml;
              /usr/bin/docker-compose -f docker-compose-$environment.yml up -d "

    echo "Restarting the application server on $server..."
    # run command restart application here
    # ssh user@$server "sudo systemctl restart your-app-service"

    echo "Deployment completed successfully for version $version on $environment environment."
}

# Check if required options are provided
if [ "$#" -ne 2 ]; then
    showError "Usage: $0 <environment> <version>"
fi

# Call the function
deployApplication "$1" "$2"
