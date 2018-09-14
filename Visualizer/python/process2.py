import matplotlib.pyplot as plt
from matplotlib.pyplot import plot, ion, show
import glob

dict = {}
name = "Payloads-2018-08-31 12:03:32 +0000"
files = [name + ".csv"]
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
            # dict["movement"] = dict.get("movement", [0]) + [float(lineData[27])]
    dataFile.close()

f = open(name + "2.csv", "w")
f.write("jawOpen,mouthLowerDown_R,mouthLowerDown_L,mouthStretch_R,mouthStretch_L,mouthPucker,mouthFrown_R,mouthFrown_L,mouthClose,mouthFunnel,mouthUpperUp_L,mouthUpperUp_R,jawForward,mouthShrugLower,mouthShrugUpper,jawRight,jawLeft,mouthDimple_L,mouthDimple_R,mouthRollLower,mouthRollUpper,mouthLeft,mouthRight,mouthSmile_L,mouthSmile_R,mouthPress_L,mouthPress_R,movement\n")

# byteRanges = [range(253,254), range(878,879), range(1525,1527)]

for x in range(0, len(dict["jawOpen"])):
    line = ""
    line += str(dict["jawOpen"][x]) + ","
    line += str(dict["mouthLowerDown_R"][x]) + ","
    line += str(dict["mouthLowerDown_L"][x]) + ","
    line += str(dict["mouthStretch_R"][x]) + ","
    line += str(dict["mouthStretch_L"][x]) + ","
    line += str(dict["mouthPucker"][x]) + ","
    line += str(dict["mouthFrown_R"][x]) + ","
    line += str(dict["mouthFrown_L"][x]) + ","
    line += str(dict["mouthClose"][x]) + ","
    line += str(dict["mouthFunnel"][x]) + ","
    line += str(dict["mouthUpperUp_L"][x]) + ","
    line += str(dict["mouthUpperUp_R"][x]) + ","
    line += str(dict["jawForward"][x]) + ","
    line += str(dict["mouthShrugLower"][x]) + ","
    line += str(dict["mouthShrugUpper"][x]) + ","
    line += str(dict["jawRight"][x]) + ","
    line += str(dict["jawLeft"][x]) + ","
    line += str(dict["mouthDimple_L"][x]) + ","
    line += str(dict["mouthDimple_R"][x]) + ","
    line += str(dict["mouthRollLower"][x]) + ","
    line += str(dict["mouthRollUpper"][x]) + ","
    line += str(dict["mouthLeft"][x]) + ","
    line += str(dict["mouthRight"][x]) + ","
    line += str(dict["mouthSmile_L"][x]) + ","
    line += str(dict["mouthSmile_R"][x]) + ","
    line += str(dict["mouthPress_L"][x]) + ","
    line += str(dict["mouthPress_R"][x]) + ","
    movement = "0,"
    # for range in byteRanges:
    #     if x in range:
    #         movement = "1,"
    line += movement
    line += "\n"
    f.write(line)
