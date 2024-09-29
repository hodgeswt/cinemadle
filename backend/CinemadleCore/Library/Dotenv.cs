using System.Globalization;

using CinemadleCore.Library.Functional;

namespace CinemadleCore.Library;

public static class Dotenv
{
    private static readonly Dictionary<string, string> EnvValues = [];

    private static bool s_envLoaded = false;


    private static void LoadEnvironmentIfNeeded()
    {
        if (s_envLoaded)
        {
            return;
        }

        if (!File.Exists(".env"))
        {
            return;
        }

        string[] dotenv = File.ReadAllLines(".env");

        if (dotenv.Length == 0)
        {
            return;
        }

        foreach (string line in dotenv)
        {
            string[] parts = line.Split('=');
            string key = parts[0];
            string value = parts[1];

            if (!string.IsNullOrEmpty(key))
            {
                EnvValues.Add(key, value);
            }
        }

        s_envLoaded = true;
    }

    public static Result<string, string> Value(string key)
    {
        LoadEnvironmentIfNeeded();

        if (EnvValues.TryGetValue(key, out string? value) && value != null)
        {
            return ResultFactory<string>.Ok(value);
        }

        string? environmentValue = Environment.GetEnvironmentVariable(key);
        if (environmentValue != null)
        {
            return ResultFactory<string>.Ok(environmentValue);
        }

        return ResultFactory<string>.Error($"Unable to locate variable: {key}");
    }
}