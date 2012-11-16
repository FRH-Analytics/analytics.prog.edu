library(ggplot2)

dados.exercicios.submetidas = read.csv("../Dados/exercicios-20112.csv")
dados.exercicios.submetidas = dados.exercicios.submetidas[dados.exercicios.submetidas$nota == 10.0, ]

png("UC1-Histograma-Exercicios Submetidos Corretamente.png", width=600, height=300)
ggplot(dados.exercicios.submetidas, aes(x=questao)) + geom_histogram(colour="white", fill="#56B4E9", binwidth=1) +
  xlab("Questão do Exercício") + ylab("Quantidade de Submissões Corretas") + 
  scale_y_continuous(breaks=seq(0, 150, 10)) +
  theme(panel.grid.minor = element_blank(), panel.background = element_blank())
dev.off()

ajeitar.nota = function(string) {
  return(as.double(paste(substr(string, 1, 1), ".", substr(string, 3, 3), sep="")))
}

get.prova = function(filename, prova, questao1, questao2, questao3, questao4) {
  dados.prova = read.csv(filename)
  
  dados.prova$questao1 = ajeitar.nota(dados.prova[, questao1])
  dados.prova$questao2 = ajeitar.nota(dados.prova[, questao2])
  dados.prova$questao3 = ajeitar.nota(dados.prova[, questao3])
  dados.prova$questao4 = ajeitar.nota(dados.prova[, questao4])
  
  quantidade.questoes.corretas = data.frame(questao=c(), qtd=c(), sum.notas=c())
  
  for (i in 1:4) {
    qtd = 0
    sum.notas = 0
    
    for (j in 1:nrow(dados.prova))
      if (!is.na(dados.prova[j, paste("questao", i, sep="")])) {
        sum.notas = sum.notas + dados.prova[j, paste("questao", i, sep="")]
        qtd = qtd + 1
      }
    
    q = c()
    for (k in 1:qtd)
      q[k] = paste("", i, sep="")
    
    quantidade.questoes.corretas = rbind(quantidade.questoes.corretas, data.frame(questao=q, qtd=qtd, sum.notas=sum.notas))
  }
  
  quantidade.questoes.corretas$prova = paste("Prova", prova)
  
  return(quantidade.questoes.corretas)
}

provas = get.prova("../Dados/Prova1.csv", 1, "X86", "X87", "X88", "X89")
provas = rbind(provas, get.prova("../Dados/Prova2.csv", 2, "X165", "X166", "X167", "X168"))
provas = rbind(provas, get.prova("../Dados/Prova3.csv", 3, "X191", "X192", "X193", "X194"))

png("UC1-Histograma-Questoes das Provas Submetidas Corretamente.png", width=600, height=300)
ggplot(provas, aes(x=questao, y=sum.notas / qtd)) + geom_histogram(colour="white", fill="#56B4E9", binwidth = 1) +
  xlab("Questão") + ylab("Média da Turma") +
  ylim(1, 10) + scale_y_continuous(breaks=seq(0, 10, 1)) +
  theme(panel.grid.minor = element_blank(), panel.background = element_blank()) +
  facet_grid(. ~ prova)
dev.off()
