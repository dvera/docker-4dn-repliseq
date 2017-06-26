#!/usr/bin/env bash

usage() {
  echo "Usage: $(basename $0) [-w windowSize ] [genome.chrom.sizes]" 1>&2
  echo "" 1>&2
  exit 1
}

while getopts ":w:" opt; do
  case $opt in
  w)
    WINSIZE=$OPTARG
   ;;
  \?)
   echo "Invalid option: -$OPTARG" >&2
   usage
   ;;
  [?])
   usage
   ;;
  :)
   echo "Option -$OPTARG requires an argument." >&2
   echo "" >&2
   usage
   ;;
  esac
done

shift $((OPTIND-1))

if [ -z $WINSIZE ]; then
  WINSIZE=5000
fi

if [[ $# -eq 0 ]] ; then
  >&2 echo 'no files given, assuming file is genome.chrom.sizes in pwd'
  INPUT="genome.chrom.sizes"
else
  INPUT=$1
fi

# check if file exists
if [[ ! -f $INPUT ]]; then >&2 echo "file \"$INPUT\" not found"; exit 1; fi

OUTPUT="w${WINDOWSIZE}.bed"

bedtools makewindows -w $WINSIZE > $OUTPUT

echo $OUTPUT
