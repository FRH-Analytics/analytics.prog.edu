library(plyr)

dados.exercicios.submetidas = read.csv("../Dados/exercicios-20112.csv")

print("Colunas da Base:")
print(colnames(dados.exercicios.submetidas))
print(paste("Tamanho da Base em Linhas:", nrow(dados.exercicios.submetidas)))
print(paste("Quantidade de Exercicios Submetidos:", length(unique(dados.exercicios.submetidas$questao))))
print("")
print("Filtrando a Base para Considerar apenas os Exercicios Submetidos Corretamente")
print("")

dados.exercicios.submetidas = dados.exercicios.submetidas[dados.exercicios.submetidas$nota == 10.0, ]
print(paste("Tamanho da Base em Linhas:", nrow(dados.exercicios.submetidas)))
print(paste("Quantidade de Exercicios Submetidos Corretamente:", length(unique(dados.exercicios.submetidas$questao))))

png("Histograma - Exercicios Submetidos Corretamente.png", width=720, height=720)
hist(dados.exercicios.submetidas[, "questao"], include.lowest=T, labels=T, main="Quantidade de Exercicios Submetidos Corretamente",
     xlab="Quantidade de Exercicios Submetidos Corretamente", ylab="Quantidade de Alunos que Submeteram tal Quantidade de Exercicios Corretamente")
dev.off()

ajeitar.nota = function(string) {
  return(as.double(paste(substr(string, 1, 1), ".", substr(string, 3, 3), sep="")))
}

imprime.hist.questoes = function(filename, label, questao1, questao2, questao3, questao4) {
  dados.prova = read.csv(filename)
  print("Colunas da Base:")
  print(colnames(dados.prova))
  print(paste("Tamanho da Base em Linhas:", nrow(dados.prova)))
  
  dados.prova$questao1 = ajeitar.nota(dados.prova[, questao1])
  dados.prova$questao2 = ajeitar.nota(dados.prova[, questao2])
  dados.prova$questao3 = ajeitar.nota(dados.prova[, questao3])
  dados.prova$questao4 = ajeitar.nota(dados.prova[, questao4])
  
  quantidade.questoes.corretas = data.frame(matricula=c(), qtd.questoes=c())
  
  for (i in 1:nrow(dados.prova)) {
    qtd = 0
    if (!is.na(dados.prova[i, "questao1"]) & dados.prova[i, "questao1"] >= 7.0) {
      qtd = qtd + 1
    }
    if (!is.na(dados.prova[i, "questao2"]) & dados.prova[i, "questao2"] >= 7.0) {
      qtd = qtd + 1
    }
    if (!is.na(dados.prova[i, "questao3"]) & dados.prova[i, "questao3"] >= 7.0) {
      qtd = qtd + 1
    }
    if (!is.na(dados.prova[i, "questao4"]) & dados.prova[i, "questao4"] >= 7.0) {
      qtd = qtd + 1
    }
    
    if (nrow(quantidade.questoes.corretas[quantidade.questoes.corretas$matricula == dados.prova[i, "Matrícula"], ]) == 0) {
      quantidade.questoes.corretas = rbind(quantidade.questoes.corretas, data.frame(matricula=dados.prova[i, "Matrícula"], qtd.questoes=qtd))
    } else {
      qtd = qtd + quantidade.questoes.corretas[quantidade.questoes.corretas$matricula == dados.prova[i, "matricula"], "qtd.questoes"]
      quantidade.questoes.corretas[quantidade.questoes.corretas$matricula == i$matricula, "qtd.questoes"] = qtd
    }
  }
  
  hist(quantidade.questoes.corretas[, "qtd.questoes"], include.lowest=T, labels=T, main=label,
       xlab="Quantidade de Questoes Submetidos Corretamente", ylab="Quantidade de Alunos que Submeteram tal Quantidade de Questoes Corretamente")
  
}

png("Histograma - Questoes da Prova Submetidas Corretamente.png", width=720, height=720)
par(mfrow = c(1,3))
imprime.hist.questoes("../Dados/Prova1.csv", "Questoes da Prova 1 Submetidas Corretamente", "X86", "X87", "X88", "X89")
imprime.hist.questoes("../Dados/Prova2.csv", "Questoes da Prova 2 Submetidas Corretamente", "X165", "X166", "X167", "X168")
imprime.hist.questoes("../Dados/Prova3.csv", "Questoes da Prova 3 Submetidas Corretamente", "X191", "X192", "X193", "X194")
dev.off()
