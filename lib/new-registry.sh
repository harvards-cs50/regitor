keys=(name port cert auth username password)
for i in $(seq ${#keys[@]}); do values[$i-1]=""; done

reqReader[0]() { 
    while [[ ! "${values[0]}" =~ [a-zA-Z0-9] || -z "${values[0]}" || -d "${values[0]}" ]];
    do
        read -p "Name of new Registry : " values[0]; 
    done
}

reqReader[1]() { 
    while [[ ! ${values[1]} =~ [0-9]:[0-9]+$ || -z "${values[1]}" ]];
    do 
        read -p "Enter port on which this registry is to be run : " values[1]; 
    done
}

reqReader[2]() {
    while [[ ! "(0 1)" =~ "${values[2]}" || -z "${values[2]}" ]];
    do
        read -p "Get certificate of this registry ? (y/n) : " values[2]
        yn=${values[2],,}
        
        if [[ "$yn" == "y" || "$yn" == "ye" || "$yn" == "yes" ]]; then values[2]=1; break;
        elif [[ "$yn" == "n" || "$yn" == "no" ]]; then values[2]=0; break;
        else continue; fi
    done
}

reqReader[3]() {
    while [[ ! "(0 1)" =~ "${values[3]}" || -z "${values[3]}" ]];
    do
        read -p "Want to assign password to this registry ? (y/n) : " values[3]
        yn=${values[3],,}

        if [[ "$yn" == "y" || "$yn" == "ye" || "$yn" == "yes" ]]; then values[3]=1; break;
        elif [[ "$yn" == "n" || "$yn" == "no" ]]; then values[3]=0; break;
        else continue; fi
    done
}

reqReader[4]() {
    while [[ ${values[3]} == 1 && -z "${values[4]}" ]];
    do
        read -p "Enter username : " values[4]; 
    done
}

reqReader[5]() {
    while [[ ${values[3]} == 1 && -z "${values[5]}" ]];
    do
        read -p "Enter password : " values[5]; 
    done
}

args=($@) 
for i in "${!args[@]}"; do
    if [[ "${args[i]}" == "-i"  ]]; then 
        keys=("${keys[@]:${#args[@]}-i-1:${#keys[@]}}");
        values=("${values[@]:${#args[@]}-i-1:${#values[@]}}");
        values=("${args[@]:1:${#args[@]}}" "${values[@]}");
        echo ${keys[@]} ${values[@]}
    fi 
done

bash lib/filereader.sh ${keys[@]};
for i in $(seq ${#values[@]}); do "reqReader[$((i-1))]"; done

name=${values[0]}; port=${values[1]}; cert=${values[2]}; auth=${values[3]}; username=${values[4]}; password=${values[5]}

mkdir $name
touch $name/data.txt
echo -e "name => $name\nport => $port\ncert => $cert\nauth => $auth\nuser => $username\npass => $password" >> $name/data.txt

executor="
    docker run -d 
    -p $port 
    --restart=always 
    --name $name
"

if [[ "$cert" == "1" ]];then
    mkdir $name/certs
    echo "generateing a self signed certificate for run docker registry"

    mkdir -p $name/opt/docker/certs/ && openssl req \
    -newkey rsa:4096 -nodes -sha256 -keyout $name/certs/dockerRegistry.key \
    -x509 -days 3650 -out $name/certs/dockerRegistry.crt

    executor="
        $executor
        -v "$(pwd)"/$name/certs:/certs \
        -e REGISTRY_HTTP_TLS_CERTIFICATE=$name/certs/dockerRegistry.crt \
        -e REGISTRY_HTTP_TLS_KEY=$name/certs/dockerRegistry.key \"
    "
fi

if [[ "$auth" == "1" ]]; then
    mkdir $name/auth
    docker run --entrypoint htpasswd httpd:2 -Bbn $username $password > $name/auth/htpasswd

    executor="
        $executor
        -v "$(pwd)"/$name/certs:/certs \
        -e REGISTRY_HTTP_TLS_CERTIFICATE=$name/certs/domain.crt \
        -e REGISTRY_HTTP_TLS_KEY=$name/certs/domain.key \"
    "
fi

executor="
    $executor
    registry
"

echo $executor