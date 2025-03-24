# Project Infratrack User Portal - Local Setup and Execution

This document outlines the setup, prerequisites, and execution steps for running the Infratrack User Portal Flutter application locally.

## Prerequisites

Before attempting local builds, ensure you have the following prerequisites installed and configured:

1.  **Git:** Git is essential for cloning the repository.
2.  **Java Development Kit (JDK):** The Flutter Android build process requires a JDK. Ensure you have a compatible JDK installed. Java 21 is recommended.
3.  **Flutter SDK:** The Flutter SDK is necessary for building Flutter applications. Version 3.29.2 or later is recommended.
4.  **Android SDK (if building for Android):** If you plan to run the application on an Android emulator or device, you need to install and configure the Android SDK.
5.  **Node.js (optional):** Some Flutter projects use Node.js for supporting tooling.

## Setup

1.  **Clone the Repository:**

    ```bash
    git clone <repository_url>
    cd sdgp_infratrack_clone
    ```

    Replace `<repository_url>` with the URL of your repository.

2.  **Install JDK (if not already installed):**

    * If you don't have Java 21, download and install the Zulu JDK (or another compatible JDK) from a reliable source.
    * Set the `JAVA_HOME` environment variable to the JDK installation directory.
    * Add the JDK's `bin` directory to your system's `PATH` environment variable.

3.  **Install Flutter SDK (if not already installed):**

    * Download the Flutter SDK from the official Flutter website ([flutter.dev](flutter.dev)).
    * Extract the SDK to a suitable location.
    * Add the Flutter `bin` directory to your system's `PATH` environment variable.
    * Run `flutter doctor` to verify the installation and identify any missing dependencies.

4.  **Install Android SDK (if building for Android):**

    * Download and install Android Studio.
    * Configure the Android SDK using Android Studio's SDK Manager.
    * Set the `ANDROID_HOME` environment variable to the Android SDK installation directory.
    * Add the Android SDK's `platform-tools` and `tools` directories to your system's `PATH` environment variable.

## Running the Application (Locally)

To run the Flutter application locally:

1.  **Navigate to the Application Directory:**

    ```bash
    cd sdgp_infratrack_clone
    ```

2.  **Install Dependencies:**

    ```bash
    flutter pub get
    ```

    This command downloads the project's dependencies.

3.  **Run the Application:**

    * **On an Android emulator or device:**

        ```bash
        flutter run
        ```

    * **On an iOS simulator or device:**

        ```bash
        flutter run
        ```

    * **On a web browser:**

        ```bash
        flutter run -d chrome
        ```

    Choose the appropriate device or emulator from the list displayed by the `flutter run` command.

## Error Fixing

* **`flutter pub get` errors:**
    * Ensure your Flutter SDK is correctly installed and configured.
    * Check your internet connection.
    * Try deleting the `pubspec.lock` file and running `flutter pub get` again.
    * Check that your Flutter version is compatible with the packages used in the project.
* **`flutter build apk` errors:**
    * Verify that your Android SDK is correctly installed and configured.
    * Ensure your `ANDROID_HOME` environment variable is set correctly.
    * Check that you have accepted the Android SDK licenses using `flutter doctor --android-licenses`.
    * Check the Android build tools and platform tools are installed.
* **Java errors:**
    * Verify that your Java version is correct.
    * Verify that the `JAVA_HOME` environment variable is set correctly.
* **Device errors:**
    * Ensure that the device or emulator that you are trying to run the app on is correctly set up.
    * Ensure that the device or emulator is connected to your computer.
* **Other build errors:**
    * Consult the Flutter documentation for specific error messages.
    * Search online forums and communities for solutions.
    * Check the `flutter doctor` output for potential issues.
