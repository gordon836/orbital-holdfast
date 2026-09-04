# Orbital Holdfast — iOS build kit (TestFlight-ready shell)

This folder is a complete Capacitor iOS project wrapping the Day 6 web prototype.
Everything runs offline (Three.js is bundled; no CDN, no fonts fetched at runtime).

## What you need
- A Mac with **Xcode 15 or newer** (App Store → Xcode). Sign in with your Apple Developer account under Xcode → Settings → Accounts.
- **Node 18+** and **CocoaPods** on the Mac: `brew install node cocoapods` (Homebrew) — or `sudo gem install cocoapods`.
- Your Apple Developer account (already enrolled).

## Steps (about 20 minutes the first time)
1. Unzip this folder, open Terminal in it, and run:
   ```
   npm install
   npx cap sync ios
   npx cap open ios
   ```
   Xcode opens `ios/App/App.xcworkspace`.
2. In Xcode, click the **App** target → **Signing & Capabilities** → tick *Automatically manage signing* and pick your **Team**. Leave the Bundle Identifier as `com.cubiccm.holdfast` (or change it — it must be unique to you).
3. Plug in your iPhone (or pick a simulator), press **Run** (▶). The game should launch full-screen in portrait.
4. **TestFlight:** at the top of Xcode choose *Any iOS Device (arm64)*, then **Product → Archive**. When the Organizer opens, click **Distribute App → App Store Connect → Upload**. Accept the defaults.
5. In [App Store Connect](https://appstoreconnect.apple.com): **My Apps → + New App** (iOS, name *Orbital Holdfast*, bundle ID from step 2, SKU `holdfast-001`). Under **TestFlight**, the build appears after ~10 minutes of processing. Add testers by email under *Internal Testing* (up to 100, instant) or *External Testing* (up to 10,000, needs a short Beta review — usually a day).
6. Testers install the TestFlight app from the App Store, accept your invite, and play.

## Updating the game
Replace `www/index.html` with the new version, then `npx cap sync ios` and archive again. Bump `CFBundleShortVersionString` / build number in Xcode (General tab) before each upload.

## Files
- `www/` — the game (index.html + three.min.js). This is the only thing that changes between versions.
- `capacitor.config.json` — app id, name, colours.
- `ios/` — the generated Xcode project. Icons and splash screens are already in `ios/App/App/Assets.xcassets`.
- `assets/` — source icon (1024×1024) and splash. Regenerate iOS sizes with `npm run assets`.
- `STORE_LISTING.md` — App Store copy, keywords, privacy answers, screenshot plan.

## Known limits of this build
- It is the prototype: placeholder voxel art, synth sound, one chapter. Fine for TestFlight; for a public App Store release plan on the polished build (see STORE_LISTING.md, "Before submitting for review").
- No save game yet — a level is one sitting.
- No analytics, no ads, no purchases, no network calls. That keeps the privacy answers simple.
