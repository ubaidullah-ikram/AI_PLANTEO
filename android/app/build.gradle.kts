import java.util.Properties
import java.io.FileInputStream


plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.planteo.ai.plant.identifier.scanner.disease.diagnose.garden.care.reminder"
    compileSdk = 36

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
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }
      signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"]?.toString()
            keyPassword = keystoreProperties["keyPassword"]?.toString()
            storeFile = keystoreProperties["storeFile"]?.let { file(it.toString()) }
            storePassword = keystoreProperties["storePassword"]?.toString()
        }
    }

    buildTypes {
        release {
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release") 
            }
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}


flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
       implementation(platform("com.google.firebase:firebase-bom:33.3.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-crashlytics")
}
