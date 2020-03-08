sudo apt-get update -y
sudo apt-get install -y \
  zip \
  git \
  wget \
  curl \
  unzip \
  lib32stdc++6 \
  libglu1-mesa \
  openjdk-8-jdk-headless
  
ANDROID_SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip"
export ANDROID_TOOLS_ROOT="/opt/android_sdk"
sudo mkdir -p "${ANDROID_TOOLS_ROOT}"
ANDROID_SDK_ARCHIVE="${ANDROID_TOOLS_ROOT}/archive"
sudo wget -q "${ANDROID_SDK_URL}" -O "${ANDROID_SDK_ARCHIVE}"
sudo unzip -q -d "${ANDROID_TOOLS_ROOT}" "${ANDROID_SDK_ARCHIVE}"
sudo chmod -R 777 "${ANDROID_TOOLS_ROOT}" 
sudo yes | "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" --licenses
sudo "${ANDROID_TOOLS_ROOT}/tools/bin/sdkmanager" "platform-tools" "build-tools;27.0.3" "build-tools;28.0.3" "platforms;android-27" "platforms;android-28"

rm "${ANDROID_SDK_ARCHIVE}"
export PATH="${ANDROID_TOOLS_ROOT}/tools:${PATH}"
export PATH="${ANDROID_TOOLS_ROOT}/tools/bin:${PATH}"

FLUTTER_ROOT="/opt/flutter"
sudo mkdir -p "${FLUTTER_ROOT}"
sudo chmod 777 "${FLUTTER_ROOT}"
git clone https://github.com/flutter/flutter "${FLUTTER_ROOT}"
export PATH="${FLUTTER_ROOT}/bin:${PATH}"
export ANDROID_HOME="${ANDROID_TOOLS_ROOT}"
echo 'export PATH="/opt/flutter/bin":"/opt/android_sdk/tools":"/opt/android_sdk/tools/bin":$PATH' >> ~/.bashrc
echo 'export ANDROID_HOME="/opt/android_sdk"' >> ~/.bashrc
echo 'export PATH="$PATH":"$HOME/.pub-cache/bin"' >> ~/.bashrc
echo "alias adb=/opt/android_sdk/platform-tools/adb" >> ~/.bashrc
# Disable analytics and crash reporting on the builder.
flutter config  --no-analytics

# Perform an artifact precache so that no extra assets need to be downloaded on demand.
flutter precache

# Accept licenses.
yes "y" | flutter doctor --android-licenses

# Perform a doctor run.
flutter doctor -v

# Perform a flutter upgrade
flutter upgrade

flutter pub global activate devtools

sudo apt-get install -y adb