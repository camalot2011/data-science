#Assignment6_5

text = "X-DSPAM-Confidence:    0.8475";

pos = text.find(".")
num = text[(pos-1):(pos+6)]
print(float(num))