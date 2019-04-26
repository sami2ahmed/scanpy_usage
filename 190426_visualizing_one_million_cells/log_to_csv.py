import re, sys

file = sys.argv[1]

def to_seconds(time):
    m = re.match('(\d+):(\d\d):(\d\d).(\d\d)', time)
    return int(m.group(1)) * 60 * 60 + int(m.group(2)) * 60 + int(m.group(3)) + int(m.group(4)) / 100.0

def report_stage(stage, time):
    print(f'{stage},{time},{to_seconds(time)}')

stage = None
running_stage = False
for line in open(file):
    m = re.match('(reading\s\S+)\s\((.+)\)', line)
    if m:
        report_stage(m.group(1), m.group(2))
    elif not running_stage:
        stage = line.strip()
        running_stage = True
    m = re.match('\s+finished\s\((.+)\)', line)
    if m:
        report_stage(stage, m.group(1))
        running_stage = False