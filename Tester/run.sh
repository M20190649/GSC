set -e

output=default
newnetwork=0 
newtrips=-1
systemusers=0
workingdir=$1
gui="ngui"
while [ "$1" != "" ]; do
    case $1 in
        -n)						newnetwork=1
                                ;;
        -tp)    				shift
								newtrips=$1
                                ;;
		-u)    					shift
								systemusers=$1
                                ;;
        -o)          			shift
								output=$1
                                ;;
		-g)						gui="gui"
								;;
    esac
    shift
done

echo "Regenerating network file"
if [ "$newnetwork" = "1" ]; then
	if [ -f $workingdir"/"Data.con.xml ]
	then
		netconvert --node-files=$workingdir"/"Data.nod.xml --edge-files=$workingdir"/"Data.edg.xml --connection-files=$workingdir"/"Data.con.xml --output-file=$workingdir"/"Data.net.xml --proj.utm
		echo "Adding connection"
		netconvert --sumo-net-file=$workingdir"/"Data.net.xml --connection-files=$workingdir"/"Data.con.xml --output-file=$workingdir"/"Data.net.xml
		echo "Adding traffic lights"
		netconvert --sumo-net-file=$workingdir"/"Data.net.xml --tllogic-files $workingdir"/"Data.tll.xml --output-file=$workingdir"/"Data.net.xml
	else
		netconvert --node-files=$workingdir"/"Data.nod.xml --edge-files=$workingdir"/"Data.edg.xml --output-file=$workingdir"/"Data.net.xml --proj.utm
	fi
fi

if [ "$newtrips" != "-1" ]; then

	echo "Generate new routes with "$newtrips"% trucks"
	python $workingdir"/"genTrips.py $workingdir $newtrips
	duarouter --net-file $workingdir"/"Data.net.xml --trip-files $workingdir"/"trips.xml --route-files $workingdir"/"Data.rou.xml --output-file $workingdir"/Data".rou.xml

else
	echo "Reusing routes"
fi

echo "<?xml version='1.0' encoding='iso-8859-1'?>
<configuration xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:noNamespaceSchemaLocation='http://sumo.sf.net/xsd/sumoConfiguration.xsd'>
    <input>
        <net-file value='Data.net.xml'/>
        <route-files value='Data.rou.alt.xml'/>
    </input>
    <time>
       <begin value='0'/>
    </time>
    <report>
        <no-step-log value='true'/>
    </report>
    <traci_server>
        <remote-port value='8813'/>
    </traci_server>
</configuration>" > $workingdir"/Data.sumocfg"

python $workingdir"/"simulate.py $workingdir $gui $systemusers $output
