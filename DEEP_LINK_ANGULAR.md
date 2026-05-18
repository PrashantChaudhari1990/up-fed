# Deep Link Setup — Angular Project (ABCOF Federation)

> This file covers the **server/hosting side** of Universal Links (iOS) and App Links (Android).
> Your Angular app acts as the domain host for the `.well-known` verification files.

---

## Project Configuration

| Setting | Value |
|---------|-------|
| Domain | `bttoa-connect.oorjaa.tech` |
| Android Package Name | `tech.oorjaa.vas.abcof` |
| iOS Bundle ID | `tech.oorjaa.vas.abcof` |
| iOS Team ID | `6751527920` |

---

## Step 1 — Create `.well-known` Folder

Inside your Angular project `src/` folder:

```
your-angular-project/
└── src/
    └── .well-known/
        ├── assetlinks.json              ← Android
        └── apple-app-site-association   ← iOS
```

```bash
mkdir -p src/.well-known
```

---

## Step 2 — Android File: `assetlinks.json`

Create file at: `src/.well-known/assetlinks.json`

```json
[
  {
    "relation": ["delegate_permission/common.handle_all_urls"],
    "target": {
      "namespace": "android_app",
      "package_name": "tech.oorjaa.vas.abcof",
      "sha256_cert_fingerprints": [
        "8F:9E:A1:6E:CA:DA:78:13:7A:77:C5:75:59:80:2E:FA:C6:67:66:5C:0E:75:DE:85:BB:7D:6A:DF:F3:42:8C:94",
        "F8:47:13:0F:5D:76:E0:58:3E:EF:29:54:91:83:76:CF:AE:7A:9A:96:1D:CC:30:34:DF:69:0F:3A:1D:10:B0:CD"
      ]
    }
  }
]
```

---

## Step 3 — iOS File: `apple-app-site-association`

Create file at: `src/.well-known/apple-app-site-association`

> **No `.json` extension** — exact filename only

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "6751527920.tech.oorjaa.vas.abcof",
        "paths": ["*"]
      }
    ]
  }
}
```

---

## Step 4 — Include Files in Angular Build

Angular ignores `.well-known` by default. Fix this in `angular.json`:

```json
"assets": [
  "src/favicon.ico",
  "src/assets",
  {
    "glob": "**/*",
    "input": "src/.well-known",
    "output": ".well-known"
  }
]
```

---

## Step 5 — Server Configuration (Pick Your Hosting)

Both files must be served over **HTTPS** with `Content-Type: application/json` and return `200` (no redirects).

---

### Option A — NGINX

```nginx
location /.well-known/assetlinks.json {
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    add_header Cache-Control "no-cache";
}

location /.well-known/apple-app-site-association {
    default_type application/json;
    add_header Cache-Control "no-cache";
}
```

---

### Option B — Apache `.htaccess`

```apache
<Files "assetlinks.json">
    Header set Content-Type "application/json"
    Header set Access-Control-Allow-Origin "*"
</Files>

<Files "apple-app-site-association">
    Header set Content-Type "application/json"
</Files>
```

---

### Option C — Firebase Hosting (`firebase.json`)

```json
{
  "hosting": {
    "headers": [
      {
        "source": "/.well-known/assetlinks.json",
        "headers": [{ "key": "Content-Type", "value": "application/json" }]
      },
      {
        "source": "/.well-known/apple-app-site-association",
        "headers": [{ "key": "Content-Type", "value": "application/json" }]
      }
    ]
  }
}
```

---

### Option D — Netlify (`_headers` file in `src/`)

```
/.well-known/assetlinks.json
  Content-Type: application/json
  Access-Control-Allow-Origin: *

/.well-known/apple-app-site-association
  Content-Type: application/json
```

---

## Step 6 — Verify Files Are Live

After deploying, open in browser and confirm you see the JSON:

```
https://bttoa-connect.oorjaa.tech/.well-known/assetlinks.json
https://bttoa-connect.oorjaa.tech/.well-known/apple-app-site-association
```

Use these tools to validate:

| Tool | URL |
|------|-----|
| Android Validator | https://digitalassetlinks.googleapis.com/v1/statements:list?source.web.site=https://bttoa-connect.oorjaa.tech&relation=delegate_permission/common.handle_all_urls |
| iOS / AASA Validator | https://branch.io/resources/aasa-validator/ |
| General Checker | https://www.deeplinkr.com |

---

## Deep Links to Share with Users

Your deep links are just **your domain URLs** — no 3rd party service needed.

### Format:
```
https://bttoa-connect.oorjaa.tech/{angular-route}?{params}
```

### Examples:
```
# Home page
https://bttoa-connect.oorjaa.tech/

# Product page
https://bttoa-connect.oorjaa.tech/product/123

# Product with query params
https://bttoa-connect.oorjaa.tech/product/123?color=red&ref=promo

# User profile
https://bttoa-connect.oorjaa.tech/profile/john

