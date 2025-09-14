##############################################
# 🔐 Razorpay SDK – prevent crash on release
##############################################
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# ✅ Fix for missing classes used by Razorpay internally
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

##############################################
# 🔧 Kotlin Metadata – required by Razorpay
##############################################
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**

##############################################
# 🧊 Flutter Native Code – prevent reflection issues
##############################################
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

##############################################
# 🧠 Optional: Keep annotation info (safe in 2025)
##############################################
-keepattributes *Annotation*

##############################################
# 🧹 Optional cleanup: avoid AndroidX + lifecycle warnings
##############################################
-dontwarn androidx.annotation.**
-dontwarn androidx.lifecycle.**

# 🛑 If you still face issues, disable R8 temporarily (in build.gradle):
# buildTypes.release.minifyEnabled false
