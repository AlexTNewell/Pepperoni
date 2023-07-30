# Run Terraform to generate the private key
PRIVATE_KEY=$(terraform output -raw tls_private_key.rsa.private_key_pem)

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
