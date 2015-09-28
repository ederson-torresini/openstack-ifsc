FILE="/tmp/centos.img"
NAME="openstack-ifsc/centos:latest"

all: compile clean-pre install clean-post

compile:
	docker build -t ${NAME} .
	docker save -o ${FILE} ${NAME}

clean-pre:
	glance image-delete ${NAME}

install:
	glance image-create --name ${NAME} --disk-format raw --container-format docker --owner admin --min-disk 1 --min-ram 512 --file ${FILE} --is-public True --progress

clean-post:
	rm -f ${FILE}
