#!/bin/bash
set -euo pipefail
umask 077
KIT=$(cd "$(dirname "$0")" && pwd)
cd "$KIT"
if [ -z "${JAVA_HOME:-}" ] && [ -d '/Applications/Android Studio.app/Contents/jbr/Contents/Home' ]; then
    export JAVA_HOME='/Applications/Android Studio.app/Contents/jbr/Contents/Home'
    export PATH="$JAVA_HOME/bin:$PATH"
fi
SIGNING_DIR="$HOME/.config/imperial-school-views"
SIGNING_PROPERTIES="${IMPERIAL_SIGNING_PROPERTIES:-$SIGNING_DIR/android-signing.properties}"
if [ -n "${IMPERIAL_SIGNING_PROPERTIES:-}" ] && [ ! -f "$SIGNING_PROPERTIES" ]; then
    printf 'Указанный IMPERIAL_SIGNING_PROPERTIES не существует.\n' >&2
    exit 2
fi
if [ ! -f "$SIGNING_PROPERTIES" ]; then
    if [ -e "$SIGNING_DIR/android-release.jks" ]; then
        printf 'Ключ уже существует, но файл его настроек отсутствует. Восстановите резервную копию ключа.\n' >&2
        exit 2
    fi
    umask 077
    mkdir -p "$SIGNING_DIR"
    IMPERIAL_NEW_KEY_PASSWORD=$(openssl rand -hex 32)
    export IMPERIAL_NEW_KEY_PASSWORD
    keytool -genkeypair -keystore "$SIGNING_DIR/android-release.jks" -storetype PKCS12 -alias imperial-school-views -storepass:env IMPERIAL_NEW_KEY_PASSWORD -keypass:env IMPERIAL_NEW_KEY_PASSWORD -dname 'CN=Imperial School Views, O=Imperial School' -keyalg RSA -keysize 3072 -validity 10000
    cat > "$SIGNING_PROPERTIES" <<SIGNING
storeFile=android-release.jks
storePassword=$IMPERIAL_NEW_KEY_PASSWORD
keyAlias=imperial-school-views
keyPassword=$IMPERIAL_NEW_KEY_PASSWORD
SIGNING
    unset IMPERIAL_NEW_KEY_PASSWORD
    printf 'Создан пользовательский ключ Android вне проекта. Сохраните ключ и файл настроек в надёжном месте.\n'
fi
export IMPERIAL_SIGNING_PROPERTIES="$SIGNING_PROPERTIES"
if [ ! -f local.properties ] && [ -z "${ANDROID_HOME:-}" ] && [ -d "$HOME/Library/Android/sdk" ]; then
    export ANDROID_HOME="$HOME/Library/Android/sdk"
fi
./gradlew --no-daemon :app:exportRelease
printf 'На сайт: только APK и android-release.json из dist/.\nКлюч и настройки подписи хранятся вне проекта.\n'
