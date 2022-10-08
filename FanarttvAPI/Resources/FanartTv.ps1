function Get-FanartTv {
<#
    .SYNOPSIS
        Gets FanartTv API data for Movies, TV Shows, & Music

    .DESCRIPTION
        The Get-FanartTv cmdlet gets FanartTv API data for Movies, TV Shows, & Music

    .PARAMETER Type
        Defines the type of media to get

        Acceptable values are:
            'Movies', 'Music', 'TV

    .PARAMETER MusicType
        Defines the type of music media to get

        Acceptable values are:
            'albums', 'labels'

    .PARAMETER Id
        The IMDB or TMDB id of the media type to get

        Multiple Ids can be defined using separating each one with a comma

        Source | ID
            tmdb_id | 120
            imdb_id | tt0120737

    .PARAMETER Date
        A local time DateTime value to limit latest data queries.

        Example:
            yyyy-MM-dd, yyyy/MM/dd
        The entered value is converted to UnixTime using the Get-Date command

        Note:
        DateTime appears to be when values were published\updated to the FanArt API and not when the media was published

    .EXAMPLE
        Movies by Id response body:

        {
        "name": "The Lord of the Rings: The Fellowship of the Ring",
        "tmdb_id": "120",
        "imdb_id": "tt0120737",
        "hdmovielogo": [
            {
            "id": "50927",
            "url": "http://assets.fanart.tv/fanart/movies/120/hdmovielogo/the-lord-of-the-rings-the-fellowship-of-the-ring-5232c108a0b11.png",
            "lang": "en",
            "likes": "7"
            }
        ],
        "moviedisc": [
            {
            "id": "29003",
            "url": "http://assets.fanart.tv/fanart/movies/120/moviedisc/the-lord-of-the-rings-the-fellowship-of-the-ring-5156389dc28f2.png",
            "lang": "en",
            "likes": "5",
            "disc": "1",
            "disc_type": "bluray"
            }
        ],
        "movielogo": [
            {
            "id": "1613",
            "url": "http://assets.fanart.tv/fanart/movies/120/movielogo/the-lord-of-the-rings-the-fellowship-of-the-ring-4f78564165f48.png",
            "lang": "en",
            "likes": "4"
            }
        ],
        "movieposter": [
            {
            "id": "57317",
            "url": "http://assets.fanart.tv/fanart/movies/120/movieposter/the-lord-of-the-rings-the-fellowship-of-the-ring-528aa45a8633a.jpg",
            "lang": "en",
            "likes": "4"
            }
        ],
        "hdmovieclearart": [
            {
            "id": "34307",
            "url": "http://assets.fanart.tv/fanart/movies/120/hdmovieclearart/the-lord-of-the-rings-the-fellowship-of-the-ring-518f5ccc16a40.png",
            "lang": "en",
            "likes": "3"
            }
        ],
        "movieart": [
            {
            "id": "1140",
            "url": "http://assets.fanart.tv/fanart/movies/120/movieart/the-lord-of-the-rings-the-fellowship-of-the-ring-4f6c938a134a1.png",
            "lang": "en",
            "likes": "2"
            }
        ],
        "moviebackground": [
            {
            "id": "5299",
            "url": "http://assets.fanart.tv/fanart/movies/120/moviebackground/the-lord-of-the-rings-the-fellowship-of-the-ring-4fdb8b38d6453.jpg",
            "lang": "en",
            "likes": "2"
            }
        ],
        "moviebanner": [
            {
            "id": "12355",
            "url": "http://assets.fanart.tv/fanart/movies/120/moviebanner/the-lord-of-the-rings-the-fellowship-of-the-ring-50485f0da465c.jpg",
            "lang": "en",
            "likes": "1"
            }
        ],
        "moviethumb": [
            {
            "id": "40949",
            "url": "http://assets.fanart.tv/fanart/movies/120/moviethumb/the-lord-of-the-rings-the-fellowship-of-the-ring-51d7e42a53a1d.jpg",
            "lang": "en",
            "likes": "1"
            }
        ]
    }

    .EXAMPLE
        Get-FanartTv -Type Movies

        Gets around 200+ of the latest movies

    .EXAMPLE
        Get-FanartTv -Type Tv -Date 2022-10-01

        Gets TVShows added\updated since 2022-10-01

    .EXAMPLE
        Get-FanartTv -Type Movies -Id 120

        Gets the movie with the IMDB Id of 120, which also includes image links

    .EXAMPLE
        Get-FanartTv -Type Movies -Id 120,121,122

        Gets the movie with the defined IMDB Ids, which also includes image links

    .EXAMPLE
        Get-FanartTv -Type Music -MusicType albums -Id f4a31f0a-51dd-4fa7-986d-3095c40c5ed9

        Gets the music album with the MBID Id of f4a31f0a-51dd-4fa7-986d-3095c40c5ed9, which also includes image links

    .EXAMPLE
        Get-FanartTv -Type Music -MusicType labels -Id e832b688-546b-45e3-83e5-9f8db5dcde1d

        Gets the music labels with the Id of e832b688-546b-45e3-83e5-9f8db5dcde1d

    .NOTES
        Look into adding image preview function
        Determine in pagination is supported

    .LINK
        https://github.com/Celerium/FanartTV-PowerShellWrapper
        https://fanarttv.docs.apiary.io
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(ParameterSetName = 'index',          Mandatory = $true)]
        [Parameter(ParameterSetName = 'indexById',      Mandatory = $true)]
        [Parameter(ParameterSetName = 'indexByMusic',   Mandatory = $true)]
        [ValidateSet('movies', 'music', 'tv')]
        [string]$Type,

        [Parameter(ParameterSetName = 'indexByMusic',   Mandatory = $true)]
        [ValidateSet('albums', 'labels')]
        [string]$MusicType,

        [Parameter(ParameterSetName = 'indexById',      Mandatory = $true, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = 'indexByMusic',   Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]$Id,

        [Parameter(ParameterSetName = 'index',          Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [DateTime]$Date
    )

    Write-Verbose "Using the [ $($PSCmdlet.ParameterSetName) ] parameter set"

    if ($Type -ne 'Music' -and [bool]$MusicType){
        Write-Error "The [ $Type ] type is not compatible with the [ $MusicType ] option"
        exit 1
    }

    if ($Date){
        $UnixTime = Get-Date $Date -UFormat %s
        Write-Verbose "Converting [ $Date ] to Epoch\Unix time [ $UnixTime ]"
    }

    $rest_results = [System.Collections.Generic.List[object]]::new()
    $client_key = (New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList 'N/A', $FanartTv_API_Key).GetNetworkCredential().Password

    if($Id){
        ForEach ($EntryId in $Id){

            switch ($PSCmdlet.ParameterSetName) {
                'indexById'     { $resource_uri = "/$Type/$($EntryId)?api_key=$client_key" }
                'indexByMusic'  { $resource_uri = "/$Type/$MusicType/$($EntryId)?api_key=$client_key" }
            }

            Write-Verbose "Querying  [ $($FanartTv_Base_URI + $resource_uri.split('=')[0] + '=*****') ]"

            try {
                $rest_output = Invoke-RestMethod -Method Get -Uri ($FanartTv_Base_URI + $resource_uri) -Headers $FanartTv_Headers  -ErrorAction Stop -ErrorVariable web_error
            } catch {
                Write-Error $_
            } finally {
                #Future use
                #[void] ($FanartTv_Headers.Remove('api_key'))
                #[void] ($FanartTv_Headers.Remove('client_key'))
            }

            $data = @{}
            $data = $rest_output
            $rest_results.Add($data) > $null
        }
    }
    else{
        switch ($PSCmdlet.ParameterSetName) {

            'index' {   if ($Date){$resource_uri = "/$Type/latest?api_key=$client_key&date=$UnixTime"}
                        else{$resource_uri = "/$Type/latest?api_key=$client_key"} }
        }

        Write-Verbose "Querying  [ $($FanartTv_Base_URI + $resource_uri.split('=')[0] + '=*****') ]"

        try {
            $rest_output = Invoke-RestMethod -Method Get -Uri ($FanartTv_Base_URI + $resource_uri) -Headers $FanartTv_Headers  -ErrorAction Stop -ErrorVariable web_error
        } catch {
            Write-Error $_
        } finally {
            #Future use
            #[void] ($FanartTv_Headers.Remove('api_key'))
            #[void] ($FanartTv_Headers.Remove('client_key'))
        }

        $data = @{}
        $data = $rest_output
        $rest_results.Add($data) > $null
    }

    return $rest_results

}
