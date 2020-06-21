import numpy as np
import matplotlib.pyplot as plt

X, Y, Z, V, Yv, Zv, S = [], [], [], [], [], [], []

for line in open('table.txt', 'r'):
 	values = [float(s) for s in line.split()]
 	Y.append(values[0])
 	X.append(values[1])
 	Z.append(values[2])
 	V.append(values[3])

for line in open('stddev.txt', 'r'):
 	valuesstd = [float(s) for s in line.split()]
 	S.append(valuesstd[0])

countchangesy=1; countchangest=1; countchangesv = 1; lenghtv=0;

for i in range (1, len(V)):
	if V[i] < V[i-1]:
		countchangest += 1

lenghtt=int(len(V)/countchangest)

for i in range (0, len(V)):
		if V[i] > V[i-1]:
			countchangesv += 1
		if V[i] < V[i-1]: 
			countchangesv=1

lenghtv = int(lenghtt/countchangesv)

for i in range (0, lenghtt):
	if X[i] > X[i-1]:
		countchangesy += 1

lenghty=int(len(X)/countchangesy)

for i in range (0, lenghtv):
	fig = plt.figure(figsize=(15,10))
	fig = plt.gcf()
	for j in range (0, countchangesv):
		Yv=[]; Zv=[]; Sv=[];
		for k in range (0, countchangest):
			Zv.append (int(Z[i+j+lenghtv+k*lenghtt]))
			Yv.append (Y[i+j*lenghtv+k*lenghtt])
			Sv.append (S[i+j*lenghtv+k*lenghtt])

		if j==0:
			plt.plot(Zv, Yv, label = "External lace")
			plt.errorbar(Zv, Yv, Sv, linestyle='None', marker='^')
		if j==1:
			plt.plot(Zv, Yv, label = "Middle lace")
			plt.errorbar(Zv, Yv, Sv, linestyle='None', marker='^')
		if j==2:
			plt.plot(Zv, Yv, label = "Inner lace")
			plt.errorbar(Zv, Yv, Sv, linestyle='None', marker='^')
		if j==3:
			plt.plot(Zv, Yv, label = "External and Middle laces")
			plt.errorbar(Zv, Yv, Sv, linestyle='None', marker='^')
		if j==4:
			plt.plot(Zv, Yv, label = "External and Inner laces")
			plt.errorbar(Zv, Yv, Sv, linestyle='None', marker='^')
		if j==5:
			plt.plot(Zv, Yv, label = "Middle and Inner laces")
			plt.errorbar(Zv, Yv, Sv, linestyle='None', marker='^')
		if j==6:
			plt.plot(Zv, Yv, label = "All 3 laces")
			plt.errorbar(Zv, Yv, Sv, linestyle='None', marker='^')

		plt.plot(Zv, Yv, 'o', color='black')

	plt.ylabel('Time (s)')
	plt.xlabel('Thread count')
	
	plt.title("Pragma For effect on different paralization scales in matrix multiplication with " + str(int(X[i])) + " size matrix")
	plt.legend()
	plt.draw()
	
	graphicfile = "tablegraphsize" + str(int(X[i])) + ".png"
	fig.savefig(graphicfile)