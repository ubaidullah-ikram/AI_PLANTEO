plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.planteo.ai.plant.identifier.scanner.disease.diagnose.garden.care.reminder"
    compileSdk = flutter.compileSdkVersion

  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
    isCoreLibraryDesugaringEnabled = true
}

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.planteo.ai.plant.identifier.scanner.disease.diagnose.garden.care.reminder"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }
}


flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
