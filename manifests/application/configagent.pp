# alteredinfra::application::configagent
#
# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include alteredinfra::application::configagent
class alteredinfra::application::configagent (
  String $application_name       = 'ConfigurationAgent',
  String $installation_root_path = "C:\\Program Files\\Devpro",
  String $puppet_file_path       = "C:\\Program Files\\Puppet Labs\\Puppet\\bin\\puppet.bat",
  String $package_repository     = undef,
  String $application_version    = undef,
  String $logging_level          = 'Information',
  String $windows_7zip_exe_path  = "C:\\Program Files\\7-Zip\\7z.exe",
  String $iis_appcmd_exe_path    = "C:\\Windows\\system32\\inetsrv\\appcmd.exe",
  String $iis_apppool_name       = 'ConfigurationAgentAppPool',
  String $iis_site_name          = 'Default Web Site',
  String $temporary_folder_path  = "D:\\Temp"
) {
  # input validation
  validate_re($application_version, ['^(\d_\d_\d_\d.*)$'])
  if ($package_repository == undef) {
    fail('package_repository is undefined')
  }

  # variables
  $package_path     = "${package_repository}\\${application_name}_${application_version}.zip"
  $application_path = "${installation_root_path}\\${application_name}_${application_version}"

  file { $package_path:
    ensure => 'present'
  }
  file { $installation_root_path:
    ensure => 'directory'
  }
  ~> file { "${application_path}\\appsettings.json":
    ensure  => file,
    content => epp('alteredinfra/configagent/appsettings.json.epp', {
        'puppet_file_path'         => $puppet_file_path,
        'logging_debug_loglevel'   => $logging_level,
        'logging_console_loglevel' => $logging_level
      })
  }

  if ($::facts['osfamily'] == 'windows') {
    exec { "Extract ${application_name} package":
      command   => "\"${windows_7zip_exe_path}\" x \"${package_path}\" -o\"${application_path}\"",
      cwd       => $temporary_folder_path,
      creates   => $application_path,
      logoutput => false
    }
    ~> iis_application_pool { $iis_apppool_name:
      ensure                    => 'present',
      enable32_bit_app_on_win64 => false,
      managed_runtime_version   => 'v4.0',
      managed_pipeline_mode     => 'Integrated',
      identity_type             => 'ApplicationPoolIdentity'
    }
    ~> iis_application { "${iis_site_name}\\${application_name}":
      ensure          => 'present',
      applicationname => $application_name,
      sitename        => $iis_site_name,
      physicalpath    => $application_path,
      applicationpool => $iis_apppool_name
    }
    ~> exec {"Restart ${iis_apppool_name} IIS application pool":
      command     => "${iis_appcmd_exe_path} start apppool ${iis_apppool_name}",
      refreshonly => true,
      logoutput   => true
    }
  }

  File[$package_path] ~> Exec["Extract ${application_name} package"]

  File["${application_path}\\appsettings.json"] ~> Exec["Restart ${iis_apppool_name} IIS application pool"]
}
