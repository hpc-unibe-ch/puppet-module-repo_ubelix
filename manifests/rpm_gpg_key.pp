# repo_ubelix::blah
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#  repo_ubelix::rpm_gpg_key { 'UBELIX-6':
#    path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-UBELIX-6"
#  }
define repo_ubelix::rpm_gpg_key($path) {
  # Given the path to a key, see if it is imported, if not, import it
  exec {  "import-${name}":
    path      => '/bin:/usr/bin:/sbin:/usr/sbin',
    command   => "rpm --import ${path}",
    unless    => "rpm -q gpg-pubkey-$(echo $(gpg --throw-keyids < ${path}) | cut -c 11-18 | tr '[A-Z]' '[a-z]')",
    require   => File[$path],
    logoutput => 'on_failure',
  }
}
