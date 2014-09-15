# == Class: ubelixrepo
#
# This class configures the UBELIX repository and imports the GPG key.
#
# === Parameters
#
# [*mirrorlist*]
#   URL of the script that returns the mirror list
#
# [*baseurl]
#   If not using the mirror list option, setup the baseurl of a repo here.
#
# [*failovermethod]
#   Failover method to use if serveral mirrors are available
#
# [*proxy]
#   Set a proxy for an individual repo.
#
# [*enabled]
#   0 => disable repo; 1 => enable repo
#
# [*gpgcheck]
#   0 => disable gpg checks; 1 => enable gpg checks
#
# === Examples
#
# To use the default values:
#
#  include ubelixrepo
#
# To  override some values:
#
#  class { 'ubelixrepo':
#    baseurl => 'proxy.unibe.ch:80',
#    enabled => 1,
#  }
#
class ubelixrepo (
  $ubelixrepo_mirrorlist     = 'absent',
  $ubelixrepo_baseurl        = "http://gridadmin.ubelix.unibe.ch/mirror/ubelix/${::operatingsystemmajrelease}/\$basearch",
  $ubelixrepo_failovermethod = 'absent',
  $ubelixrepo_proxy          = 'absent',
  $ubelixrepo_enabled        = 1,
  $ubelixrepo_gpgcheck       = 1,
) {

  if $::osfamily == 'RedHat' and $::operatingsystem !~ /Fedora|Amazon/ {
    yumrepo { 'ubelix':
      mirrorlist     => $ubelixrepo_mirrorlist,
      baseurl        => $ubelixrepo_baseurl,
      failovermethod => $ubelixrepo_failovermethod,
      proxy          => $ubelixrepo_proxy,
      enabled        => $ubelixrepo_enabled,
      gpgcheck       => $ubelixrepo_gpgcheck,
      gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-UBELIX-${::operatingsystemmajrelease}",
      descr          => "UBELIX specific packages for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
    }

    file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-UBELIX-${::operatingsystemmajrelease}":
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => "puppet:///modules/ubelixrepo/RPM-GPG-KEY-UBELIX-${::operatingsystemmajrelease}",
    }

    ubelixrepo::rpm_gpg_key{ "UBELIX-${::operatingsystemmajrelease}":
      path   => "/etc/pki/rpm-gpg/RPM-GPG-KEY-UBELIX-${::operatingsystemmajrelease}",
      before => Yumrepo['ubelix'],
    }

  } else {
      notice ("Your operating system ${::operatingsystem} will not have the UBELIX repository applied")
  }
}
