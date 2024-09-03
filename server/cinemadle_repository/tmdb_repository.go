package cinemadle_repository

import (
	"os"

	"github.com/cyruzin/golang-tmdb"
	"github.com/joho/godotenv"

	"hodgeswill.com/cinemadle_datamodel"
)

type TmdbRepository struct {
	IsInitialized bool
	TmdbClient    *tmdb.Client
}

func (t *TmdbRepository) SearchMovies(query string) ([]cinemadle_datamodel.SearchResult, error) {
	if !t.IsInitialized {
		err := t.Initialize(nil)

		if err != nil {
			return nil, err
		}
	}

	searchMovies, err := t.TmdbClient.GetSearchMovies(query, nil)

	if err != nil {
		return nil, err
	}

	_ = searchMovies.SearchMoviesResults

	return nil, nil
}

func (t *TmdbRepository) Initialize(tmdbApiKey *string) error {
	if t.IsInitialized {
		return nil
	}

	tmdbKey := ""
	if tmdbApiKey == nil {
		if err := godotenv.Load(); err != nil {
			return err
		}
		tmdbKey = os.Getenv("TMDB_API_KEY")
	} else {
		tmdbKey = *tmdbApiKey
	}

	c, err := tmdb.InitV4(tmdbKey)
	if err != nil {
		return err
	}

	t.TmdbClient = c
	t.IsInitialized = true

	return nil
}
