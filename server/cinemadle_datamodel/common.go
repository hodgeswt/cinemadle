package cinemadle_datamodel

import "encoding/json"

func FromJson[T any](j string, o *T) error {
	return json.Unmarshal([]byte(j), o)
}
