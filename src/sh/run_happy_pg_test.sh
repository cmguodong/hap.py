#!/bin/bash

# Simple performance and consistency test.
#

set +e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${DIR}/detect_vars.sh

echo "PG evaluation test for ${HCVERSION} from ${HCDIR}"

HG19=${DIR}/../../example/chr21.fa

TMP_OUT=`mktemp`

# run hap.py
${PYTHON} ${HCDIR}/hap.py \
			 	-l chr21 \
			 	${DIR}/../../example/happy/PG_NA12878_chr21.vcf.gz \
			 	${DIR}/../../example/happy/NA12878_chr21.vcf.gz \
			 	-f ${DIR}/../../example/happy/PG_Conf_chr21.bed.gz \
			 	-r ${DIR}/../../example/chr21.fa \
			 	-o ${TMP_OUT} \
			 	-X \
			 	--force-interactive

if [[ $? != 0 ]]; then
	echo "hap.py failed!"
	exit 1
fi

diff -I fileDate -I source_version ${TMP_OUT}.counts.json ${DIR}/../../example/happy/expected.counts.json
if [[ $? != 0 ]]; then
	echo "Counts differ!"
	exit 1
fi

diff -I fileDate -I source_version ${TMP_OUT}.summary.csv ${DIR}/../../example/happy/expected.summary.csv
if [[ $? != 0 ]]; then
	echo "Summary differs!"
	exit 1
fi

rm -f ${TMP_OUT}*
echo "PG quantification test SUCCEEDED!"
