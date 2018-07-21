#!/bin/bash


function cpuinfo() {
    cpu_model=`cat /proc/cpuinfo|grep "model name"|head -1|awk -F: '{print $2}'`
    cpu_num=`cat /proc/cpuinfo|grep "core id"|grep "0"|uniq -c|awk '{print $1}'`
    cpu_cores=`cat /proc/cpuinfo|grep "processor"|wc -l`
    single_cores=`expr ${cpu_cores} / ${cpu_num}`

    printf "CPU: ${cpu_model} (${cpu_num}*${single_cores}Cores)\n"
}

function motherboard() {
    vendor=`dmidecode  -t 1 | grep "Manufacturer" | awk -F ":" '{print $2}' | sed 's/[ \t]*$//g' | sed 's/^[ \t]*//g'`
    model=`dmidecode  -t 1 | grep "Product" | awk -F ":" '{print $2}' | sed 's/[ \t]*$//g' | sed 's/^[ \t]*//g'`
    sn=`dmidecode  -t 1 | grep "Serial Number" | awk -F ":" '{print $2}' | sed 's/[ \t]*$//g' | sed 's/^[ \t]*//g'`
    printf "MotherBoard: ${vendor} ${model}(${sn})\n"
}

function meminfo() {
    mem_num=`dmidecode  -t 17 | grep "Memory Device" | wc -l`
    mem_size=`dmidecode -t 19 | grep "Range Size" | awk -F ":" '{print $2}' | sed 's/[ \t]*$//g' | sed 's/^[ \t]*//g'`
    mem_manu=""
    for((i=1;i<=$mem_num;i++));
    do
        mem_vendor=`dmidecode  -t 17 | grep "Manufacturer" | head -1 | tail -1 | awk -F ':' '{print $2}' | sed 's/[ \t]*$//g' | sed 's/^[ \t]*//g'`
        mem_type=`dmidecode  -t 17 | grep "Type:" | head -${i} | tail -1 | awk '{print $2}' | sed 's/[ \t]*$//g' | sed 's/^[ \t]*//g'`
        mem_speed=`dmidecode  -t 17 | grep "Speed" | head -${i} | tail -1 | awk -F ':' '{print $2}' | sed 's/[ \t]*$//g' | sed 's/^[ \t]*//g'`
        mem_manu=${mem_manu}${mem_vendor}" "${mem_type}" "${mem_speed}"/"
    done

    printf "Memory:${mem_size}(${mem_manu})\n"
}

function osinfo() {
    release=`cat /etc/redhat-release | awk '{print $1"_"$3}'`
    kname=`uname -s`
    nodename=`uname -n`
    kernel=`uname -r`
    bit=`uname -i`
    printf "OS_RELEASE: ${release}"_"${bit}\n"
    printf "OS_DETAIL: ${kname} ${nodename} ${kernel} ${bit}\n"
}

main() {
    cpuinfo
    motherboard
    meminfo
    osinfo
}


main
