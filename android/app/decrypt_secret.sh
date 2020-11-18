#!/bin/sh

# Decrypt the file
# mkdir $HOME/secrets
# --batch to prevent interactive command
# --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$GOOGLE_SERVICE_SECRET" \
--output /google-services.json google-services.json.gpg