# Player accounts & cloud saves — one-time setup

The game code is ready: an **ACCOUNT** button (title screen and Home Base) offers Sign in with Apple, Google and
email + password, and saves `holdfast.base2` + `holdfast.save` to Firestore (`players/{uid}`) after every run and
upgrade, merging the best of device and cloud progress. Until the config below exists the game simply runs offline.

## 1. Firebase project (5 min)
1. https://console.firebase.google.com → **Add project** → name `orbital-holdfast` (Analytics off is fine).
2. **Build → Authentication → Get started → Sign-in method**: enable **Email/Password**, **Google**, **Apple**.
   - Apple: Services ID isn't needed for the native iOS flow; leave the OAuth fields empty.
3. **Build → Firestore Database → Create database** (production mode), then **Rules** → paste:
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{db}/documents {
       match /players/{uid} { allow read, write: if request.auth != null && request.auth.uid == uid; }
     }
   }
   ```
4. **Project settings → Your apps → Add app → Web** (`</>`), nickname `holdfast-web`. Copy the `firebaseConfig` object.
5. Still in **Your apps → Add app → iOS**, bundle id `com.cubiccm.holdfast`. Download `GoogleService-Info.plist`;
   copy its `CLIENT_ID` and `REVERSED_CLIENT_ID` values (needed for Google sign-in only).

## 2. Put the config in the repo
- `www/firebase-config.js` → replace `null` with the web config object (add `appleClientId: "com.cubiccm.holdfast"`).
- `capacitor.config.json` → add
  ```json
  "plugins": { "GoogleAuth": { "scopes": ["profile", "email"], "iosClientId": "<CLIENT_ID>.apps.googleusercontent.com", "forceCodeForRefreshToken": true } }
  ```
- `ios/App/App/Info.plist` → inside the top `<dict>` add
  ```xml
  <key>CFBundleURLTypes</key><array><dict><key>CFBundleURLSchemes</key><array><string><REVERSED_CLIENT_ID></string></array></dict></array>
  ```
Push those three files → GitHub Actions builds a new TestFlight build. The build lane enables the
**Sign in with Apple** capability on the App ID through the App Store Connect API automatically.

## 3. App Store Connect follow-ups (before submitting a build with accounts)
- **App Privacy** is currently "no data collected". With accounts you collect **Email address** and **User ID**
  (linked to the user, for app functionality) — update it in App Store Connect → App Privacy.
- Apple's guideline 4.8: because Google sign-in is offered, Sign in with Apple must be offered too — it is.
- Accounts are optional, so no demo login is needed for App Review.
