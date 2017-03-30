c_zone=( QDC-D QDC-E )

for zone in "${dc_zone[@]}"

do

python import2.py $zone > hosts.txt

  # echo $zone
# export zone

cat hosts.txt| tr '\n' ',' > hosts1.txt
{ printf "nodegroups:\n nodes: L@" ; cat hosts1.txt ; } > /etc/salt/master.d/nodegroups.conf

salt -N nodes test.ping > output
grep -B 1 'True' output| sed 's/True//g'|sed 's/://g'|sed '/^\s*$/d' > good_hosts
cat hosts.txt | tr ' ' '\n' > hosts_list
comm -23 <( sort hosts_list|uniq ) <( sort good_hosts| uniq ) > hosts_bad_$zone

done

cat hosts_bad_* > all_bad_hosts
rm hosts_bad_*

 files=( output hosts.txt hosts1.txt )
 for i in "${files[@]}"
 do
     rm $i
 done
