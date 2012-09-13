import os, subprocess, sys
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import traci 
import GSC
sumoBinary = "sumo-gui"
PORT = 8813

#Run SUMO and TraCI
process = subprocess.Popen("%s -c %s" % (sumoBinary, sys.argv[1] + "/Data.sumocfg"), shell=True, stdout=sys.stdout)
traci.init(PORT)

step = 0
GSCvehIds["0"]

while step==0 or traci.simulation.getMinExpectedNumber() > 0:
	traci.simulationStep()
	

	if step in range(0,1):
		print GSC.TrafficLight.getNextGreen("Ju1", "Main1toJu1.-30_2", "Ju1toN1_0", 400000)
	
	for v in traci.vehicle.getIDList()
		if v in GSCvehIds
			traci.vehicle.setMaxSpeed(v,GSC.Vehivle.getRecommentedSpeed(v))

	step+=1

#Clean up
traci.close()
sys.stdout.flush()








