export SU2_RUN=$HOME/.local/bin/su2/bin/
# TODO: revisit ^ to be less redundant, once I understand what's just in `bin` in the zip archive, and not also in `bin/su2`
path=($SU2_RUN $path)
export PATH
pythonpath=($SU2_RUN $pythonpath)
export PYTHONPATH
