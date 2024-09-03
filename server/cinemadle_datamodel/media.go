package cinemadle_datamodel

import "encoding/json"

type Media struct {
	Id      int `json:"id"`
	Length  int `json:"length"`
	Revenue int `json:"revenue"`

	VoteAverage float32 `json:"revenue"`

	Title     string `json:"title"`
	Rating    string `json:"rating"`
	Date      string `json:"date"`
	PosterUri string `json:posterUri"`

	Cast []Person `json:"cast"`
	Crew []Person `json:"crew"`
}

func (m Media) ToJson() (string, error) {
	j, err := json.Marshal(m)

	if err != nil {
		return "", err
	}

	return string(j), nil
}
