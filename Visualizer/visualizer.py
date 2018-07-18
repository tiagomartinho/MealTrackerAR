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

#del dict["Bite"]
#del dict["Chew"]

# Related Bite > 0.1
#del dict["jawOpen"]
#del dict["mouthLowerDown_R"]
#del dict["mouthLowerDown_L"]
#del dict["mouthStretch_R"]
#del dict["mouthStretch_L"]

# Not Related Bite
#del dict["mouthFrown_R"]
#del dict["mouthFrown_L"]
#del dict["mouthPucker"]

# Related Chew > 0.1
del dict["jawOpen"]
del dict["mouthLowerDown_R"]
del dict["mouthLowerDown_L"]
del dict["mouthStretch_R"]
del dict["mouthStretch_L"]

del dict["mouthPucker"]
del dict["mouthFrown_R"]
del dict["mouthFrown_L"]
del dict["mouthClose"]
del dict["mouthFunnel"]

# Shows chew pattern with small values
del dict["mouthUpperUp_L"]
del dict["mouthUpperUp_R"]
del dict["jawForward"]

# Noise
del dict["mouthShrugLower"] # GOES TO ZERO IN BITE
del dict["mouthShrugUpper"]
del dict["jawRight"]
del dict["jawLeft"]
del dict["mouthDimple_L"]
del dict["mouthDimple_R"]
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
    ax.plot(dict[key][100:250], label=key)
legend = ax.legend(loc='upper right', shadow=True, fontsize='x-large')
plt.show()

print(dict["Chew"][100:250])
