#!/bin/bash
# Assumes this is being executed from a session that has already logged
# into Heroku with "heroku login -i" beforehand.
# 
# You can set this up to run every night when you aren't using the
# instance with a cronjob. For example:
# 0 3 * * * /home/pi/whoogle-search/config/heroku-regen.sh <app_name>

HEROKU_CLI_SITE="https://devcenter.heroku.com/articles/heroku-cli"
GITHUB_REPO="https://github.com/letientruong12"

if ! [[ -x "$(command -v heroku)" ]]; then
    echo "Must have heroku cli installed: $HEROKU_CLI_SITE"
    exit 1
fi

if [[ $# -ne 1 ]]; then
    echo -e "Must provide the name of the Heroku app to regenerate"
    exit 1
fi

APP_NAME="$1"

# Destroy the existing app
heroku apps:destroy "$APP_NAME" --confirm "$APP_NAME"

# Create a new app
heroku apps:create "$APP_NAME"

# Clone the GitHub repository
TEMP_DIR=$(mktemp -d)
git clone "$GITHUB_REPO" "$TEMP_DIR"

# Change directory to the cloned repo
cd "$TEMP_DIR"

# Deploy the app to Heroku
git push heroku master

# Clean up the temporary directory
rm -rf "$TEMP_DIR"