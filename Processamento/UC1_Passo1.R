library(foreign)

get.exercicios.com.nota.minima = function(fonte, nota.minima=10) {
  print("Lendo Exercicios...")
  exercicios = read.csv(fonte)
  print(paste("Tamanho do arquivo (em linhas):", nrow(exercicios)))
  
  filtro = exercicios[exercicios$nota == nota.minima, ]
  print(paste("Tamanho do arquivo (em linhas) com nota minima de ", nota.minima, ": ", nrow(filtro), sep=""))
  print("Exercicios Lidos.")
  
  return(filtro[, c("matricula", "questao", "MM.DD.AAAA.HH.MM")])
}

get.exercicios.entre.os.dias = function(dados, deste.o.dia=NA, ate.o.dia=NA) {
  print("Filtrando Dados por data...")
  print(paste("Tamanho do arquivo (em linhas):", nrow(dados)))
  dados.filtrados = dados[0, ]
  
  if (!is.na(deste.o.dia) & !is.na(ate.o.dia))
    dados.filtrados = dados[as.POSIXct(dados$MM.DD.AAAA.HH.MM, format="%m/%d/%Y  %H:%M:%S") >= deste.o.dia & 
                              as.POSIXct(dados$MM.DD.AAAA.HH.MM, format="%m/%d/%Y  %H:%M:%S") <= ate.o.dia, ]
  else if (!is.na(deste.o.dia))
    dados.filtrados = dados[as.POSIXct(dados$MM.DD.AAAA.HH.MM, format="%m/%d/%Y  %H:%M:%S") >= deste.o.dia, ]
  else if (!is.na(ate.o.dia))
    dados.filtrados = dados[as.POSIXct(dados$MM.DD.AAAA.HH.MM, format="%m/%d/%Y  %H:%M:%S") <= ate.o.dia, ]
  
  print(paste("Tamanho do arquivo (em linhas) filtrado:", nrow(dados.filtrados)))
  return(dados.filtrados[, c("matricula", "exercicio")])
}

get.exercicios.entre.questoes = function(dados, questao.inicial, questao.final=NA) {
  print("Filtrando Dados por data...")
  print(paste("Tamanho do arquivo (em linhas):", nrow(dados)))
  
  if (!is.na(questao.final))
    dados.filtrados = dados[dados$exercicio >= questao.inicial & dados$exercicio <= questao.final, ]
  else
    dados.filtrados = dados[dados$exercicio >= questao.inicial, ]
  
  print(paste("Tamanho do arquivo (em linhas) filtrado:", nrow(dados.filtrados)))
  return(dados.filtrados)
}

formatar.nota = function(string) {
  return(as.double(paste(substr(string, 1, 1), ".", substr(string, 3, 3), sep="")))
}

filtra.dados.prova.por.nota = function(dados, nota.limiar=7) {
  df = data.frame(matricula=c(), questao=c())
  
  for (i in 1:nrow(dados)) {
    q = c()
    
    if (!is.na(dados[i, "questao1"]) & dados[i, "questao1"] >= nota.limiar)
      q[length(q) + 1] = 1
    if (!is.na(dados[i, "questao2"]) & dados[i, "questao2"] >= nota.limiar)
      q[length(q) + 1] = 2
    if (!is.na(dados[i, "questao3"]) & dados[i, "questao3"] >= nota.limiar)
      q[length(q) + 1] = 3
    if (!is.na(dados[i, "questao4"]) & dados[i, "questao4"] >= nota.limiar)
      q[length(q) + 1] = 4
    
    for (j in q)
      df = rbind(df, data.frame(matricula=dados[i, "Matrícula"], questao=j))
  }
  
  return(df)
}

read.provas = function(filename, q1, q2, q3, q4) {
  print("Lendo Provas...")
  dados = read.csv(filename)
  
  print(paste("Tamanho do arquivo (em linhas):", nrow(dados)))
  print("Formantando Notas...")
  dados$questao1 = formatar.nota(dados[, q1])
  dados$questao2 = formatar.nota(dados[, q2])
  dados$questao3 = formatar.nota(dados[, q3])
  dados$questao4 = formatar.nota(dados[, q4])
  
  dados = dados[, c("Matrícula", "questao1", "questao2", "questao3", "questao4")]
  dados.filtrados = filtra.dados.prova.por.nota(dados)
  
  return(dados.filtrados)
}

contabiliza.frequencias = function(dados) {
  dados.contabilizados = data.frame(questao=c(), exercicio=c(), qtd=c())
  
  for (i in 1:nrow(dados)) {
    q = dados[i, "questao"]
    e = dados[i, "exercicio"]
    
    if (nrow(dados.contabilizados[dados.contabilizados$questao == q & dados.contabilizados$exercicio == e, ]) == 0)
      dados.contabilizados = rbind(dados.contabilizados, data.frame(questao=c(q), exercicio=c(e), qtd=c(0)))
    
    dados.contabilizados[dados.contabilizados$questao == q & dados.contabilizados$exercicio == e, "qtd"] = dados.contabilizados[dados.contabilizados$questao == q & dados.contabilizados$exercicio == e, "qtd"] + 1
  }
  
  return(dados.contabilizados)
}

cria.data.frame = function(exercicio.inicial, exercicio.final, matricula=NA, coluna=NA) {
  tmp = data.frame(matricula=c(0), questao1=c(0), questao2=c(0), questao3=c(0), questao4=c(0))
  if (!is.na(matricula))
    tmp = data.frame(matricula=c(matricula), questao1=c(0), questao2=c(0), questao3=c(0), questao4=c(0))
  
  for (i in exercicio.inicial:exercicio.final)
    tmp[, paste("exercicio", i, sep="")] = c(0)
  
  if (!is.na(coluna))
    tmp[, coluna] = c(1)
  
  return(tmp)
}

