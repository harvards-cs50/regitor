# Funtion Calling
#   => place "-f" option before the name of function in cmd (command line)
#       => Eg. >>> registry -f new-registry [filename]  --- (filename <- optional)
#       =>     Note = First source this file to run it in this way


#file format
#   => Sequence not necessary
#   => Every pair of key-value should be in new line
#   => Seperators allows "=" and ">"
#         => key = value
#         => key > value
#   => Keys are required for according to functions
#         => new-registry
#              KEYS        Values
#              name     =  Give your custom name to the registry
#              port     =  Eg. 5000:5000 , 1234:5000 , etc
#              auth     =  0 or 1  => 0 = (no password  ; 1 means put password) to registry
#              username =  Username for auth login ; Not needed if auth is 0
#              password =  Password for auth login ; Not needed if auth is 0
#              cert     =  0 or 1  => 0 = (no certificate  ; 1 means put certificate) to registry
#

options=(
    -nr
)

filerun=(
    lib/new-registry
)

args=("$@")

for arg in $(seq ${#args[@]});
do
    if [[ "$1" == "registry" ]]; then
        if [[ "${args[arg-1]}" == "-f" ]]; then
            ${args[arg]} ${args[arg+1]}
        fi
    fi
done