package main

import (
	"context"
	"fmt"
	"os"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
	uri := "mongodb://127.0.0.1:27017"

	// Wait logic for entrypoint
	if len(os.Args) > 1 && os.Args[1] == "--ping" {
		ctx, cancel := context.WithTimeout(context.Background(), 1*time.Second)
		defer cancel()
		client, err := mongo.Connect(ctx, options.Client().ApplyURI(uri))
		if err == nil && client.Ping(ctx, nil) == nil {
			os.Exit(0)
		}
		os.Exit(1)
	}

	if len(os.Args) < 3 {
		fmt.Println("usage: mongo-init <user> <pass>")
		return
	}

	u, p := os.Args[1], os.Args[2]
	ctx := context.TODO()

	c, err := mongo.Connect(ctx, options.Client().ApplyURI(uri))
	if err != nil {
		fmt.Println("connect err")
		return
	}

	cmd := bson.D{
		{Key: "createUser", Value: u},
		{Key: "pwd", Value: p},
		{Key: "roles", Value: bson.A{bson.M{"role": "root", "db": "admin"}}},
	}

	if err := c.Database("admin").RunCommand(ctx, cmd).Err(); err != nil {
		fmt.Println("create user err:", err)
	}
	_ = c.Disconnect(ctx)
}
