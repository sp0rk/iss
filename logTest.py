import json
import numpy as np
import math
import matplotlib.pyplot as plt
import glob
import os

list_of_files = glob.glob('./*.json') # * means all if need specific format then *.csv
latest_file = max(list_of_files, key=os.path.getctime)
print(latest_file)

k = latest_file.split('x')
kp = k[1]
ki = k[2]
kd = k[3]

data = json.load(open(latest_file))['items']
times = data[0]['items']
heights = data[1]['items']
thrusts = data[2]['items']
velocities = data[3]['items']
targets = data[4]['items']

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

plt.show()
