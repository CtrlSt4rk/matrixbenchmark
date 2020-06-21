import numpy as np
import matplotlib.pyplot as plt

X, Y, Z, V, Xaux, Yaux, S = [], [], [], [], [], [], []
for line in open('table.txt', 'r'):
 	values = [float(s) for s in line.split()]
 	Y.append(values[0])
 	X.append(values[1])
 	Z.append(values[2])
 	V.append(values[3])

for line in open('stddev.txt', 'r'):
 	valuesstd = [float(s) for s in line.split()]
 	S.append(valuesstd[0])

countchangesv = 1; countchangest = 1; countchangesvaux = 1;
zlenght=0

for i in range (1, len(Z)):
	if Z[i] < Z[i-1]:
		countchangest += 1

for t in range (0, countchangest):
	currentthreads = int(Z[zlenght])
	sizenamet = int(len(Z)/countchangest)

	for i in range (0, len(V)):
		if V[i] > V[i-1]:
			countchangesvaux += 1
		if V[i] < V[i-1]: 
			countchangesv=countchangesvaux
			countchangesvaux=1

	sizenamev = int(int(len(V)/countchangest)/countchangesv)
	
	tillnowv=0

	fig = plt.figure(figsize=(15,10))
	fig = plt.gcf()

	for i in range (1, countchangesv+1):	

		if (tillnowv==0):
			tillnowv+=int(int(len(V)/countchangest)*t)
			sizenamev+=int(int(len(V)/countchangest)*t)
		
		xauxlabel = "Xaux"+str(i)
		yauxlabel = "Yaux"+str(i)
		xauxlabel = X[int(tillnowv):int(sizenamev)]
		yauxlabel = Y[int(tillnowv):int(sizenamev)]
		sauxlabel = S[int(tillnowv):int(sizenamev)]

		tillnowv+=int(int(len(V)/countchangest)/countchangesv) #tillnow = menor valor do intervalo
		sizenamev+=int(int(len(V)/countchangest)/countchangesv) #sizename = maior valor do intervalo
	
		if i==1:
			plt.plot(xauxlabel, yauxlabel, label = "External lace")
			plt.errorbar(xauxlabel, yauxlabel, sauxlabel, linestyle='None', marker='^')
		if i==2:
			plt.plot(xauxlabel, yauxlabel, label = "Middle lace")
			plt.errorbar(xauxlabel, yauxlabel, sauxlabel, linestyle='None', marker='^')
		if i==3:
			plt.plot(xauxlabel, yauxlabel, label = "Inner lace")
			plt.errorbar(xauxlabel, yauxlabel, sauxlabel, linestyle='None', marker='^')
		if i==4:
			plt.plot(xauxlabel, yauxlabel, label = "External and Middle laces")
			plt.errorbar(xauxlabel, yauxlabel, sauxlabel, linestyle='None', marker='^')
		if i==5:
			plt.plot(xauxlabel, yauxlabel, label = "External and Inner laces")
			plt.errorbar(xauxlabel, yauxlabel, sauxlabel, linestyle='None', marker='^')
		if i==6:
			plt.plot(xauxlabel, yauxlabel, label = "Middle and Inner laces")
			plt.errorbar(xauxlabel, yauxlabel, sauxlabel, linestyle='None', marker='^')
		if i==7:
			plt.plot(xauxlabel, yauxlabel, label = "All 3 laces")
			plt.errorbar(xauxlabel, yauxlabel, sauxlabel, linestyle='None', marker='^')

		plt.plot(xauxlabel, yauxlabel, 'o', color='black')

	plt.ylabel('Time (s)')
	plt.xlabel('Matrix Size (n x n)')

	plt.title("Pragma For effect on different paralization scales in matrix multiplication with " + str(currentthreads) + " threads")
	plt.legend()
	plt.draw()

	graphicfile = "tablegraph" + str(countchangest - t) + ".png"
	fig.savefig(graphicfile)
	zlenght += sizenamet