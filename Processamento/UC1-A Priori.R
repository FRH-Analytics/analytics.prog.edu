library(plyr)
library(foreign)

dados.exercicios.submetidas = read.csv("../Dados/exercicios-20112.csv")
dados.exercicios.submetidas = dados.exercicios.submetidas[dados.exercicios.submetidas$nota == 10.0, ]

# print(nrow(dados.exercicios.submetidas))

dados.exercicios.submetidas = dados.exercicios.submetidas[, c("matricula", "questao")]
colnames(dados.exercicios.submetidas) = c("matricula", "exercicio")
dados.exercicios.submetidas = unique(dados.exercicios.submetidas)

exercicios.um = dados.exercicios.submetidas[dados.exercicios.submetidas$exercicio < 86, ]
exercicios.dois = dados.exercicios.submetidas[dados.exercicios.submetidas$exercicio > 85 & dados.exercicios.submetidas$exercicio < 165, ]
exercicios.tres = dados.exercicios.submetidas[dados.exercicios.submetidas$exercicio > 164, ]

ajeitar.nota = function(string) {
  return(as.double(paste(substr(string, 1, 1), ".", substr(string, 3, 3), sep="")))
}

prepara.data.frame.provas = function(dados, limiar=7) {
  
  df = data.frame(matricula=c(), questao=c())
  
  for (i in 1:nrow(dados)) {
    q = c()

    if (!is.na(dados[i, "questao1"]) & dados[i, "questao1"] >= limiar)
      q[length(q) + 1] = 1
    if (!is.na(dados[i, "questao2"]) & dados[i, "questao2"] >= limiar)
      q[length(q) + 1] = 2
    if (!is.na(dados[i, "questao3"]) & dados[i, "questao3"] >= limiar)
      q[length(q) + 1] = 3
    if (!is.na(dados[i, "questao4"]) & dados[i, "questao4"] >= limiar)
      q[length(q) + 1] = 4
    
    for (j in q)
      df = rbind(df, data.frame(matricula=dados[i, "Matrícula"], questao=j))
  }
  
  return(df)
}

ajeita.provas = function(filename, q1, q2, q3, q4) {
  dados = read.csv(filename)
  
  dados$questao1 = ajeitar.nota(dados[, q1])
  dados$questao2 = ajeitar.nota(dados[, q2])
  dados$questao3 = ajeitar.nota(dados[, q3])
  dados$questao4 = ajeitar.nota(dados[, q4])
  
  dados = dados[, c("Matrícula", "questao1", "questao2", "questao3", "questao4")]
  dados = unique(dados)
  
  return(prepara.data.frame.provas(dados))
}

prova.um = ajeita.provas("../Dados/Prova1.csv", "X86", "X87", "X88", "X89")
prova.dois = ajeita.provas("../Dados/Prova2.csv", "X165", "X166", "X167", "X168")
prova.tres = ajeita.provas("../Dados/Prova3.csv", "X191", "X192", "X193", "X194")

prova.um$tipo = 1
prova.dois$tipo = 2
prova.tres$tipo = 3

prova.exercicio.um = merge(prova.um, exercicios.um, by="matricula")
# print(prova.exercicio.um[1:10, ])
# prova.exercicio.um = prova.exercicio.um[, c("questao", "exercicio")]
prova.exercicio.dois = merge(prova.dois, exercicios.dois, by="matricula")
# prova.exercicio.dois = prova.exercicio.dois[, c("questao", "exercicio")]
prova.exercicio.tres = merge(prova.tres, exercicios.tres, by="matricula")
# prova.exercicio.tres = prova.exercicio.tres[, c("questao", "exercicio")]

cria.data.frame = function(exericios, matricula=NA, coluna=NA) {
  tmp = data.frame(matricula=c(0), questao1=c(0), questao2=c(0), questao3=c(0), questao4=c(0))
  if (!is.na(matricula))
    tmp = data.frame(matricula=c(matricula), questao1=c(0), questao2=c(0), questao3=c(0), questao4=c(0))
  
  for (i in 1:exericios)
    tmp[, paste("exercicio", i, sep="")] = c(0)
  
  if (!is.na(coluna))
    tmp[, coluna] = c(1)
  
  return(tmp)
}

