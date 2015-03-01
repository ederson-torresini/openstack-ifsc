all: compile clean install

compile:
	docker build -t centos:minimal .
	docker save -o /tmp/centos.img centos:minimal

clean:
	glance image-delete centos:minimal

install:
	glance image-create --name "centos:minimal" --disk-format raw --container-format docker --owner admin --min-disk 1 --min-ram 512 --file /tmp/centos.img --is-public True --progress

