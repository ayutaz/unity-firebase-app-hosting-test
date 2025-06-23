#!/bin/bash
# Unity生成のXcodeプロジェクトを修正するスクリプト

PBXPROJ=$1
TEAM_ID=$2

if [ -z "$PBXPROJ" ] || [ -z "$TEAM_ID" ]; then
    echo "Usage: $0 <project.pbxproj> <team_id>"
    exit 1
fi

echo "Fixing Unity Xcode project: $PBXPROJ"
echo "Team ID: $TEAM_ID"

# バックアップ作成
cp "$PBXPROJ" "$PBXPROJ.backup"

# 基本的な修正
sed -i '' "s/DEVELOPMENT_TEAM = \"\"/DEVELOPMENT_TEAM = \"$TEAM_ID\"/g" "$PBXPROJ"
sed -i '' "s/DEVELOPMENT_TEAM = \".*\"/DEVELOPMENT_TEAM = \"$TEAM_ID\"/g" "$PBXPROJ"
sed -i '' 's/CODE_SIGN_STYLE = Manual/CODE_SIGN_STYLE = Automatic/g' "$PBXPROJ"
sed -i '' 's/CODE_SIGN_STYLE = "Manual"/CODE_SIGN_STYLE = "Automatic"/g' "$PBXPROJ"
sed -i '' 's/CODE_SIGN_IDENTITY = ".*"/CODE_SIGN_IDENTITY = "Apple Development"/g' "$PBXPROJ"
sed -i '' 's/CODE_SIGN_IDENTITY = ""/CODE_SIGN_IDENTITY = "Apple Development"/g' "$PBXPROJ"

# プロビジョニングプロファイル設定をクリア
sed -i '' 's/PROVISIONING_PROFILE_SPECIFIER = ".*"/PROVISIONING_PROFILE_SPECIFIER = ""/g' "$PBXPROJ"
sed -i '' 's/PROVISIONING_PROFILE = ".*"/PROVISIONING_PROFILE = ""/g' "$PBXPROJ"
sed -i '' 's/"PROVISIONING_PROFILE\[sdk=iphoneos\*\]" = ".*"/"PROVISIONING_PROFILE[sdk=iphoneos*]" = ""/g' "$PBXPROJ"

# Unity特有の設定を修正
sed -i '' 's/ENABLE_BITCODE = YES/ENABLE_BITCODE = NO/g' "$PBXPROJ"
sed -i '' 's/ENABLE_BITCODE = "YES"/ENABLE_BITCODE = "NO"/g' "$PBXPROJ"

# ターゲット設定の修正
sed -i '' 's/IPHONEOS_DEPLOYMENT_TARGET = 11.0/IPHONEOS_DEPLOYMENT_TARGET = 12.0/g' "$PBXPROJ"

# Bundle Identifierの確認と修正
sed -i '' 's/PRODUCT_BUNDLE_IDENTIFIER = ".*"/PRODUCT_BUNDLE_IDENTIFIER = "com.yousan"/g' "$PBXPROJ"

# 自動管理を強制
if ! grep -q "ProvisioningStyle = Automatic" "$PBXPROJ"; then
    # TargetAttributesセクションを探して修正
    perl -i -pe 's/(TargetAttributes\s*=\s*\{[^}]*?)(ProvisioningStyle\s*=\s*Manual)/$1ProvisioningStyle = Automatic/g' "$PBXPROJ"
fi

echo "Fixes applied to $PBXPROJ"