# questoes.exercicios.um = data.frame(matricula=c(0), questao1=c(0), questao2=c(0), questao3=c(0), questao4=c(0))
# for (i in 1:max(prova.exercicio.um[, "exercicio"])) {
#   questoes.exercicios.um[, paste("exercicio", i, sep="")] = c(0)
# }

questoes.exercicios.um = cria.data.frame(max(prova.exercicio.um[, "exercicio"]))
questoes.exercicios.dois = cria.data.frame(max(prova.exercicio.dois[, "exercicio"]))
questoes.exercicios.tres = cria.data.frame(max(prova.exercicio.tres[, "exercicio"]))
# print(questoes.exercicios.um)
# print(cria.data.frame(max(prova.exercicio.um[, "exercicio"]), "123"))

print(prova.exercicio.um[1:10, ])

for (i in 1:nrow(prova.exercicio.um)) {
  atual = questoes.exercicios.um[questoes.exercicios.um$matricula == prova.exercicio.um[i, "matricula"], ]
  if (nrow(atual) == 0) {
    questoes.exercicios.um = rbind(questoes.exercicios.um, cria.data.frame(max(prova.exercicio.um[, "exercicio"]), as.character(prova.exercicio.um[i, "matricula"])))
    atual = questoes.exercicios.um[questoes.exercicios.um$matricula == prova.exercicio.um[i, "matricula"], ]
  }
  
  questoes.exercicios.um[questoes.exercicios.um$matricula == prova.exercicio.um[i, "matricula"], paste("questao", prova.exercicio.um[i, "questao"], sep="")] = 1
  questoes.exercicios.um[questoes.exercicios.um$matricula == prova.exercicio.um[i, "matricula"], paste("exercicio", prova.exercicio.um[i, "exercicio"], sep="")] = 1
}

for (i in 1:nrow(prova.exercicio.dois)) {
  atual = questoes.exercicios.dois[questoes.exercicios.dois$matricula == prova.exercicio.dois[i, "matricula"], ]
  if (nrow(atual) == 0) {
    questoes.exercicios.dois = rbind(questoes.exercicios.dois, cria.data.frame(max(prova.exercicio.dois[, "exercicio"]), as.character(prova.exercicio.dois[i, "matricula"])))
    atual = questoes.exercicios.dois[questoes.exercicios.dois$matricula == prova.exercicio.dois[i, "matricula"], ]
  }
  
  questoes.exercicios.dois[questoes.exercicios.dois$matricula == prova.exercicio.dois[i, "matricula"], paste("questao", prova.exercicio.dois[i, "questao"], sep="")] = 1
  questoes.exercicios.dois[questoes.exercicios.dois$matricula == prova.exercicio.dois[i, "matricula"], paste("exercicio", prova.exercicio.dois[i, "exercicio"], sep="")] = 1
}

for (i in 1:nrow(prova.exercicio.tres)) {
  atual = questoes.exercicios.tres[questoes.exercicios.dois$matricula == prova.exercicio.tres[i, "matricula"], ]
  if (nrow(atual) == 0) {
    questoes.exercicios.tres = rbind(questoes.exercicios.tres, cria.data.frame(max(prova.exercicio.tres[, "exercicio"]), as.character(prova.exercicio.tres[i, "matricula"])))
    atual = questoes.exercicios.tres[questoes.exercicios.tres$matricula == prova.exercicio.tres[i, "matricula"], ]
  }
  
  questoes.exercicios.tres[questoes.exercicios.tres$matricula == prova.exercicio.tres[i, "matricula"], paste("questao", prova.exercicio.tres[i, "questao"], sep="")] = 1
  questoes.exercicios.tres[questoes.exercicios.tres$matricula == prova.exercicio.tres[i, "matricula"], paste("exercicio", prova.exercicio.tres[i, "exercicio"], sep="")] = 1
}

