include("test.jl")
using Suppressor

#Dados - dimensões
dim=[10,50,100,500,1000,2000,3000,4000,5000,6000,7000]

#Função para plotar os testes planejados e obter os resultados com as dimensões dadas
function run_tables(dim)
    prob=[1 2 3 4 5 9]; df=[]; metodos=["plu","lu","chol","inv"]
    #Escrevendo as tabelas em um arquivo de texto
    open("output.txt","w") do io
        for i in [1 3 4 5 9]
            df=tables(i,dim,metodos)
            write(io,"Problema ("*Char(64+i)*") \n")
            for j=1:3
                latex_tab=@capture_out pretty_table(df[j], backend=Val(:latex), header=(names(df[j])))
                write(io,latex_tab)
                write(io,'\n')
            end
        end
        #Para o problema 2 não dá pra usar cholesky
        df=tables(2,dim,["plu","lu","inv"])
        write(io,"Problema (B) \n")
        for j=1:3
            latex_tab=@capture_out pretty_table(df[j], backend=Val(:latex))
            write(io,latex_tab)
            write(io,'\n')
        end
    end
end

#run_tables(dim)

#=function run_graphics(dim)
    prob=[1 2 3 4 5 9]; df=[]; metodos=["plu","lu","chol"]
    for i in [1 3 4 5 9]
        scatter_error(i,dim,metodos)
        scatter_residue(i,dim,metodos)
        scatter_time(i,dim,metodos)
    end
    scatter_error(2,dim,["plu","lu"])
    scatter_residue(2,dim,["plu","lu"])
    scatter_time(2,dim,["plu","lu"])
end=#

#run_tables(dim)

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