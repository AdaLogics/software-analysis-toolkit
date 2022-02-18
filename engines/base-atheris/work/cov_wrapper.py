#!/usr/bin/python3

# Copyright 2022 Ada Logics ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###### Coverage stub
import atexit
import coverage
cov = coverage.coverage(data_file='.coverage', cover_pylib=True)
cov.start()
# Register an exist handler that will print coverage
def exit_handler():
    cov.stop()
    cov.save()
atexit.register(exit_handler)
####### End of coverage stub
