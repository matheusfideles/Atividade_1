include("matrices.jl")
using LinearAlgebra, DataFrames, Latexify, PrettyTables

#Função que retorna a inversa de uma matriz A usando fatoração PLU/Cholesky
function findInverse(A)
   #Dimensão da matriz, Alocando a inversa, vetor da base canonica e obtendo a fatoração
   n=size(A,1); inv=zeros(n,n); b=zeros(n,1)
   factor, opt_s=getFactorization(A,"chol") #tenta achar cholesky de A
   #Resolvendo cada um dos sistemas e preenchendo as colunas da inversa
   for i=1:n 
      b[i]=1; #Atualizando a coordenada do i-esimo vetor da base canonica
      inv[:,i]=solveSystem(factor,b,opt_s); #Tenta resolver usando cholesky
      b[i]=0; #Zerando a entrada para a próxima iteração
   end
   return inv
end

#função resolve o sistema Ax=b e retorna a solução única
#Usa a fatoração da matriz descrita por factor e opt, ambas informações são argumentos de entrada
function solveSystem(factor,b,opt="plu")
   #Variáveis e vetores prealocados
   n=size(b); x=zeros(n);
   #Considerando o caso LU\PLU\Cholesky
   if opt != "inv"
      b_aux=b; y=zeros(n)
      U=factor.U; L=factor.L
      #Checando a fatoração utilizada e ajustando o vetor b se necessário
      if opt=="plu"
         b_aux=b[factor.p]
      end
      y=L\b_aux; x=U\y
   else #Caso de resolver com a inversa -> factor=A
      x=findInverse(factor)*b
   end
   return x
end

#Recebe: i -> indice do problema e n_conj -> conjunto contendo os valores de n que queremos testar, método, flag se é simetrica ou não
#Retorna: Erro relativo, resíduo e tempo de resolução para cada valor de n informado, informação é disposta em uma matriz  
function resultMatrix(i,n_conj,metodos=["plu","lu","chol","inv"],simet=true)
   #Matriz para armazenar os valores]
   n=size(n_conj,1)
   m=size(metodos,1)
   resp=zeros(n,3,m)

   #Iterando para cada problema/metodo e resolvendo
   for j=1:n
      #Gerando matrizes e vetores do problema
      A=testMatrix(i,n_conj[j],simet)
      x_opt=2*rand(n_conj[j],1).-1; b=A*x_opt #x* para o problema e vetor b
      x=zeros(n_conj[j]); errox=0; erroAx=0; tempo=0  #Vetores auxiliares para armazenar o ponto obtido, erros, resíduos e tempo
      for k=1:m
         if metodos[k]=="inv"
            #Armazena o tempo de achar inversa + resolver sistema
            tempo=@elapsed x=solveSystem(A,b,metodos[k])
            #Calculando erro e resíduo e colocando na matriz
            errox=norm(x-x_opt)/norm(x_opt)
            erroAx=norm(A*x-b)/norm(b)
            resp[j,:,k].=[errox,erroAx,tempo]
         else
            #Armazena o tempo de achar a fatoração e resolver o sistema
            tempo=@elapsed begin
               factor,opt_s=getFactorization(A,metodos[k])
               x=solveSystem(factor,b,opt_s)
            end
            #Erros e anexando na matriz
            errox=norm(x-x_opt)/norm(x_opt)
            erroAx=norm(A*x-b)/norm(b)
            resp[j,:,k].=[errox,erroAx,tempo]
         end
      end
   end
   return resp
end