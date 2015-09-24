FILE="/tmp/debian.img"

all: compile clean-pre install clean-post

compile:
	docker build -t debian:minimal .
	docker save -o ${FILE} debian:minimal

clean-pre:
	glance image-delete debian:minimal

install:
	glance image-create --name "debian:minimal" --disk-format raw --container-format docker --owner admin --min-disk 1 --min-ram 512 --file ${FILE} --is-public True --progress

clean-post:
	rm -f ${FILE}
