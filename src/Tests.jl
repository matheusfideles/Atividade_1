include("Matrices.jl")
include("Systems.jl")
using Plots, LaTeXStrings, DataFrames, PrettyTables

#Retorna o resultado do i-ésimo problema (Com A Simétrica ou não) para cada dimensão em n_conj e metodos no vetor metodos
#Recebe: i -> indice do problema e n_conj -> conjunto contendo os valores de n que queremos testar
#metodo -> Métodos que vamos resolver o problema  simet ->  flag se A é simetrica ou não
#Retorna: Erro relativo, resíduo e tempo de resolução para cada valor de n informado, informação é disposta em um tensor 
function resultMatrix(i,n_conj=[2,5,10,100,1000,10000],metodos=["plu","lu","chol","inv"],simet=true)
    #Matriz para armazenar as respostas
    #n linhas para cada dimensão, 3 colunas, nessa ordem, erro resíduo e tempo
    #m matrizes representando cada método
    m=length(metodos); n=length(n_conj)
    resp=zeros(n,3,m)

    #Iterando para cada dimensão
    for j in eachindex(n_conj)
        A=testMatrix(i,n_conj[j],simet) #Matriz A do sistema
        b,x_resp=testb(A) #Vetor b de Ax=b e solução b=Ax^*
        for k in eachindex(metodos)
            if metodos[k]=="inv"
                tempo=@elapsed x=solveInverse(A,b) #Armazenando tempo de achar inversa + resolver o sistema.
            else
                #Armazenando o tempo de achar a fatoração e resolver o sistema
                tempo=@elapsed begin
                    factor=getFactorization(A, metodos[k])
                    x=solveSystem(factor,b)
                end
            end
            erro=norm(x-x_resp)/norm(x_resp)#Erro relativo
            resid=norm(A*x-b)/norm(b) #Resíduo relativo
            resp[j,:,k].=[erro,resid,tempo]
        end
    end
    return resp
end