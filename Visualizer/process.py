import matplotlib.pyplot as plt
from matplotlib.pyplot import plot, ion, show
import glob

dict = {}
files = glob.glob("./*.csv")
name = "1076Meal2018J"
files = [name + ".csv"]
for file in files:
    dataFile = open(file)
    for lineNum, line in enumerate(dataFile):
        lineData = line.split(",")
        key = lineData[0]
        value = [float(lineData[1])]
        dict[key] = dict.get(key, [0]) + value
    dataFile.close()

f = open(name + "withMoves.csv", "w")
f.write("jawOpen,mouthLowerDown_R,mouthLowerDown_L,mouthStretch_R,mouthStretch_L,mouthPucker,mouthFrown_R,mouthFrown_L,mouthClose,mouthFunnel,mouthUpperUp_L,mouthUpperUp_R,jawForward,mouthShrugLower,mouthShrugUpper,jawRight,jawLeft,mouthDimple_L,mouthDimple_R,mouthRollLower,mouthRollUpper,mouthLeft,mouthRight,mouthSmile_L,mouthSmile_R,mouthPress_L,mouthPress_R,movement\n")

byteRanges = [range(240,280), range(870,910), range(1380,1440)]

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
    for range in byteRanges:
        if x in range:
            movement = "1,"
    line += movement
    line += "\n"
    f.write(line)
