class people::penxera {
  # 自分の環境で欲しいresourceをinclude
  #include dropbox
  #include sublimetext
  include osx

    'Kobito':
        source   => "http://kobito.qiita.com/download/Kobito_v1.2.0.zip",
        provider => compressed_app;

  # homebrewでインストール
  package {
    'zsh':
        install_options => [
          '--disable-etcdir'
        ]
    [
      'tmux',
      'reattach-to-user-namespace',
      'tig',
    ]:
  }

  file_line { 'add zsh to /etc/shells':
  path    => '/etc/shells',
  line    => "${boxen::config::homebrewdir}/bin/zsh",
  require => Package['zsh'],
  before  => Osx_chsh[$::luser];
}
osx_chsh { $::luser:
  shell   => "${boxen::config::homebrewdir}/bin/zsh";
}

  $home     = "/Users/${::luser}"
  $src      = "${home}/src"
  $dotfiles = "${src}/dotfiles"

  # ~/src/dotfilesにGitHub上のpenxera/dotfilesリポジトリを
  # git-cloneする。そのとき~/srcディレクトリがなければいけない。
  repository { $dotfiles:
    source  => "penxera/dotfiles",
    require => File[$src]
  }
  # git-cloneしたらインストールする
  exec { "sh ${dotfiles}/install.sh":
    cwd => $dotfiles,
    creates => "${home}/.zshrc",
    require => Repository[$dotfiles],
  }
}
