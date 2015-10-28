FILE="/tmp/ubuntu.img"
NAME="openstack-ifsc/ubuntu:latest"

all: compile clean-pre install clean-post

compile:
	docker build -t ${NAME} .
	docker save -o ${FILE} ${NAME}

clean-pre:
	openstack image delete ${NAME}

install:
	openstack image create --disk-format raw --container-format docker --owner admin --min-disk 1 --min-ram 512 --file ${FILE} --public ${NAME}

clean-post:
	rm -f ${FILE}
