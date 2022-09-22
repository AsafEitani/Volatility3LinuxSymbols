 usage="$(basename "$0") [-h] [-v volatility dir] [-f dump path] [-k kernel version] [-d container distro] -- Volatility3 Linux kernel symbols creation tool

where:
    -h|--help    show this help text
    -v|--voldir  Volatility3 directory path
    -f|--file    memory dump path
   [-k|--kernel] memory dump kernel version (default: calculated from the dump with Volatility3 banner plugin)
   [-d|--distro] linux distribution for the symbol creation docker container (default:'ubuntu:focal')
"

DIST="ubuntu:focal"

while getopts 'hv:f:k:d:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    v|voldir) VOLDIR=$OPTARG
       ;;
    f|file) FILE=$OPTARG
       ;;
    k|kernel) VERSION=$OPTARG
       ;;
    d|distro) DIST=$OPTARG
       ;;
    :) printf "missing argument for %s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: %s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

if [ -z "$FILE" ] || [ -z "$VOLDIR" ]; then
        echo 'Missing -v or -f arguments' >&2
        echo "$usage" >&2
        exit 1
fi

if [[ -z "${VERSION}" ]]; then
    echo "Finding image linux kernel version..."
    VERSION=$(python3 ${VOLDIR}/vol.py -f ${FILE} banner | grep -Po "(?<=Linux version )(.+?) " | head -n1 | xargs)
    echo ""
    echo "Found linux version ${VERSION}"
fi

cp Dockerfile-template Dockerfile -f
sed -i 's|distribution|'"$DIST"'|' Dockerfile
echo "Building docker image to create profile JSON..."
docker build . -t profile_builder
rm Dockerfile
echo "Running docker container to create JSON..."
mkdir -p result
docker run -it --rm -v ${PWD}/result:/result -e VERSION=${VERSION} profile_builder
mv result/linux-image-${VERSION}.json ${VOLDIR}/volatility3/symbols/
rm -d result
echo "${VOLDIR}/volatility3/symbols/linux-image-${VERSION}.json was created successfully."
echo "Building profile JSON done!"
