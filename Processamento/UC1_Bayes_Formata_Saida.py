import re

def get_probabilidade_q(line, pattern):
    m = re.match(pattern, line)
    if m:
        return float(m.group(1))
    return -1


def get_probabilidade_q1(probabilidade, line):
    if (probabilidade == -1):
        probabilidade = get_probabilidade_q(line, "Class questao1: P\(C\) = ([0-9.]+)")
    return probabilidade

def get_probabilidade_q2(probabilidade, line):
    if (probabilidade == -1):
        probabilidade = get_probabilidade_q(line, "Class questao2: P\(C\) = ([0-9.]+)")
    return probabilidade

def get_probabilidade_q3(probabilidade, line):
    if (probabilidade == -1):
        probabilidade = get_probabilidade_q(line, "Class questao3: P\(C\) = ([0-9.]+)")
    return probabilidade

def get_probabilidade_q4(probabilidade, line):
    if (probabilidade == -1):
        probabilidade = get_probabilidade_q(line, "Class questao4: P\(C\) = ([0-9.]+)")
    return probabilidade

def get_exercicios(mapa, file, i):
    m = re.match("Attribute exercicio([0-9]+)", file[i])
    if m:
        if re.match("1", file[i+1]):
            o = re.match("([0-9.]+)", file[i+2])
            mapa[int(m.group(1))] = float(o.group(1))
            return mapa
        elif re.match("0	1", file[i+1]):
            o = re.match(".*	([0-9.]+)", file[i+2])
            mapa[int(m.group(1))] = float(o.group(1))
            return mapa

def formata_saida(arquivo_entrada, arquivo_saida):
    f = open(arquivo_entrada, 'r')
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

    questao_atual = 0
    for i in xrange(1, len(file)):
        probabilidade_q1 = get_probabilidade_q1(probabilidade_q1, file[i])
        probabilidade_q2 = get_probabilidade_q2(probabilidade_q2, file[i])
        probabilidade_q3 = get_probabilidade_q3(probabilidade_q3, file[i])
        probabilidade_q4 = get_probabilidade_q4(probabilidade_q4, file[i])
        
        if probabilidade_q1 != -1:
            questao_atual = 1
        if probabilidade_q2 != -1:
            questao_atual = 2
        if probabilidade_q3 != -1:
            questao_atual = 3
        if probabilidade_q4 != -1:
            questao_atual = 4
        
        if questao_atual == 1:
            get_exercicios(exercicios_q1, file, i)
        elif questao_atual == 2:
            get_exercicios(exercicios_q2, file, i)
        elif questao_atual == 3:
            get_exercicios(exercicios_q3, file, i)
        elif questao_atual == 4:
            get_exercicios(exercicios_q4, file, i)

    saida = "questao,exercicio, probabilidade\n"
    for (k, v) in exercicios_q1.items():
        saida += "1,%s,%s\n" %(str(k), str(v))
    for (k, v) in exercicios_q2.items():
        saida += "2,%s,%s\n" %(str(k), str(v))
    for (k, v) in exercicios_q3.items():
        saida += "3,%s,%s\n" %(str(k), str(v))
    for (k, v) in exercicios_q4.items():
        saida += "4,%s,%s\n" %(str(k), str(v))

    saida = saida[:-1]

    myFile = open(arquivo_saida, 'w')
    myFile.write(saida)
    myFile.close()


formata_saida("UC1_Bayes_Prova1_Saida.txt", "UC1_Bayes_Prova1_Formatado.txt")
formata_saida("UC1_Bayes_Prova2_Saida.txt", "UC1_Bayes_Prova2_Formatado.txt")
formata_saida("UC1_Bayes_Prova3_Saida.txt", "UC1_Bayes_Prova3_Formatado.txt")
