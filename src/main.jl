include("test.jl")
using Suppressor

#Dados
metodos=["plu","lu","chol","inv"]
prob=[1 2 3 4 5 9]
dim=[10,50,100,1000,2000,3000,4000,5000]

#Função para plotar os resultados
function run(metodos,dim)
    prob=[1 2 3 4 5 9]; df=[]
    #Escrevendo as tabelas em um arquivo de texto
    open("output.txt","w") do io
        for i in [1 3 4 5 9]
            df=tables(i,dim,metodos)
            for j=1:3
                latex_tab=@capture_out pretty_table(df[j];backend=Val(:latex))
                write(io,latex_tab)
                write(io,'\n')
            end
        end
    end
end

#Função para plotar todos os gráficos
#=function run(metodos,dim)
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
end=#