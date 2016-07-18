#!/bin/bash
#this is a script that get resources of cpu
#20151023

get_total_cpu_time()
{
	i=0
	a[$i]="0"
	cpu_sum_old=0
	flag=1
	while [ $flag == 1 ]
	do
		i=$[$i + 1]
		j=$[$i + 1]
		a[$i]=`cat /proc/stat | grep cpu | awk 'NR==1' | awk '{print $'$j'}'`
		if [ "${a[$i]}" != "" ]
		then
			cpu_sum_old=$[$cpu_sum_old + ${a[$i]}]
		else
			flag=0
		fi
	done
}

get_idel_cpu_time()
{
	cpu_idel_old=`cat /proc/stat | grep cpu | awk 'NR==1' | awk '{print $5}'`
}

get_total_cpu_time_new()
{
        i=0
        a[$i]="0"
        cpu_sum_new=0
        flag=1
        while [ $flag == 1 ]
        do
                i=$[$i + 1]
                j=$[$i + 1]
                a[$i]=`cat /proc/stat | grep cpu | awk 'NR==1' | awk '{print $'$j'}'`
                if [ "${a[$i]}" != "" ]
                then
                        cpu_sum_new=$[$cpu_sum_new + ${a[$i]}]
                else
                        flag=0
                fi
        done
}

get_idel_cpu_time_new()
{
        cpu_idel_new=`cat /proc/stat | grep cpu | awk 'NR==1' | awk '{print $5}'`
}
while (true)
do
get_total_cpu_time
get_idel_cpu_time
sleep 1
get_total_cpu_time_new
get_idel_cpu_time_new

idel_diff=$[$cpu_idel_new - $cpu_idel_old]
total_diff=$[$cpu_sum_new - $cpu_sum_old]
#echo $idel_diff
#echo $total_diff
#midd=$[$total_diff-$idel_diff]
percent=$(awk 'BEGIN{printf "%2.2f%%",'$idel_diff' * 100.0 / '$total_diff'}')
echo $percent
done
