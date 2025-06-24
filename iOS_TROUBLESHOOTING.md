# iOS Build Troubleshooting Guide

## Common Issues and Solutions

### 1. Certificate Issues
- **Error**: "No signing certificate"
- **Solution**: 
  - Ensure `IOS_P12_BASE64` contains the base64-encoded .p12 file
  - Check that `IOS_P12_PASSWORD` is correct
  - Certificate must be valid iOS Distribution or Development certificate

### 2. Provisioning Profile Issues
- **Error**: "No provisioning profile"
- **Solution**:
  - Ensure `IOS_MOBILEPROVISION_BASE64` contains the base64-encoded .mobileprovision file
  - Profile must match the bundle ID (com.yousan)
  - Profile must include the certificate being used

### 3. Bundle ID Mismatch
- **Error**: "Bundle identifier doesn't match"
- **Current Bundle ID**: com.yousan
- **Solution**:
  - Provisioning profile must be created for com.yousan or com.yousan.*
  - Check Unity ProjectSettings for iOS bundle identifier

### 4. Team ID Issues
- **Error**: "No account for team"
- **Solution**:
  - Ensure `IOS_DEVELOPMENT_TEAM` matches your Apple Developer Team ID
  - Team ID must match the one in provisioning profile

## How to Generate Required Files

### 1. Export Certificate (.p12)
```bash
# From Keychain Access on macOS:
# 1. Find your iOS Distribution certificate
# 2. Right-click > Export
# 3. Save as .p12 with password
# 4. Convert to base64:
base64 -i certificate.p12 -o certificate_base64.txt
```

### 2. Export Provisioning Profile
```bash
# From Apple Developer Portal:
# 1. Create Ad Hoc or App Store distribution profile
# 2. Include bundle ID: com.yousan
# 3. Download .mobileprovision file
# 4. Convert to base64:
base64 -i profile.mobileprovision -o profile_base64.txt
```

## Debugging Workflows

The repository includes several debugging workflows:

1. **ios_test_signing.yaml** - Tests certificate and profile setup
2. **ios_fix_signing.yaml** - Step-by-step signing verification
3. **ios_minimal_test.yaml** - Minimal build test
4. **ios_build_only.yaml** - Build without signing (simulator only)

Run these workflows to diagnose specific issues.

## Current Implementation

The main workflow (`firebase_distribute.yaml`) uses a two-job approach:
1. **build-ios**: Generates Xcode project using Unity Builder (Linux)
2. **build-ios-xcode**: Builds IPA using Xcode (macOS)

The build process:
1. Creates custom keychain
2. Imports certificates
3. Installs provisioning profile
4. Attempts automatic signing first
5. Falls back to manual signing
6. Falls back to simulator build (no signing)

## Required GitHub Secrets

All these must be set in repository settings:

- `IOS_P12_BASE64` - Certificate file (base64)
- `IOS_P12_PASSWORD` - Certificate password
- `IOS_MOBILEPROVISION_BASE64` - Provisioning profile (base64)
- `IOS_DEVELOPMENT_TEAM` - Apple Developer Team ID
- `IOS_CODE_SIGN_IDENTITY` - (Optional) Certificate name
- `FIREBASE_IOS_APP_ID` - Firebase app ID for deployment