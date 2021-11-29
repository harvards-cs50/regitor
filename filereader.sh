# filename = details.txt
# ${@:2} = keys



if [[ ! -z $(tail -1c details.txt) ]]; then echo "" >> details.txt; fi

splitors=(":" "=" ">")

keys=($@)
for i in $(seq ${#keys[@]}); do values[$i-1]=""; done
while read -r line; do
    for splitor in ${splitors[@]}
    do
        key=$( echo "$line" | cut -d "$splitor" -f 1 )
        
        if [ ${#key} -lt ${#line} ];then
        key="${key// /}"
            for e in $(seq ${#keys[@]})
            do
                if [[ "${key,,}" == "${keys[$e-1],,}" && ${values[$e-1]} == "" ]]; then
                    value=$( echo "$line" | cut -d "$splitor" -f 2 );
                    value="${value// /}";
                    values[$e-1]=$value;
                    break;
                fi
            done
        fi
    done
done < details.txt

echo ${values[@]}
