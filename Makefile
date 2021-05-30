postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=password -d postgres:12-alpine

rmpostgres:
	docker stop postgres12 && docker rm postgres12

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb --username=root --owner=root simple_bank

newpostgres: rmpostgres 
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=password -d postgres:12-alpine
	sleep 3
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank
	migrate -path db/migration/ -database "postgresql://root:password@localhost:5432/simple_bank?sslmode=disable" -verbose up  

migrateup:
	migrate -path db/migration/ -database "postgresql://root:password@localhost:5432/simple_bank?sslmode=disable" -verbose up  

migratedown:
	migrate -path db/migration/ -database "postgresql://root:password@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate

cleantest:
	go clean -testcache

test: cleantest
	go test -v -cover ./...

.PHONY: postgres rmpostgres createdb dropdb migrateup migratedown sqlc test cleantest
