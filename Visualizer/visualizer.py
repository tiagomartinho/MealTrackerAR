import matplotlib.pyplot as plt
from matplotlib.pyplot import plot, ion, show
import glob

dict = {}
files = glob.glob("./*.csv")
for file in files:
    dataFile = open(file)
    for lineNum, line in enumerate(dataFile):
        lineData = line.split(",")
        key = lineData[0]
        value = [float(lineData[1])]
        dict[key] = dict.get(key, [0]) + value
    dataFile.close()

# Related Common
#del dict["jawOpen"]

# Related Bite > 0.1
del dict["mouthLowerDown_R"]
del dict["mouthLowerDown_L"]
del dict["mouthStretch_R"]
del dict["mouthStretch_L"]

# Not Related Chew
#del dict["mouthLowerDown_R"]
#del dict["mouthLowerDown_L"]

# Not Related Bite
#del dict["mouthClose"]
#del dict["mouthFrown_R"]
#del dict["mouthFrown_L"]

# Related Chew > 0.1
#del dict["mouthClose"]

# Not Related Common
del dict["jawForward"] # Shows pattern with small values
del dict["mouthShrugLower"] # GOES TO ZERO IN BITE
del dict["mouthFunnel"]
# Have chew pattern
del dict["mouthFrown_R"]
del dict["mouthFrown_L"]
del dict["mouthPucker"]

# Noise
del dict["mouthShrugUpper"]
del dict["jawRight"]
del dict["jawLeft"]
del dict["mouthDimple_L"]
del dict["mouthDimple_R"]
del dict["mouthUpperUp_L"]
del dict["mouthUpperUp_R"]
del dict["mouthRollLower"]
del dict["mouthRollUpper"]
del dict["mouthLeft"]
del dict["mouthRight"]
del dict["mouthSmile_L"]
del dict["mouthSmile_R"]
del dict["mouthPress_L"]
del dict["mouthPress_R"]

fig, ax = plt.subplots()
for key in dict:
    ax.plot(dict[key], label=key)
legend = ax.legend(loc='upper right', shadow=True, fontsize='x-large')
plt.show()
