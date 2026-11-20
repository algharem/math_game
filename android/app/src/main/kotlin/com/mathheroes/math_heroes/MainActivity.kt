package com.mathheroes.math_heroes

import io.flutter.embedding.android.FlutterFragmentActivity

// local_auth needs a FragmentActivity host on Android; using FlutterActivity
// makes every biometric prompt fail with a "no_fragment_activity" error.
class MainActivity : FlutterFragmentActivity()
