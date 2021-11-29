cpath=$(dirname "$0")

options=(
    -n
)

commands=(
    'bash $cpath/lib/new-registry.sh'
)

for i in ${!options[@]};
do
    if [[ "$1" == "${options[i]}" ]]; then eval ${commands[i]}; fi
done