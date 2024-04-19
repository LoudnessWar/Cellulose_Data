import sys
with open(sys.argv[1]) as fin, open(sys.argv[2], "w") as fout:
    fin.readline()
    fout.write(f"#Frame DSI\n")
    for line in fin:
        data = line.split()
        fout.write(f"{data[0]} {round(float(data[1]) - float(data[2]) - float(data[3]), 4)}\n")
