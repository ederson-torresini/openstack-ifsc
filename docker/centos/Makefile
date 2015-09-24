FILE="/tmp/centos.img"

all: compile clean-pre install clean-post

compile:
	docker build -t centos:minimal .
	docker save -o ${FILE} centos:minimal

clean-pre:
	glance image-delete centos:minimal

install:
	glance image-create --name "centos:minimal" --disk-format raw --container-format docker --owner admin --min-disk 1 --min-ram 512 --file ${FILE} --is-public True --progress

clean-post:
	rm -f ${FILE}
