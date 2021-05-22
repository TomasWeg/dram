package main

var Errors = defaultErrorRegistry()

func defaultErrorRegistry() *errorRegistry {
	return &errorRegistry{
		CannotOpen:         0x52,
		InvalidPath:        0x55,
		CannotClose:        0x56,
		AlreadyOpen:        0x57,
		TableAlreadyExists: 0x58,
		TableNotFound:      0x59,
		IndexAlreadyExists: 0x60,
		IndexNotFound:      0x61,
		EntityNotFound:     0x62,
	}
}

type errorRegistry struct {
	CannotOpen         byte
	InvalidPath        byte
	CannotClose        byte
	AlreadyOpen        byte
	TableAlreadyExists byte
	TableNotFound      byte
	IndexAlreadyExists byte
	IndexNotFound      byte
	EntityNotFound     byte
}
