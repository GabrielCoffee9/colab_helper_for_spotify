Colab Helper for Spotify

An app to explore Spotify features!

![logo](https://i.imgur.com/OOvHVDD.png)


*WARNING*: This specific version of the app needs a temporarily workaround in the spotify_sdk by hand to stop infinite loading at Spotify App Remote syncing in release mode.

First, add this import at the very top of the file:  ```C:\Users\{USERNAME}\AppData\Local\Pub\Cache\hosted\pub.dev\spotify_sdk-3.0.2\lib\models\connection_status.dart```

``` import 'package:flutter/foundation.dart'; ``` 


Second, modify this function on the file: ```C:\Users\{USERNAME}\AppData\Local\Pub\Cache\hosted\pub.dev\spotify_sdk-3.0.2\lib\models\connection_status.g.dart``` 
```
ConnectionStatus _$ConnectionStatusFromJson(Map<String, dynamic> json) {
  if (kReleaseMode) {
    return ConnectionStatus(
      json['b'] as String?,
      json['c'] as String?,
      json['d'] as String?,
      connected: json['a'] as bool,
    );
  } else {
    return ConnectionStatus(
      json['message'] as String?,
      json['errorCode'] as String?,
      json['errorDetails'] as String?,
      connected: json['connected'] as bool,
    );
  }
}


```
