# Protect okhttp3 from R8 obfuscation/shrinking
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**