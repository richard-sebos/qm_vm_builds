#!/bin/bash
# Script to set up Linux command-line to access GitHub and clone repositories

# Variables
git_config_name="Your Name"  # Replace with your name
git_config_email="your.email@example.com"  # Replace with your GitHub email

# Check for git installation
if ! command -v git &> /dev/null; then
    echo "Git is not installed. Installing Git..."
    sudo apt update && sudo apt install -y git || sudo yum install -y git
else
    echo "Git is already installed."
fi

# Configure Git
if [ -n "$git_config_name" ] && [ -n "$git_config_email" ]; then
    echo "Configuring Git with your name and email..."
    git config --global user.name "$git_config_name"
    git config --global user.email "$git_config_email"
else
    echo "Please provide valid name and email to configure Git."
    exit 1
fi

# Test GitHub connectivity
read -p "Enter the URL of a GitHub repository to test cloning: " repo_url

if [ -z "$repo_url" ]; then
    echo "No repository URL provided. Exiting."
    exit 1
fi

echo "Cloning the repository to test GitHub access..."
git clone "$repo_url"

if [ $? -eq 0 ]; then
    echo "Repository cloned successfully. GitHub access is configured."
else
    echo "Failed to clone the repository. Please check the URL and your credentials."
    exit 1
fi

# Additional instructions for using GitHub
cat << EOF

Setup complete! To clone a GitHub repository, use the following command:

  git clone https://github.com/username/repository-name.git

When prompted, enter your GitHub username and password to authenticate.

Happy coding!
EOF