format.prova.exercicio.comprimir.questoes = function(dados) {
  tmp = dados[1, ]
  tmp$questao = NA
  
  for (i in 1:nrow(dados))
    for (j in c("questao1", "questao2", "questao3", "questao4"))
      if (dados[i, j] == 1)
        tmp = rbind(tmp, cbind(dados[i, ], data.frame(questao=c(j))))
  
  return(tmp[2:nrow(tmp), 5:length(colnames(tmp))])
}

format.prova.exercicio = function(dados, exercicio.inicial, exercicio.final) {
  questoes.exercicios = cria.data.frame(exercicio.inicial, exercicio.final)
  
  for (i in 1:nrow(dados)) {
    atual = questoes.exercicios[questoes.exercicios$matricula == dados[i, "matricula"], ]
    if (nrow(atual) == 0) {
      questoes.exercicios = rbind(questoes.exercicios, cria.data.frame(exercicio.inicial, exercicio.final, as.character(dados[i, "matricula"])))
      atual = questoes.exercicios[questoes.exercicios$matricula == dados[i, "matricula"], ]
    }
    
    questoes.exercicios[questoes.exercicios$matricula == dados[i, "matricula"], paste("questao", dados[i, "questao"], sep="")] = 1
    questoes.exercicios[questoes.exercicios$matricula == dados[i, "matricula"], paste("exercicio", dados[i, "exercicio"], sep="")] = 1
  }
  
  formatado = format.prova.exercicio.comprimir.questoes(questoes.exercicios[2:nrow(questoes.exercicios), 2:length(colnames(questoes.exercicios))])
  
  for (i in 1:length(colnames(formatado)))
    formatado[, i] = factor(formatado[, i])
  
  return(formatado)
}

dados.exercicios.submetidos = get.exercicios.com.nota.minima("../Dados/exercicios-20112.csv")
colnames(dados.exercicios.submetidos) = c("matricula", "exercicio", "MM.DD.AAAA.HH.MM")

data.prova.um = as.POSIXct("9.17.2011.10.00.00", format="%m.%d.%Y.%H.%M.%S")
dados.exercicios.submetidos.prova.um = get.exercicios.entre.os.dias(dados.exercicios.submetidos, ate.o.dia=data.prova.um)
data.prova.dois = as.POSIXct("10.29.2011.10.00.00", format="%m.%d.%Y.%H.%M.%S")
dados.exercicios.submetidos.prova.dois = get.exercicios.entre.os.dias(dados.exercicios.submetidos, data.prova.um, data.prova.dois)
data.prova.tres = as.POSIXct("11.26.2011.10.00.00", format="%m.%d.%Y.%H.%M.%S")
dados.exercicios.submetidos.prova.tres = get.exercicios.entre.os.dias(dados.exercicios.submetidos, data.prova.dois, data.prova.tres)

print(paste("Tamanho da base com todos os exercicios separados por prova:", nrow(dados.exercicios.submetidos.prova.um) + nrow(dados.exercicios.submetidos.prova.dois) + nrow(dados.exercicios.submetidos.prova.tres)))

dados.exercicios.submetidos.prova.um = get.exercicios.entre.questoes(dados.exercicios.submetidos.prova.um, 1, 85)
dados.exercicios.submetidos.prova.dois = get.exercicios.entre.questoes(dados.exercicios.submetidos.prova.dois, 86, 164)
dados.exercicios.submetidos.prova.tres = get.exercicios.entre.questoes(dados.exercicios.submetidos.prova.tres, 165)

dados.prova.um = read.provas("../Dados/Prova1.csv", "X86", "X87", "X88", "X89")
dados.prova.dois = read.provas("../Dados/Prova2.csv", "X165", "X166", "X167", "X168")
dados.prova.tres = read.provas("../Dados/Prova3.csv", "X191", "X192", "X193", "X194")

dados.prova.exercicio.um = merge(dados.prova.um, dados.exercicios.submetidos.prova.um, by="matricula")
dados.prova.exercicio.dois = merge(dados.prova.dois, dados.exercicios.submetidos.prova.dois, by="matricula")
dados.prova.exercicio.tres = merge(dados.prova.tres, dados.exercicios.submetidos.prova.tres, by="matricula")

dados.prova.exercicio.um.frequencia = contabiliza.frequencias(dados.prova.exercicio.um)
dados.prova.exercicio.dois.frequencia = contabiliza.frequencias(dados.prova.exercicio.dois)
dados.prova.exercicio.tres.frequencia = contabiliza.frequencias(dados.prova.exercicio.tres)

questoes.exercicios.um = format.prova.exercicio(dados.prova.exercicio.um, 1, 85)
questoes.exercicios.dois = format.prova.exercicio(dados.prova.exercicio.dois, 86, 164)
questoes.exercicios.tres = format.prova.exercicio(dados.prova.exercicio.tres, 165, max(dados.prova.exercicio.tres[, "exercicio"]))

write.csv(dados.prova.exercicio.um.frequencia, "UC1_Frequencias_Prova1.csv", quote=F, row.names=F, col.names=F)
write.csv(dados.prova.exercicio.dois.frequencia, "UC1_Frequencias_Prova2.csv", quote=F, row.names=F, col.names=F)
write.csv(dados.prova.exercicio.tres.frequencia, "UC1_Frequencias_Prova3.csv", quote=F, row.names=F, col.names=F)

write.arff(questoes.exercicios.um, "UC1_Bayes_Prova1.arff")
write.arff(questoes.exercicios.dois, "UC1_Bayes_Prova2.arff")
write.arff(questoes.exercicios.tres, "UC1_Bayes_Prova3.arff")
