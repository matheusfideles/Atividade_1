include("test.jl")
#Função para plotar todos os gráficos
function main()
    dim=[10,100,500,750,1000,2500,5000,7500,10000]
    #dim=[i for i=100:100:900]

    #Tempo da Inversa - todos os problemas
    plot_times_all(dim,"inv")

    #Gráficos para os demais métodos
    for i=1:1
        #Tempos dos demais métodos - LU, Chol e PLU
        plot_times(i,dim,["plu","chol"])
        plot_times(i,dim,["lu"])

        #Erros para cada problema
        scatter_error(i,dim,["plu","chol"])
        scatter_error(i,dim,["lu"])

        #Resíduos para cada problema - tudo menos inversa
        scatter_residue(i,dim,["plu","chol"])
        scatter_residue(i,dim,["lu"])

        #Erro e residuo para inversa
        scatter_error(i,dim,["inv"])
        scatter_residue(i,dim,["inv"])
    end
end