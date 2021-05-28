package main

import "C"
import (
	"bytes"
	"fmt"
	"strings"
	"unsafe"

	"github.com/genjidb/genji"
	"github.com/vmihailenco/msgpack/v5"
)

var database *genji.DB

func main() {}

//export OpenDatabase
func OpenDatabase(path *C.char) byte {

	if database != nil {
		return Errors.AlreadyOpen
	}

	databasePath := C.GoString(path)

	var err error
	database, err = genji.Open(databasePath)
	if err != nil {
		return Errors.InvalidPath
	}

	return 0x00
}

//export CreateTable
func CreateTable(tableNamePtr *C.char) byte {
	tableName := C.GoString(tableNamePtr)

	err := database.Exec(fmt.Sprint("CREATE TABLE ", tableName))
	if err != nil {
		return Errors.TableAlreadyExists
	}

	return 0x00
}

//export DropTable
func DropTable(tableNamePtr *C.char) byte {
	tableName := C.GoString(tableNamePtr)
	err := database.Exec(fmt.Sprint("DROP TABLE ", tableName))
	if err != nil {
		return Errors.TableNotFound
	}

	return 0x00
}

//export CreateIndex
func CreateIndex(indexNamePtr *C.char, tableNamePtr *C.char, fieldPtr *C.char, isUniquePtr *C.char) byte {
	indexName := C.GoString(indexNamePtr)
	tableName := C.GoString(tableNamePtr)
	field := C.GoString(fieldPtr)
	isUnique := *isUniquePtr != 0
	var query string

	if isUnique {
		query = fmt.Sprint("CREATE UNIQUE INDEX ", indexName, " ON ", tableName, "(", field, ")")
	} else {
		query = fmt.Sprint("CREATE INDEX ", indexName, " ON ", tableName, "(", field, ")")
	}

	fmt.Printf("Query: %v\n", query)

	err := database.Exec(query)
	if err != nil {
		return Errors.IndexAlreadyExists
	}

	return 0x00
}

//export Reindex
func Reindex() byte {
	database.Exec("REINDEX;")
	return 0x00
}

//export DropIndex
func DropIndex(indexNamePtr *C.char) byte {
	indexName := C.GoString(indexNamePtr)
	err := database.Exec(fmt.Sprint("DROP INDEX ", indexName))
	if err != nil {
		return Errors.IndexNotFound
	}

	return 0x00
}

//export Insert
func Insert(tableNamePtr *C.char, buffPtr *C.uchar, data_length C.int) byte {
	tableName := C.GoString(tableNamePtr)
	buffer := C.GoBytes(unsafe.Pointer(buffPtr), data_length)

	decoder := msgpack.NewDecoder(bytes.NewBuffer(buffer))
	data, _ := decoder.DecodeMap()

	// Create query
	query := fmt.Sprint("INSERT INTO ", tableName, " VALUES ?")

	// Execute insert
	err := database.Exec(query, &data)

	if err != nil {
		return Errors.TableNotFound
	}

	return 0x00
}

//export Delete
func Delete(tableNamePtr *C.char, entityIdPtr *C.char) byte {
	tableName := C.GoString(tableNamePtr)
	entityId := C.GoString(entityIdPtr)

	query := fmt.Sprint("DELETE FROM ", tableName, " WHERE id = ", entityId)

	err := database.Exec(query)

	if err != nil {
		if strings.Contains(err.Error(), "table not found") {
			return Errors.TableNotFound
		} else {
			return Errors.EntityNotFound
		}
	}

	return 0x00
}

//export Update
func Update(tableNamePtr *C.char, entityIdPtr *C.char, buffPtr *C.uchar, data_length C.int) byte {
	tableName := C.GoString(tableNamePtr)
	entityId := C.GoString(entityIdPtr)
	buffer := C.GoBytes(unsafe.Pointer(buffPtr), data_length)

	decoder := msgpack.NewDecoder(bytes.NewBuffer(buffer))
	data, _ := decoder.DecodeMap()

	println("Data decoded")

	var updateStmt []string

	for k, v := range data {
		updateStmt = append(updateStmt, fmt.Sprint(k, " = ", v))
	}

	// Create query
	query := fmt.Sprint("UPDATE ", tableName, " SET ", strings.Join(updateStmt, ","), " WHERE id = ", entityId)

	fmt.Printf("Query to execute: %v\n", query)

	err := database.Exec(query)
	if err != nil {
		fmt.Printf("Error updating entity: %v\n", err)
		return Errors.EntityNotFound
	}

	return 0x00
}

//export Query
// func Query(tableNamePtr *C.char, queryPtr *C.char) *C.uchar {
// 	return 0x00
// }

//export Close
func Close() byte {
	err := database.Close()
	if err == nil {
		return 0x00
	}

	return Errors.CannotClose
}
