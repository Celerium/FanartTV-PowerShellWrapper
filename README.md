# FanartTv API PowerShell Wrapper

This PowerShell module acts as a wrapper for the [FanartTv](https://fanart.tv/) API.

---

## Introduction

The FanartTv API offers users the ability to extract data from FanartTv into a third-party reporting tools.

- Full documentation for FanartTv's RESTful API can be found [here](https://fanarttv.docs.apiary.io) *[ Requires a login ]*.

This module serves to abstract away the details of interacting with FanartTv's API endpoints in such a way that is consistent with PowerShell nomenclature. This gives system administrators and PowerShell developers a convenient and familiar way of using FanartTv's API to create documentation scripts, automation, and integrations.

### Function Naming

FanartTv features a REST API that makes use of common HTTPs GET actions. In order to maintain PowerShell best practices, only approved verbs are used.

- GET -> Get-

Additionally, PowerShell's `verb-noun` nomenclature is respected. Each noun is prefixed with `FanartTv` in an attempt to prevent naming problems.

For example, one might access the `/movies` API endpoint by running the following PowerShell command with the appropriate parameters:

```posh
Get-FanartTv -Type movies
```

---

## Install & Import

This module can be installed directly from the [PowerShell Gallery](https://www.powershellgallery.com/packages/FanartTvAPI) with the following command:

- :information_source: This module supports PowerShell 5.0+ and should work in PowerShell Core.

```posh
Install-Module -Name FanartTvAPI
```

If you are running an older version of PowerShell, or if PowerShellGet is unavailable, you can manually download the *Master* branch and place the *FanartTvAPI* folder into the (default) `C:\Program Files\WindowsPowerShell\Modules` folder.

After installation (by either methods), load the module into your workspace:

```posh
Import-Module FanartTvAPI
```

---

## Initial Setup

After importing this module, you will need to configure both the *base URI* & *API access tokens* that are used to talk with the FanartTv API.

1. Run `Add-FanartTvBaseURI`
   - By default, FanartTv's `https://webservice.fanart.tv/v3` uri is used.
   - If you have your own API gateway or proxy, you may put in your own custom uri by specifying the `-base_uri` parameter:
      -  `Add-FanartTvBaseURI -base_uri http://myapi.gateway.example.com`
<br><br>

2. Run `Add-FanartTvAPIKey -Api_Key 123456789`
   - It will prompt you to enter in your API access tokens if you do not specify them.
   - FanartTv API access tokens are generated [here](https://fanart.tv/get-an-api-key/)
<br><br>

[optional]

1. Run `Export-FanartTvModuleSettings`
   - This will create a config file at `%UserProfile%\FanartTvAPI` that securely holds the *base uri* & *API access tokens* information.
   - Next time you run `Import-Module -Name FanartTvAPI`, this configuration file will automatically be loaded.
      - :warning: Exporting module settings encrypts your API access tokens in a format that can **only be unencrypted with your Windows account**. It makes use of PowerShell's `System.Security.SecureString` type, which uses reversible encrypted tied to your user principal. This means that you cannot copy your configuration file to another computer or user account and expect it to work.
      - :warning: Exporting and importing module settings requires use of the `ConvertTo-SecureString` cmdlet, which is currently buggy in Linux & Mac PowerShell core ports.

---

## Usage

Calling an API resource is as simple as running `Get-FanartTv`

- The following is a table of supported functions and their corresponding API resources:
- Table entries with [ `-` ] indicate that the functionality is NOT supported by the FanartTv API at this time.

| API Resource    | Create    | Read                      | Update    | Delete    |
| --------------  | --------- | ------------------------- | --------- | --------- |
| FanartTv        | -         | `Get-FanartTv`            | -         | -         |

Each `Get-FanartTv*` function will respond with the raw data that FanartTv's API provides.

---

## Wiki & Help :blue_book:

- A full list of functions can be retrieved by running `Get-Command -Module FanartTvAPI`.
- Help info and a list of parameters can be found by running `Get-Help <command name>`, such as:

```posh
Get-Help Get-FanartTv
Get-Help Get-FanartTv -Full
```
---
