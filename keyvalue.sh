#/bin/sh
line='id:2377893499379884 ip:127.0.0.1 port:443 ak:sdjh sk:jsdhfhjdsh bucket:men object:zzzz.vhd size:10240 encryp:1'

#line=`cat image.cfg|grep 2377893499379884`

function map_get()
{
    dict=$1
    key=$2
    default_value=$3
    pair=`echo $dict | awk '{for(i=1;i<=NF;i++){print $i;}}' | grep "$key"`
    realkey=`echo $pair|awk -F: '{print $1}'`
    value=`echo $pair|awk -F: '{print $2}'`

    if [ "$key"x != "$realkey"x ] || [ ""x == "$value"x ]; then
        echo $default_value
        return 0
    fi

    echo $value
    return 0
}

value=`map_get "$line" "encryp" "abc"`
echo $value

value=`map_get "$line" "ip"`
echo $value

