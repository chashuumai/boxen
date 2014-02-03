class people::penxera {
  #puppetfile
  include osx

  # lib
  include zsh

  # local application for develop
  include iterm2::stable
  #include sublime_text_2
  #sublime_text_2::package { 'Emmet':
  #  source => 'sergeche/emmet-sublime'
  #}
  include firefox
  include chrome
  include cyberduck

  # local application for utility
  include dropbox



  # homebrewでインストール
  package {
    [
  #    'readline', # use for rails
  #    'tree',
  #    'git-extras',
  #    'z',
  #    'tig',
    ]:
  }

  # local application
  package {

    'Kobito':
        source   => "http://kobito.qiita.com/download/Kobito_v1.2.0.zip",
        provider => compressed_app;

    'XtraFinder':
        source   => "http://www.trankynam.com/xtrafinder/downloads/XtraFinder.dmg",
        provider => pkgdmg;

    'sublimeText':
        source  =>  "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203059.dmg",
        provider    =>  pkgdmg;

    'GoogleJapaneseInput':
        source => "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
        provider => pkgdmg;


}

#osx
package {
  'zsh':
      install_options => [
        '--disable-etcdir'
      ]
}

file_line { 'add zsh to /etc/shells':
    path    => '/etc/shells',
    line    => "${boxen::config::homebrewdir}/bin/zsh",
    require => Package['zsh'],
    before  => Osx_chsh[$::boxen_user];
}

osx_chsh { $::boxen_user:
    shell   => "${boxen::config::homebrewdir}/bin/zsh";
}


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
    command => 'git submodule init && git submodule update',
    require => Repository[$dotfiles]
  }
}
