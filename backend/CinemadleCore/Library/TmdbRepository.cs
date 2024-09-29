using System.ComponentModel;
using System.Runtime.CompilerServices;

using CinemadleCore.Library.Functional;

using TMDbLib.Client;

namespace CinemadleCore.Library;

public class TmdbRepository
{
    private readonly TMDbClient _tmdbClient;

    private static TmdbRepository? s_instance;

    private TmdbRepository(string apiKey)
    {
        _tmdbClient = new(apiKey);
    }

    private static Result<string> Init()
    {
        if (s_instance == null)
        {
            Result<string, string> apiKeyResult = Dotenv.Value("TMDB_API_KEY");

            if (apiKeyResult.IsError)
            {
                Result<string> err = ResultFactory<string>.Error(apiKeyResult.UnwrapError);
            }

            s_instance = new TmdbRepository(apiKeyResult.Unwrap);

            return ResultFactory<string>.Ok();
        }
    }

    public static Result<TmdbRepository, string> Instance
    {
        get
        {


            return ResultFactory<TmdbRepository>.Ok(s_instance);
        }
    }
}