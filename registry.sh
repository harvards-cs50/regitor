cpath=$(dirname "$0")

options=(
    -nr
)

commands=(
    'bash $cpath/lib/new-registry.sh'
)

for i in ${!options[@]};
do
    if [[ "$1" == "${options[i]}" ]]; then eval ${commands[i]}; fi
done