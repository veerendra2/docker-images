package main

import (
	"context"
	"flag"
	"fmt"
	"os"
	"time"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func main() {
	uri := flag.String("uri", "mongodb://127.0.0.1:27017", "Mongo URI")
	user := flag.String("user", "admin", "Admin user")
	pass := flag.String("pass", "changeme!", "User pass")
	ping := flag.Bool("ping", false, "Ping server")

	flag.Parse()

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	client, err := mongo.Connect(ctx, options.Client().ApplyURI(*uri))
	if err != nil {
		fmt.Fprintln(os.Stderr, "connect:", err)
		os.Exit(1)
	}
	defer client.Disconnect(ctx)

	if *ping {
		if err := client.Ping(ctx, nil); err != nil {
			fmt.Fprintln(os.Stderr, "ping:", err)
			os.Exit(1)
		}
		os.Exit(0)
	}

	cmd := bson.D{
		{Key: "createUser", Value: *user},
		{Key: "pwd", Value: *pass},
		{Key: "roles", Value: bson.A{bson.M{"role": "root", "db": "admin"}}},
	}

	if err := client.Database("admin").RunCommand(ctx, cmd).Err(); err != nil {
		fmt.Fprintln(os.Stderr, "create user:", err)
		os.Exit(1)
	}
}
