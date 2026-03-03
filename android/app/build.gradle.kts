plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {

    namespace = "com.example.photgraphy_system"
    compileSdk = flutter.compileSdkVersion

    defaultConfig {
        applicationId = "com.example.photgraphy_system"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "app"

    productFlavors {
        create("admin") {
            dimension = "app"
            applicationIdSuffix = ".admin"
        }

        create("dev") {
            dimension = "app"
            applicationIdSuffix = ".dev"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
flutter {
    source = "../.."
}
