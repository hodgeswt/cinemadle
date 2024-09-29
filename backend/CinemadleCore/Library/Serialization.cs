using System.Text.Json;

using CinemadleCore.Library.Functional;

namespace CinemadleCore.Library;

public static class Serialization
{
    public static readonly JsonSerializerOptions Opts = new()
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
    };

    public static Result<string, string> Serialize<T>(T obj)
    {
        return ResultFactory<string>.Wrap(() => JsonSerializer.Serialize(obj, Opts));
    }
}