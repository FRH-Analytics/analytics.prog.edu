import re

f = open("UC1-Output-Prova3.txt", 'r')
file = f.readlines()
f.close()

probabilidade_q1 = -1
exercicios_q1 = dict()

probabilidade_q2 = -1
exercicios_q2 = dict()

probabilidade_q3 = -1
exercicios_q3 = dict()

probabilidade_q4 = -1
exercicios_q4 = dict()

def get_probabilidade_q(line, pattern):
    m = re.match(pattern, line)
    if m:
        return float(m.group(1))
    return -1


def get_probabilidade_q1(line):
    global probabilidade_q1
    
    if (probabilidade_q1 == -1):
        probabilidade_q1 = get_probabilidade_q(line, "Class questao1: P\(C\) = ([0-9.]+)")
        return probabilidade_q1 != -1
    return False

def get_probabilidade_q2(line):
    global probabilidade_q2
    
    if (probabilidade_q2 == -1):
        probabilidade_q2 = get_probabilidade_q(line, "Class questao2: P\(C\) = ([0-9.]+)")
        return probabilidade_q2 != -1
    return False

def get_probabilidade_q3(line):
    global probabilidade_q3
    
    if (probabilidade_q3 == -1):
        probabilidade_q3 = get_probabilidade_q(line, "Class questao3: P\(C\) = ([0-9.]+)")
        return probabilidade_q3 != -1
    return False

def get_probabilidade_q4(line):
    global probabilidade_q4
    
    if (probabilidade_q4 == -1):
        probabilidade_q4 = get_probabilidade_q(line, "Class questao4: P\(C\) = ([0-9.]+)")
        return probabilidade_q4 != -1
    return False

def get_exercicios(mapa, file, i):
    m = re.match("Attribute exercicio([0-9]+)", file[i])
    if m:
        if re.match("1", file[i+1]):
            o = re.match("([0-9.]+)", file[i+2])
            mapa[int(m.group(1))] = float(o.group(1))
#            print mapa
            return mapa
        elif re.match("0	1", file[i+1]):
            o = re.match(".*	([0-9.]+)", file[i+2])
            mapa[int(m.group(1))] = float(o.group(1))
#            print mapa
            return mapa

questao_atual = 0
for i in xrange(1, len(file)):
#    print exercicios_q1
    if get_probabilidade_q1(file[i]):
        questao_atual = 1
    if get_probabilidade_q2(file[i]):
        questao_atual = 2
    if get_probabilidade_q3(file[i]):
        questao_atual = 3
    if get_probabilidade_q4(file[i]):
        questao_atual = 4

    if questao_atual == 1:
        get_exercicios(exercicios_q1, file, i)
    elif questao_atual == 2:
        get_exercicios(exercicios_q2, file, i)
    elif questao_atual == 3:
        get_exercicios(exercicios_q3, file, i)
    elif questao_atual == 4:
        get_exercicios(exercicios_q4, file, i)


print "Q1:", probabilidade_q1
print "Q2:", probabilidade_q2
print "Q3:", probabilidade_q3
print "Q4:", probabilidade_q4

print exercicios_q1
print exercicios_q2
print exercicios_q3
print exercicios_q4

saida = "questao,probabilidade,exercicio\n"
for (k, v) in exercicios_q1.items():
    saida += "1,%s,%s\n" %(str(v), str(k))
for (k, v) in exercicios_q2.items():
    saida += "2,%s,%s\n" %(str(v), str(k))
for (k, v) in exercicios_q3.items():
    saida += "3,%s,%s\n" %(str(v), str(k))
for (k, v) in exercicios_q4.items():
    saida += "4,%s,%s\n" %(str(v), str(k))

myFile = open('UC1-Resultado-Prova3.csv', 'w')
myFile.write(saida[:-1])
myFile.close()