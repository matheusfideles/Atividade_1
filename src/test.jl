include("matrices.jl")
include("systems.jl")
using Plots, LaTeXStrings, DataFrames

#a=[5,10,50,100,150,200,250,300,350,400,450,500,600,700,800,900]
#b=[i for i=1000:1000:10000]
#dim=vcat(a,b)

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

#Gráficos de dispersão do residuo relativo para um conjunto de métodos e problema fixo
function scatter_residue(i,dim,met=["plu" "lu" "chol" "inv"])
    m=size(met,1); resp=resultMatrix(i,dim,met)
    
    #Arrumando label do gráfico
    metodos=[]
    for i=1:m
        if met[i]=="inv"
            push!(metodos,"Inversa")
        elseif met[i]=="plu"
            push!(metodos,"LU com Piv Parcial")
        elseif met[i]=="lu"
            push!(metodos,"LU")
        else
            push!(metodos,"Cholesky")
        end
    end
    
    #Vetores dos residuos
    residuo=[]
    for i=1:m
        push!(residuo,resp[:,2,i])
    end

    #Plotando o gráfico
    scatter(dim,residuo,label=metodos)
    xlabel!(L"$n$")
    ylabel!(L"\frac{||Ax-||}{||x^*||}")
    savefig("images/Residuos - Metodos")
end

#Gráficos de dispersão do erro relativo para um conjunto de métodos e problema fixo
function scatter_error(i,dim,met=["plu","lu","chol","inv"])
    m=size(met,1); resp=resultMatrix(i,dim,met)
    
    #Arrumando label do gráfico
    metodos=[]
    for i=1:m
        if met[i]=="inv"
            push!(metodos,"Inversa")
        elseif met[i]=="plu"
            push!(metodos,"LU com Piv Parcial")
        elseif met[i]=="lu"
            push!(metodos,"LU")
        else
            push!(metodos,"Cholesky")
        end
    end
    metodos=reshape(metodos,(1,m))
    
    #Vetores dos residuos
    erro=[]
    for i=1:m
        push!(erro,resp[:,1,i])
    end

    #Plotando o gráfico
    scatter(dim,erro,label=metodos,legend=:topleft)
    xlabel!(L"$n$")
    ylabel!(L"\frac{||x-x^*||}{||x^*||}")
    savefig("images/Erros - Metodos - Prob ("*Char(64+i)*")")
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
    scatter(dim,tempo,label=["A" "B" "C" "D" "E" "F" "G" "H" "I"])
    xlabel!(L"$n$")
    ylabel!(L"$Tempo (s)$")
    savefig("images/Tempos - Todos os prob - "*metodo)
end

#Função que plota os tempos na resolução do i-esimo problema com os métodos dados para um conjunto de dimensões
function plot_times(i,dim,met)
    m=size(met,1); metodos=Matrix{String}(undef,1,m)
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
    scatter(dim,[tempos[:,j] for j=1:m],label=metodos)
    xlabel!(L"$n$")
    ylabel!(L"$Tempo (s)$")
    savefig("images/Tempos - Metodos")
end