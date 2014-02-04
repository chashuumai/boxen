class people::penxera {

  # lib
  include osx
  include wget
  include zsh

  # local application for develop
  include iterm2::stable
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

    'sublimeText':
        source   =>  "http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%20Build%203059.dmg",
        provider =>  pkgdmg;

    'GoogleJapaneseInput':
        source   => "http://dl.google.com/japanese-ime/latest/GoogleJapaneseInput.dmg",
        provider => pkgdmg;

    'senevier':
        source   => "http://www.bicoid.com/app/senebier/archive/senebier.dmg",
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
  # $src     = "${home}/src"
  $dotfiles = "${home}/dotfiles"

  repository { $dotfiles:
    source  => "${::boxen_user}/dotfiles"
    # require => File[$src]
  }
  exec { "sh ${dotfiles}/bootstrap.sh":
    cwd => $dotfiles,
    creates => "${home}/.zshrc",
    require => Repository[$dotfiles],
    notify  => Exec['submodule-clone'],
  }
  exec { "submodule-clone":
    cwd => $dotfiles,
    command => 'git submodule init && git submodule update',
    require => Repository[$dotfiles],
  }
}
