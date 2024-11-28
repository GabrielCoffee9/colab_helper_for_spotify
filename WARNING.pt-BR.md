*AVISO*: Esta versão do app precisa de uma solução temporária no [spotify_sdk](https://github.com/brim-borium/spotify_sdk) feita manualmente para impedir o carregamento infinito na sincronização do Spotify App Remote no modo release.

Primeiro, adicione este import no topo do arquivo:  ```C:\Users\{USERNAME}\AppData\Local\Pub\Cache\hosted\pub.dev\spotify_sdk-3.0.2\lib\models\connection_status.dart```

``` import 'package:flutter/foundation.dart'; ``` 


Segundo, modifique esta função no arquivo: ```C:\Users\{USERNAME}\AppData\Local\Pub\Cache\hosted\pub.dev\spotify_sdk-3.0.2\lib\models\connection_status.g.dart``` 
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