include("Matrices.jl")
include("Tests.jl")
include("Graphs.jl")
using Tables, DataFrames, PrettyTables, Suppressor, Printf

#Tabela de tempos para todos os métodos com base em um conjunto de n's em um problema
#Vai ser usada só para colocar no inicio do relatório que não trabalharemos tanto com a inversa pois é caro
function time_table(dim, metodos)
    #Problemas que vamos avaliar
    prob=[1,3,4,5,6,8,9]

    #Rodando todos os problemas e Salvando
    respAll=[resultMatrix(i,dim,metodos,true) for i in prob]
    
    #Cabeçalho da tabela
    header=["n"]; metodos=renomearEixo(metodos)
    for met in metodos
        push!(header, met) 
    end

    #Montando cada uma das matrizes que vamos passar para tabela
    m=length(dim); n=length(metodos)
    matricesAll=[]
    for i in eachindex(respAll)
        tempos=zeros(m,n+1)
        tempos[:,1]=dim
        for j in eachindex(metodos)
            tempos[:,j+1]=respAll[i][:,3,j]
        end
        push!(matricesAll,tempos) #Colocando dim na primeira coluna
    end

    #Passando essas matrizes para Dataframe
    matricesAll=[DataFrame(matricesAll[i],Symbol.(header)) for i in eachindex(matricesAll)]

    #Passando a primeira coluna para inteiro
    for i in eachindex(matricesAll)
        matricesAll[i].n=Int.(matricesAll[i].n)
    end
    
    #Passando as demais entradas para notação científica
    for col in names(matricesAll[1])[2:end]
        for i in eachindex(matricesAll)
            matricesAll[i][!,col]=string.(@sprintf("%.3e", x) for x in matricesAll[i][!,col])
        end
    end

    #Salvando tudo em um arquivo de texto
    open("Output.txt","w") do io
        for i in eachindex(matricesAll)
            write(io,"Problema ("*Char(64+prob[i])*") - Tempos\n")
            latex_tab=@capture_out pretty_table(matricesAll[i],backend=Val(:latex),header=names(matricesAll[i]))
            write(io,latex_tab); write(io,'\n')
        end
    end
end