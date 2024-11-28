<div align="center"> 
  <h1 align="center">
    Colab Helper for Spotify
  </h1>
  
  <p> <img width="300" height="300" src="https://i.imgur.com/OOvHVDD.png"> </p>
   
  <h3> 
    Um aplicativo para explorar os recursos do Spotify!
  </h3>
  
  [![en](https://img.shields.io/badge/lang-en-red.svg)](./README.md)
  [![pt-BR](https://img.shields.io/badge/lang-pt--BR-green.svg)](./README.pt-BR.md)

</div>


# Sobre
O Colab Helper é um aplicativo Flutter para Android para ajudar as pessoas a adicionar músicas em playlists colaborativas e interagir com amigos.

Este aplicativo é para fins de portfólio e ainda não está concluído.


## Autenticação
- [x] Sincronizar automaticamente com o app do Spotify
- [x] Verificar se o Spotify está instalado no dispositivo
- [x] Tela de reconexão quando a sincronização com Spotify for perdida

## Interações do usuário
- [x] Ver todas as playlists
- [x] Seguir/Deixar de seguir um artista
- [x] Seguir/Deixar de seguir uma playlist
- [x] Acessar músicas curtidas
- [x] Reordenar músicas em uma playlist
- [ ] Adicionar mais músicas a uma playlist

## Pesquisa
- [x] Playlists
- [x] Álbuns
- [x] Artista
- [ ] Podcasts
- [ ] Perfis

## Player
- [x] Contexto do player
- [x] Imagem da capa do conteúdo
- [x] Reproduzir/Pausar uma música
- [x] Pular/Voltar faixa (ilimitado apenas para usuários premium)
- [x] 15 segundos para frente/para trás em podcasts
- [x] Fila (apenas para usuários premium)
- [x] Lista de dispositivos (para usuários free, esta página é apenas para visualização)
- [x] Botão para adicionar conteúdo à biblioteca (botão like)
- [ ] Ver a barra de progresso de um amigo se ele estiver ouvindo a mesma música

## Social
- [ ] Pesquisar amigos no aplicativo Colab
- [ ] Ver a última música que seus amigos estavam ouvindo
- [ ] Bate-papo em grupo para enviar prévias de músicas e decidir se a música deve ser adicionada a uma playlist colaborativa

## Configurações personalizadas

### Idiomas
- [x] Inglês
- [x] Português Brasileiro

### Temas
- [x] Sistema
- [x] Modo claro
- [x] Modo escuro



# Capturas de tela
### Modo escuro
<p> 
  <img width="320" height="740" src="https://i.imgur.com/RR5KOsz.png" hspace="4"> 
  <img width="320" height="740" src="https://i.imgur.com/0O7WArT.png" hspace="4"> 
  <img width="320" height="740" src="https://i.imgur.com/RVW3zzZ.png" hspace="4">
</p>

### Modo claro
<p> 
  <img width="320" height="740" src="https://i.imgur.com/feQFlXV.png" hspace="4"> 
  <img width="320" height="740" src="https://i.imgur.com/reks547.png" hspace="4"> 
  <img width="320" height="740" src="https://i.imgur.com/Ac4Ix5T.png" hspace="4">
</p>

## Desenvolvimento
Faça um fork/clone do repositório, depois instale as dependências:

    flutter pub get

Se você quiser buildar esse projeto, precisará de um appClientId e um appRedirectURI, ambos fornecidos no [Painel do Desenvolvedor do Spotify](https://developer.spotify.com/dashboard).

Crie um novo arquivo chamado api-keys.json na raiz do projeto
```{json}
{
    "appClientId": "myAppClientId",
    "appRedirectURI": "myAppRedirectURI"
}
```
Dica: normalmente o appRedirectURI é ```http://localhost:8888/callback```


Execute o seguinte comando para gerar os arquivos de tradução:

    flutter gen-l10n

Inicie o aplicativo com o comando dart define from file:

    flutter run --dart-define-from-file api-keys.json

Além disso, leia este [aviso](./WARNING.pt-BR.md).
    
## Mais informações
Se você faz parte do Spotify e há algo errado/não permitido no projeto, entre em contato comigo por e-mail.

Se você tiver alguma dúvida sobre o projeto, entre em contato comigo por e-mail.

E-mail: contactcoffeeapps@gmail.com

