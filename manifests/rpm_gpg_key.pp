# == Define ubelixrepo::rpm_gpg_key
#
# This define imports a given RPM gpg key if it is not
# already imported in the rpm keyring.
#
# Reqiures:
#   A file resources with the given path must exist before as it
#   is required in the define.
#
# == Parameters
#
# [*path*]
#   Path of the RPM GPG key to import
#
# === Examples
#
#  ubelixrepo::rpm_gpg_key { 'UBELIX-6':
#    path => "/etc/pki/rpm-gpg/RPM-GPG-KEY-UBELIX-6"
#  }
#
define ubelixrepo::rpm_gpg_key($path) {
  # Given the path to a key, see if it is imported, if not, import it
  exec {  "import-${name}":
    path      => '/bin:/usr/bin:/sbin:/usr/sbin',
    command   => "rpm --import ${path}",
    unless    => "rpm -q gpg-pubkey-$(echo $(gpg --throw-keyids < ${path}) | cut -c 11-18 | tr '[A-Z]' '[a-z]')",
    require   => File[$path],
    logoutput => 'on_failure',
  }
}

