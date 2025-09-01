# Keep ML Kit text recognition classes
-keep class com.google.mlkit.vision.text.** { *; }
-dontwarn com.google.mlkit.vision.text.**

# Keep used ML Kit recognizers
-keep class com.google.mlkit.vision.text.latin.** { *; }

# If you really don’t need these, tell R8 to ignore missing ones
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
