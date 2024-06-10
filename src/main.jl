include("test.jl")

#Dados
metodos=["plu","lu","chol","inv"]
#prob=[1 2 3 4 5 9]
dim=[10,50,100,500,1000,1500,2000,2500,3000,3500,4000,4500,5000]

#Função para plotar todos os gráficos
function run(metodos,dim)
    #Gráficos comparando LU com Cholesky
    for i in [1,3,4,5,9]
        plot_times(i,dim,["plu","chol"])
    end

    #Gráficos de tempos de todo mundo
    for i in [1,3,4,5,9]
        plot_times(i,dim,metodos)
    end
    plot_times(2,dim,["plu","lu","chol"])

    #Gráficos de erros de todo mundo
    for i in [1,3,4,5,9]
        scatter_error(i,dim,metodos)
    end
    scatter_error(2,dim,["plu","lu","chol"])

    #Gráficos de residuos de todo mundo
    for i in [1,3,4,5,9]
        scatter_residue(i,dim,metodos)
    end
    scatter_residue(2,dim,["plu","lu","chol"])
end