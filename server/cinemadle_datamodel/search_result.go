package cinemadle_datamodel

import "encoding/json"

type SearchResult struct {
	Id    int    `json:"id"`
	Title string `json:"title"`

	AdditionalInformation map[string]string `json:"additionalInformation"`
}

func (m SearchResult) ToJson() (string, error) {
	j, err := json.Marshal(m)

	if err != nil {
		return "", err
	}

	return string(j), nil
}
