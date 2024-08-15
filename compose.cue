services: {
	minio: {
		image: "quay.io/minio/minio"
		ports: [
			"127.0.0.1:9000:9000",
			"127.0.0.1:9001:9001",
		]
		environment: {
			MINIO_ROOT_USER: "adminuser",
			MINIO_ROOT_PASSWORD: "adminpassword",
		}
		command: "server /data --console-address :9001"
	}
}
