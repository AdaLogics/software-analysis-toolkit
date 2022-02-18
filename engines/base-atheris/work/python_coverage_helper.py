import os
import sys
import shutil

from coverage.data import CoverageData
from coverage import coverage

from glob import glob


# Finds all *.toc files in ./workpath and reads these files in order to
# identify Python files associated with a pyinstaller packaged executable.
# Copies all of the Python files to a temporary directory (/medio) following
# the original directory structure.
def get_all_files_from_toc(toc_file, file_path_set):
    with open(toc_file, "rb") as tf:
        for line in tf:
            try:
                line = line.decode()
            except:
                continue
            if ".py" in line:
                split_line = line.split(" ")
                for word in split_line:
                    word = word.replace("'", "").replace(",","").replace("\n","")
                    if ".py" in word:
                        if os.path.isfile(word):
                            #print(word)
                            file_path_set.add(word)
                            #print("Is a file")

def create_file_structure_from_tocs(work_path, proxy_path):
    file_path_set = set()
    for d in os.listdir(work_path):
        full_path = os.path.join(work_path, d)
        if not os.path.isdir(full_path):
            continue

        # We have a directory
        for d2 in os.listdir(full_path):
            if not ".toc" in d2:
                continue
            full_toc_file = os.path.join(full_path, d2)
            get_all_files_from_toc(full_toc_file, file_path_set)
            #print(d2)
    #exit(0)
    #print(line, end="")

    for f2 in file_path_set:
        if f2[0] == '/':
            relative_src = f2[1:]
        else:
            relative_src = f2

        dst_path = os.path.join(proxy_path, relative_src)
        os.makedirs(os.path.dirname(dst_path), exist_ok=True)
        shutil.copy(f2, dst_path)
        if "atheris" in dst_path or "work" in dst_path:
            print(dst_path)

def translate_lines(cov_data, new_cov_data, all_file_paths):
    for orig_l in cov_data.measured_files():
        l = orig_l
        print(l)
        if l.startswith("/tmp/_MEI"):
            # notice "/a/b" when split like below is made into the list
            # ['','a','b']
            l = "/".join(l.split("/")[3:])
            print("l: %s"%(l))

        # Check if this file exists in our file paths:
        for f2 in all_file_paths:
            if f2.endswith(l):
                print("Found matching: %s"%(f2))
                new_cov_data.add_lines({f2 : cov_data.lines(orig_l)})

        #new_file = l.replace("/tmp/_MEIgbWBno/", "/work/")
        #if os.path.isfile(new_file):
           # print("Got a new file: %s"%(new_file))
            #new_cov_data.add_lines({new_file : cov_data.lines(l)})


def translate_coverage(all_file_paths):
    data = CoverageData(".coverage")
    data2 = CoverageData(".new_coverage")
    data.read()
    translate_lines(data, data2, all_file_paths)
    data2.write()

if len(sys.argv) < 2:
    print("Error. Please give command")
    sys.exit(0)


if sys.argv[1] == 'extract':
    print("Extracting the ToC")
    create_file_structure_from_tocs(sys.argv[2], sys.argv[3])

if sys.argv[1] == 'translate':
    print("Translating the coverage")
    files_path = sys.argv[2]
    all_file_paths = list()
    for r,d,f in os.walk(files_path):
        #print("r: %s -- d: %s --- f: %s"%(r,d,f))
        for f2 in f:
            abs_path = os.path.abspath(os.path.join(r, f2))
            all_file_paths.append(abs_path)
    #for f3 in all_file_paths:
    #    print(f3)
    print("Done with path walk")
    translate_coverage(all_file_paths)