# Any Angular route
https://bttoa-connect.oorjaa.tech/your-angular-route/sub-route
```

### Share these links via:
- WhatsApp, SMS, Email
- QR Code (use https://qr-code-generator.com or https://qrcode.tec-it.com)
- Social Media bios and posts
- Marketing emails / campaigns
- Push notifications
- Printed on packaging / banners

> **Behavior when link is clicked:**
> - **App installed** → Opens Flutter app directly on that Angular page
> - **App not installed** → Opens Angular web page in browser (add store badges there!)

---

## Auto-Redirect to App Store (When App Not Installed)

Add this script to your Angular `index.html` or create a redirect component:

### Option 1 — Add to `index.html` (Simplest)

Add this script in the `<head>` section of `src/index.html`:

```html
<script>
  (function() {
    var userAgent = navigator.userAgent || navigator.vendor || window.opera;
    var isAndroid = /android/i.test(userAgent);
    var isIOS = /iPad|iPhone|iPod/.test(userAgent) && !window.MSStream;

    // Store URLs
    var playStoreUrl = 'https://play.google.com/store/apps/details?id=tech.oorjaa.vas.abcof';
    var appStoreUrl = 'https://apps.apple.com/app/id6751527920';

    // Check if on mobile and app didn't open (fallback)
    // This runs after a delay - if app opened, user won't see this
    if (isAndroid || isIOS) {
      // Try to detect if app opened by checking if page is still visible after delay
      setTimeout(function() {
        if (!document.hidden) {
          // Page is still visible = app didn't open = show store prompt
          var storeUrl = isAndroid ? playStoreUrl : appStoreUrl;

          // Option A: Auto-redirect to store
          // window.location.href = storeUrl;

          // Option B: Show a banner (less aggressive)
          var banner = document.createElement('div');
          banner.innerHTML = '<div style="position:fixed;bottom:0;left:0;right:0;background:#1a73e8;color:white;padding:15px;text-align:center;z-index:9999;font-family:sans-serif;">' +
            '<span>Get the ABCOF Federation App</span>' +
            '<a href="' + storeUrl + '" style="background:white;color:#1a73e8;padding:8px 16px;margin-left:15px;border-radius:5px;text-decoration:none;font-weight:bold;">Download</a>' +
            '<span onclick="this.parentElement.parentElement.remove()" style="position:absolute;right:15px;cursor:pointer;">✕</span>' +
            '</div>';
          document.body.appendChild(banner);
        }
      }, 2500);
    }
  })();
</script>
```

### Option 2 — Smart App Banner (iOS Only)

Add this meta tag in `<head>` of `index.html`:

```html
<meta name="apple-itunes-app" content="app-id=6751527920">
```

This shows Apple's native "Open in App" banner on iOS Safari.

### Option 3 — Angular Component for Download Page

Create a dedicated `/download` route that redirects to the correct store:

**download.component.ts:**
```typescript
import { Component, OnInit } from '@angular/core';
import { Platform } from '@angular/cdk/platform';

@Component({
  selector: 'app-download',
  template: `
    <div class="download-page">
      <h1>Download ABCOF Federation App</h1>
      <p>Redirecting to store...</p>
      <div class="store-buttons">
        <a [href]="playStoreUrl" class="store-btn android">
          <img src="assets/google-play-badge.png" alt="Get it on Google Play">
        </a>
        <a [href]="appStoreUrl" class="store-btn ios">
          <img src="assets/app-store-badge.png" alt="Download on App Store">
        </a>
      </div>
    </div>
  `
})
export class DownloadComponent implements OnInit {
  playStoreUrl = 'https://play.google.com/store/apps/details?id=tech.oorjaa.vas.abcof';
  appStoreUrl = 'https://apps.apple.com/app/id6751527920';

  constructor(private platform: Platform) {}

  ngOnInit() {
    // Auto-redirect based on platform
    if (this.platform.ANDROID) {
      window.location.href = this.playStoreUrl;
    } else if (this.platform.IOS) {
      window.location.href = this.appStoreUrl;
    }
  }
}
```

---

## Store URLs for ABCOF Federation

| Store | URL |
|-------|-----|
| Play Store | `https://play.google.com/store/apps/details?id=tech.oorjaa.vas.abcof` |
| App Store | `https://apps.apple.com/app/id6751527920` |

---

## Final Checklist

```
□ src/.well-known/assetlinks.json created (SHA-256 already configured)
□ src/.well-known/apple-app-site-association created (Team ID: 6751527920)
□ angular.json assets array updated
□ Server config updated (nginx / apache / firebase / netlify)
□ Deployed and both URLs return 200 + JSON
□ Validated with Google Digital Asset Links tool
□ Validated with AASA validator
```

---

## Testing Deep Links

### Android (via ADB)

```bash
# Make sure device/emulator is connected
adb shell am start \
  -W -a android.intent.action.VIEW \
  -d "https://bttoa-connect.oorjaa.tech/product/123" \
  tech.oorjaa.vas.abcof

# Test with query params
adb shell am start \
  -W -a android.intent.action.VIEW \
  -d "https://bttoa-connect.oorjaa.tech/profile/john?ref=share" \
  tech.oorjaa.vas.abcof
```

### iOS (Simulator)

```bash
# Open URL in simulator
xcrun simctl openurl booted "https://bttoa-connect.oorjaa.tech/product/123"

# With params
xcrun simctl openurl booted "https://bttoa-connect.oorjaa.tech/product/123?color=red"
```
