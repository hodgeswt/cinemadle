# cinemadle

A movie guessing game that is still in development.

## Building

To build cinemadle, do the following:

1. Ensure you have an `API_KEY` defined in an `.env` file in the `packages/tmdb_repository` folder.
1. Import the `Cinemadle` powershell module
1. If running for the first time, run `Invoke-BuildProject -IncludePackages`
1. After that, run `Invoke-BuildProject`. Additional flags provide more options


To generate a release build, run `Invoke-BuildProject -Release`

A build can be hosted with `Invoke-HostBuild`
