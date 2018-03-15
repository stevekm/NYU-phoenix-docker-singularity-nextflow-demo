SHELL:=/bin/bash
.PHONY: containers

# ~~~~~ SETUP PIPELINE ~~~~~ #
./nextflow:
	curl -fsSL get.nextflow.io | bash

install: ./nextflow

update: ./nextflow
	./nextflow self-update

containers:
	cd containers && make build

# fetch pre-built Singularity image file from repo
containers/demo1/stevekm_phoenix-demo_demo1-2018-03-15-98ab3fa47f3d.img:
	git checkout img containers/demo1/stevekm_phoenix-demo_demo1-2018-03-15-98ab3fa47f3d.img

image: containers/demo1/stevekm_phoenix-demo_demo1-2018-03-15-98ab3fa47f3d.img

# ~~~~~ RUN PIPELINE ~~~~~ #
run-l: install
	./nextflow run main.nf -profile local -with-dag flowchart.dot && \
	[ -f flowchart.dot ] && dot flowchart.dot -Tpng -o flowchart.png

run-p: install
	module load singularity/2.4.2 && module load jre/1.8 && \
	./nextflow run main.nf -profile phoenix -with-dag flowchart.dot && \
	[ -f flowchart.dot ] && dot flowchart.dot -Tpng -o flowchart.png

# ~~~~~ CLEANUP ~~~~~ #
clean-traces:
	rm -f trace*.txt.*

clean-logs:
	rm -f .nextflow.log.*

clean-reports:
	rm -f *.html.*

clean-flowcharts:
	rm -f *.dot.*

clean-output:
	[ -d output ] && mv output oldoutput && rm -rf oldoutput &

clean-work:
	[ -d work ] && mv work oldwork && rm -rf oldwork &

# deletes files from previous runs of the pipeline, keeps current results
clean: clean-logs clean-traces clean-reports clean-flowcharts

# deletes all pipeline output
clean-all: clean clean-output clean-work
	[ -d .nextflow ] && mv .nextflow .nextflowold && rm -rf .nextflowold &
	rm -f .nextflow.log
	rm -f *.png
	rm -f trace*.txt*
	rm -f *.html*
	rm -f *.dot

clean-image:
	[ -f containers/demo1/stevekm_phoenix-demo_demo1-2018-03-15-98ab3fa47f3d.img ] && rm -f containers/demo1/stevekm_phoenix-demo_demo1-2018-03-15-98ab3fa47f3d.img || :
