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
