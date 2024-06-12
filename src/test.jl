include("matrices.jl")
include("systems.jl")
using Plots, LaTeXStrings, DataFrames, PrettyTables

#a=[10,50,100,200,300,400,450,500,600,700,800,900]
#b=[1000,2500,5000,10000]
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

#Retorna tabelas, para um dado problema, rodando com as dimensões e métodos informados
function tables(i,dim,met)
    n=length(dim); m=length(met)
    resp=resultMatrix(i,dim,met)
    time_matrix=zeros(n,m); error_matrix=zeros(n,m); residue_matrix=zeros(n,m)

    #Obtendo as colunas
    for j=1:m
        error_matrix[:,j]=resp[:,1,j] 
        residue_matrix[:,j]=resp[:,2,j]
        time_matrix[:,j]=resp[:,3,j]
    end

    #Tratativa dos dados
    dfe=DataFrame(Tables.table(error_matrix))
    dfr=DataFrame(Tables.table(residue_matrix))
    dft=DataFrame(Tables.table(time_matrix))
    
    #Ajustando os nomes das colunas
    newname=[]
    for j=1:m
        if met[j]=="plu"
            push!(newname,"LUP")
        elseif met[j]=="lu"
            push!(newname,"LU")
        elseif met[j]=="inv"
            push!(newname,"Inv.")
        elseif met[j]=="chol"
            push!(newname,"Chol.")
        end
    end

    rename!(dfe,Symbol.(newname)); rename!(dfr,Symbol.(newname)); rename!(dft,Symbol.(newname))
    return dfe, dfr, dft
end

#tabela dos residuos
function residue_table(i,dim,met)
    n=length(dim); m=length(met)
    resp=resultMatrix(i,dim,met)
    residue_matrix=zeros(n,m)

    #Obtendo as colunas
    for j=1:m
        residue_matrix[:,j]=resp[:,2,j]
    end

    #Tratativa dos dados
    df=DataFrame(Tables.table(residue_matrix))
    
    #Ajustando os nomes das colunas
    newname=[]
    for j=1:m
        if met[j]=="plu"
            push!(newname,"LUP")
        elseif met[j]=="lu"
            push!(newname,"LU")
        elseif met[j]=="inv"
            push!(newname,"Inv.")
        elseif met[j]=="chol"
            push!(newname,"Chol.")
        end
    end

    rename!(df,Symbol.(newname))
    pretty_table(df;backend=Val(:latex))
    return df
end

#Tabela dos erros
function error_table(i,dim,met)
    n=length(dim); m=length(met)
    resp=resultMatrix(i,dim,met)
    error_matrix=zeros(n,m)

    #Obtendo as colunas
    for j=1:m
        error_matrix[:,j]=resp[:,1,j]
    end

    #Tratativa dos dados
    df=DataFrame(Tables.table(error_matrix))
    
    #Ajustando os nomes das colunas
    newname=[]
    for j=1:m
        if met[j]=="plu"
            push!(newname,"LUP")
        elseif met[j]=="lu"
            push!(newname,"LU")
        elseif met[j]=="inv"
            push!(newname,"Inv.")
        elseif met[j]=="chol"
            push!(newname,"Chol.")
        end
    end

    rename!(df,Symbol.(newname))
    pretty_table(df;backend=Val(:latex))
    return df
end

#Gráficos de dispersão do residuo relativo para um conjunto de métodos e problema fixo
function scatter_residue(i,dim,met=["plu","lu","chol","inv"])
    m=size(met,1); resp=resultMatrix(i,dim,met)
    #String para separar os arquivos na hora de gerar os gráficos e não ir sobreescrevendo
    aux=""
    for i=1:m
       aux=aux*met[i]*" " 
    end

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
    residuo=[]
    for i=1:m
        push!(residuo,resp[:,2,i])
    end

    #Plotando o gráfico
    scatter(dim,residuo,label=metodos,legend=:topleft)
    xlabel!(L"$n$")
    ylabel!(L"\frac{||Ax-b||}{||b||}")
    savefig("images/Residuos - Metodos - Prob ("*Char(64+i)*") - "*aux)
end

#Gráficos de dispersão do erro relativo para um conjunto de métodos e problema fixo
function scatter_error(i,dim,met=["plu","lu","chol","inv"])
    m=size(met,1); resp=resultMatrix(i,dim,met)
    #String para separar os arquivos na hora de gerar os gráficos e não ir sobreescrevendo
    aux=""
    for i=1:m
       aux=aux*met[i]*" " 
    end

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
    savefig("images/Erros - Metodos - Prob ("*Char(64+i)*") - "*aux)
end

#Função que plota os tempos para dados problemas com um conjunto de dimensões dado e um método específico
function plot_times_all(prob,dim,met)
    #Iterando para cada problema
    tempo=[]
    for i in prob
        resp=resultMatrix(i,dim,[met])
        push!(tempo,resp[:,3,1])
    end

    #Arrumando nome do png do gráfico
    if met=="inv"
        metodo="Inversa"
    elseif met=="plu"
        metodo="LU com Piv Parcial"
    elseif met=="lu"
        metodo="LU"
    else
        metodo="Cholesky"
    end

    #Arrumando label
    probLetra=[Char(64+i) for i in prob]

    #Criando o gráfico e salvando
    scatter(dim,tempo,label=probLetra)
    xlabel!(L"$n$")
    ylabel!(L"$Tempo (s)$")
    savefig("images/Tempos - Todos os prob - "*metodo)
end

#Função que plota os tempos na resolução do i-esimo problema com os métodos dados para um conjunto de dimensões
function plot_times(i,dim,met=["plu","lu","chol","inv"])
    m=size(met,1); metodos=Matrix{String}(undef,1,m)

    #String para separar os arquivos na hora de gerar os gráficos e não ir sobreescrevendo
    aux=""
    for i=1:m
       aux=aux*met[i]*" " 
    end

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
    display(resp)
    tempos=resp[:,3,1:m]
    display(tempos)

    #Construindo o gráfico
    scatter(dim,[tempos[:,j] for j=1:m],label=metodos)
    xlabel!(L"$n$")
    ylabel!(L"$Tempo (s)$")
    savefig("images/Tempos - Metodos - ("*Char(64+i)*") - "*aux)
end