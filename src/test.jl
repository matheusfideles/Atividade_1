include("matrices.jl")
include("systems.jl")
using Plots, LaTeXStrings, DataFrames

#Retorna a matriz com os números de condições de cada problema para valores dados de n no vetor dim
#entrada (i,j) -> numero de condição do problema i com dimensão j
function cond_table(dim)
    n=size(dim,1)
    cond_matrix=zeros(9,n)
    #Preenchendo a matriz
    for i=1:9
        for j=1:n
            cond_matrix[i,j]=round(conditionNumber(i,dim[j]),digits=2)
        end
    end
    #Tratativa dos dados na matriz
    df=DataFrame(Tables.table(cond_matrix))
    newname=dim
    rename!(df,Symbol.(newname))
    return df
end

#Gráficos de dispersão para erro relativo
function scatter_error(x,y,prob,m)
    plot(x,[y[j] for j=1:m],label=["LU com Piv. Parcial" "LU" "Cholesky" "Inversa"])
    title!("Problema ("*Char(64+prob)*")")
    xlabel!(L"$n$")
    ylabel!(L"$\frac{||x-x^*||}{||x^*||}$")
    savefig("images/Problema ("*Char(64+prob)*") - Erros.png")
end

#Gráficos de dispersão para resíduo relativo
function scatter_residue(x,y,prob,m)
    plot(x,[y[j] for j=1:m],label=["LU com Piv. Parcial" "LU" "Cholesky" "Inversa"])
    title!("Problema ("*Char(64+prob)*")")
    xlabel!(L"$n$")
    ylabel!(L"$\frac{||Ax-b||}{||b||}$")
    savefig("images/Problema ("*Char(64+prob)*") - Resíduos.png")
end

#Gráficos de dispersão para tempo
function scatter_time(x,y,prob,m)
    p=plot(x,[y[j] for j=1:m],label=["LU com Piv. Parcial" "LU" "Cholesky" "Inversa"])
    title!("Problema ("*Char(64+prob)*")")
    xlabel!(L"$n$")
    ylabel!(L"$Tempo (s)$")
    savefig("images/Problema ("*Char(64+prob)*") - Tempos.png")
end

#Gráficos de reta/dispersão para um dado método com o desempenho de tempo do algoritmo, residuo e erro relativo para um conjunto de dimensões n
function plot_lines(dim)
    #Eixo x do gráfico são as dimensões
    met=["plu","lu","chol","inv"]
    n=size(dim,1)
    m=size(met,1)

    #Alocando matrizes com valores de y para cada gráfico
    #Tempos -> entrada (i,j) nos dá o tempo de resolução do problema i de dimensão j
    #erros/residuos -> entrada (i,j) nos dá o erro relativo/residuo relativo obtido ao resolver o problema i de dimensão j
    tempos=zeros(n,m)
    erros=zeros(n,m) 
    residuos=zeros(n,m)
    resp=zeros(n,3,m)

    #Calculando os erros, resíduos e tempos -> para cada problema e variamos o método (que vai ser entendido como uma curva)
    #Fazendo só com matriz simétrica, no momento
    for i=1:9
        resp=resultMatrix(i,dim,met,true)  
        erros=[resp[:,1,k] for k=1:m]
        residuos=[resp[:,2,k] for k=1:m]
        tempos=[resp[:,3,k] for k=1:m]
        #Construindo e salvando os gráfico como imagens
        scatter_error(dim,erros,i,m)
        scatter_residue(dim,residuos,i,m)
        scatter_time(dim,tempos,i,m)
    end
end