class people::penxera {
  # 自分の環境で欲しいresourceをinclude
  #include dropbox
  #include sublimetext
  include osx
  # lib
  include zsh

  # local application for develop
  include iterm2::stable
  include sublime_text_2
  sublime_text_2::package { 'Emmet':
    source => 'sergeche/emmet-sublime'
  }
  include firefox
  include chrome
  include cyberduck

  # local application for utility
  include dropbox



  # homebrewでインストール
  package {
    [
      'readline', # use for rails
      'tree',
      'git-extras',
      'z',
      'tig',
    ]:
  }

  # local application
  package {
    # utility
    # 'XtraFinder':
    # source   => "http://www.trankynam.com/xtrafinder/downloads/XtraFinder.dmg",
    # provider => pkgdmg;
  }


  #file_line { 'add zsh to /etc/shells':
  #path    => '/etc/shells',
  #line    => "${boxen::config::homebrewdir}/bin/zsh",
  #require => Package['zsh'],
  #before  => Osx_chsh[$::boxen_user];
  #}

  #osx_chsh { $::boxen_user:
  #  shell   => "${boxen::config::homebrewdir}/bin/zsh";
  #}


  # dotfile setting
  $home     = "/Users/${::boxen_user}"
  #$src     = "${home}/src"
  $dotfiles = "${home}/dotfiles"

  # ~/dotfilesにGitHubのpenxera/dotfiles git-clone
  repository { $dotfiles:
    source  => "penxera/dotfiles",
    # require => File[$src]
  }
  # git-cloneしたらインストール
  exec { "submodule-clone":
    # "sh ${dotfiles}/install.sh":
    cwd => $dotfiles,
    # creates => "${home}/.zshrc",
    command => 'git submodule init && git submodule update'
    require => Repository[$dotfiles],
  }
}
