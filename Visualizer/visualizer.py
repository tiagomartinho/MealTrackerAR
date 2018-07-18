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

# Not Related Chew
#del dict["mouthLowerDown_R"]
#del dict["mouthLowerDown_L"]

# Not Related Bite
#del dict["mouthClose"]
#del dict["mouthFrown_R"]
#del dict["mouthFrown_L"]

# Related Chew > 0.1
#del dict["mouthClose"]
#del dict["mouthFrown_R"]
#del dict["mouthFrown_L"]

# Not Related Common
del dict["mouthStretch_R"]
del dict["mouthStretch_L"]
del dict["jawForward"]
del dict["jawRight"]
del dict["jawLeft"]
del dict["mouthRollUpper"]
del dict["mouthRollLower"]
del dict["mouthFunnel"]
del dict["mouthShrugUpper"]
del dict["mouthShrugLower"]
del dict["mouthLeft"]
del dict["mouthRight"]
del dict["mouthUpperUp_L"]
del dict["mouthUpperUp_R"]
del dict["mouthPucker"]
del dict["mouthPress_L"]
del dict["mouthPress_R"]
del dict["mouthDimple_L"]
del dict["mouthDimple_R"]
del dict["mouthSmile_L"]
del dict["mouthSmile_R"]

fig, ax = plt.subplots()
for key in dict:
    ax.plot(dict[key], label=key)
legend = ax.legend(loc='upper right', shadow=True, fontsize='x-large')
plt.show()
