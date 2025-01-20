# add_devbuild.py
from pathlib import Path
import subprocess
import sys

commit = subprocess.check_output(["git", "describe", "--always"],text=True).strip("\n")
version = f"GH3DX Nightly {commit}"

path = sys.argv[1]

f = open(path, "w")

f.write(f'gh3dx_version = "{version}"')

f.close()