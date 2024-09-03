package cinemadle_datamodel

import "encoding/json"

type Person struct {
	Name string `json:"name"`
	Role string `json:"role"`
}

func (p Person) ToJson() (string, error) {
	j, err := json.Marshal(p)

	if err != nil {
		return "", err
	}

	return string(j), nil
}
