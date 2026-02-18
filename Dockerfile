# syntax=docker/dockerfile:1

# ==========================================
# Global ARGs
# ==========================================
ARG TARGETPLATFORM=linux/amd64
ARG FLUTTER_VERSION=3.41.0
ARG ANDROID_SDK_VERSION=35
ARG ANDROID_BUILD_TOOLS_VERSION=35.0.0
ARG CMDLINE_TOOLS_VERSION=13114758


# ==========================================
# Stage 1: Builder - Android APK build
# ==========================================
FROM --platform=$TARGETPLATFORM ubuntu:22.04 AS builder


# Use global ARGs
ARG FLUTTER_VERSION
ARG ANDROID_SDK_VERSION
ARG ANDROID_BUILD_TOOLS_VERSION
ARG CMDLINE_TOOLS_VERSION


# Disable interactive prompts
ENV DEBIAN_FRONTEND=noninteractive


# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-17-jdk \
    wget \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Detect actual Java path and create symlink if needed
RUN REAL_JAVA=$(dirname $(dirname $(readlink -f $(which javac)))) && \
    echo "Real Java path: ${REAL_JAVA}" && \
    if [ "${REAL_JAVA}" != "/usr/lib/jvm/java-17-openjdk-amd64" ]; then \
    mkdir -p /usr/lib/jvm && \
    ln -sf ${REAL_JAVA} /usr/lib/jvm/java-17-openjdk-amd64; \
    fi


# Set JAVA_HOME via ENV (works for all subsequent RUN commands)
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH


# Verify that Java is working
RUN java -version && javac -version && \
    echo "JAVA_HOME is set to: ${JAVA_HOME}" && \
    ls -la ${JAVA_HOME}/bin/java


# Configure Android SDK
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_HOME=$ANDROID_SDK_ROOT
ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/build-tools/${ANDROID_BUILD_TOOLS_VERSION}


# Create directory for Android SDK
RUN mkdir -p $ANDROID_SDK_ROOT/cmdline-tools


# Download and install Android Command Line Tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d $ANDROID_SDK_ROOT/cmdline-tools && \
    mv $ANDROID_SDK_ROOT/cmdline-tools/cmdline-tools $ANDROID_SDK_ROOT/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip


# Install required Android SDK components (JAVA_HOME already set via ENV)
RUN echo "Current JAVA_HOME: ${JAVA_HOME}" && \
    yes | sdkmanager --licenses && \
    sdkmanager --install \
    "platform-tools" \
    "platforms;android-${ANDROID_SDK_VERSION}" \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "cmdline-tools;latest"


# Download Flutter SDK (release archive instead of git clone for speed)
RUN wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -O /tmp/flutter.tar.xz && \
    tar xf /tmp/flutter.tar.xz -C /opt && \
    rm /tmp/flutter.tar.xz


# Configure environment variables for Flutter
ENV FLUTTER_ROOT=/opt/flutter
ENV PATH="${FLUTTER_ROOT}/bin:${FLUTTER_ROOT}/bin/cache/dart-sdk/bin:$PATH"
ENV PUB_CACHE=/root/.pub-cache


# Fix Git safe.directory warning
RUN git config --global --add safe.directory /opt/flutter && \
    git config --global --add safe.directory "${FLUTTER_ROOT}"


# Initial Flutter setup
RUN flutter doctor -v && \
    flutter config --no-analytics && \
    flutter config --android-sdk $ANDROID_SDK_ROOT && \
    flutter precache --android --no-ios --no-web


# Create directories for caching
RUN mkdir -p $PUB_CACHE && \
    mkdir -p /root/.gradle


# Set working directory
WORKDIR /app


# Copy dependency files to leverage layer caching
COPY pubspec.yaml pubspec.lock ./


# Install dependencies
RUN flutter pub get


# Copy entire project
COPY . .

# Create .env file from secret
RUN --mount=type=secret,id=api_url \
    API_URL="$(cat /run/secrets/api_url)" && \
    test -n "$API_URL" && \
    printf 'API_URL=%s\n' "$API_URL" > .env


# Run code generation
RUN dart run build_runner build --delete-conflicting-outputs


# Build a single universal Android APK in release mode
RUN flutter build apk --release --no-tree-shake-icons


# Verify that the build succeeded
RUN test -f /app/build/app/outputs/flutter-apk/app-release.apk || \
    (echo "ERROR: app-release.apk not found!" && exit 1)


# ==========================================
# Stage 2: Runtime - Artifact storage
# ==========================================
FROM alpine:latest AS runtime


# Set image metadata
ARG FLUTTER_VERSION
ARG BUILD_DATE
ARG VCS_REF


LABEL maintainer="cowboycloud@icloud.com" \
    description="Flutter Android APK Build Artifacts" \
    version="1.0.0" \
    flutter.version="${FLUTTER_VERSION}" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.title="moveUP Android Build" \
    org.opencontainers.image.description="Production-ready Android APK artifacts"


# Create directory for APKs
RUN mkdir -p /artifacts


# Copy built APKs from builder stage
COPY --from=builder /app/build/app/outputs/flutter-apk/*.apk /artifacts/


# Set working directory
WORKDIR /artifacts


# Default command - list files with sizes
CMD ["ls", "-lh"]
