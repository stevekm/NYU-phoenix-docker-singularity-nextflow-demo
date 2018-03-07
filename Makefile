SHELL:=/bin/bash

# ~~~~~ SETUP PIPELINE ~~~~~ #
./nextflow:
	curl -fsSL get.nextflow.io | bash

install: ./nextflow


# ~~~~~ RUN PIPELINE ~~~~~ #
run: install
	./nextflow run main.nf  -with-dag flowchart.dot $(EP) && \
	[ -f flowchart.dot ] && dot flowchart.dot -Tpng -o flowchart.png

resume: install
	./nextflow run main.nf  -resume -with-dag flowchart.dot $(EP) && \
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

clean: clean-logs clean-traces clean-reports clean-flowcharts

clean-all: clean clean-output clean-work 
	[ -d .nextflow ] && mv .nextflow .nextflowold && rm -rf .nextflowold &
	rm -f .nextflow.log
	rm -f *.png
	rm -f trace*.txt*
	rm -f *.html*
