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

# Related > 0.2
#del dict["jawOpen"]
#del dict["mouthLowerDown_R"]
#del dict["mouthLowerDown_L"]
#del dict["mouthShrugUpper"]
#del dict["mouthFunnel"]
#del dict["mouthClose"]

# Not Related < 0.2
del dict["jawForward"]
del dict["jawRight"]
del dict["jawLeft"]
del dict["mouthPucker"]
del dict["mouthShrugLower"]
del dict["mouthLeft"]
del dict["mouthRight"]
del dict["mouthUpperUp_L"]
del dict["mouthUpperUp_R"]
del dict["mouthRollUpper"]
del dict["mouthRollLower"]
del dict["mouthPress_L"]
del dict["mouthPress_R"]
del dict["mouthSmile_L"]
del dict["mouthSmile_R"]
del dict["mouthDimple_L"]
del dict["mouthDimple_R"]
del dict["mouthFrown_R"]
del dict["mouthFrown_L"]
del dict["mouthStretch_R"]
del dict["mouthStretch_L"]

fig, ax = plt.subplots()
for key in dict:
    ax.plot(dict[key], label=key)
legend = ax.legend(loc='upper right', shadow=True, fontsize='x-large')
plt.show()
