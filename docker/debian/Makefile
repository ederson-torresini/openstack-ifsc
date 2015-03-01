all: compile clean install

compile:
	docker build -t debian:minimal .
	docker save -o /tmp/debian.img debian:minimal

clean:
	glance image-delete debian:minimal

install:
	glance image-create --name "debian:minimal" --disk-format raw --container-format docker --owner admin --min-disk 1 --min-ram 512 --file /tmp/debian.img --is-public True --progress

