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

#Função que plota os tempos para cada problema de teste com um conjunto de dimensões dado e um método específico
function plot_times_all(dim,met)
    #Iterando para cada problema
    tempo=[]
    for i=1:9
        resp=resultMatrix(i,dim,[met])
        push!(tempo,resp[:,3,1])
    end

    #Arrumando label do gráfico
    if met=="inv"
        metodo="Inversa"
    elseif met=="plu"
        metodo="LU com Piv Parcial"
    elseif met=="lu"
        metodo="LU"
    else
        metodo="Cholesky"
    end

    #Criando o gráfico e salvando
    plot(dim,tempo,label=["A" "B" "C" "D" "E" "F" "G" "H" "I"])
    xlabel!(L"$n$")
    ylabel!(L"$Tempo (s)$")
    savefig("images/Tempos - Todos os prob - "*metodo)
end

#Função que plota os tempos na resolução do i-esimo problema com os métodos dados para um conjunto de dimensões
function plot_times(i,dim,met)
    m=size(met,1)
    metodos=Matrix{String}(undef,1,m)
    for i=1:m
        if met[i]=="inv"
            metodos[i]="Inversa"
        elseif met[i]=="plu"
            metodos[i]="LU com Piv. Parcial"
        elseif met[i]=="lu"
            metodos[i]="LU"
        else
            metodos[i]="Cholesky"
        end
    end

    #Alocando tempos
    n=size(dim,1)
    tempos=zeros(n,1)

    #Obtendo os dados
    resp=resultMatrix(i,dim,met,true)
    tempos=resp[:,3,1:m]

    #Construindo o gráfico
    plot(dim,[tempos[:,j] for j=1:m],label=metodos)
    xlabel!(L"$n$")
    ylabel!(L"$Tempo (s)$")
    savefig("images/Tempos - Metodos")
end