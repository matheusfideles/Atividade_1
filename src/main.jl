include("Tests.jl")
include("Graphs.jl")
using Suppressor

#Dados - dimensões
dim=[2,5,10,50]

#Função para rodar todos os testes planejados e obter os resultados com as dimensões dadas
function main(dim)
    metodos=["plu","lu","chol","inv"]; metodos_sc=["plu","lu","inv"]
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