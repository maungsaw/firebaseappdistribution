# Preserve freeRASP/Talsec internal classes from being stripped/renamed incorrectly
-keep class com.talsec.** { *; }
-dontwarn com.talsec.**