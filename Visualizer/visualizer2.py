import matplotlib.pyplot as plt
from matplotlib.pyplot import plot, ion, show
import glob

dict = {}
#files = glob.glob("./*.csv")
files = ["AndreMeal2018-07-21 195825 +0000columns.csv"]
for file in files:
    dataFile = open(file)
    for lineNum, line in enumerate(dataFile):
        if lineNum != 0:
            lineData = line.split(",")
            dict["jawOpen"] = dict.get("jawOpen", [0]) + [float(lineData[0])]
            dict["mouthLowerDown_R"] = dict.get("mouthLowerDown_R", [0]) + [float(lineData[1])]
            dict["mouthLowerDown_L"] = dict.get("mouthLowerDown_L", [0]) + [float(lineData[2])]
            dict["mouthStretch_R"] = dict.get("mouthStretch_R", [0]) + [float(lineData[3])]
            dict["mouthStretch_L"] = dict.get("mouthStretch_L", [0]) + [float(lineData[4])]
            dict["mouthPucker"] = dict.get("mouthPucker", [0]) + [float(lineData[5])]
            dict["mouthFrown_R"] = dict.get("mouthFrown_R", [0]) + [float(lineData[6])]
            dict["mouthFrown_L"] = dict.get("mouthFrown_L", [0]) + [float(lineData[7])]
            dict["mouthClose"] = dict.get("mouthClose", [0]) + [float(lineData[8])]
            dict["mouthFunnel"] = dict.get("mouthFunnel", [0]) + [float(lineData[9])]
            dict["mouthUpperUp_L"] = dict.get("mouthUpperUp_L", [0]) + [float(lineData[10])]
            dict["mouthUpperUp_R"] = dict.get("mouthUpperUp_R", [0]) + [float(lineData[11])]
            dict["jawForward"] = dict.get("jawForward", [0]) + [float(lineData[12])]
            dict["mouthShrugLower"] = dict.get("mouthShrugLower", [0]) + [float(lineData[13])]
            dict["mouthShrugUpper"] = dict.get("mouthShrugUpper", [0]) + [float(lineData[14])]
            dict["jawRight"] = dict.get("jawRight", [0]) + [float(lineData[15])]
            dict["jawLeft"] = dict.get("jawLeft", [0]) + [float(lineData[16])]
            dict["mouthDimple_L"] = dict.get("mouthDimple_L", [0]) + [float(lineData[17])]
            dict["mouthDimple_R"] = dict.get("mouthDimple_R", [0]) + [float(lineData[18])]
            dict["mouthRollLower"] = dict.get("mouthRollLower", [0]) + [float(lineData[19])]
            dict["mouthRollUpper"] = dict.get("mouthRollUpper", [0]) + [float(lineData[20])]
            dict["mouthLeft"] = dict.get("mouthLeft", [0]) + [float(lineData[21])]
            dict["mouthRight"] = dict.get("mouthRight", [0]) + [float(lineData[22])]
            dict["mouthSmile_L"] = dict.get("mouthSmile_L", [0]) + [float(lineData[23])]
            dict["mouthSmile_R"] = dict.get("mouthSmile_R", [0]) + [float(lineData[24])]
            dict["mouthPress_L"] = dict.get("mouthPress_L", [0]) + [float(lineData[25])]
            dict["mouthPress_R"] = dict.get("mouthPress_R", [0]) + [float(lineData[26])]
            dict["movement"] = dict.get("movement", [0]) + [float(lineData[27])]
    dataFile.close()

#del dict["jawOpen"]
#del dict["mouthLowerDown_R"]
#del dict["mouthLowerDown_L"]
#del dict["mouthStretch_R"]
#del dict["mouthStretch_L"]
#del dict["mouthPucker"]
#del dict["mouthFrown_R"]
#del dict["mouthFrown_L"]
#del dict["mouthClose"]
#del dict["mouthFunnel"]
#del dict["mouthUpperUp_L"]
#del dict["mouthUpperUp_R"]
#del dict["jawForward"]
#del dict["mouthShrugLower"] # GOES TO ZERO IN BITE
#del dict["mouthShrugUpper"]
#del dict["jawRight"]
#del dict["jawLeft"]
#del dict["mouthDimple_L"]
#del dict["mouthDimple_R"]
#del dict["mouthRollLower"]
#del dict["mouthRollUpper"]
#del dict["mouthLeft"]
#del dict["mouthRight"]
#del dict["mouthSmile_L"]
#del dict["mouthSmile_R"]
#del dict["mouthPress_L"]
#del dict["mouthPress_R"]

fig, ax = plt.subplots()
for key in dict:
    ax.plot(dict[key], label=key)
legend = ax.legend(loc='upper right', shadow=True, fontsize='x-large')
plt.show()
