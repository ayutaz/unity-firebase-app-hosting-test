# GitHub Secrets Setup Guide

## 🚨 Current Issue
The iOS build is failing because the required secret `IOS_DEVELOPMENT_TEAM` is not set.

## Required Secrets for iOS Build

### 1. IOS_DEVELOPMENT_TEAM (MISSING - REQUIRED)
- **What**: Your Apple Developer Team ID
- **Where to find**: 
  - Log in to https://developer.apple.com/account/
  - Go to Membership section
  - Copy your Team ID (10 characters, e.g., "ABCD123456")
- **How to set**: 
  1. Go to https://github.com/ayutaz/unity-firebase-app-hosting-test/settings/secrets/actions
  2. Click "New repository secret"
  3. Name: `IOS_DEVELOPMENT_TEAM`
  4. Value: Your Team ID

### 2. IOS_P12_BASE64
- **What**: Your iOS signing certificate in base64 format
- **How to create**:
  ```bash
  # Export certificate from Keychain Access as .p12
  # Then convert to base64:
  base64 -i certificate.p12 > certificate_base64.txt
  # Copy the contents of certificate_base64.txt
  ```

### 3. IOS_P12_PASSWORD
- **What**: Password for the .p12 certificate file
- **Value**: The password you set when exporting the certificate

### 4. IOS_MOBILEPROVISION_BASE64
- **What**: Your provisioning profile in base64 format
- **How to create**:
  ```bash
  # Download from Apple Developer Portal
  # Must be for bundle ID: com.yousan
  base64 -i profile.mobileprovision > profile_base64.txt
  # Copy the contents of profile_base64.txt
  ```

### 5. IOS_CODE_SIGN_IDENTITY (Optional)
- **What**: Certificate name (e.g., "iPhone Distribution: Your Company")
- **Default**: "iPhone Distribution" if not set

### 6. FIREBASE_IOS_APP_ID
- **What**: Firebase App ID for iOS
- **Where to find**: Firebase Console > Project Settings > Your iOS App

## Other Required Secrets (Already Set)

These appear to be already configured:
- UNITY_EMAIL
- UNITY_PASSWORD
- UNITY_LICENSE
- GCP_SA_KEY
- FIREBASE_PROJECT_ID
- FIREBASE_ANDROID_APP_ID

## Quick Setup Steps

1. **Get your Team ID**:
   - Visit https://developer.apple.com/account/#/membership/
   - Copy the Team ID

2. **Set the secret**:
   - Go to https://github.com/ayutaz/unity-firebase-app-hosting-test/settings/secrets/actions
   - Add `IOS_DEVELOPMENT_TEAM` with your Team ID

3. **Re-run the workflow**:
   - The build should proceed past the validation step
   - You may encounter additional issues with certificates/profiles if they're not set correctly

## Verification

After setting the secrets, the workflow will verify:
1. All required secrets are present ✓
2. Certificate can be imported ✓
3. Provisioning profile matches bundle ID (com.yousan) ✓
4. Code signing can be performed ✓

The diagnostic workflows in this repository can help identify any remaining issues.