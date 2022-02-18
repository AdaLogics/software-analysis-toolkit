#!/bin/bash -eu
#FUZZ=$1
#cd $WORK

set -x

#git clone --depth 1 --branch rel_1_3 https://github.com/sqlalchemy/sqlalchemy
#cd sqlalchemy
#python3 setup.py install
#cd ../


pip3 install 2to3 soupsieve html5lib lxml 
pip3 install bzr+lp:beautifulsoup

STORAGE=/medio
ZIPFILES=zipfiles
# Wrap in pyinstaller
#rm -rf ./workpath
#rm -rf ./coverage-dist-test
#rm -rf ./valid-fuzzer
#rm -rf ./valid-workpath
#rm -rf ./valid-distpath
#mkdir workpath coverage-dist-test valid-fuzzer valid-workpath valid-distpath

FUZZWD=fuzzworkdir
BASE=$PWD
mkdir $FUZZWD

rm -rf $BASE/$ZIPFILES
mkdir $BASE/$ZIPFILES

#for fuzz in fuzz_pyyaml fuzz_reader; do
for fuzz in bs4_fuzzer; do
  fuzzer_name=$fuzz.py

  WORKDIR=workdir_$fuzzer_name
  mkdir $FUZZWD/$WORKDIR
  # First compile a valid fuzzer
  FUZZD1=$BASE/$FUZZWD/$WORKDIR/distpath
  FUZZD2=$BASE/$FUZZWD/$WORKDIR/workpath
  FUZZD3=$BASE/$FUZZWD/$WORKDIR/cov_distpath
  FUZZD4=$BASE/$FUZZWD/$WORKDIR/cov_workpath
  pyinstaller --distpath=$FUZZD1 --workpath=$FUZZD2 --onefile --name $fuzzer_name.pkg $fuzzer_name

  # Run the fuzzer for a short period of time
  cd $FUZZD1
  mkdir corpus
  ./$fuzzer_name.pkg ./corpus/ -max_total_time=20 || true
  cd $BASE

  # Compile a coverage-wrapper fuzzer
  cat cov_wrapper.py $fuzzer_name > tmp_fuzzer_v.py
  mv tmp_fuzzer_v.py $fuzzer_name
  pyinstaller --distpath=$FUZZD3 --workpath=$FUZZD4 --onefile --name $fuzzer_name.pkg $fuzzer_name

  # Extract the relevant files from the pyinstalled binary, zip these files.
  rm -rf /medio/
  python3 ./python_coverage_helper.py extract $FUZZD2 "/medio"
  zip -r fuzzer_source_codes.zip /medio
  mv fuzzer_source_codes.zip $BASE/$ZIPFILES/$fuzzer_name.zip
done



##### Coverage runtime part
# Inputs:
# - fuzzer names
# - fuzzer coverage builds
# - fuzzer corpus
# - fuzzer source codes
# Output:
# - HTML report
cd $BASE
MERGED_FILES=merged
rm -rf $BASE/$MERGED_FILES
mkdir $BASE/$MERGED_FILES
mkdir $BASE/$MERGED_FILES/medio

COVDIR=$BASE/coverage_dir
mkdir $COVDIR
#for fuzz in fuzz_pyyaml fuzz_reader; do
for fuzz in bs4_fuzzer; do
  cd $BASE
  fuzzer_name=$fuzz.py
  WORKDIR=workdir_$fuzzer_name
  # First compile a valid fuzzer
  FUZZD1=$BASE/$FUZZWD/$WORKDIR/distpath
  FUZZD2=$BASE/$FUZZWD/$WORKDIR/workpath
  FUZZD3=$BASE/$FUZZWD/$WORKDIR/cov_distpath
  FUZZD4=$BASE/$FUZZWD/$WORKDIR/cov_workpath

  # Unzip the dependency files and synchronise with the rest
  cd $BASE/$ZIPFILES
  unzip $fuzzer_name.zip
  rsync -r ./medio $BASE/$MERGED_FILES
  rm -rf ./medio
  cd $BASE

  # Run the coverage analysis on the fuzzer with the given corpus
  cd $FUZZD3
  cp -rf $FUZZD1/corpus ./corpus
  ./$fuzzer_name.pkg ./corpus -atheris_runs=$(ls -la ./corpus | wc -l) || true

  # Translate the file paths in the coverage.py database to be similar
  # to the files as they exist in the base runner.
  echo ""
  python3 $BASE/python_coverage_helper.py translate $BASE/$MERGED_FILES/
  cp .new_coverage $COVDIR/.coverage_$fuzz
done

# Combine all of the coverage files
cd $COVDIR
coverage combine .coverage_*
coverage html
