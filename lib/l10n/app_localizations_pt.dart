// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get loading => 'Carregando';

  @override
  String get syncAccount => 'Sincronizar conta';

  @override
  String get yourPlaylists => 'Suas Playlists';

  @override
  String get language => 'Idiomas';

  @override
  String get system => 'Sistema';

  @override
  String get english => 'Inglês';

  @override
  String get portugueseBrazilian => 'Português Brasil';

  @override
  String get settings => 'Configurações';

  @override
  String get viewAll => 'Ver todas';

  @override
  String get allPlaylists => 'Todas as Playlists';

  @override
  String get unnamedPlaylist => 'Playlist sem nome';

  @override
  String get unnamedAlbum => 'Álbum sem nome';

  @override
  String get unavailableSong => 'Música indisponível';

  @override
  String get unknown => 'Desconhecido';

  @override
  String nSongs(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString músicas',
      one: '1 música',
      zero: 'sem músicas',
    );
    return '$_temp0';
  }

  @override
  String get searchYourPlaylists => 'Pesquise suas Playlists';

  @override
  String get typeToSearch => 'Digite algo para pesquisar';

  @override
  String get errorLoadingSearch => 'Error loading searching, please try again.';

  @override
  String get noResultsFound => 'Nenhum resultado encontrado.';

  @override
  String get emptyPlaylist => 'Playlist vazia !!!';

  @override
  String get errorReorder =>
      'Erro ao tentar reordenar a música, tente novamente.';

  @override
  String get album => 'Álbum';

  @override
  String get artist => 'Artista';

  @override
  String get track => 'Música';

  @override
  String albumType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'single': 'Single',
        'album': 'Álbum',
        'other': ' ',
      },
    );
    return '$_temp0';
  }

  @override
  String get followers => 'Seguidores';

  @override
  String get follow => 'Seguir';

  @override
  String get following => 'Seguindo';

  @override
  String get topSongs => 'Mais tocadas';

  @override
  String get albums => 'Álbuns';

  @override
  String get loadMoreAlbums => 'Carregar mais álbuns';

  @override
  String get likedSongs => 'Músicas curtidas';

  @override
  String get queue => 'Fila';

  @override
  String get nowPlaying => 'Tocando agora';

  @override
  String get nextFrom => 'Próximo de:';

  @override
  String get yourDevices => 'Seus dispositivos';

  @override
  String get onStandby => 'Em espera';

  @override
  String get currentDevice => 'Dispositivo atual';

  @override
  String get visualizationOnly => 'Só visualização';

  @override
  String get noCompatibleDevices => 'Nenhum dispositivo compátivel encontrado';

  @override
  String get latestRelease => 'Último lançamento';

  @override
  String get enjoyThisFeature => 'Aproveite esse recurso no Spotify Premium';

  @override
  String get colabFollowsPlansRules =>
      'O Colab Helper segue as regras dos planos do Spotify.';

  @override
  String get thisActionIsPremium =>
      'Esta ação está disponível apenas para usuários premium do Spotify.';

  @override
  String get spotifyPremiumLets =>
      'O Spotify Premium permite que você reproduza qualquer faixa, episódio de podcast ou audiolivro, sem anúncios e com melhor qualidade de áudio. Acesse ';

  @override
  String get toTryit => ' para experimentar gratuitamente.';

  @override
  String get syncLost => 'a Sincronização com Spotify foi perdida';

  @override
  String get syncPlsWait => 'Sincronizando com Spotify, por favor aguarde.';

  @override
  String get errorCheckConnection =>
      'Erro! Verifique sua conexão e tente novamente mais tarde.';

  @override
  String get errorCrash =>
      'Se você estiver vendo esta tela, seu aplicativo/página travou 😥';

  @override
  String get spotifyNotInstalled =>
      'Seu dispositivo não tem o aplicativo Spotify instalado';

  @override
  String get colabHelperUsesSpotify =>
      'O Colab Helper usa o aplicativo Spotify para sincronizar e reproduzir faixas. Instale o Spotify antes de usar este aplicativo.';

  @override
  String get getSpotifyFree => 'OBTER SPOTIFY GRATUITAMENTE';

  @override
  String userType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'premium': 'Premium',
        'free': 'Free',
        'other': ' ',
      },
    );
    return '$_temp0';
  }

  @override
  String get editPlaylist => 'Editar playlist';

  @override
  String get errorTryingToLoadImage =>
      'Ocorreu um erro ao tentar carregar a imagem, selecione outra imagem.';

  @override
  String get changeImage => 'Mudar Imagem';

  @override
  String get chooseFromCamera => 'Escolher da camera';

  @override
  String get chooseFromGallery => 'Escolher da galeria';

  @override
  String get imageTooBig =>
      'A imagem selecionada é muito grande. Selecione outra imagem.';

  @override
  String get imageUploadWarningOne =>
      'Ao prosseguir, você concorda em dar ao Spotify acesso à imagem que você escolher enviar.';

  @override
  String get imageUploadWarningTwo =>
      'Certifique-se de que você tem o direito de enviar a imagem.';

  @override
  String get title => 'Título';

  @override
  String get description => 'Descrição';

  @override
  String get cancelChanges => 'Cancelar alterações';

  @override
  String get discardChangesConfirmation =>
      'Tem certeza de que deseja descartar todas as alterações feitas?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sim';

  @override
  String get save => 'Salvar';

  @override
  String get sometimesTakesTime =>
      'Às vezes, ao salvar detalhes da playlist, as alterações podem levar até 1 minuto para atualizar na página. Você pode atualizar a playlist manualmente puxando para baixo para atualizar.';

  @override
  String get theme => 'Tema';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get darkMode => 'Modo escuro';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get loading => 'Carregando';

  @override
  String get syncAccount => 'Sincronizar conta';

  @override
  String get yourPlaylists => 'Suas Playlists';

  @override
  String get language => 'Idiomas';

  @override
  String get system => 'Sistema';

  @override
  String get english => 'Inglês';

  @override
  String get portugueseBrazilian => 'Português Brasil';

  @override
  String get settings => 'Configurações';

  @override
  String get viewAll => 'Ver todas';

  @override
  String get allPlaylists => 'Todas as Playlists';

  @override
  String get unnamedPlaylist => 'Playlist sem nome';

  @override
  String get unnamedAlbum => 'Álbum sem nome';

  @override
  String get unavailableSong => 'Música indisponível';

  @override
  String get unknown => 'Desconhecido';

  @override
  String nSongs(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString músicas',
      one: '1 música',
      zero: 'sem músicas',
    );
    return '$_temp0';
  }

  @override
  String get searchYourPlaylists => 'Pesquise suas Playlists';

  @override
  String get typeToSearch => 'Digite algo para pesquisar';

  @override
  String get errorLoadingSearch => 'Error loading searching, please try again.';

  @override
  String get noResultsFound => 'Nenhum resultado encontrado.';

  @override
  String get emptyPlaylist => 'Playlist vazia !!!';

  @override
  String get errorReorder =>
      'Erro ao tentar reordenar a música, tente novamente.';

  @override
  String get album => 'Álbum';

  @override
  String get artist => 'Artista';

  @override
  String get track => 'Música';

  @override
  String albumType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'single': 'Single',
        'album': 'Álbum',
        'other': ' ',
      },
    );
    return '$_temp0';
  }

  @override
  String get followers => 'Seguidores';

  @override
  String get follow => 'Seguir';

  @override
  String get following => 'Seguindo';

  @override
  String get topSongs => 'Mais tocadas';

  @override
  String get albums => 'Álbuns';

  @override
  String get loadMoreAlbums => 'Carregar mais álbuns';

  @override
  String get likedSongs => 'Músicas curtidas';

  @override
  String get queue => 'Fila';

  @override
  String get nowPlaying => 'Tocando agora';

  @override
  String get nextFrom => 'Próximo de:';

  @override
  String get yourDevices => 'Seus dispositivos';

  @override
  String get onStandby => 'Em espera';

  @override
  String get currentDevice => 'Dispositivo atual';

  @override
  String get visualizationOnly => 'Só visualização';

  @override
  String get noCompatibleDevices => 'Nenhum dispositivo compátivel encontrado';

  @override
  String get latestRelease => 'Último lançamento';

  @override
  String get enjoyThisFeature => 'Aproveite esse recurso no Spotify Premium';

  @override
  String get colabFollowsPlansRules =>
      'O Colab Helper segue as regras dos planos do Spotify.';

  @override
  String get thisActionIsPremium =>
      'Esta ação está disponível apenas para usuários premium do Spotify.';

  @override
  String get spotifyPremiumLets =>
      'O Spotify Premium permite que você reproduza qualquer faixa, episódio de podcast ou audiolivro, sem anúncios e com melhor qualidade de áudio. Acesse ';

  @override
  String get toTryit => ' para experimentar gratuitamente.';

  @override
  String get syncLost => 'a Sincronização com Spotify foi perdida';

  @override
  String get syncPlsWait => 'Sincronizando com Spotify, por favor aguarde.';

  @override
  String get errorCheckConnection =>
      'Erro! Verifique sua conexão e tente novamente mais tarde.';

  @override
  String get errorCrash =>
      'Se você estiver vendo esta tela, seu aplicativo/página travou 😥';

  @override
  String get spotifyNotInstalled =>
      'Seu dispositivo não tem o aplicativo Spotify instalado';

  @override
  String get colabHelperUsesSpotify =>
      'O Colab Helper usa o aplicativo Spotify para sincronizar e reproduzir faixas. Instale o Spotify antes de usar este aplicativo.';

  @override
  String get getSpotifyFree => 'OBTER SPOTIFY GRATUITAMENTE';

  @override
  String userType(String type) {
    String _temp0 = intl.Intl.selectLogic(
      type,
      {
        'premium': 'Premium',
        'free': 'Free',
        'other': ' ',
      },
    );
    return '$_temp0';
  }

  @override
  String get editPlaylist => 'Editar playlist';

  @override
  String get errorTryingToLoadImage =>
      'Ocorreu um erro ao tentar carregar a imagem, selecione outra imagem.';

  @override
  String get changeImage => 'Mudar Imagem';

  @override
  String get chooseFromCamera => 'Escolher da camera';

  @override
  String get chooseFromGallery => 'Escolher da galeria';

  @override
  String get imageTooBig =>
      'A imagem selecionada é muito grande. Selecione outra imagem.';

  @override
  String get imageUploadWarningOne =>
      'Ao prosseguir, você concorda em dar ao Spotify acesso à imagem que você escolher enviar.';

  @override
  String get imageUploadWarningTwo =>
      'Certifique-se de que você tem o direito de enviar a imagem.';

  @override
  String get title => 'Título';

  @override
  String get description => 'Descrição';

  @override
  String get cancelChanges => 'Cancelar alterações';

  @override
  String get discardChangesConfirmation =>
      'Tem certeza de que deseja descartar todas as alterações feitas?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get yes => 'Sim';

  @override
  String get save => 'Salvar';

  @override
  String get sometimesTakesTime =>
      'Às vezes, ao salvar detalhes da playlist, as alterações podem levar até 1 minuto para atualizar na página. Você pode atualizar a playlist manualmente puxando para baixo para atualizar.';

  @override
  String get theme => 'Tema';

  @override
  String get lightMode => 'Modo claro';

  @override
  String get darkMode => 'Modo escuro';
}
