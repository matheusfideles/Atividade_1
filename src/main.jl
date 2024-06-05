include("test.jl")
#Função para plotar todos os gráficos
function main()
    metodos=["plu","lu","chol","inv"]
    prob=[1 2 3 4 5 9]
    dim=[10,100,500,750,1000]

    #Gráficos para os demais métodos
    for i in prob
        plot_times(i,dim,metodos)
        scatter_error(i,dim,metodos)
        scatter_residue(i,dim,metodos)
    end

    for j in metodos
        plot_times_all(prob,dim,j)
    end
end