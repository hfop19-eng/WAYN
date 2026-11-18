
import com.android.build.api.dsl.ApplicationExtension
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val flutterCompileSdk = flutter.compileSdkVersion
val flutterNdkVersion = flutter.ndkVersion
val flutterTargetSdk = flutter.targetSdkVersion
val flutterVersionCode = flutter.versionCode
val flutterVersionName = flutter.versionName

extensions.configure<ApplicationExtension> {
    namespace = "com.wayn.app"
    compileSdk = flutterCompileSdk
    ndkVersion = flutterNdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.wayn.app"
        minSdk = 23
        targetSdk = flutterTargetSdk
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}
