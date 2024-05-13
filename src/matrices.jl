using LinearAlgebra
#Função referente à primeira questão, recebe i alternativa e n dimensao
function diagMatrix(i,n)
    D=zeros(n,n);
    k=0;
    #vendo qual alternativa
    if i==1
        for j=1:n
            D[j,j]=1.001^j
        end
    elseif i==2
        for j=1:n
            D[j,j]=(-1.001)^j
        end
    elseif i==3
        for j=1:n
            k=floor(10/n*j)
            D[j,j]=k/100+1
        end
    elseif i==4
        for j=1:n
            k=floor(10/n*j)
            D[j,j]=k+1
        end
    elseif i==5
        for j=1:n
            k=floor(10/n*j)
            D[j,j]=k+1.0001^j
        end
    elseif i==6
        for j=1:n
            k=floor(10/n*j)
            D[j,j]=10*k+1
        end
    elseif i==7
        for j=1:n
            k=floor(10/n*j)
            D[j,j]=(-1)^j*10*k+1
          end
    elseif i==8
        for j=1:n
            k=floor(10/n*j)
            D[j,j]=100*k+1
        end
    else
        for j=1:n
            k=floor(10/n*j)
            D[j,j]=1000*k+1
        end
    end
    return D
end

#Retorna o numero de condição na norma 2 das matrizes de testes sabendo os autovalores
#cond=lambda_max/lambda_min
function conditionNumber(i,n)
    cond=0; kmax=10; kmin=floor(10/n)
    #vendo qual alternativa
    if i==1
        cond=1.001^n/1.001
    elseif i==2
        cond=1.001^n/1.001
    elseif i==3
        cond=(kmax/100+1)/(kmin/100+1)
    elseif i==4
        cond=(kmax+1)/(kmin+1)
    elseif i==5
        cond=(kmax+1.0001^n)/(kmin+1.0001)
    elseif i==6
        cond=(10*kmax+1)/(10*kmin+1)
    elseif i==7
        cond=(10*kmax+1)/(10*kmin+1)
    elseif i==8
        cond=(100*kmax+1)/(100*kmin+1)
    else
        cond=(1000*kmax+1)/(1000*kmin+1)
    end
    return cond
end

#Gera uma matriz aleatória nxn com entradas em [-M,M]
function randSqMatrix(n)
    M=99; R=M*(2*rand(n,n).-1)
    return R
end

#Retorna a matriz A do problema, que pode ser simétrica ou não
#Recebendo a diagonal da i-esima alternativa e a dimensão n da matriz quadrada
function testMatrix(i,n,simet=true)
    #Definindo matriz diagonal
    D=diagMatrix(i,n)
    #Checamos qual matriz de teste será fornecida (simétrica ou não)
    M=randSqMatrix(n); Qrm=qr(M)
    if simet
        A=Qrm.Q*D*Qrm.Q'
    else
        N=randSqMatrix(n); Qrn=qr(N)
        A=Qrm.Q*D*Qrn.Q'
    end
    return A
end

#Função auxiliar que retorna ou a fatoração de Cholesky ou a fatoração PLU ou a fatoração LU de A
function getFactorization(A,opt="plu")
    factor=0
    opt_saida=opt
    #Calculando a fatoração desejada
    if opt=="chol" #Se pedir cholesky e não for possível, retorna PLU
        try cholesky(A);
            factor=cholesky(A)
            opt_saida="chol"
        catch e
            factor=lu(A)
            opt_saida="plu"
        end
    elseif opt=="lu"
        factor=lu(A,NoPivot())
        opt_saida="lu"
    else #caso contrário, retorna PLU
        factor=lu(A)
        opt_saida="plu"
    end 
    return factor, opt_saida
end