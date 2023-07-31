# Run Terraform to generate the private key
SETUP_SERVER_PRIVATE_KEY=$(terraform output -raw setup_server_private_key)

# Set the GitHub repository and secret name
REPO="/Pepperoni"
SECRET_NAME="PEPPERONI_SETUP_SERVER_TF_KEY"

# Check if the secret already exists
gh secret list $REPO | grep $SECRET_NAME
if [ $? -eq 0 ]; then
  # Update the existing secret
  echo "Updating the existing secret..."
  gh secret set $SECRET_NAME -b "$PEPPERONI_SETUP_SERVER_TF_KEY" $REPO
else
  # Create a new secret
  echo "Creating a new secret..."
  gh secret add $SECRET_NAME -b "$PEPPERONI_SETUP_SERVER_TF_KEY" $REPO
fi

echo "Private key has been saved to GitHub Actions secrets."

