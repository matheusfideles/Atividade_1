using LinearAlgebra

#Função referente à primeira questão, recebe i alternativa e n dimensao
function diagMatrix(i,n)
    D=zeros(n,n);
    k=0;
    #vendo qual alternativa
    if i==1
        for i=1:n
            D[i,i]=1.001^i
        end
    elseif i==2
        for i=1:n
            D[i,i]=(-1.001)^i
        end
    elseif i==3 
        for i=1:n
            k=floor(i/10)
            D[i,i]=k/100+1
        end
    elseif i==4
        for i=1:n
            k=floor(i/10)
            D[i,i]=k+1
        end
    elseif i==5 
        for i=1:n
            k=floor(i/10)
            D[i,i]=k+(1.0001)^i
        end
    elseif i==6
        for i=1:n
            k=floor(i/10)
            D[i,i]=10*k+1
        end
    elseif i==7
        for i=1:n
            k=floor(i/10)
            D[i,i]=(-1)^i*10*k+1
        end
    elseif i==8
        for i=1:n
            k=floor(i/10)
            D[i,i]=100*k+1
        end
    else
        for i=1:n
            k=floor(i/10)
            D[i,i]=1000*k+1
        end
    end
    return D
end

#Retorna o numero de condição na norma 2 das matrizes de testes sabendo os autovalores
#cond=lambda_max/lambda_min
function conditionNumber(i,n)
    kmax=floor((n)/10)
    if i==1 || i==2
        return 1.001^n/1.001
    elseif i==3
        return kmax/100+1
    elseif i==4
        return kmax+1
    elseif i==5
        return (kmax+1.0001^n)/1.0001
    elseif i==6
        return 10*kmax+1
    elseif i==7
        return abs((-1)^n*10*kmax+1)
    elseif i==8
        return 100*kmax+1
    else
        return 1000*kmax+1
    end
end

#Gera uma matriz aleatória nxn com entradas em [-M,M]
function randSqMatrix(n)
    M=999 
    return 999*(2*rand(n,n).-1)
end

#Retorna a matriz A do problema, que pode ser simétrica ou não
#Recebendo a diagonal da i-esima alternativa e a dimensão n da matriz quadrada
function testMatrix(i,n,simet=true)
    M=randSqMatrix(n); M_qr=qr(M)
    if simet #caso de ser simétrica
        A=Symmetric(M_qr.Q*diagMatrix(i,n)*M_qr.Q')
    else #Caso de não ser simétrica
        N=randSqMatrix(n); N_qr=qr(N)
        A=M_qr.Q*diagMatrix(i,n)*N_qr.Q'
    end
    return A
end

#Solução aleatória e vetor de testes do sistema Ax=b
function testb(A)
    n=size(A,1); x=2*rand(n).-1
    return A*x, x
end

#Função que retorna fatoração de Cholesky/ PLU/ LU de A
function getFactorization(A,opt="plu")
    #Encontrando a fatoração desejada
    if opt=="chol"
        return cholesky(A)
    elseif opt=="lu"
        return lu(A,NoPivot())
    else #caso contrário, retorna PLU
        return lu(A)
    end 
end