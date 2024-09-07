wp:
	docker build -t jarijokinen/wordpress -f ./Dockerfile .

push:
	docker push jarijokinen/wordpress
