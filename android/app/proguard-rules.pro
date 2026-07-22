-dontwarn me.pushy.**
-keep class me.pushy.** { *; }
-keep class androidx.core.app.** { *; }
-keep class android.support.v4.app.** { *; }
# Preserve freeRASP/Talsec SDK classes
-keep class com.talsec.** { *; }
-dontwarn com.talsec.**