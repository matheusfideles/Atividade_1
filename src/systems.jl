include("Matrices.jl")
using LinearAlgebra, DataFrames

#Função que resolve um sistema linear Ax=b a partir de uma fatoração factor
#Checamos se é PLU ou LU vendo se existe matriz de permutação na struct factor
function solveSystem(factor, b)
   if typeof(factor)==LU{Float64, Matrix{Float64}, Vector{Int64}} #Checando se é LU
      #Resolvendo os sistemas triangulares, Julia faz a forward/back substitution automatico
      y=\(factor.L,b[factor.p]); x=\(factor.U,y) 
   else #Se não, é por Cholesky
      y=\(factor.L,b); x=\(factor.U,y)
   end
   return x
end

#Função que encontra a inversa de uma matriz A usando a fatoração PLU ou Cholesky
function findInverse(A)
   factor=nothing
   try #Tentamos achar Cholesky primeiro
      factor=getFactorization(A,"chol")
   catch e #Se não for possível, nos contentamos com usar plu
      factor=getFactorization(A,"plu")
   end
   
   #Resolvendo os sistemas da forma Ax=e_i para encontrar as colunas da inversa
   n=size(A,2); e_i=zeros(n); inv=zeros(n,n)
   for i=1:n
      e_i[i]=1
      inv[:,i]=solveSystem(factor,e_i)
      e_i[i]=0
   end

   return inv
end

#Função que recebe a inversa um sistema pela inversa
function solveInverse(A,b)
   return findInverse(A)*b
end