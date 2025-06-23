#!/bin/bash
# シンプルなiOSビルドスクリプト

set -e

echo "=== Simple iOS Build Script ==="

# Xcodeプロジェクトを探す
PROJECT=$(find . -name "*.xcodeproj" -type d | head -1)
if [ -z "$PROJECT" ]; then
    echo "Error: No Xcode project found"
    exit 1
fi

echo "Found project: $PROJECT"

# プロジェクト設定を修正
PBXPROJ="$PROJECT/project.pbxproj"
if [ -f "$PBXPROJ" ]; then
    echo "Fixing project settings..."
    
    # Team IDを設定
    TEAM_ID="${APPLE_TEAM_ID:-TEMP12345}"
    
    # sedで設定を変更
    sed -i.bak "s/DEVELOPMENT_TEAM = \"\"/DEVELOPMENT_TEAM = \"$TEAM_ID\"/g" "$PBXPROJ"
    sed -i.bak "s/DEVELOPMENT_TEAM = \".*\"/DEVELOPMENT_TEAM = \"$TEAM_ID\"/g" "$PBXPROJ"
    sed -i.bak 's/CODE_SIGN_STYLE = Manual/CODE_SIGN_STYLE = Automatic/g' "$PBXPROJ"
    sed -i.bak 's/CODE_SIGN_STYLE = "Manual"/CODE_SIGN_STYLE = "Automatic"/g' "$PBXPROJ"
    
    rm -f "$PBXPROJ.bak"
fi

# ビルド（シミュレータ）
echo "Building for simulator..."
xcodebuild -project "$PROJECT" \
    -scheme Unity-iPhone \
    -sdk iphonesimulator \
    -configuration Debug \
    -derivedDataPath DerivedData \
    build \
    CODE_SIGNING_ALLOWED=NO \
    ONLY_ACTIVE_ARCH=YES \
    -quiet || {
        echo "Simulator build failed"
        exit 1
    }

echo "✅ Simulator build succeeded!"

# アプリバンドルを探す
APP=$(find DerivedData -name "*.app" -type d | head -1)
if [ -n "$APP" ]; then
    echo "Found app: $APP"
    
    # IPAを作成（シミュレータ用なので配布はできないが、ビルド成功の証明）
    mkdir -p Payload
    cp -r "$APP" Payload/
    zip -r simulator-app.ipa Payload
    rm -rf Payload
    
    echo "✅ IPA created: simulator-app.ipa"
fi

echo "=== Build completed successfully ==="