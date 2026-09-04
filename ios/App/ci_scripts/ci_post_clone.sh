#!/bin/zsh
# Xcode Cloud: runs after the repo is cloned, before "pod install".
# The Capacitor Podfile references node_modules, so install Node deps first.
set -e
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
if ! command -v node >/dev/null 2>&1; then brew install node; fi
cd "$CI_PRIMARY_REPOSITORY_PATH"
node -v; npm -v
npm ci --no-audit --no-fund || npm install --no-audit --no-fund
npx cap sync ios
cd ios/App
pod install --repo-update
