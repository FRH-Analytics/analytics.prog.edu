library(plyr)
require(lattice)
library(ggplot2)

dados.quantidade.questoes.submetidas = read.csv("../Dados/exercicios-20112.csv")
print("Colunas da Base:")
print(colnames(dados.quantidade.questoes.submetidas))
print("")
print(paste("Tamanho da Base em Linhas:", nrow(dados.quantidade.questoes.submetidas)))
print(paste("Quantidade de Alunos que Submeteram Exercicios:", length(unique(dados.quantidade.questoes.submetidas$matricula))))

dados.quantidade.questoes.submetidas = dados.quantidade.questoes.submetidas[dados.quantidade.questoes.submetidas$nota == 10.0, ]
print("")
print("")
print("")
print("Filtrando a Base para Considerar apenas os Exercicios Submetidos Corretamente")
print("")
print("")
print("")
print(paste("Tamanho da Base em Linhas:", nrow(dados.quantidade.questoes.submetidas)))
print(paste("Quantidade de Alunos que Submeteram Exercicios:", length(unique(dados.quantidade.questoes.submetidas$matricula))))

#print(as.factor(sort(dados.quantidade.questoes.submetidas[, "matricula"])))

dados.questoes.submetidas.histogram = ddply(dados.quantidade.questoes.submetidas, .(matricula), nrow)
colnames(dados.questoes.submetidas.histogram) = c("matricula", "qtd")
dados.questoes.submetidas.histogram = dados.questoes.submetidas.histogram[with(dados.questoes.submetidas.histogram, order(qtd)), ]
dados.questoes.submetidas.histogram$label = 1:nrow(dados.questoes.submetidas.histogram)
# print(dados.questoes.submetidas.histogram)


png("Histograma - Aluno x Quantidade.png", width=720, height=720)
#hist(as.factor(sort(dados.quantidade.questoes.submetidas[, "matricula"])))
#histogram(as.factor(sort(dados.quantidade.questoes.submetidas[, "matricula"])))
plot(dados.questoes.submetidas.histogram$label, dados.questoes.submetidas.histogram$qtd, type="h", include.lowest=T, labels=T, main="Quantidade de Exercicios Submetidos Corretamente por Aluno",
          xlab="Aluno", ylab="Quantidade Exercicios Submetidos Corretamente")
dev.off()


ajeitar.nota = function(string) {
  return(as.double(paste(substr(string, 1, 1), ".", substr(string, 3, 3), sep="")))
}

imprime.hist.prova = function(filename, label) {
  dados.prova = read.csv(filename)
  print("Colunas da Base:")
  print(colnames(dados.prova))
  print("")
  print(paste("Tamanho da Base em Linhas:", nrow(dados.prova)))
  
  
  
  dados.prova[dados.prova$Nota == "#VALUE!" | dados.prova$Nota == "", "Nota"] = NA
  dados.prova$Nota = ajeitar.nota(dados.prova$Nota)
#   print(dados.prova[, "Nota"])
  
  
#   hist(dados.prova[, "Nota"], breaks=10, include.lowest=T, labels=T, main=label,
#        xlab="Nota na Prova", ylab="Quantidade Alunos")
  ggplot(dados.prova, aes(x=Nota)) + geom_histogram(colour="black", fill="white", binwidth = 0.5) +
    xlab("Nota na Prova") + ylab("Número de Alunos") +
    opts(title=label)
}

# png("Histograma - Notas nas Provas.png", width=720, height=720)
# par(mfrow = c(1,3))
# imprime.hist.prova("../Dados/Prova2.csv", "Alunos que Obtiveram tal Nota na Prova 2")
png("Histograma - Notas na Prova 1.png", width=250, height=300)
imprime.hist.prova("../Dados/Prova1.csv", "Notas Obtidas na Prova 1")
dev.off()
png("Histograma - Notas na Prova 2.png", width=250, height=300)
imprime.hist.prova("../Dados/Prova2.csv", "Notas Obtidas na Prova 2")
dev.off()
png("Histograma - Notas na Prova 3.png", width=250, height=300)
imprime.hist.prova("../Dados/Prova3.csv", "Notas Obtidas na Prova 3")
dev.off()
