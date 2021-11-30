cpath=$(dirname "$0")

tempdir=$(openssl rand -hex 12)
mkdir $tempdir

keys=(
    name 
    port 
    cert 
    auth 
    username 
    password
)

conditions=(
    '[[ "$value" =~ [a-zA-Z0-9]+$ && ! -d "$value" ]]'
    '[[ "$value" =~ [0-9]:[0-9]+$ ]]'
    '[[ "(y ye yes n no)" =~ "${value,,}" ]]'
    '[[ "(y ye yes n no)" =~ "${value,,}" ]]'
    '[[ "$value" =~ [a-zA-Z0-9]+$ && "$auth" == "yes" ]]'
    '[[ "$value" =~ [a-zA-Z0-9]+$ && "$auth" == "yes" ]]'
)

commands=(
    'mv $tempdir "$value";'
    'echo -e "docker run -d -p $port --restart=always --name $name \\" >> $name/executor.txt;'
    'if [[ "(y ye yes)" =~ ${value,,} ]]; then cert="yes"; bash $cpath/create_cert.sh $name; else cert="no"; fi'
    'if [[ "(y ye yes)" =~ ${value,,} ]]; then auth="yes"; else auth="no"; fi'
    ''
    'bash $cpath/create_auth.sh $name $username $password'
)


for i in ${!keys[@]}; 
do
    value=$(grep -x "${keys[i]}.*" details.txt | tail -1 | sed 's/ //g' | tr "=>" " " | cut -d " " -f 2)
    until eval ${conditions[i]}; do read -p "Enter ${keys[i]} : " value; done
    eval "${keys[i]}=$value"
    eval ${commands[i]}
done

echo -e "name = $name\nport = $port\ncert = $cert\nauth = $auth\nusername = $username\npassword = $password" >> $name/data.txt
echo -e "  registry" >> $name/executor.txt

executor=$(cat $name/executor.txt)
eval "$executor"