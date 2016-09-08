defnie postfix::alias (
  $value,
  $file   ='/etc/aliases',
  $ensure ='present',
) {

  include postfix::augeas

  validate_string($value)
  validate_string($file)
  validate_absolute_path($file)
  validate_string($ensure)

  case $ensure {
    'present': {
      $changes = [
        "set name[. = '${name}'] '${name}'",
        "set name[. = '${name}']/value '${value}'",
      ]
    }

    'absent': {
      $changes = "rm name[. = '${name}']"
    }

    default: {
      fail "\$ensure must be either 'present' or absent', got '${ensure}'"
    }
  }

  augeas {"Postfix virtual - ${name}":
    incl    => $file,
    lens    => 'Aliases.lns',
    changes => $changes,
    require => Augeas::Lens['aliases'],
    notify  => Postfix::Hash[$file],
  }
}
