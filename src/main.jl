include("test.jl")
#Função para plotar todos os gráficos
function main()
    dim=[100,500,750,1000]

    #Tempo da Inversa - todos os problemas
    #plot_times_all(dim,"inv")

    #Gráficos para os demais métodos
    for i=1:1
        #Tempos dos demais métodos - LU, Chol e PLU
        #plot_times(i,dim,["plu","lu","chol","inv"])
        plot_times(i,dim,["inv","lu"])
        scatter_error(i,dim,["inv","lu"])
        scatter_residue(i,dim,["inv","lu"])

        #Erros para cada problema
        #scatter_error(i,dim,["plu","lu","chol","inv"])
        #scatter_error(i,dim,["plu","lu"])

        #Resíduos para cada problema - tudo menos inversa
        #scatter_residue(i,dim,["plu","lu","chol","inv"])
        #scatter_residue(i,dim,["plu","lu"])

        #Erro e residuo para inversa
        #scatter_error(i,dim,["inv"])
        #scatter_residue(i,dim,["inv"])
    end
end