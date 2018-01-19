import json
import math
import matplotlib.pyplot as plt
import glob
import os

def plot(file, plot_no):
	k = file.split('x')
	kp = k[1]
	ki = k[2]
	kd = k[3]

	data = json.load(open(file))['items']
	times = data[0]['items']
	heights = data[1]['items']
	thrusts = data[2]['items']
	velocities = data[3]['items']
	targets = data[4]['items']

	plt.figure(plot_no)

	plt.subplot(311)
	plt.plot(times, [0 for t in times], 'y', times, targets, 'r', times, heights, 'g')
	plt.ylabel('Altitude [m]')
	plt.title('kp=' + kp + ', ki=' + ki + ', kd=' + kd)

	plt.subplot(312)
	plt.plot(times, [0 for t in times], 'y', times, thrusts, 'g')
	plt.ylabel('Thrust [kN]')

	plt.subplot(313)
	plt.plot(times, [0 for t in times], 'y', times, velocities, 'g')
	plt.ylabel('Vertical speed [m/s]')

def plot_latest(files):
	latest_file = max(files, key=os.path.getctime)
	plot(latest_file, 1)

def plot_all(files):
	plot_no = 1
	for file in files:
		print(file)
		plot(file, plot_no)
		plot_no += 1

list_of_files = glob.glob('./*.json')

# plot_latest(list_of_files)
plot_all(list_of_files)
plt.show()