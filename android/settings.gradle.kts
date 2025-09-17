pluginManagement {
    // This block tells Gradle where to find the plugins themselves.
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    val flutterSdkPath = run {
        val properties = java.util.Properties()
        java.io.File(settings.rootDir, "local.properties").inputStream().use { properties.load(it) }
        val flutterSdk = properties.getProperty("flutter.sdk")
        checkNotNull(flutterSdk) { "flutter.sdk not set in local.properties" }
        flutterSdk
    }

    includeBuild(java.io.File(flutterSdkPath, "packages/flutter_tools/gradle"))

    plugins {
        id("com.android.application") version "7.3.0" apply false
        id("org.jetbrains.kotlin.android") version "1.9.20" apply false
    }
}

// This block tells your project where to find its own dependencies.
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
    }
}

include(":app")

