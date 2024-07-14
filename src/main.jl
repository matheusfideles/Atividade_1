include("Tests.jl")
include("Graphs.jl")
include("Table.jl")

#Dados - dimensões
dim=[2,5,10,50]

#Função para rodar todos os testes planejados e obter os resultados com as dimensões dadas
function graph_all(dim)
    metodos=["plu","lu","chol"]; metodos_sc=["plu","lu"]
    #Separando os que podemos usar cholesky
    for i in [1,3,4,5,6,8,9]
        resp=resultMatrix(i,dim,metodos,true)
        disp_tempo_main(i,true,resp,metodos,dim)
        disp_erro(i,true,resp,metodos,dim)
        disp_residuo(i,true,resp,metodos,dim)
    end

    #Demais problemas que excluimos
    for i in [2,7]
        for simet in [true, false]
            resp=resultMatrix(i,dim,metodos_sc,simet)
            disp_tempo_main(i,simet,resp,metodos_sc,dim)
            disp_erro(i,simet,resp,metodos_sc,dim)
            disp_residuo(i,simet,resp,metodos_sc,dim)
        end
    end

    #Os mesmos problemas que usamos cholesky anteriormente, mas assimétrico
    for i in [1,3,4,5,6,8,9]
        resp=resultMatrix(i,dim,metodos_sc,false)
        disp_tempo_main(i,false,resp,metodos_sc,dim)
        disp_erro(i,false,resp,metodos_sc,dim)
        disp_residuo(i,false,resp,metodos_sc,dim)
    end
end

#time_table([2,5,10,100,1000,2000],["plu","lu","chol","inv"])
graph_all([100,200,300,400,500,600,700,800,900,1000])