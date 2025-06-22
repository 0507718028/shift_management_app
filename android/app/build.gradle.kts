plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.shift_management_app"
    compileSdk = 35  // غيرتها إلى 35

    signingConfigs {
        create("release") {
            // ملف keystore للنشر الرسمي، علقه أو اتركه فارغًا إذا لم يكن لديك ملف توقيع
            // storeFile = file("../keystore/release.keystore")
            // storePassword = "your_store_password"
            // keyAlias = "your_key_alias"
            // keyPassword = "your_key_password"
        }
        // لا تنشئ debug جديد، بل عدّل الموجود:
        getByName("debug").apply {
            storeFile = file(System.getProperty("user.home") + "/.android/debug.keystore")
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
    }

    defaultConfig {
        applicationId = "com.example.shift_management_app"
        minSdk = 21
        targetSdk = 35  // غيرتها إلى 35
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            // تستخدم توقيع debug هنا لبناء نسخة release للتجربة فقط (غير مخصصة للنشر)
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

flutter {
    source = "../.."
}
