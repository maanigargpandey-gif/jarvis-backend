# Proguard Rules for Jarvis OS
# Keeping Flutter code
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class * extends io.flutter.app.FlutterApplication { *; }
-keep class * extends io.flutter.plugin.common.PluginRegistry { *; }

# Keep Proguard hidden stuff
-dontobfuscate
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.jarvis.godmode.** { *; }
