namespace CinemadleCore.Library.Functional;


public class Result<T>
    where T : class
{
    private readonly T? _error;

    public T UnwrapError => _error!;

    public static Result<T> Error(T error) => new(error);

    public static Result<T> Ok() => new(null);
    private Result(T? error)
    {
        _error = error;
    }
}

public class Result<T, U>
{
    private readonly T? _value;

    private readonly U? _error;

    public T Unwrap => _value!;

    public U UnwrapError => _error!;

    public bool IsOk => _value != null;

    public bool IsError => _error != null;

    public static Result<T, U> Ok(T value) => new(value, default);

    public static Result<T, U> Error(U error) => new(default, error);

    public static Result<V, U> MapError<V>(Result<T, U> result) => Result<V, U>.Error(result.UnwrapError);

    public static Result<T, U> Wrap(Func<T> f, Func<Exception, U> e)
    {
        try
        {
            return Result<T, U>.Ok(f());
        }
        catch (Exception ex)
        {
            return Result<T, U>.Error(e(ex));
        }
    }

    private Result(T? value, U? error)
    {
        _value = value;
        _error = error;
    }
}

public abstract class ResultFactory<T>
    where T : class
{
    public static Result<T, string> Ok(T value) => Result<T, string>.Ok(value);
    public static Result<T, string> Error(string error) => Result<T, string>.Error(error);
    public static Result<T, string> Wrap(Func<T> f) => Result<T, string>.Wrap(f, (ex) => ex.Message);

    public static Result<V, string> MapError<V>(Result<T, string> result) => Result<T, string>.MapError<V>(result);

    public static Result<T> Ok() => Result<T>.Ok();

    public static Result<T> Error(T error) => Result<T>.Error(error);
}