namespace CinemadleCore.DataModel;

public readonly struct Media
{
    public readonly int Id;

    public readonly int Length;

    public readonly int Revenue;

    public readonly double VoteAverage;

    public readonly string Title;

    public readonly string Rating;

    public readonly string Date;

    public readonly string ImageUri;

    public readonly IEnumerable<Person> Cast;

    public readonly IEnumerable<Person> Crew;
}