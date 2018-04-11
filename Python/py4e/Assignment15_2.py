# Assignment 15.2

import sqlite3

fname = input("Enter file name:")
if len(fname) < 1: fname = "mbox.txt"
fh = open(fname)

conn = sqlite3.connect('org.sqlite')
cur = conn.cursor()
cur.execute('DROP TABLE IF EXISTS Counts')
cur.execute('CREATE TABLE Counts (org TEXT, count INTEGER)')

for line in fh:
    if not line.startswith("From: "): continue
    words = line.split()
    org = words[1].split('@')[1]
    cur.execute('SELECT count FROM Counts WHERE org = ?', (org,))
    row = cur.fetchone()
    if row is None:
        cur.execute('INSERT INTO Counts (org,count) VALUES (?,1)',(org,))
    else:
        cur.execute('UPDATE Counts SET count = count + 1 WHERE org = ?',(org,))

conn.commit()
