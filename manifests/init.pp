# repo_ubelix
#
# Manages the UBELIX repository definition.
#
# @summary This class manages the yum repository definitino and the gpg key.
#
# @example
#   include repo_ubelix
class repo_ubelix (
  Enum['present', 'absent'] $ensure,
  String $baseurl,
  String $mirrorlist,
  Enum['roundrobin', 'priority'] $failovermethod,
  Integer $enabled,
  Integer $gpgcheck,
) {

  $release = $facts['os']['release']['major']
  $keypath = "/etc/pki/rpm-gpg/RPM-GPG-KEY-UBELIX-${release}"

  if $facts['os']['family'] == 'RedHat' and $facts['os']['name'] !~ /Fedora|Amazon/ {
    yumrepo { 'ubelix':
      # lint:ignore:selector_inside_resource
      ensure         => $ensure,
      mirrorlist     => $baseurl ? {
        'absent' => $mirrorlist,
        default  => 'absent',
      },
      # lint:endignore
      baseurl        => $baseurl,
      failovermethod => $failovermethod,
      proxy          => 'absent',
      enabled        => $enabled,
      gpgcheck       => $gpgcheck,
      gpgkey         => "file://${keypath}",
      descr          => 'UBELIX specific packages',
    }

    file { $keypath:
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => file("repo_ubelix/RPM-GPG-KEY-UBELIX-${release}"),
    }

    repo_ubelix::rpm_gpg_key{ "UBELIX-${release}":
      path   => $keypath,
      before => Yumrepo['ubelix'],
    }

  } else {
      notice ("Your operating system ${facts['os']['name']} will not have the UBELIX repository applied")
  }
}
