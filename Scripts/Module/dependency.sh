#!/bin/bash

TARGET_FILE="Tuist/ProjectDescriptionHelpers/Dependency.swift"

# ✅ 입력
echo ""
read -p "모듈 이름을 입력하세요 (feature모듈은 feature_name 으로 입력): " MODULE_INPUT
read -p "'$MODULE_INPUT' 모듈이 의존하는 모듈들을 입력하세요 (공백 구분): " DEPENDS_ON

# ✅ 모듈 이름 → key 형식으로 변환
get_key() {
  local name=$(echo "$1" | xargs)
  if [[ "$name" == feature_* ]]; then
    local core="${name#feature_}"
    echo ".feature(.$core)"
  else
    echo ".$name"
  fi
}

FEATURE_CASE=$(get_key "$MODULE_INPUT")

# ✅ 의존 모듈 배열 변환
to_dependency_value() {
  local formatted=""
  for item in "$@"; do
    name=$(echo "$item" | xargs)
    if [[ "$name" == feature_* ]]; then
      name="${name#feature_}"
      formatted+=".feature(.$name), "
    else
      formatted+=".$name, "
    fi
  done
  echo "[${formatted%, }]"
}

IFS=' ' read -ra DEPENDS_ON_ARRAY <<< "$DEPENDS_ON"
VALUE_ARRAY=$(to_dependency_value "${DEPENDS_ON_ARRAY[@]}")
NEW_LINE="        $FEATURE_CASE: $VALUE_ARRAY,"

# ✅ 파일 확인
if [ ! -f "$TARGET_FILE" ]; then
  echo "❌ Dependency.swift 파일이 존재하지 않습니다: $TARGET_FILE"
  exit 1
fi

# ✅ key가 존재하면 교체
if grep -q "^ *$FEATURE_CASE:" "$TARGET_FILE"; then
  sed -i '' "s|^ *$FEATURE_CASE:.*|$NEW_LINE|" "$TARGET_FILE"
  echo "🔁 $FEATURE_CASE 항목을 수정하였습니다."
  echo ""
  exit 0
fi

# ✅ key가 없으면 삽입 위치 판단
if [[ "$MODULE_INPUT" == feature_* ]]; then
  # feature 모듈이면 .feature(.base): 위에 삽입
  awk -v newEntry="$NEW_LINE" '
    index($0, ".feature(.base):") > 0 && !added {
      print newEntry
      added = 1
    }
    { print }
  ' "$TARGET_FILE" > "$TARGET_FILE.tmp" && mv "$TARGET_FILE.tmp" "$TARGET_FILE"
  
else
  # 일반 모듈이면 딕셔너리 마지막 key 아래 삽입
  awk -v newEntry="$NEW_LINE" '
    BEGIN { last_line = "" }
    { last_line = $0; lines[NR] = $0 }
    END {
      for (i = 1; i <= NR; i++) {
        print lines[i]
        if (i == NR) print newEntry
      }
    }
  ' "$TARGET_FILE" > "$TARGET_FILE.tmp" && mv "$TARGET_FILE.tmp" "$TARGET_FILE"
fi
echo "➕ $FEATURE_CASE 항목을 추가하였습니다."
echo ""
