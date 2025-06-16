#!/bin/bash

read -p "생성할 Feature 모듈 이름을 입력하세요: " MODULE_NAME

if [ -z "$MODULE_NAME" ]; then
    echo "모듈 이름이 비어 있습니다. 종료합니다."
    exit 1
fi

AUTHOR=$(git config --get user.name)
DATE=$(date +'%-m/%-d/%y')
TARGET_FILE="Tuist/ProjectDescriptionHelpers/Module.swift"
LOWER_MODULE_NAME=$(echo "$MODULE_NAME" | tr '[:upper:]' '[:lower:]')

echo ""
echo "🚀 Feature 모듈을 생성합니다."
echo "📦 모듈:   $MODULE_NAME"
echo "👤 작성자: $AUTHOR"
echo "📅 날짜:   $DATE"

tuist scaffold FeatureModule \
  --module-name "$MODULE_NAME" \
  --author "$AUTHOR" \
  --date "$DATE"
  
awk -v mod="$LOWER_MODULE_NAME" '
  /enum FeatureModule/ { inside = 1 }
  inside && /^ *case / { last_case_line = NR }
  inside && /^}/ { inside = 0 }
  { lines[NR] = $0 }
  END {
    for (i = 1; i <= NR; i++) {
      print lines[i]
      if (i == last_case_line) {
        print "    case " mod
      }
    }
  }
' "$TARGET_FILE" > "$TARGET_FILE.tmp" && mv "$TARGET_FILE.tmp" "$TARGET_FILE"
