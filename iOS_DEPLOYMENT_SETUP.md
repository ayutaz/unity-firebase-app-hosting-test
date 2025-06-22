# iOS Deployment Setup Guide

This guide explains the required GitHub Secrets for iOS deployment to Firebase App Distribution.

## Required Secrets

### 1. **IOS_P12_BASE64**
   - Your iOS signing certificate in P12 format, encoded as base64
   - Export from Keychain Access on macOS
   - Encode: `base64 -i certificate.p12 -o certificate_base64.txt`

### 2. **IOS_P12_PASSWORD**
   - Password for the P12 certificate file

### 3. **IOS_MOBILEPROVISION_BASE64**
   - Your provisioning profile encoded as base64
   - Download from Apple Developer Portal
   - Encode: `base64 -i profile.mobileprovision -o profile_base64.txt`

### 4. **IOS_DEVELOPMENT_TEAM**
   - Your Apple Developer Team ID
   - Find in Apple Developer Portal under Membership

### 5. **IOS_CODE_SIGN_IDENTITY**
   - Certificate name for code signing
   - Usually "iPhone Distribution: Your Company Name"

### 6. **FIREBASE_IOS_APP_ID**
   - Firebase App ID for iOS
   - Found in Firebase Console > Project Settings > Your iOS App

### 7. **GCP_SA_KEY**
   - Service account key for Firebase access (already set if Android/WebGL work)

## Bundle ID Configuration

The workflow is configured to use bundle ID: `com.yousan`

Make sure this matches:
1. Your Unity project's bundle ID in ProjectSettings
2. Your provisioning profile's app ID
3. Your Firebase iOS app configuration

## Testing

After setting up all secrets, the workflow will:
1. Build Xcode project using Unity Builder (Linux)
2. Build and sign the iOS app (macOS)
3. Deploy to Firebase App Distribution

Check the Actions tab in GitHub to monitor the workflow execution.