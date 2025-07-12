// File: android/build.gradle.kts

buildscript {
    dependencies {
        classpath("com.android.tools.build:gradle:8.3.0") // ✅ versi terbaru
        classpath("com.google.gms:google-services:4.3.15") // ✅ diperlukan untuk Firebase
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: untuk memindahkan folder build
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
