# Altered-Infra Puppet module

## Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with alteredinfra](#setup)
    * [What alteredinfra affects](#what-alteredinfra-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with alteredinfra](#beginning-with-alteredinfra)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

The **alteredinfra** module installs, configures and manages various infrastructure components. For the moment, it only works on Windows OS and Puppet 4 or higher.

With this module, you are able to easily install & configure:

* the configuration agent that is part of the Altered Infrastructure solution provided by [www.devpro.fr](http://www.devpro.fr).

On a side note, this is an example of Puppet code to install an ASP.NET Core application!

## Setup

### What alteredinfra affects

If it's obvious what your module touches, you can skip this section. For example, folks can probably figure out that your mysql_instance module affects their MySQL instances.

This modules touches the following elements:

* Files located by default in `C:\Program Files` (application files) and `D:\ProgamData` (log files)
* IIS by adding a new appliation beneath the default web site

### Setup Requirements

This modules requires the following modules:

* [puppetlabs/iis](https://forge.puppet.com/puppetlabs/iis)

It's advised to use `r10k` and a puppetfile to load modules.

### Beginning with alteredinfra

If you use a `puppetfile` (with a tool like r10k for example), here is the line to be added:

```rubydsl
mod 'alteredinfra',
  :git    => 'https://github.com/devpro/puppet-infra',
  :branch => 'dev'
```

In addition to `include alteredinfra::application::configagent`, the following data needs to be configured:

```yaml
alteredinfra::application::configagent::package_repository: path_to_repo_where_zipfile_is
alteredinfra::application::configagent::application_version: "1_0_0_0"
```

## Usage

All parameters for the ConfigurationAgent application are contained within the main `application/configagent` class, so for any function of the module, set the options you want. See the common usages below for examples.

### Install and enable alteredinfra

```puppet
include alteredinfra::application::configagent
```

## Reference

### Classes

#### Public classes

* alteredinfra::application::configagent: Application class.

### Parameters

The following parameters are available in the `alteredinfra::application::configagent` class:

#### `application_name`

Optional.

Data type: String.

Application name that will be used in the application file path and application pool name.

Default value: `ConfigurationAgent`.

#### `installation_root_path`

Optional.

Data type: String.

Root path where the application will be installed.

Default value: `C:\Program Files\Devpro`.

#### `temporary_folder_path`

Optional.

Data type: String.

Temporary folder where the installation package will be extracted.

Default value: `C:\Temp`.

#### `log_folder_path`

Optional.

Data type: String.

Application log file folder path.

Default value: `C:\ProgramData\Devpro\ConfigurationAgent\Logs`.

#### `puppet_file_path`

Optional.

Data type: String.

Path of puppet file.

Default value: `C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat`.

#### `package_repository`

Mandatory.

Data type: String.

Application package repository.

#### `application_version`

Mandatory.

Data type: String.

Application version numer (for example: 1_0_0_0).

#### `logging_level`

Optional.

Data type: String.

Logging level.

Default value: `Information`.

#### `windows_7zip_exe_path`

Optional.

Data type: String.

Path of 7zip exe file on Windows.

Default value: `C:\Program Files\7-Zip\7z.exe`.

#### `iis_appcmd_exe_path`

Optional.

Data type: String.

Path of IIS appcmd exe file.

Default value: `C:\\Windows\\system32\\inetsrv\\appcmd.exe`.

#### `iis_apppool_name`

Optional.

Data type: String.

IIS application pool name.

Default value: `ConfigurationAgentAppPool`.

#### `iis_site_name`

Optional.

Data type: String.

IIS site name on which the application will be installed.

Default value: `Default Web Site`.

#### `iis_apppool_identitytype`

Optional.

Data type: String.

IIS application pool identity type.

Default value: `LocalSystem`.

## Limitations

This module has been tested on Windows 10 and Windows 2008 R2 running Puppet agent open source 5.3.

## Development

This is an open project, anyone can contribute and provide feedbacks.

## Contributors

To see who's already involved, see the [list of contributors.](https://github.com/devpro/puppet-infra/graphs/contributors)
