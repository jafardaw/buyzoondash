// plugins {
//     id("com.android.application")
//     id("com.google.gms.google-services")
//     id("kotlin-android")
//     id("dev.flutter.flutter-gradle-plugin")
// }

// android {
//     namespace = "com.example.buyzoonapp"
//     compileSdk = flutter.compileSdkVersion
//     ndkVersion = flutter.ndkVersion

//     compileOptions {
//         sourceCompatibility = JavaVersion.VERSION_1_8
//         targetCompatibility = JavaVersion.VERSION_1_8
//         isCoreLibraryDesugaringEnabled = true
//     }

//     kotlinOptions {
//         jvmTarget = "1.8"
//     }

//     defaultConfig {
//         applicationId = "com.example.buyzoonapp"
//         minSdk = flutter.minSdkVersion
//         targetSdk = flutter.targetSdkVersion
//         versionCode = flutter.versionCode ?: 1
//         versionName = flutter.versionName ?: "1.0.0"
        
//         ndk {
//             // 🔑 إعدادات المعماريات - اختار واحدة فقط من الخيارات:
            
//             // الخيار 1: لجميع الأجهزة (3 APKs)
//             // abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a", "x86_64"))
            
//             // الخيار 2: للأجهزة الحديثة فقط (APK واحد أصغر)
//             abiFilters.add("arm64-v8a")
//         }
//     }

//     buildTypes {
//         getByName("release") {
//             signingConfig = signingConfigs.getByName("debug")
            
//             // إعدادات تقليص الحجم
//             isMinifyEnabled = true
//             isShrinkResources = true
//             proguardFiles(
//                 getDefaultProguardFile("proguard-android-optimize.txt"),
//                 "proguard-rules.pro"
//             )
//         }
        
//         getByName("debug") {
//             signingConfig = signingConfigs.getByName("debug")
//         }
//     }
// }

// flutter {
//     source = "../.."
// }

// dependencies {
//     coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
// }