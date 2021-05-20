package dramdb

import "github.com/genjidb/genji"
import "C"

func OpenDatabase(path string) error {
	db, err := genji.Open(path)
	if err != nil {
		return err
	}

	db.Close()

	return nil
}