print(questoes.exercicios.um[1:10, ])
print(as.character(prova.exercicio.um[1:10, "matricula"]))
print(nrow(prova.exercicio.um))
# print(prova.exercicio.um[as.character(questoes.exercicios.um$matricula) == "107076E4", ])

questoes.exercicios.um = questoes.exercicios.um[2:nrow(questoes.exercicios.um), 2:length(colnames(questoes.exercicios.um))]
questoes.exercicios.dois = questoes.exercicios.dois[2:nrow(questoes.exercicios.dois), 2:length(colnames(questoes.exercicios.dois))]
questoes.exercicios.tres = questoes.exercicios.tres[2:nrow(questoes.exercicios.tres), 2:length(colnames(questoes.exercicios.tres))]
write.arff(questoes.exercicios.um, "UC1.arff")
write.arff(questoes.exercicios.dois, "UC2.arff")
write.arff(questoes.exercicios.tres, "UC3.arff")

contabiliza.tuplas.iguais = function(dados) {
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

write.csv(contabiliza.tuplas.iguais(prova.exercicio.um), "UC1-Prova1.csv", quote=F, row.names=F, col.names=F)
write.csv(contabiliza.tuplas.iguais(prova.exercicio.dois), "UC1-Prova2.csv", quote=F, row.names=F, col.names=F)
write.csv(contabiliza.tuplas.iguais(prova.exercicio.tres), "UC1-Prova3.csv", quote=F, row.names=F, col.names=F)

# provas.exercicios = rbind(prova.exercicio.um, prova.exercicio.dois)
# provas.exercicios = rbind(provas.exercicios, prova.exercicio.tres)

write.csv(prova.exercicio.um, "provasExerciciosUm.csv", quote=F, row.names=F, col.names=F)
write.csv(prova.exercicio.dois, "provasExerciciosDois.csv", quote=F, row.names=F, col.names=F)
write.csv(prova.exercicio.tres, "provasExerciciosTres.csv", quote=F, row.names=F, col.names=F)

print(questoes.exercicios.um[1:10, ])

anexo.comprimir.questoes = function(df) {
  tmp = df[1, ]
  tmp$questao = NA
  
  for (i in 1:nrow(df))
    for (j in c("questao1", "questao2", "questao3", "questao4"))
      if (df[i, j] == 1)
        tmp = rbind(tmp, cbind(df[i, ], data.frame(questao=c(j))))
  
  return(tmp[2:nrow(tmp), 5:length(colnames(tmp))])
}

questoes.exercicios.um.ajeitado = anexo.comprimir.questoes(questoes.exercicios.um)
questoes.exercicios.dois.ajeitado = anexo.comprimir.questoes(questoes.exercicios.dois)
questoes.exercicios.tres.ajeitado = anexo.comprimir.questoes(questoes.exercicios.tres)

for (i in 1:length(colnames(questoes.exercicios.um.ajeitado)))
  questoes.exercicios.um.ajeitado[, i] = factor(questoes.exercicios.um.ajeitado[, i])

for (i in 1:length(colnames(questoes.exercicios.dois.ajeitado)))
  questoes.exercicios.dois.ajeitado[, i] = factor(questoes.exercicios.dois.ajeitado[, i])

for (i in 1:length(colnames(questoes.exercicios.tres.ajeitado)))
  questoes.exercicios.tres.ajeitado[, i] = factor(questoes.exercicios.tres.ajeitado[, i])

print(questoes.exercicios.um.ajeitado[1:10, ])

write.arff(questoes.exercicios.um.ajeitado, "UC1-Prova1.arff")
write.arff(questoes.exercicios.um.ajeitado, "UC1-Prova2.arff")
write.arff(questoes.exercicios.um.ajeitado, "UC1-Prova3.arff")

dados.teste = read.csv("UC1-Resultado.csv")
print(dados.teste)
