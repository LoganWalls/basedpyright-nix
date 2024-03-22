import os, sys, subprocess
from typing import TYPE_CHECKING

path = os.path.join(os.path.dirname(__file__), "bin/node")

if TYPE_CHECKING:
    call = subprocess.call
    run = subprocess.run
    Popen = subprocess.Popen

else:

    def call(args, **kwargs):
        return subprocess.call([path, *args], **kwargs)

    def run(args, **kwargs):
        return subprocess.run([path, *args], **kwargs)

    def Popen(args, **kwargs):
        return subprocess.Popen([path, *args], **kwargs)


def main() -> None:
    sys.exit(call(sys.argv[1:]))


if __name__ == "__main__":
    main()
