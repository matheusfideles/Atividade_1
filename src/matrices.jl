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
        cont=n; k=0;
        while cont>=10 
            for i=1:10
                D[10*k+i,10*k+i]=k/100+1
            end
            cont-=10; k+=1
        end
        for i=1:cont
            D[10*k+i,10*k+i]=k/100+1
        end
    elseif i==4
        cont=n; k=0;
        while cont>=10 
            for i=1:10
                D[10*k+i,10*k+i]=k+1
            end
            cont-=10; k+=1
        end
        for i=1:cont
            D[10*k+i,10*k+i]=k+1
        end
    elseif i==5
        cont=n; k=0;
        while cont>=10 
            for i=1:10
                D[10*k+i,10*k+i]=k+(1.0001)^i
            end
            cont-=10; k+=1
        end
        for i=1:cont
            D[10*k+i,10*k+i]=k+(1.0001)^i
        end
    elseif i==6
        cont=n; k=0;
        while cont>=10 
            for i=1:10
                D[10*k+i,10*k+i]=10*k+1
            end
            cont-=10; k+=1
        end
        for i=1:cont
            D[10*k+i,10*k+i]=10*k+1
        end
    elseif i==7
        cont=n; k=0;
        while cont>=10 
            for i=1:10
                D[10*k+i,10*k+i]=(-1)^(10*k+i)*10*k+1
            end
            cont-=10; k+=1
        end
        for i=1:cont
            D[10*k+i,10*k+i]=(-1)^(10*k+i)*10*k+1
        end
    elseif i==8
        cont=n; k=0;
        while cont>=10 
            for i=1:10
                D[10*k+i,10*k+i]=100*k+1
            end
            cont-=10; k+=1
        end
        for i=1:cont
            D[10*k+i,10*k+i]=100*k+1
        end
    else
        cont=n; k=0;
        while cont>=10  
            for i=1:10
                D[10*k+i,10*k+i]=1000*k+1
            end
            cont-=10; k+=1
        end
        for i=1:cont
            D[10*k+i,10*k+i]=1000*k+1
        end
    end
    return D
end

#Retorna o numero de condição na norma 2 das matrizes de testes sabendo os autovalores
#cond=lambda_max/lambda_min
function conditionNumber(i,n)
    cond=0; kmax=floor((n-1)/10)
    if i==1 || i==2
        cond=1.001^n/1.001
    elseif i==3
        cond=kmax/100+1
    elseif i==4
        cond=kmax+1
    elseif i==5
        cond=(kmax+1.0001^n)/1.0001
    elseif i==6 || i==7
        cond=10*kmax+1
    elseif i==8
        cond=100*kmax+1
    else
        cond=1000*kmax+1
    end
    return cond
end

#Gera uma matriz aleatória nxn com entradas em [-M,M]
function randSqMatrix(n)
    M=999; R=M*(2*rand(n,n).-1)
    return R
end

#Retorna a matriz A do problema, que pode ser simétrica ou não
#Recebendo a diagonal da i-esima alternativa e a dimensão n da matriz quadrada
function testMatrix(i,n,simet=true)
    #Definindo matriz diagonal
    D=diagMatrix(i,n)
    #Checamos qual matriz de teste será fornecida (simétrica ou não)
    M=randSqMatrix(n); Qrm=qr(M); qm=Matrix(Qrm.Q)
    if simet
        A=qm*D*qm'
        #Evitando erro numérico -> Forçando a ser simétrica
        for i=1:n
            for j=(i+1):n
                A[i,j]=A[j,i]
            end
        end
    else
        #Caso da não simétrica
        N=randSqMatrix(n); Qrn=qr(N); qn=Matrix(Qrn.Q)
        A=qm.Q*D*qn'
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