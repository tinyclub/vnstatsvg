# Support hosts without http server
    
Add protocol features to allow to read traffic XML data via the other
protocols.

a 'file' protocol is added to support all of the other protocols, three methods
can be used:

## Firstly

a daemon can be called to get the XML traffic data from the other
services directly and forward the XML output to proxy.sh.

    <iface>
      <name>eth0</name>
      <description>Local Host</description>
      <host>localhost</host>
      <protocol>file</protocol>
      <dump_tool>/usr/lib/cgi-bin/vnstat.sh</dump_tool>
    </iface>

## Second

A daemon can be run periodically to collect the XML data and put them into a
directory. Another program can be called by proxy.sh to output the data.

It is very similar to above method, but need extra 'dump_tool' here may have not
need to access remote host while getting data, but get local data directly for
a daemon have collected data for us.

The following method is similar but works better for it can reuse local
interfaces. So, thie method is not recommendded, see below one.

## Third

The data from the other servers can be stored to the same directory of local
data but map to different local 'virtual' interfaces.

For example, download the remote test.org data to local /var/lib/vnstat/eth5,
and then, we can get the output with localhost directly. Or, even you can
use something like /var/lib/vnstat/test.org-eth0, for example:

    $ cp /var/lib/vnstat/eth0 /var/lib/vnstat/test.org-eth0
    $ vnstat -i test.org-eth0

Let's write a simple daemon below, use ssh protocol (with public key) as an example:

    # collect-data.sh
    hosts="a b c d e"
    ifaces="eth0 eth1"
    while :;
    do
    	for h in $hosts
    	do
                    for i in $ifaces
                    do
                        scp ${h}:/var/lib/vnstat/${i} /var/lib/vnstat/${h}-${i}
                    done
    	done
    	sleep 5
    done

Based on the above shell script, you can write a simple cron script.

Then, we can add the following lines into sidebar.xml:

    <iface>
       <name>a-eth0</name>
       <description>Remote Host</description>
       <host>localhost</host>
       <protocol>http</protocol>
       <dump_tool>/cgi-bin/vnstat.sh</dump_tool>
    </iface>
    <iface>
       <name>b-eth0</name>
       <description>Remote Host</description>
       <host>localhost</host>
       <protocol>http</protocol>
       <dump_tool>/cgi-bin/vnstat.sh</dump_tool>
    </iface>
    <iface>
       <name>c-eth0</name>
       <description>Remote Host</description>
       <host>localhost</host>
       <protocol>http</protocol>
       <dump_tool>/cgi-bin/vnstat.sh</dump_tool>
    </iface>
    <iface>
       <name>d-eth0</name>
       <description>Remote Host</description>
       <host>localhost</host>
       <protocol>http</protocol>
       <dump_tool>/cgi-bin/vnstat.sh</dump_tool>
    </iface>
    <iface>
       <name>e-eth0</name>
       <description>Remote Host</description>
       <host>localhost</host>
       <protocol>http</protocol>
       <dump_tool>/cgi-bin/vnstat.sh</dump_tool>
    </iface>

Note: To get the second data from remote host, we must collect second(s) data
with collect-data.sh:

    # collect-data.sh
    hosts="a b c d e"
    ifaces="eth0 eth1"
    while :;
    do
    	for h in hosts
    	do
                    for i in $ifaces
                    do
                        scp ${h}:/var/lib/vnstat/${i} /var/lib/vnstat/${h}-${i}
                        scp ${h}:/proc/net/dev > /var/lib/vnstat/${h}-${i}-second
                    done
    	done
    	sleep 5
    done
