dc_zone=( QDC-D QDC-E )

for zone in "${dc_zone[@]}"

do

python import2.py $zone > hosts_zone.txt

  # echo $zone
# export zone

cat hosts_zone.txt| tr ' ' ',' > hosts1_zone.txt
{ printf "nodegroups:\n nodes: L@" ; cat hosts1_zone.txt ; } > /etc/salt/master.d/nodegroups.conf

salt -N nodes test.ping > output
grep -B 1 'True' output| sed 's/True//g'|sed 's/://g'|sed '/^\s*$/d' > good_hosts_$zone
cat hosts_zone.txt | tr ' ' '\n' > hosts_list_$zone
comm -23 <( sort hosts_list_$zone|uniq ) <( sort good_hosts_$zone| uniq ) > hosts_bad_$zone

done

cat hosts_bad_* >> all_bad_hosts
cat good_hosts_* >> all_good_hosts
cat hosts_list* >> all_hosts_list
rm hosts_bad_* hosts_list_* good_hosts_*

 files=( output hosts_zone.txt hosts1_zone.txt )
 for i in "${files[@]}"
 do
     rm $i
 done
