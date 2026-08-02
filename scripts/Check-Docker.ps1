$ErrorActionPreference = 'Stop'

docker version --format 'Docker client={{.Client.Version}} server={{.Server.Version}}'
docker run --rm espressif/idf:v6.0.2 bash -lc @'
idf.py --version
qemu-system-xtensa --version | head -n 1
qemu-system-riscv32 --version | head -n 1
'@
